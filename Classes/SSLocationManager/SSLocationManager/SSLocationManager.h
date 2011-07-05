
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
//  SSLocationManager.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/27/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MulticastDelegate.h"
#import "YahooPlaceFinder.h"

@class YahooPlaceData;
@protocol SSLocationManagerDelegate;

@interface SSLocationManager: NSObject<YahooPlaceFinderDelegate, CLLocationManagerDelegate>
{
    YahooPlaceFinder *_placeFinder;
    CLLocationManager *_coreLocationManager;
    YahooPlaceData *currentLocation;
    CLLocationCoordinate2D currentCoordinate;

    MulticastDelegate<SSLocationManagerDelegate> *_multicastDelegate;

    BOOL _updateInProgress;
}

@property (nonatomic, retain)   YahooPlaceData *currentLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D currentCoordinate;

- (void) addDelegate:(id)delegate;
- (void) removeDelegate:(id)delegate;
+ (id) sharedManager;
- (void) startUpdatingCurrentLocation;

@end

@protocol SSLocationManagerDelegate<NSObject>
@required
- (void) ssLocationManager:(SSLocationManager *)locManager updatedCurrentLocation:(YahooPlaceData *)_currentLocation;
- (void) ssLocationManager:(SSLocationManager *)locManager didFailWithError:(NSError *)error;
@end
