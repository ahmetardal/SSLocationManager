//
//  YahooPlaceData.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/22/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooPlaceData: NSObject
{
    NSNumber *quality;
    NSNumber *latitude;
    NSNumber *longitude;
    NSNumber *radius;
    NSString *name;
    NSString *line1;
    NSString *line2;
    NSString *line3;
    NSString *line4;
    NSString *house;
    NSString *street;
    NSString *xstreet;
    NSString *unittype;
    NSString *unit;
    NSString *postal;
    NSString *neighborhood;
    NSString *city;
    NSString *county;
    NSString *state;
    NSString *country;
    NSString *countrycode;
    NSString *statecode;
    NSString *countycode;
    NSString *hash;
    NSNumber *woeid;
    NSNumber *woetype;
    NSString *uzip;
}

@property (nonatomic, retain) NSNumber *quality;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *radius;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *line1;
@property (nonatomic, retain) NSString *line2;
@property (nonatomic, retain) NSString *line3;
@property (nonatomic, retain) NSString *line4;
@property (nonatomic, retain) NSString *house;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *xstreet;
@property (nonatomic, retain) NSString *unittype;
@property (nonatomic, retain) NSString *unit;
@property (nonatomic, retain) NSString *postal;
@property (nonatomic, retain) NSString *neighborhood;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *county;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *countrycode;
@property (nonatomic, retain) NSString *statecode;
@property (nonatomic, retain) NSString *countycode;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSNumber *woeid;
@property (nonatomic, retain) NSNumber *woetype;
@property (nonatomic, retain) NSString *uzip;

- (id) initWithJsonDictionary:(NSDictionary *)json;
- (NSString *) toString;
+ (id) placeData;

@end
