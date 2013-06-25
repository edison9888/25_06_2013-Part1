//
//  InfoPage.m
//  Red Beacon
//
//  Created by Runi Kovoor on 16/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import "InfoPage.h"
#import "RBLoginHandler.h"
#import "LoginViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "Red_BeaconAppDelegate.h"
#import "Reachability.h"

@implementation InfoPage

@synthesize loginOrLogoutButton, loginLogoutStatusLabel, usernameLabel;
@synthesize overlay;

//to display on top of the LoginButton
NSString * kLoggedInButtonTitle = @"Logout";
NSString * kLoggedOutButtonTitle = @"Login or Signup";

//this function will return the nibName for this class
+ (NSString*)getNibName {
    
    return @"InfoPage";
}

//will setup the navigation bar, format the navigation items
- (void)setupNavigationBar 
{
    /*
    //adds the cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 60, 30);
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onTouchUpCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    cancelButtonItem = nil;*/
    
    [self.navigationItem setRBIconImage];
    
    //adds the Close button
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.frame = CGRectMake(0, 0, 60, 30);
    closeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] 
                           forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onTouchUpClose:) 
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [closeButton release];
    closeButton = nil;
    self.navigationItem.rightBarButtonItem = closeButtonItem;
    [closeButtonItem release];
    closeButtonItem = nil;
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,60, 30)];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;   
}

//checks the login status and displays corresponding title on top of the button
- (void)showLoginStatusAsButtonTitle 
{
    if ([RBBaseHttpHandler isSessionInfoAvailable])
    {
        NSString * username = [[RBDefaultsWrapper standardWrapper] currentUserName];
//        NSString * loggedInMessage = [NSString stringWithFormat:@"%@\n%@",
//                                      kLoggedInButtonTitle,
//                                      username];
//        loginOrLogoutButton.lineBreakMode = UILineBreakModeWordWrap;
//        loginOrLogoutButton.titleLabel.textAlignment = UITextAlignmentCenter;
//        [loginOrLogoutButton setTitle:loggedInMessage
//                             forState:UIControlStateNormal];
        loginLogoutStatusLabel.frame = CGRectMake(42, 350, 242, 23);
        [loginLogoutStatusLabel setText:kLoggedInButtonTitle];
        [usernameLabel setText:username];
    }
    else
    {
       // [loginOrLogoutButton setTitle:kLoggedOutButtonTitle forState:UIControlStateNormal];
        loginLogoutStatusLabel.frame = CGRectMake(44, 348, 242, 45);
        [loginLogoutStatusLabel setText:kLoggedOutButtonTitle];
        [usernameLabel setText:@""];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];    
    [self showLoginStatusAsButtonTitle];
    
}

- (void)logout 
{
     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    loginHandler = [[RBLoginHandler alloc] init];
    loginHandler.delegate = self;
    [loginHandler sendLogoutRequest];
    [pool drain];
}

#pragma mark - Button Action Methods
- (IBAction)onTouchUpLoginOrLogout:(id)sender 
{
    if (![RBBaseHttpHandler isSessionInfoAvailable]) 
    {        
        LoginViewController *loginViewController = [[LoginViewController alloc]
                                                    initWithNibName:@"LoginViewController" 
                                                    bundle:nil];

        [self.navigationController pushViewController:loginViewController animated:YES];
        [loginViewController hideLoginLabel:YES];
        [loginViewController release];
        loginViewController = nil;

    }
    else
    {
        if ([Reachability connected]) {
            
            Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
            self.overlay = [RBLoadingOverlay loadOverView:appDelegate.window
                                              withMessage:@"Logging out..." 
                                                 animated:YES];
            [NSThread detachNewThreadSelector:@selector(logout) 
                                     toTarget:self 
                                   withObject:nil];
        }       
        
    }
    [self showLoginStatusAsButtonTitle];
}

- (IBAction)onTouchUpCancel:(id)sender
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)onTouchUpClose:(id)sender 
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)removeOverlay {
    [self.overlay removeFromSuperview:YES];
    self.overlay = nil;
}

#pragma mark - RBBaseHTTPHandler Delegate
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{
    [self removeOverlay];
    RBDefaultsWrapper * sharedWrapper = [RBDefaultsWrapper standardWrapper];
    [sharedWrapper clearUserInformation];
    NSLog(@"Logout succesful");
    [self showLoginStatusAsButtonTitle];
    [loginHandler release];
    loginHandler = nil;
    
}

#pragma mark - HTTP Delegate method
- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request
{
    [self removeOverlay];
    
    //error occured while logging out
    NSLog(@"Logout error");
    [self showLoginStatusAsButtonTitle];
    [loginHandler release];
    loginHandler = nil;
    
}
#pragma mark -

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.loginOrLogoutButton = nil;
    self.loginLogoutStatusLabel = nil;
    self.usernameLabel = nil;
}


- (void)dealloc
{
    [loginOrLogoutButton release];
    loginOrLogoutButton = nil;
    self.loginLogoutStatusLabel = nil;
    self.usernameLabel = nil;
    self.overlay = nil;
    
    [super dealloc];
}

@end
