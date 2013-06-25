//
//  TDMMyFavoritesViewController.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMyFavoritesViewController.h"
#import "TDMBarsViewController.h"
#import "TDMRestaurantsViewController.h"
#import "TDMNavigationController.h"
#import "BussinessModel.h"
#import "TDMLoginViewController.h"

#define kNORMAL_CELL_HEIGHT 73
#define kNUMBER_OF_ROWS 3
@implementation TDMMyFavoritesViewController
@synthesize favoritesCell;

@synthesize detailsTable;
@synthesize statusLabel;
@synthesize addBar;
@synthesize addRestaurantButton;
@synthesize isAnimated;
@synthesize isFromMyProfile;

#pragma mark - Memory Management

- (void)dealloc 
{
    [super dealloc];
 //   segment = nil;
//    if (favoritesCell) {
//        [favoritesCell release];
//    }
//    if (detailsTable) {
//         [detailsTable release];
//    }
//    if (statusLabel) {
//        [statusLabel release];
//    }
//    if (addBar) {
//        [addBar release];
//    }
//    if (addRestaurantButton) {
//        [addRestaurantButton release];
//    }
//    if (barArray) {
//        [barArray release];
//    }
//    if (restaurantArray) {
//          [restaurantArray release];
//    }
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setFavoritesCell:nil];
    [self setDetailsTable:nil];
    [self setStatusLabel:nil];
    [self setAddBar:nil];
    [self setAddRestaurantButton:nil];
    [super viewDidUnload];
   
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = kTABBAR_TITLE_FAVORITES;
        [self.navigationItem setTDMIconImage];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAdView];
    [self customizeView];
   
   self.navigationItem.hidesBackButton = YES;

    // Do any additional setup after loading the view from its nib.
    
    
}
- (void)customizeView
{
    statusLabel.hidden = YES;
    addBar.hidden = YES;
    addRestaurantButton.hidden = YES;
    businesIdArray = [[NSMutableArray alloc]init];
    restaurantArray = [[NSMutableArray alloc]init];   
    barArray = [[NSMutableArray alloc]init];
    infoArray = [[NSMutableArray alloc]init];
    [self addsegmentControl];
    if ([self.tabBarController.moreNavigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [self.tabBarController.moreNavigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    if (isFromMyProfile) 
    {
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
         [self createAccountButtonOnNavBar];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    if (animated || isAnimated) {
         [self initialize];
    }
    isAnimated = NO;
}

- (void)initialize
{
    dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSString *userId = [dict objectForKey:@"userid"];
   
    //testing 
    if (userId) 
    {
        [businesIdArray removeAllObjects];
         [barArray removeAllObjects];
        [infoArray removeAllObjects];
        [restaurantArray removeAllObjects];
        businessIDArray = [[DatabaseManager sharedManager] getAllBusinessIDForUserID:userId] ;
        if ([businessIDArray count] == 0) 
        {
            segment.hidden = YES;
            detailsTable.hidden = YES;
            statusLabel.text = @"Your Wish List is empty.";
            statusLabel.hidden = NO;
            addBar.hidden = NO;
            addRestaurantButton.hidden = NO;
            
        }
        else
        {
            segment.hidden = NO;
            detailsTable.hidden = NO;
            addBar.hidden = YES;
            addRestaurantButton.hidden = YES;
            statusLabel.hidden = YES;
            
            for (int i = 0; i < [businessIDArray count]; i++) 
            {
                NSDictionary *data = [businessIDArray objectAtIndex:i];
                
                if ([[data objectForKey:@"type"]intValue] == 0) 
                {    
                   
                    [barArray addObject:data];
                    infoArray = barArray ; 
                    
                }
                else
                {
                    [restaurantArray addObject:data];
                    infoArray = restaurantArray ;
                }
            }
        }
       

    }
    else
    {
        segment.hidden = YES;
        detailsTable.hidden = YES;
        statusLabel.text = @"Your Wish List is empty.";
        statusLabel.hidden = NO;
        addBar.hidden = NO;
        addRestaurantButton.hidden = NO;

    }
    [segment setSelectedSegmentIndex:0];
    [self performSelector:@selector(segmentClicked:)];
    infoArray = restaurantArray ;
}

-(void)addsegmentControl{
    
   NSArray * segmentItems = [NSArray arrayWithObjects: @"Restaurants", @"Bars", nil];
    segment=[[UISegmentedControl alloc]initWithItems:segmentItems]; 
    [segment setFrame:CGRectMake(85, 81, 170, 35)];
    segment.segmentedControlStyle = UISegmentedControlStylePlain;
    segment.selectedSegmentIndex=SEGMENT_CONTROL_RESTAUARANTS_BUTTON;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5){
        //NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_BOLD_FONT_WITH_SIZE(13)
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:kGET_REGULAR_FONT_WITH_SIZE(14)
                                                               forKey:UITextAttributeFont];
        
        [segment setTitleTextAttributes:attributes 
                                      forState:UIControlStateNormal];
        attributes = nil;

        }
    else{
        
        [self changeUISegmentFont:segment];
        [segment setFrame:CGRectMake(48, 85, 230, 30)];
         
    }
    [segment addTarget: self action: @selector(segmentClicked:) 
                     forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segment];

}
-(void) changeUISegmentFont:(UIView*) myView 
{
    if ([myView isKindOfClass:[UILabel class]]) {  // Getting the label subview of the passed view
        UILabel* label = (UILabel*)myView;
        [label setTextAlignment:UITextAlignmentCenter];
        [label setFont:kGET_BOLD_FONT_WITH_SIZE(13)]; // Set the font size you want to change to
        
    }
    
    NSArray* subViewArray = [myView subviews]; // Getting the subview array
    
    NSEnumerator* iterator = [subViewArray objectEnumerator]; // For enumeration
    
    UIView* subView;
    
    while (subView = [iterator nextObject]) { // Iterating through the subviews of the view passed
        
        [self changeUISegmentFont:subView]; // Recursion
        
    }
    
}

- (IBAction)segmentClicked:(id)sender 
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 5)
        [self changeUISegmentFont:segment];
    if (segment.selectedSegmentIndex == 0) 
    {
        infoArray = restaurantArray;
    }
    else
    {
        infoArray = barArray;
    }
    
    [detailsTable reloadData];
}

