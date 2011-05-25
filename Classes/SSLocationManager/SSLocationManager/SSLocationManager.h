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
    YahooPlaceFinder  *_placeFinder;
    CLLocationManager *_coreLocationManager;
    YahooPlaceData         *currentLocation;
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
