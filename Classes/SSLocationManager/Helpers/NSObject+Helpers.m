//
//  NSObject+Helpers.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/27/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "NSObject+Helpers.h"

@implementation NSObject(Helpers)

- (BOOL) isNotKindOfClass:(Class)aClass
{
    return ![self isKindOfClass:aClass];
}

- (BOOL) isNotNilAndOfType:(Class)aClass
{
    return (self != nil) && [self isKindOfClass:aClass];
}

- (BOOL) isNilOrNotOfType:(Class)aClass
{
    return (self == nil) || [self isNotKindOfClass:aClass];
}

@end
