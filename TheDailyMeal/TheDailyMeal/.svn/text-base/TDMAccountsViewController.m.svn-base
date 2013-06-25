//
//  TDMAccountsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAccountsViewController.h"
#import "TDMLoginViewController.h"
#import "TDMMyProfileViewController.h"
#import "TDMAboutUsViewController.h"
#import "TDMDataStore.h"
#import "DatabaseManager.h"
#import "TDMLogoutService.h"
#import "AppDelegate.h"
#import "LocationManager.h"

@class AppDelegate;

//#import "TDMBusinessReviewListHandlerAndProvider.h"

@interface TDMAccountsViewController()
- (void)customizeCurrentView;
- (void)enableLoggedinMode;
- (void)enableLoggedOutMode;
- (void)showOverlayView;
- (void)removeOverlayView;
@end

#define kIMAGEVIEW_TAG 4
@implementation TDMAccountsViewController
@synthesize myProfileButton;
@synthesize loginsignupButton;
@synthesize notificationSwitch;
@synthesize notificationsButton;
@synthesize aboutUsButton;
@synthesize locationNotificationSwitch;
@synthesize FBLogInButton;
@synthesize signUpButton;
@synthesize facebook;
#pragma mark - Memory Management

- (void)dealloc
{
    
    if(facebook){
        
        [facebook release];
        facebook = nil;
    }
    [self setMyProfileButton:nil];
    [self setLoginsignupButton:nil];
    [self setNotificationSwitch:nil];
    [self setNotificationsButton:nil];
    [self setAboutUsButton:nil];
    
    if(logoutHandler){
        
        [logoutHandler release];
        logoutHandler = nil;
    }
    [self removeOverlayView];
    
    [locationNotificationSwitch release];
    [FBLogInButton release];
    [signUpButton release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload       
{
    [self setMyProfileButton:nil];
    [self setLoginsignupButton:nil];
    [self setNotificationSwitch:nil];
    [self setNotificationsButton:nil];
    [self setAboutUsButton:nil];
    [self setLocationNotificationSwitch:nil];
    [self setFBLogInButton:nil];
    [self setSignUpButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BOOL notificationStatus = [[[NSUserDefaults standardUserDefaults]valueForKey:@"notification"] boolValue];
    [notificationSwitch setOn:notificationStatus];
    [self.navigationItem setTDMIconImage];
    if([TDMDataStore sharedStore].isNotificationON || [[[NSUserDefaults standardUserDefaults] objectForKey:@"Notification"] isEqualToString:@"YES"])
    {
        [self.notificationSwitch setOn:YES];
    }
    else
    {
        [self.notificationSwitch setOn:NO];
    }
}

// when the user is logged in
- (void)enableLoggedinMode {
    
    //hidden
    [self.notificationSwitch setHidden:NO];
    [self.notificationsButton setHidden:NO];
    [self.myProfileButton setHidden:NO];
    [self.FBLogInButton setHidden:YES];
    [self.signUpButton setHidden:YES];
    
    //frames
    [self.aboutUsButton setFrame:CGRectMake(23, 135, 270, 43)];
    [self.loginsignupButton setFrame:CGRectMake(23, 204, 270 , 43)];
    [self.loginsignupButton setTitle:@"Log Out" forState:UIControlStateNormal];
}

//considering he is not logged in
- (void)enableLoggedOutMode {
    
    //hidden
    [self.notificationSwitch setHidden:YES];
    [self.notificationsButton setHidden:YES];
    [self.myProfileButton setHidden:YES];
    
    //frames
    [self.FBLogInButton setHidden:NO];
    [self.signUpButton setHidden:NO];
    
    [self.aboutUsButton setFrame:CGRectMake(23, 20, 270, 43)];
    [self.loginsignupButton setFrame:CGRectMake(23, 80, 270 , 43)];
    [self.signUpButton setFrame:CGRectMake(23, 142, 270, 43)];
    [self.FBLogInButton setFrame:CGRectMake(23, 202, 270, 43)];
    [self.loginsignupButton setTitle:@"Log In" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    //this will customize the current view
    [self customizeCurrentView];
    [self.loginsignupButton setSelected:NO];
    [self.signUpButton setSelected:NO];
    if([TDMDataStore sharedStore].isLoggedIn) {
        [self enableLoggedinMode];
    }
    else {
        [self enableLoggedOutMode];
    }
    overlayTitle = @"Logging Out";
}

#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations

- (void)customizeCurrentView
{
    [self createAdView];
    //this will hide the Tabbar
    [self hideTabbar];
    
    //this will create Back Bar Button in Navigationbar
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];

    [self.navigationItem setTDMIconImage];
}

#pragma mark - Button Actions
- (IBAction)aboutUsClicked:(id)sender
{
    TDMAboutUsViewController *aboutUsViewController = (TDMAboutUsViewController *)[self getClass:kABOUTUS_CLASS];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}

- (IBAction)myProfileClicked:(id)sender
{
    TDMMyProfileViewController *myProfileViewController = (TDMMyProfileViewController *)[self getClass:kMYPROFILE_CLASS];
    [self.navigationController pushViewController:myProfileViewController animated:YES];
}


- (IBAction)loginClicked:(id)sender
{
    [self.loginsignupButton setSelected:YES];
    if(![TDMDataStore sharedStore].isLoggedIn)
    {
        [self.loginsignupButton setTitle:@"Log In" forState:UIControlStateNormal];
        TDMLoginViewController *loginViewController = (TDMLoginViewController *)[self getClass:kLOGIN_SIGNUPCLASS];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    else
    {
        [self.loginsignupButton setTitle:@"Log Out" forState:UIControlStateNormal];
     
        [self showOverlayView];
        [NSThread detachNewThreadSelector:@selector(sentLogoutRequest) toTarget:self withObject:nil];
    }
   
}

- (void)sentLogoutRequest
{
    NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc]init];
    logoutHandler = [[TDMLogoutService alloc] init];
    logoutHandler.logoutHandlerDelegate = self;
    [logoutHandler logoutCurrentUser];
    [pool drain];
}

- (IBAction)notificationAction:(id)sender 
{
    UISwitch* settingSwitch = (UISwitch*)sender;
    
    if(settingSwitch.on == 1)
    {
        [TDMDataStore sharedStore].isNotificationON = YES;
        [self.notificationSwitch setOn:YES];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Notification"];
    }
    else
    {
        [TDMDataStore sharedStore].isNotificationON = NO;
        [self.notificationSwitch setOn:NO];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"Notification"];
    }
}


- (void)sentLoginRequestWithUID:(NSString *)uid andUrl:(NSString *)url
{
    [self showOverlayView];
    NSAutoreleasePool  *pool = [[NSAutoreleasePool alloc]init];
    TDMHTTPLoginService *loginHandler = [[TDMHTTPLoginService alloc] init];
    [loginHandler loginUserWithFBUid:uid andRedirectUrl:url];
    loginHandler.loginHandlerDelegate = self;
    [pool drain];
    
}


- (void)FacebookLoginWithAceessTocken {
    
    [self sentLoginRequestWithUID:[facebook accessToken] andUrl:[facebook redirectUri]];
}

- (IBAction)FBLogInButtonClicked:(id)sender {
    
    if(facebook){
        
        [facebook release];
        facebook = nil;
    }
    facebook = [[Facebook alloc] initWithAppId:FBAPP_KEY andDelegate:self];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    facebook.userFlow = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.logindelegate = facebook;
    
    [facebook logout:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [self FacebookLoginWithAceessTocken];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    }  
    overlayTitle = @"Logging In";
}

- (IBAction)signUpButtonClicked:(id)sender {
    
    [self.signUpButton setSelected:YES];
    if(![TDMDataStore sharedStore].isLoggedIn)
    {
        [self.loginsignupButton setTitle:@"Log In" forState:UIControlStateNormal];
        TDMLoginViewController *loginViewController = (TDMLoginViewController *)[self getClass:kLOGIN_SIGNUPCLASS];
        loginViewController.isfromSettings = 1;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    else
    {
        [self.loginsignupButton setTitle:@"Log Out" forState:UIControlStateNormal];
        
        [self showOverlayView];
        [NSThread detachNewThreadSelector:@selector(sentLogoutRequest) toTarget:self withObject:nil];
    }

}


- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self FacebookLoginWithAceessTocken];
}

- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
}



//- (IBAction)useFacebookTouched:(id)sender{
//- (IBAction)FBLogInButtonClicked:(id)sender{
//    
//    if(fbHelper){
//        [fbHelper release];
//        fbHelper = nil;
//    }
//    fbHelper = [[TDMMFBHelper alloc] init];
//    fbHelper.delegate = self;
//    [fbHelper initFaceBook];
//    [fbHelper loginToFacebook];
//}
//
//
//#pragma mark TDMFBHelperDelegate
//
//- (void)fbDidLogin:(NSString*)uid{
//    
//    [fbHelper logoutOfFacebook];
//    
//    NSLog(@"UID : --%@",uid);
//    [self sentLoginRequestWithUID:uid andUrl:@"http://api.facebook.com/restserver.php"];
//    
//}
//
//
//- (void)fbDidNotLogin{
//    
//    NSLog(@"Incorrect facebook credentials. Please try again.");
//}

#pragma mark - Login delegates

-(void)loggedInSuccessfully 
{
    [self removeOverlayView];
    [self enableLoggedinMode];
    [TDMDataStore sharedStore].isLoggedIn = YES;
}

-(void)loginFailed 
{
    [self removeOverlayView];
    [self enableLoggedOutMode];
    [TDMDataStore sharedStore].isLoggedIn = NO;
}

-(void)invalidUser
{
    [self enableLoggedOutMode];
    [TDMDataStore sharedStore].isLoggedIn = NO;
}


#pragma mark logout delegates

-(void)loggedOutSuccessfully {
    
    [self.loginsignupButton setSelected:NO];
    [self removeOverlayView];
 
    [TDMDataStore sharedStore].isLoggedIn = NO;
    [self.loginsignupButton setSelected:NO];
    [TDMUtilities clearCookies];
    [[DatabaseManager sharedManager]deleteUserDataBase];
    [self enableLoggedOutMode];
}
-(void)logOutFailed {
    [self removeOverlayView];
    [self.loginsignupButton setSelected:NO];
  
}

#pragma mark    Overlay View Management
- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:overlayTitle];
    overlayTitle = @"Logging Out";
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
- (void)networkError
{
    [self.loginsignupButton setSelected:NO];
    
    [self removeOverlayView];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:TDM_TITLE message:@"Network Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}


@end
