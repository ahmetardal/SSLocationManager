//
//  SSWebRequestDelegate.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 6/18/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSWebRequest;

@protocol SSWebRequestDelegate

@required
- (void) SSWebRequest:(SSWebRequest *)request didFinish:(NSString *)responseString;
- (void) SSWebRequest:(SSWebRequest *)request didFailWithError:(NSError *)error;

@optional
- (void) SSWebRequestCancelled:(SSWebRequest *)request;

@end
