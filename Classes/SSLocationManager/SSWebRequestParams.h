//
//  SSWebRequestParams.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 6/17/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSWebRequestParams : NSObject
{
    NSMutableArray *paramsArr;
}

- (void) addKey:(NSString *)key withValue:(NSObject *)value;
- (NSString *) getPostDataString;
- (NSString *) getPostDataStringEncoded;

@end
