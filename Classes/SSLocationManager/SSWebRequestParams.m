//
//  SSWebRequestParams.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 6/17/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import "SSWebRequestParams.h"

@implementation SSWebRequestParams

- (void) addKey:(NSString *)key withValue:(NSObject *)value
{
    [paramsArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:value, key, nil]];
}

- (NSString *) getPostDataString
{
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
	for (NSDictionary *param in paramsArr) {
        NSString *key   = [[param allKeys]   objectAtIndex:0];
		NSString *value = [[param allValues] objectAtIndex:0];
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
	}
	NSString *postDataStr = [pairs componentsJoinedByString:@"&"];
    [pairs release];

	return postDataStr;
}

- (NSString *) getPostDataStringEncoded
{
	return [[self getPostDataString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark -
#pragma mark Construction/Destruction Methods

- (id) init
{
	if (self = [super init]) {
		paramsArr = [[NSMutableArray alloc] init];
	}	
	return self;
}

- (void) dealloc
{
	[paramsArr release];
	[super dealloc];
}

@end
