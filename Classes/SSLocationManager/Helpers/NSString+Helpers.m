//
//  NSString+Helpers.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 1/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "NSString+Helpers.h"

@implementation NSString(Helpers)

- (BOOL) notEqualToString:(NSString *)string
{
    return ![self isEqualToString:string];
}

- (BOOL) containsString:(NSString *)string
{
    if (string == nil) {
        return NO;
    }

    return ([self rangeOfString:string].location != NSNotFound);
}

@end
