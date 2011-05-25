//
//  SSWebRequest.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 1/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSWebRequest.h"
#import "NSString+Helpers.h"

#define kSSWebRequestDefaultTimeout     40
#define kSSWebRequestErrorDomain        @"com.sslabs.sswebrequest"

enum SSWebRequestErrorCodes {
    kSSWebRequestErrorCodeCannotCreateRequest = 100,
    kSSWebRequestErrorCodeCannotCreateConnection
};

@implementation SSWebRequest

@synthesize status, timeout, userData, didFinishSelector, didFailSelector;

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod
          andPostData:(NSString *)postData
       andHttpHeaders:(NSDictionary *)headers
{
    if (self.status != kSSWebRequestStatusUnstarted) {
		NSLog(@"HTTP request already running or the request is not usable anymore");
		return;
	}

    NSTimeInterval timeoutInterval = (self.timeout != 0) ? self.timeout : kSSWebRequestDefaultTimeout;
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                   timeoutInterval:timeoutInterval];
    if (_request == nil) {
        status = kSSWebRequestStatusFailed;
        NSError *err = [NSError errorWithDomain:kSSWebRequestErrorDomain
                                           code:kSSWebRequestErrorCodeCannotCreateRequest
                                       userInfo:nil];
        [delegate SSWebRequest:self didFailWithError:err];
        return;
    }
    
    //
    // set http method and set post data if any
    //
    [_request setHTTPMethod:httpMethod];
    if (postData != nil) {
        [_request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        // timeout interval is being reset after setting post body, we should re-assign it here (~?)
        [_request setTimeoutInterval:timeoutInterval];
    }

    //
    // append http headers if any
    //
    if (headers != nil) {
        NSArray *keys = [headers allKeys];
        for (NSString *key in keys) {
            [_request addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }

    _responseData = [[NSMutableData alloc] initWithLength:0];
    status = kSSWebRequestStatusLoading;

    NSLog(@"starting connection %@", url);

    //
    // create the connection
    //
    _connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    if (_connection == nil) {
        [_responseData release];
        _responseData = nil;
        _request = nil;
        status = kSSWebRequestStatusFailed;

        NSError *err = [NSError errorWithDomain:kSSWebRequestErrorDomain
                                           code:kSSWebRequestErrorCodeCannotCreateConnection
                                       userInfo:nil];
        [delegate SSWebRequest:self didFailWithError:err];
    }
}

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod
          andPostData:(NSString *)postData
{
    [self startWithUrl:url andHttpMethod:httpMethod andPostData:postData andHttpHeaders:nil];
}

- (void) startWithUrl:(NSString *)url
          andPostData:(NSString *)postData
{
    [self startWithUrl:url andHttpMethod:@"POST" andPostData:postData andHttpHeaders:nil];
}

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod
{
    [self startWithUrl:url andHttpMethod:httpMethod andPostData:nil andHttpHeaders:nil];
}

- (void) startWithUrl:(NSString *)url
{
    [self startWithUrl:url andHttpMethod:@"GET" andPostData:nil andHttpHeaders:nil];
}

- (void) cancel
{
	if (_connection == nil) {
        NSLog(@"cannot cancel, uninitialized connection.");
        return;
	}

    [_connection cancel];
    status = kSSWebRequestStatusCancelled;
    if (delegate && [delegate respondsToSelector:@selector(SSWebRequestCancelled:)]) {
        [delegate SSWebRequestCancelled:self];
    }
}


#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    status = kSSWebRequestStatusFailed;
    if (_responseData != nil) {
        [_responseData release];
        _responseData = nil;
    }

    NSLog(@"SSWebRequest::connection:didFailWithError - %@", [error description]);

    //
    // notify delegate
    //
    if (delegate == nil) {
        return;
    }
    if (didFailSelector != nil) {
        if ([delegate respondsToSelector:didFailSelector]) {
            [delegate performSelector:didFailSelector withObject:self withObject:error];
        }
        didFinishSelector = didFailSelector = nil;
    }
    else if ([delegate respondsToSelector:@selector(SSWebRequest:didFailWithError:)]) {
        [delegate SSWebRequest:self didFailWithError:error];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseStr = [[[NSString alloc] initWithData:_responseData
                                                   encoding:NSUTF8StringEncoding] autorelease];
    [_responseData release];
    _responseData = nil;
    status = kSSWebRequestStatusFinished;

    //
    // notify delegate
    //
    NSLog(@"SSWebRequest::connectionDidFinishLoading - received response: %@", responseStr);
    if (delegate == nil) {
        return;
    }
    if (didFinishSelector != nil) {
        if ([delegate respondsToSelector:didFinishSelector]) {
            [delegate performSelector:didFinishSelector withObject:self withObject:responseStr];
        }
        didFinishSelector = didFailSelector = nil;
    }
    else if ([delegate respondsToSelector:@selector(SSWebRequest:didFinish:)]) {
        [delegate SSWebRequest:self didFinish:responseStr];
    }
}


#pragma mark -
#pragma mark Construction/Destruction Methods

- (id) initWithDelegate:(id)deleg
{
	if (!(self = [super init])) {
		return self;
	}

    _connection   = nil;
    _request      = nil;
    _responseData = nil;
    userData      = nil;
    delegate      = deleg;
    status        = kSSWebRequestStatusUnstarted;
    timeout       = 0;
    didFinishSelector = nil;
    didFailSelector   = nil;
	return self;
}

+ (SSWebRequest *) requestWithDelegate:(id)deleg
{
    return [[[SSWebRequest alloc] initWithDelegate:deleg] autorelease];
}

+ (SSWebRequest *) requestWithDelegate:(id<SSWebRequestDelegate>)deleg
                  didFinishSelector:(SEL)_didFinishSelector
                    didFailSelector:(SEL)_didFailSelector
{
    SSWebRequest *req = [[SSWebRequest alloc] initWithDelegate:deleg];
    req.didFinishSelector = _didFinishSelector;
    req.didFailSelector = _didFailSelector;
    return [req autorelease];
}

- (void) dealloc
{
    [_responseData release];
    [userData release];
    [super dealloc];
}

@end
