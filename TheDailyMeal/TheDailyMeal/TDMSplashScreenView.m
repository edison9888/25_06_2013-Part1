//
//  TDMSplashScreenView.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 02/04/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSplashScreenView.h"

@implementation TDMSplashScreenView
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [spinner startAnimating];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [spinner startAnimating];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overlay View Management
- (void)showOverlayView
{
    if (overlayView) 
    {
        [self removeOverlayView];
    }
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading..."];
}

- (void)removeOverlayView
{
    if (overlayView)
    {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}

- (void)dealloc {
    [spinner release];
    [super dealloc];
}
@end
