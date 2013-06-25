//
//  TDMMyProfileViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMViewReviewsViewController.h"
#import "TDMMyFavoritesViewController.h"
#import "DatabaseManager.h"



@interface TDMMyProfileViewController()
//private
- (void)reworkOnTableView;
- (void)customizeCurrentView;

@end

#define kNORMAL_CELL_HEIGHT 44
#define kCELL_PLACEHOLDER_USERNAME @"User Name"
#define kCELL_PLACEHOLDER_ADDRESS @"Address"
#define kCELL_PLACEHOLDER_RATE @"Rate"
#define kROW_USERNAME 0
#define kROW_ADDRESS 1
#define kROW_RATE 2

#define kNUMBER_OF_ROWS 3
#define kCORNER_RADIUS 10.0f
#define kCELL_TEXT_COLOR [UIColor darkGrayColor]
#define kCELL_TEXTFIELD_FRAME CGRectMake(0, 0, 231, kNORMAL_CELL_HEIGHT)

static NSString *CellIdentifier = @"Cell";
@implementation TDMMyProfileViewController
@synthesize usersName;
@synthesize eMailId;
@synthesize rateInfo;




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setUsersName:nil];
    [self setEMailId:nil];
    [self setRateInfo:nil];
  
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
    [self initialize];
    // Do any additional setup after loading the view from its nib.
}

- (void)initialize
{
    NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    if ([dict count]>0) 
    {
        NSLog(@"%@",dict);
        eMailId.text = [dict objectForKey:@"email"];
        usersName.text = [dict objectForKey:@"username"];
        TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(13, 37, 78, 80)];
        [self.view addSubview:asyncImageView]; 
        asyncImageView.tag = 10;     
        NSString *urlpath = [dict objectForKey:@"userimage"];
        if (!([urlpath isKindOfClass:[NSNull class]] )) 
        {
            if(urlpath) {
                
                NSURL *url = [[NSURL alloc] initWithString:urlpath];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [url release];
                url = nil;
            }
        }
        else
            [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];

    }
   
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

#pragma mark ViewCreations
- (void)customizeCurrentView{
    
    //this will create the navigation Title as My Profile
    [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_MY_PROFILE];
    
    //this will create the back button on the navigation bar
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    
    //making the tableView little bit curved at the corner
    [self reworkOnTableView];
    
    //this will hide the TabbarController in the bottom
    [self hideTabbar];
}

- (void)reworkOnTableView{
    
}


#pragma mark - Button Actions
- (IBAction)myReviewsClicked:(id)sender{
    
    TDMMyFavoritesViewController *fav = (TDMMyFavoritesViewController *)[self getClass:kMYFAVORITES_CLASS];
    [self.navigationController pushViewController:fav animated:YES];
//    TDMViewReviewsViewController *viewReviews = (TDMViewReviewsViewController *)[self getClass:kVIEWREVIEW_CLASS];
//    [self.navigationController pushViewController:viewReviews animated:YES];
//    NSLog(@"reviews clicked");
}

//- (IBAction)myFavoritesClicked:(id)sender{
//    
//    NSLog(@"favorites clicked");
//   
//}


#pragma mark - Memory Management
- (void)dealloc
{
    [usersName release];
    [eMailId release];
    [rateInfo release];
  
    [super dealloc];
}

@end
