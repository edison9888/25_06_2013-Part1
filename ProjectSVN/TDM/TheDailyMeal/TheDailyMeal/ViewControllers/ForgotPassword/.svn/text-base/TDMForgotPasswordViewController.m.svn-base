//
//  TDMForgotPasswordViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/12/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMForgotPasswordViewController.h"
#import "MBProgressHUD.h"
#import "TDMCoreDataManager.h"
#import "TDMCityGuideListOfRestaurantsHandler.h"
#import "DatabaseManager.h"

#import "TDMAddSignatureDishHandlerAndProvider.h"

#import "TDMAddPhotoHandlerAndProvider.h"

@interface TDMForgotPasswordViewController()
//private
- (void)customiseCurrentView;
@end

#define kIMAGEVIEW_TAG 4
@implementation TDMForgotPasswordViewController

@synthesize emailTextField;
@synthesize submitButton;
@synthesize forgotScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [self setEmailTextField:nil];
    [self setSubmitButton:nil];
    [self setForgotScrollView:nil];
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
    //this will customise the Current view
    [self customiseCurrentView];
}

#pragma mark View Creations
//this will customise the Current view
- (void)customiseCurrentView {
    
    //this will create the Navigationbar Title as About Us
    [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_FORGOT_PASSWORD];
    
    //this will create the navigationButton on the top of type the Back Bar Buttons
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
}

#pragma mark  - TextField Delegates
- (BOOL)textFieldShouldReturn: (UITextField *)textField{ 
    [textField resignFirstResponder]; 
    return YES; 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
   forgotScrollView.contentSize = CGSizeMake(0, 500);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    forgotScrollView.contentSize = CGSizeMake(0, 0);
}

#pragma mark Button Actions
- (IBAction)submitButtonClicked:(id)sender{

   
    NSLog(@"clicked the submit button");
    
    if (emailTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Email Field Cannot be Empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    TDMForgotPasswordHandlerAndProvider *forgotPassword = [[TDMForgotPasswordHandlerAndProvider alloc] init];
    forgotPassword.forgotPasswordDelegate = self;
    [forgotPassword sendForgotPasswordEmail:emailTextField.text];
    [emailTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

}

#pragma mark Memory Management
- (void)dealloc{
    UIImageView *tempImageView = (UIImageView *)[self.view viewWithTag:kIMAGEVIEW_TAG];
    if (tempImageView) {
        tempImageView.image = nil;
    }
    REMOVE_TEXTFIELD_FROM_MEMORY(emailTextField)
    REMOVE_FROM_MEMORY(submitButton)
    REMOVE_FROM_MEMORY(forgotScrollView)
}


//Forgot Password Delegate Methods

-(void)emailSent {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Further Instructions have been sent to your email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    [alertView release];
    
    [self.tabBarController setSelectedIndex:3];
}

-(void)invalidEmail {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    emailTextField.text = @"";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"You have entered an invalid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    [alertView release];
}
@end
