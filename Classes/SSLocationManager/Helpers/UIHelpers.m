//
//  UIHelpers.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 6/25/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import "UIHelpers.h"

@implementation UIHelpers

#pragma mark -
#pragma mark UIAlertView Helper Methods

+ (void) showAlertWithTitle:(NSString *)title msg:(NSString *)msg buttonTitle:(NSString *)btnTitle
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:btnTitle
                                       otherButtonTitles:nil];
    [av show];
    [av release];
}

+ (void) showAlertWithTitle:(NSString *)title
{
    [UIHelpers showAlertWithTitle:title msg:nil buttonTitle:@"OK"];
}

+ (void) showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{
    [UIHelpers showAlertWithTitle:title msg:msg buttonTitle:@"OK"];
}

@end
