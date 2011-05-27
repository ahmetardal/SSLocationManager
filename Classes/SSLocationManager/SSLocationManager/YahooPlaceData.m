//
//  YahooPlaceData.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/22/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "YahooPlaceData.h"

@implementation YahooPlaceData

@synthesize quality;
@synthesize latitude;
@synthesize longitude;
@synthesize radius;
@synthesize name;
@synthesize line1;
@synthesize line2;
@synthesize line3;
@synthesize line4;
@synthesize house;
@synthesize street;
@synthesize xstreet;
@synthesize unittype;
@synthesize unit;
@synthesize postal;
@synthesize neighborhood;
@synthesize city;
@synthesize county;
@synthesize state;
@synthesize country;
@synthesize countrycode;
@synthesize statecode;
@synthesize countycode;
@synthesize hash;
@synthesize woeid;
@synthesize woetype;
@synthesize uzip;

- (id) initWithJsonDictionary:(NSDictionary *)json
{
    if (!(self = [super init])) {
        return self;
    }
    
    if (json == nil) {
        return self;
    }

    //
    // set all properties using KVC
    //
    for (NSString *key in [json allKeys]) {
        @try {
            [self setValue:[json objectForKey:key] forKey:key];
        }
        @catch (NSException *e) { }
    }

    return self;
}

- (void) dealloc
{
    [self.quality release];
    [self.latitude release];
    [self.longitude release];
    [self.radius release];
    [self.name release];
    [self.line1 release];
    [self.line2 release];
    [self.line3 release];
    [self.line4 release];
    [self.house release];
    [self.street release];
    [self.xstreet release];
    [self.unittype release];
    [self.unit release];
    [self.postal release];
    [self.neighborhood release];
    [self.city release];
    [self.county release];
    [self.state release];
    [self.country release];
    [self.countrycode release];
    [self.statecode release];
    [self.countycode release];
    [self.hash release];
    [self.woeid release];
    [self.woetype release];
    [self.uzip release];
    [super dealloc];
}

- (NSString *) toString
{
    NSString *s = [NSString stringWithFormat:
                   @"[quality]\n%d\n\n"
                   @"[latitude]\n%.6f\n\n"
                   @"[longitude]\n%.6f\n\n"
                   @"[radius]\n%d\n\n"
                   @"[name]\n%@\n\n"
                   @"[line1]\n%@\n\n"
                   @"[line2]\n%@\n\n"
                   @"[line3]\n%@\n\n"
                   @"[line4]\n%@\n\n"
                   @"[house]\n%@\n\n"
                   @"[street]\n%@\n\n"
                   @"[xstreet]\n%@\n\n"
                   @"[unittype]\n%@\n\n"
                   @"[unit]\n%@\n\n"
                   @"[postal]\n%@\n\n"
                   @"[neighborhood]\n%@\n\n"
                   @"[city]\n%@\n\n"
                   @"[county]\n%@\n\n"
                   @"[state]\n%@\n\n"
                   @"[country]\n%@\n\n"
                   @"[countrycode]\n%@\n\n"
                   @"[statecode]\n%@\n\n"
                   @"[countycode]\n%@\n\n"
                   @"[hash]\n%@\n\n"
                   @"[woeid]\n%d\n\n"
                   @"[woetype]\n%d\n\n"
                   @"[uzip]\n%@\n\n",
                   [quality intValue],
                   [latitude floatValue],
                   [longitude floatValue],
                   [radius intValue],
                   name,
                   line1,
                   line2,
                   line3,
                   line4,
                   house,
                   street,
                   xstreet,
                   unittype,
                   unit,
                   postal,
                   neighborhood,
                   city,
                   county,
                   state,
                   country,
                   countrycode,
                   statecode,
                   countycode,
                   hash,
                   [woeid intValue],
                   [woetype intValue],
                   uzip];
    return s;
}

+ (id) placeData
{
    return [[[YahooPlaceData alloc] init] autorelease];
}

@end
