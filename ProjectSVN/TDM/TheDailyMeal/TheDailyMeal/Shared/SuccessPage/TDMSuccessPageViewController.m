//
//  TDMSuccessPageViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSuccessPageViewController.h"

@implementation TDMSuccessPageViewController
@synthesize okButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the navigation Title as My Profile
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_REVIEWS];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setOkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [okButton release];
    [super dealloc];
}
- (IBAction)okButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
