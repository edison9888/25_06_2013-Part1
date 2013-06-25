//
//  TDMForgotPasswordViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/12/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMForgotPasswordViewController.h"
#import "DatabaseManager.h"

#import "TDMNavigationController.h"

@interface TDMForgotPasswordViewController()
//private
- (void)customiseCurrentView;
@end

#define kIMAGEVIEW_TAG 4
@implementation TDMForgotPasswordViewController

@synthesize emailTextField;
@synthesize submitButton;
@synthesize forgotScrollView;

#pragma mark - Memory Management

- (void)dealloc
{
    UIImageView *tempImageView = (UIImageView *)[self.view viewWithTag:kIMAGEVIEW_TAG];
    if (tempImageView) {
        tempImageView.image = nil;
    }
    REMOVE_TEXTFIELD_FROM_MEMORY(emailTextField)
    REMOVE_FROM_MEMORY(submitButton)
    REMOVE_FROM_MEMORY(forgotScrollView)
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle

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

- (void)viewWillAppear:(BOOL)animated{
    //this will customise the Current view
    emailTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.submitButton.userInteractionEnabled = YES;
    [self customiseCurrentView];
    //self.successiveButtonClick = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.frame=CGRectMake(20, 63, 280, 50);
    [self createAdView];
    [self.navigationItem setTDMIconImage];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Handle orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View Creations
//this will customise the Current view
- (void)customiseCurrentView 
{    
    //this will create the Navigationbar Title as About Us
    [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_FORGOT_PASSWORD];
    [self.navigationItem setTDMIconImage];
    
    //this will create the navigationButton on the top of type the Back Bar Buttons
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
}

#pragma mark  - TextField Delegates
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{ 
    [textField resignFirstResponder]; 
    return YES; 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.submitButton.userInteractionEnabled = YES;
   forgotScrollView.contentSize = CGSizeMake(0, 500);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    forgotScrollView.contentSize = CGSizeMake(0, 0);
}

#pragma mark - Button Actions
- (IBAction)submitButtonClicked:(id)sender{
    
        [self.submitButton setSelected:YES];
        self.submitButton.userInteractionEnabled = NO;
        NSString *emailReg =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
        
        if (emailTextField.text.length == 0) 
        {
            [self.submitButton setSelected:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Email Field Cannot be Empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            self.submitButton.userInteractionEnabled = YES;
            return;
        }
        else if(![emailTest evaluateWithObject:emailTextField.text])
        {
            [self.submitButton setSelected:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Please Enter a Valid Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            self.submitButton.userInteractionEnabled = YES;
            return;  
        }
        else
        {
            [NSThread detachNewThreadSelector:@selector(sentEmailAddress) toTarget:self withObject:nil];
        }
}

- (void)sentEmailAddress
{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
    TDMHTTPForgotPasswordService *forgotPassword = [[TDMHTTPForgotPasswordService alloc]init];
    forgotPassword.forgotPasswordDelegate = self;
    [forgotPassword sendForgotPasswordEmail:emailTextField.text];
    [self.submitButton setSelected:NO];
    [pool drain];
}


#pragma mark - Forgot password Delegates Methods

-(void)emailSent 
{

        [self.submitButton setSelected:NO];
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Further Instructions have been sent to your email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    [alertView release];
    
    [self.tabBarController setSelectedIndex:3];
}

-(void)invalidEmail 
{
    
    [self.submitButton setSelected:NO];

    emailTextField.text = @"";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"You have entered an invalid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    [alertView release];
}
-(void) networkErroInForgotPassword
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"The Daily Meal" message:@"Networ Error. please try after some time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
    [alertView release];
}
@end
