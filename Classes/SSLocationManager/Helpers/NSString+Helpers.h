//
//  NSString+Helpers.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 1/6/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Helpers)
- (BOOL) notEqualToString:(NSString *)string;
- (BOOL) containsString:(NSString *)string;
@end
