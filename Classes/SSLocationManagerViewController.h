//
//  SSLocationManagerViewController.h
//  SSLocationManager
//
//  Created by Ahmet Ardal on 5/24/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLocationManager.h"

@interface SSLocationManagerViewController: UIViewController<SSLocationManagerDelegate>
{
    BOOL _updatingLocation;
    UITextView *textView;
    UIButton *button;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction) buttonTapped:(id)sender;

@end
