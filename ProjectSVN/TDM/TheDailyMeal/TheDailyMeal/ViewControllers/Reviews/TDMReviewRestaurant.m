//
//  TDMReviewRestaurant.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMReviewRestaurant.h"

@implementation TDMReviewRestaurant
@synthesize restaurantReviewImage;
@synthesize restaurantReviewTextView;
@synthesize restaurantReviewSubmitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
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
    [restaurantReviewTextView.layer setCornerRadius:10.0];
    [restaurantReviewImage.layer setCornerRadius:10.0];
    [self.navigationItem setRBIconImage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRestaurantReviewImage:nil];
    [self setRestaurantReviewTextView:nil];
    [self setRestaurantReviewSubmitButton:nil];
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
    [restaurantReviewImage release];
    [restaurantReviewTextView release];
    [restaurantReviewSubmitButton release];
    [super dealloc];
}
- (IBAction)restaurantReviewSubmitButtonClicked:(id)sender {
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL retValue = YES;
    if([text isEqualToString:@"\n"])
    {
        retValue = NO;
        [textView resignFirstResponder];
    }
    return retValue;
}
@end
