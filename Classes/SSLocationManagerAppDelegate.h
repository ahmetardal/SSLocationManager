//
//  SSLocationManagerAppDelegate.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 5/24/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSLocationManagerViewController;

@interface SSLocationManagerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SSLocationManagerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SSLocationManagerViewController *viewController;

@end

