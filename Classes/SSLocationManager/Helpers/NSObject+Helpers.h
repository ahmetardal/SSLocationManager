//
//  NSObject+Helpers.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 2/27/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Helpers)

- (BOOL) isNotKindOfClass:(Class)aClass;
- (BOOL) isNotNilAndOfType:(Class)aClass;
- (BOOL) isNilOrNotOfType:(Class)aClass;

@end
