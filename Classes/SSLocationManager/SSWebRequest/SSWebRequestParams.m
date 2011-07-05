
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

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
