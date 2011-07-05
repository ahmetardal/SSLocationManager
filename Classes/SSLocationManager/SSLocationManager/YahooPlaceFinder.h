
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
//  YahooPlaceFinderHelper.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/22/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SSWebRequestDelegate.h"
#import "YahooPlaceData.h"

typedef enum YahooPlaceFinderStatus_
{
    kYahooPlaceFinderStatus_NotStarted,
    kYahooPlaceFinderStatus_Updating,
    kYahooPlaceFinderStatus_Finished,
    kYahooPlaceFinderStatus_Failed
} YahooPlaceFinderStatus;

@protocol YahooPlaceFinderDelegate;

@interface YahooPlaceFinder: NSObject<SSWebRequestDelegate>
{
    YahooPlaceFinderStatus status;
    id<YahooPlaceFinderDelegate> delegate;
}

@property (nonatomic, assign) YahooPlaceFinderStatus status;
@property (nonatomic, assign) id<YahooPlaceFinderDelegate> delegate;

+ (id) placeFinderWithDelegate:(id<YahooPlaceFinderDelegate>)_delegate;
- (id) initWithDelegate:(id<YahooPlaceFinderDelegate>)_delegate;
- (void) startUpdatingPlaceDataForLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
- (void) startUpdatingPlaceDataForCoordinate:(CLLocationCoordinate2D)coordinate;

@end


@protocol YahooPlaceFinderDelegate<NSObject>
@optional
- (void) placeFinder:(YahooPlaceFinder *)placeFinder didUpdatePlaceData:(YahooPlaceData *)placeData;
- (void) placeFinder:(YahooPlaceFinder *)placeFinder didFail:(NSError *)error;
@end
