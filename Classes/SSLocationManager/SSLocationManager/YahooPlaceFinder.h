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
