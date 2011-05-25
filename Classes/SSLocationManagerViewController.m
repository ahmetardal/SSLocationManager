//
//  SSLocationManagerViewController.m
//  SSLocationManager
//
//  Created by Ahmet Ardal on 5/24/11.
//  Copyright 2011 SpinningSphere Labs. All rights reserved.
//

#import "SSLocationManagerViewController.h"
#import "UIHelpers.h"

@implementation SSLocationManagerViewController

@synthesize textView, button;

- (void) initialize
{
    _updatingLocation = NO;
    [[SSLocationManager sharedManager] addDelegate:self];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return self;
    }

    [self initialize];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void) startLocationUpdate
{
    if (_updatingLocation) {
        return;
    }

    _updatingLocation = YES;
    self.textView.text = @"";
    [self.button setTitle:@"updating location..." forState:UIControlStateNormal];
    [self.button setEnabled:NO];
    [[SSLocationManager sharedManager] startUpdatingCurrentLocation];
}

- (IBAction) buttonTapped:(id)sender
{
    [self startLocationUpdate];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self startLocationUpdate];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
    [self.textView release];
    [self.button release];
    [super dealloc];
}


#pragma mark -
#pragma mark SSLocationManagerDelegate Methods

- (void) ssLocationManager:(SSLocationManager *)locManager updatedCurrentLocation:(YahooPlaceData *)_currentLocation
{
    _updatingLocation = NO;
    [self.button setTitle:@"find my location" forState:UIControlStateNormal];
    [self.button setEnabled:YES];

    self.textView.text = [_currentLocation toString];
}

- (void) ssLocationManager:(SSLocationManager *)locManager didFailWithError:(NSError *)error
{
    _updatingLocation = NO;
    [self.button setTitle:@"find my location" forState:UIControlStateNormal];
    [self.button setEnabled:YES];

    [UIHelpers showAlertWithTitle:@"Location update failed. Could not get location info."];
    self.textView.text = @"location update failed...";
}

@end
