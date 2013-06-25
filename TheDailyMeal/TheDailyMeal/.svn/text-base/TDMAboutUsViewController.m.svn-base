//
//  TDMAboutUsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAboutUsViewController.h"
#import "TDMNavigationController.h"


@interface TDMAboutUsViewController()
//private
- (void)customizeCurrentView;
@end

@implementation TDMAboutUsViewController
@synthesize aboutTextView;
@synthesize dailyMealLogoImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self.navigationItem setTDMIconImage];
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
    aboutTextView.editable = NO;
    dailyMealLogoImageView.image = [UIImage imageNamed:@"logoImage"];
    aboutTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.navigationItem setTDMIconImage];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDailyMealLogoImageView:nil];
    [self setAboutTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    //this will customise the Current View
    [self customizeCurrentView];
    
}

#pragma mark - View Creations
- (void)customizeCurrentView{
    
    //this will create the Navigationbar Title as About Us
    [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_ABOUT_US];
    
    //this will create the navigationButton on the top of type the Back Bar Buttons
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
}

#pragma mark - Memory Management
- (void)dealloc{
    REMOVE_IMAGEVIEW_FROM_MEMORY(dailyMealLogoImageView)
    REMOVE_TEXTFIELD_FROM_MEMORY(aboutTextView)
    [self setDailyMealLogoImageView:nil];
    [self setAboutTextView:nil];
    [super dealloc];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender    
{    
    [UIMenuController sharedMenuController].menuVisible = NO;  //do not display the menu
    [self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;
}
@end
