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
#import "TDMCoreDataManager.h"
#import "TDMUserLogin.h"
#import "DatabaseManager.h"
#import "MBProgressHUD.h"

#import "TDMFoursquareBrowse.h"

@interface TDMAccountsViewController()
- (void)customizeCurrentView;
@end

#define kIMAGEVIEW_TAG 4
@implementation TDMAccountsViewController
@synthesize myProfileButton;
@synthesize loginsignupButton;

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
    NSLog(@"login %d",[TDMUserLogin sharedLoginDetails].isLoggedIn);
    if(![TDMUserLogin sharedLoginDetails].isLoggedIn)
    {
        myProfileButton.hidden = YES;
        [loginsignupButton setFrame:CGRectMake(20, 186,272 , 43)];
        [loginsignupButton setTitle:@"Login/SignUp" forState:UIControlStateNormal];
    }
    else
    {
        myProfileButton.hidden = NO;
        [loginsignupButton setFrame:CGRectMake(20, 254,272 , 43)];
        [loginsignupButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [self setMyProfileButton:nil];
    [self setLoginsignupButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //this will customize the current view
    [self customizeCurrentView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations
- (void)customizeCurrentView{
        
    //set CustomizedTitle in NavBar
    [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_MY_SETTINGS];
    
    //this will hide the Tabbar
    [self hideTabbar];
    
    //this will create Back Bar Button in Navigationbar
    [self createNavigationBarButtonOfType:kHOME_BAR_BUTTON_TYPE];
}

#pragma mark Button Actions
- (IBAction)aboutUsClicked:(id)sender{
     
    TDMAboutUsViewController *aboutUsViewController = (TDMAboutUsViewController *)[self getClass:kABOUTUS_CLASS];
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}
- (IBAction)myProfileClicked:(id)sender{
//    TDMFoursquareBrowse * browse = [[TDMFoursquareBrowse alloc] init];
//    [browse makeFourSquareBrowseRequestWithQuery:@"American Restaurant" forLatitude:40.72 andLongitude:-73.99];
    
    TDMMyProfileViewController *myProfileViewController = (TDMMyProfileViewController *)[self getClass:kMYPROFILE_CLASS];
    [self.navigationController pushViewController:myProfileViewController animated:YES];
}
- (IBAction)loginClicked:(id)sender{
    if([loginsignupButton.titleLabel.text isEqualToString:@"Logout"])
    {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        TDMLogoutHandler *logoutHandler = [[TDMLogoutHandler alloc] init];
        [logoutHandler logoutCurrentUser];
        logoutHandler.logoutHandlerDelegate = self;
    }
    else
    {
        TDMLoginViewController *loginViewController = (TDMLoginViewController *)[self getClass:kLOGIN_SIGNUPCLASS];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

#pragma mark - Memory Management
- (void)dealloc{
  
    [myProfileButton release];
    [loginsignupButton release];
    [super dealloc];
}
#pragma logout handler
-(void)loggedOutSuccessfully
{
    NSLog(@"Log out successful");

    [TDMUserLogin sharedLoginDetails].isLoggedIn = NO;
    [[DatabaseManager sharedManager]deleteUserDataBase];
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    [loginsignupButton setTitle:@"Login/SignUp" forState:UIControlStateNormal];

    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)logOutFailed
{
    NSLog(@"Logout failed");
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}


@end
