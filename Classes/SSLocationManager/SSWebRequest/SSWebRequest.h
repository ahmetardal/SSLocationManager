
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  SSWebRequest.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 1/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSWebRequestDelegate.h"
#import "SSWebRequestParams.h"

typedef enum SSWebRequestStatus_
{
    kSSWebRequestStatusUnset,
    kSSWebRequestStatusUnstarted,
    kSSWebRequestStatusLoading,
    kSSWebRequestStatusFinished,
    kSSWebRequestStatusCancelled,
    kSSWebRequestStatusFailed
} SSWebRequestStatus;

@interface SSWebRequest: NSObject
{
    NSURLConnection *_connection;
    NSMutableURLRequest *_request;
    NSMutableData *_responseData;
    id delegate;
    NSObject *userData;

    SSWebRequestStatus status;
    NSUInteger timeout;

    /** Called on the delegate when the request completes successfully. */
    // this method would be something like this (return value is not used):
    // - (id) someRequest:(SSWebRequest *)request didFinish:(NSString *)responseString;
    SEL didFinishSelector;
    /** Called on the delegate when the request fails. */
    // and this one would be something like this (return value is again not used):
    // - (id) someRequest:(SSWebRequest *)request didFailWithError:(NSError *)error;
    SEL didFailSelector;
}

@property (nonatomic, readonly) SSWebRequestStatus status;
@property (nonatomic, assign)   NSUInteger timeout;
@property (nonatomic, retain)   NSObject *userData;
@property (nonatomic, assign)   SEL didFinishSelector;
@property (nonatomic, assign)   SEL didFailSelector;

+ (SSWebRequest *) requestWithDelegate:(id)deleg;

+ (SSWebRequest *) requestWithDelegate:(id<SSWebRequestDelegate>)deleg
                  didFinishSelector:(SEL)_didFinishSelector
                    didFailSelector:(SEL)_didFailSelector;

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod
          andPostData:(NSString *)postData
       andHttpHeaders:(NSDictionary *)headers;

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod
          andPostData:(NSString *)postData;

- (void) startWithUrl:(NSString *)url
          andPostData:(NSString *)postData;

- (void) startWithUrl:(NSString *)url
        andHttpMethod:(NSString *)httpMethod;

- (void) startWithUrl:(NSString *)url;

- (void) cancel;

@end
