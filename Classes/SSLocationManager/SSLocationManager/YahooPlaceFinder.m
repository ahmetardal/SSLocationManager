
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
//  YahooPlaceFinderHelper.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/22/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "YahooPlaceFinder.h"
#import "YahooPlaceData.h"
#import "JSON.h"
#import "SSWebRequest.h"
#import "NSObject+Helpers.h"

/*
 * REF: http://developer.yahoo.com/geo/placefinder/
 * REF: http://developer.yahoo.com/geo/placefinder/guide/requests.html#base-uri
 * EXAMPLE REQUEST: http://where.yahooapis.com/geocode?location=37.42,-122.12&flags=J&gflags=R&appid=zHgnBS4m
 */

static NSString *const kYahooPlacesApiEndPoint = @"http://where.yahooapis.com/geocode";
static NSString *const kYahooPlacesApiAppId = @"zHgnBS4m";  // create one for your app at: https://developer.apps.yahoo.com/dashboard/createKey.html

@implementation YahooPlaceFinder

@synthesize delegate, status;

+ (id) placeFinderWithDelegate:(id<YahooPlaceFinderDelegate>)_delegate
{
    return [[[YahooPlaceFinder alloc] initWithDelegate:_delegate] autorelease];
}

- (id) init
{
    return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id<YahooPlaceFinderDelegate>)_delegate
{
    if (!(self = [super init])) {
        return self;
    }

    self.status = kYahooPlaceFinderStatus_NotStarted;
    self.delegate = _delegate;
    return self;
}

- (void) dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Place Finder Methods

- (void) startUpdatingPlaceDataForLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    if (self.status == kYahooPlaceFinderStatus_Updating) {
        NSLog(@"this YahooPlaceFinder instance is already updating, can't start another update.");
        return;
    }

    //
    // prepare querystring
    //
    NSString *locationToken = [NSString stringWithFormat:@"%.06f,%.06f", latitude, longitude];
    SSWebRequestParams *params = [[SSWebRequestParams alloc] init];
    [params addKey:@"location" withValue:locationToken];
    [params addKey:@"flags"    withValue:@"J"]; // response format: json
    [params addKey:@"gflags"   withValue:@"R"]; // reverse-geo-lookup
    [params addKey:@"appid"    withValue:kYahooPlacesApiAppId];
    NSString *queryString = [params getPostDataStringEncoded];
    [params release];

    //
    // start request
    //
    NSString *url = [NSString stringWithFormat:@"%@?%@", kYahooPlacesApiEndPoint, queryString];
    SSWebRequest *request = [SSWebRequest requestWithDelegate:self];
    [request startWithUrl:url];

    NSLog(@"starting yahoo places api request with url: %@", url);

    self.status = kYahooPlaceFinderStatus_Updating;
}

- (void) startUpdatingPlaceDataForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self startUpdatingPlaceDataForLatitude:coordinate.latitude andLongitude:coordinate.longitude];
}


#pragma mark -
#pragma mark SSWebRequestDelegate Methods

- (void) updateFailed
{
    self.status = kYahooPlaceFinderStatus_Failed;
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(placeFinder:didFail:)]) {
        [self.delegate placeFinder:self didFail:nil];
    }
}

- (void) SSWebRequest:(SSWebRequest *)request didFinish:(NSString *)responseString
{
    id result = [responseString JSONValue];
    if ([result isNilOrNotOfType:[NSDictionary class]]) {
        [self updateFailed]; return;
    }
    
    id resultSet = [result objectForKey:@"ResultSet"];
    if ([resultSet isNilOrNotOfType:[NSDictionary class]]) {
        [self updateFailed]; return;
    }
    
    id results = [resultSet objectForKey:@"Results"];
    if ([results isNilOrNotOfType:[NSArray class]] || ([results count] < 1)) {
        [self updateFailed]; return;
    }

    id rawPlaceData = [results objectAtIndex:0];
    self.status = kYahooPlaceFinderStatus_Finished;

    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(placeFinder:didUpdatePlaceData:)]) {
        YahooPlaceData *place = nil;
        @try {
            place = [[[YahooPlaceData alloc] initWithJsonDictionary:rawPlaceData] autorelease];
        }
        @catch (NSException *e) {
            [self updateFailed]; return;
        }

        [self.delegate placeFinder:self didUpdatePlaceData:place];
    }
}

- (void) SSWebRequest:(SSWebRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"yahoo place finder request failed with error: %@", (error ? [error description] : @""));

    self.status = kYahooPlaceFinderStatus_Failed;
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(placeFinder:didFail:)]) {
        [self.delegate placeFinder:self didFail:error];
    }
}

@end
