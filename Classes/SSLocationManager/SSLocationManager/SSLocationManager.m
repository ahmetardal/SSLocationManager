
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
//  SSLocationManager.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/27/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSLocationManager.h"

@implementation SSLocationManager

@synthesize currentLocation, currentCoordinate;

- (void) addDelegate:(id)delegate
{
	[_multicastDelegate addDelegate:delegate];
}

- (void) removeDelegate:(id)delegate
{
	[_multicastDelegate removeDelegate:delegate];
}

- (void) startUpdatingCurrentLocation
{
    if (_updateInProgress) {
        NSLog(@"SSLocationManager::startUpdatingCurrentLocation - cannot start a new update, one is already in progress");
        return;
    }

    NSLog(@"SSLocationManager::startUpdatingCurrentLocation - starting location update");
    _updateInProgress = YES;
    [_coreLocationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark Singleton Methods

- (id) init
{
    if (!(self = [super init])) {
        return self;
    }

    _updateInProgress = NO;
    currentLocation = nil;
    currentCoordinate = CLLocationCoordinate2DMake(0.0f, 0.0f);

    _multicastDelegate = [[MulticastDelegate alloc] init];
    _placeFinder = [[YahooPlaceFinder alloc] initWithDelegate:self];
    _coreLocationManager = [[CLLocationManager alloc] init];
    [_coreLocationManager setDelegate:self];

    return self;
}

+ (id) sharedManager
{
	static SSLocationManager *sharedManager = nil;
    @synchronized (self) {
        if (sharedManager == nil) {
            sharedManager = [[SSLocationManager alloc] init];
        }
    }
    return sharedManager;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation
{
    //
    // skip cached location
    //
    NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceNow];
    if (abs(interval) > 2.0f) {
        NSLog(@"SSLocationManager::locationManager:didUpdateToLocation:fromLocation - cached location, skipping...");
        return;
    }

    NSLog(@"SSLocationManager::locationManager:didUpdateToLocation:fromLocation - new location: %.02f %.02f%",
          newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    //
    // device updated location, now start fetching data about the location using Yahoo Places API
    //
    [manager stopUpdatingLocation];
    [_placeFinder startUpdatingPlaceDataForCoordinate:newLocation.coordinate];
    currentCoordinate = newLocation.coordinate;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"SSLocationManager::locationManager:didFailWithError - location manager failed with error: %@", [error description]);
    [manager stopUpdatingLocation];
    [_multicastDelegate ssLocationManager:self didFailWithError:error];
    _updateInProgress = NO;
    currentCoordinate = CLLocationCoordinate2DMake(0.0f, 0.0f);
}


#pragma mark -
#pragma mark YahooPlaceFinderDelegate Methods

- (void) placeFinder:(YahooPlaceFinder *)placeFinder didUpdatePlaceData:(YahooPlaceData *)placeData
{
    NSLog(@"SSLocationManager::placeFinder:didUpdatePlaceData - YahooPlaceFinder request finished");
    self.currentLocation = placeData;
    [_multicastDelegate ssLocationManager:self updatedCurrentLocation:placeData];
    _updateInProgress = NO;
}

- (void) placeFinder:(YahooPlaceFinder *)placeFinder didFail:(NSError *)error
{
    NSLog(@"SSLocationManager::placeFinder:didFail - YahooPlaceFinder request failed");
    [_multicastDelegate ssLocationManager:self didFailWithError:error];
    _updateInProgress = NO;
}

@end
