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
        return;
    }

    NSLog(@"starting location update");
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

    //
    // device updated location, now fetch data about the location using Yahoo Places API
    //
    double lat = newLocation.coordinate.latitude;
    double lot = newLocation.coordinate.longitude;
    NSLog(@"SSLocationManager::locationManager:didUpdateToLocation:fromLocation - new location: %.02f %.02f%", lat, lot);

    [manager stopUpdatingLocation];
    [_placeFinder startUpdatingPlaceDataForCoordinate:newLocation.coordinate];
    currentCoordinate = newLocation.coordinate;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"SSLocationManager::locationManager:didFailWithError - location manager failed with: %@", [error description]);
    [manager stopUpdatingLocation];
    [_multicastDelegate ssLocationManager:self didFailWithError:error];
    _updateInProgress = NO;
    currentCoordinate = CLLocationCoordinate2DMake(0.0f, 0.0f);
}


#pragma mark -
#pragma mark YahooPlaceFinderDelegate Methods

- (void) placeFinder:(YahooPlaceFinder *)placeFinder didUpdatePlaceData:(YahooPlaceData *)placeData
{
    NSLog(@"YahooPlaceFinder request finished");
    NSString *placeInfo = [NSString stringWithFormat:@"country: %@, state: %@, county: %@, city: %@, woeid: %d",
                           placeData.country, placeData.state, placeData.county, placeData.city, placeData.woeid];
    NSLog(@"YahooPlaceFinder - Place info fetched --> %@", placeInfo);

    self.currentLocation = placeData;
    [_multicastDelegate ssLocationManager:self updatedCurrentLocation:placeData];
    _updateInProgress = NO;
}

- (void) placeFinder:(YahooPlaceFinder *)placeFinder didFail:(NSError *)error
{
    NSLog(@"YahooPlaceFinder request failed");
    [_multicastDelegate ssLocationManager:self didFailWithError:error];
    _updateInProgress = NO;
}

@end
