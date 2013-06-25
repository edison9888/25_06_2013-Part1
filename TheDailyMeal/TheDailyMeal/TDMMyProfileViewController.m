//
//  TDMMyProfileViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DatabaseManager.h"
#import "TDMMyFavoritesViewController.h"

#import "TDMNavigationController.h"

@interface TDMMyProfileViewController()
//private
//- (void)reworkOnTableView;
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
@synthesize profileTable;




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
    [self setProfileTable:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileTable.backgroundColor = [UIColor clearColor];
    [self initialize];
    [self createAdView];
    self.usersName.hidden=YES;
    self.eMailId.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}

- (NSString *) urlEncoded:(NSString*)strInput {
    
    /*CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
     
     NULL,
     
     (CFStringRef)strInput,
     
     NULL,
     
     (CFStringRef)@"!*'\"();@&=+$,?%#[]%^ ",
     
     kCFStringEncodingUTF8);*/
    NSString *urlString = [strInput stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    return urlString;
    
}

- (void)initialize
{
    NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    if ([dict count]>0) 
    {
        eMailId.text = [dict objectForKey:@"email"];
        usersName.text = [dict objectForKey:@"username"];
        TDMAsyncImage * asyncImageView = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(7, 90, 85, 85)] autorelease];
        [self.view addSubview:asyncImageView]; 
        asyncImageView.tag = 10;     
        NSString *urlpath = [dict objectForKey:@"userimage"];
        NSString *newUrl = [self urlEncoded:urlpath];
        if (!([urlpath isKindOfClass:[NSNull class]])) 
        {
            if(urlpath) {
                
                NSURL *url = [[NSURL alloc] initWithString:newUrl];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [url release];
                url = nil;
            }
        }
            
        //[asyncImageView release];
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

    [self.navigationItem setTDMIconImage];
    
    //this will hide the TabbarController in the bottom
    [self hideTabbar];
}


#pragma mark - Button Actions
- (IBAction)myReviewsClicked:(id)sender{
    
   // TDMMyFavoritesViewController *fav = (TDMMyFavoritesViewController *)[self getClass:kMYFAVORITES_CLASS];
     TDMMyFavoritesViewController *fav = [[TDMMyFavoritesViewController alloc]initWithNibName:@"TDMMyFavoritesViewController" bundle:nil];
    fav.isFromMyProfile = 1;
    [self.navigationController pushViewController:fav animated:YES];
    [fav release];
}


#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       if(indexPath.row==0)
         cell.textLabel.text = usersName.text;  
       else
         cell.textLabel.text=eMailId.text;  
    cell.textLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:16];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.backgroundColor=[UIColor whiteColor];
    return cell; 
}


#pragma mark - Memory Management
- (void)dealloc
{
    [self setUsersName:nil];
    [self setEMailId:nil];
    [self setRateInfo:nil];
    [profileTable release];
    [super dealloc];
}

@end
