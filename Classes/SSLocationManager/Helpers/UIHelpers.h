//
//  UIHelpers.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 6/25/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelpers: NSObject
{
}

+ (void) showAlertWithTitle:(NSString *)title;
+ (void) showAlertWithTitle:(NSString *)title msg:(NSString *)msg;
+ (void) showAlertWithTitle:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle;

@end