- (IBAction)addABarAction:(id)sender 
{
    if ([TDMDataStore sharedStore].isLoggedIn)
    {
     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate selectTabItem:0];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isFromFavourites"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        REMOVE_FROM_MEMORY(alert)
        
    }
//    TDMBarsViewController *barsObj = [[TDMBarsViewController alloc]initWithNibName:@"TDMBarsViewController" bundle:nil];
//    barsObj.isFromFavorites = 1;
//    [self.navigationController pushViewController:barsObj animated:NO];
//    [barsObj release];
}

- (IBAction)addARestaurantAction:(id)sender 
{
    if ([TDMDataStore sharedStore].isLoggedIn)
    {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate selectTabItem:1];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isFromFavourites"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Please login to access this feature" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
        REMOVE_FROM_MEMORY(alert)
        
    }
//    TDMRestaurantsViewController *restaurantsObj =[[TDMRestaurantsViewController alloc]initWithNibName:@"TDMRestaurantsViewController" bundle:nil];
//    restaurantsObj.isFromFavorites = 1;
//    [self.navigationController pushViewController:restaurantsObj animated:NO];
//    [restaurantsObj release];
}

#pragma mark - AlertView Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        TDMLoginViewController *loginVC = [[TDMLoginViewController alloc]initWithNibName:@"TDMLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
    }
   
    
}

#pragma mark - Handle Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma  mark TableView datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kNORMAL_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [infoArray count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    info = [infoArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"TDMFavoritesCustomCell";
    TDMFavoritesCustomCell *favCell = (TDMFavoritesCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (favCell == nil)
    {
        [[NSBundle mainBundle]loadNibNamed:@"TDMFavoritesCustomCell" owner:self options:nil];
        favCell = favoritesCell;
        self.favoritesCell = nil;
    }
    [favCell populateInformation:info];
    cell = favCell;
    return cell;
}

#pragma mark - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    TDMBusinessViewController *businessVC = [[TDMBusinessViewController alloc]initWithNibName:@"TDMBusinessViewController" bundle:nil];
    info = [infoArray objectAtIndex:indexPath.row];

    BussinessModel *model = [[[BussinessModel alloc]init] autorelease];
    
    model.name = [info objectForKey:@"name"];
    model.fourSquareId = [info objectForKey:@"foursquareid"];
    model.locationAddress = [info objectForKey:@"address"];
   // model.venueId = [info objectForKey:@"businessid"];
    model.categoryName = [info objectForKey:@"category"];
    model.imageURL = [info objectForKey:@"image"];
    model.locationLatitude =[info objectForKey:@"latitude"];
    model.locationLongitude = [info objectForKey:@"longitude"];
    model.contactPhone = [info objectForKey:@"phoneNumber"];
    businessVC.model = model;
    
//    businessVC.model.name = [info objectForKey:@"name"];
//    businessVC.model.locationAddress = [info objectForKey:@"address"];
//    businessVC.model.venueId = [info objectForKey:@"businessid"];
//    businessVC.model.categoryName = [info objectForKey:@"category"];
//    businessVC.model.imageURL = [info objectForKey:@"image"];
//    businessVC.model.locationLatitude = [info objectForKey:@"latitude"];
//    businessVC.model.locationLongitude = [info objectForKey:@"longitude"];
//    businessVC.model.contactPhone = [info objectForKey:@"phoneNumber"];
    
    
    businessVC.tpyeForBusiness = [[info objectForKey:@"type"]intValue];
    [self.navigationController pushViewController:businessVC animated:YES];
    [businessVC release];
    businessVC = nil;
}

@end
