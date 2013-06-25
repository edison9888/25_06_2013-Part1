//
//  TDMAddSignatureDishFindRestaurant.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMAddSignatureDishFindRestaurant.h"
#import "Business.h"
#import "Criteria.h"
#import "TDMRestaurantsViewController.h"
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "TDMRestaurantDetails.h"
#import "MBProgressHUD.h"
#define kBARS_CELL_HEIGHT 71;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 2, 182, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 48, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 48, 134, 21)

@interface TDMAddSignatureDishFindRestaurant()
//private

- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
- (void)deallocContentsInView;
@end

@implementation TDMAddSignatureDishFindRestaurant
@synthesize searchRestaurant;
@synthesize searchAddress;
@synthesize restaurantTable;
@synthesize segmentControl;
@synthesize restaurantsHeadersArray;
@synthesize typeOfBusiness;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //this will create the navigation Title as My Profile
        [self createCustomisedNavigationTitleWithString:kNAVBAR_TITLE_BEST_DISHES];
        
        //this will create the back button on the navigation bar
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
    [self.navigationItem setRBIconImage];
    // Do any additional setup after loading the view from its nib.
    TDMBaseViewController *baseObject = [[TDMBaseViewController alloc]init];
    if (typeOfBusiness == 0) 
    {
        arrayRestaurants = [baseObject getBusinessFromDatabaseWithType:kBUSINESS_REST_TYPE];
    }
    else if (typeOfBusiness == 1) 
    {
        arrayRestaurants = [baseObject getBusinessFromDatabaseWithType:kBUSINESS_BAR_TYPE];
    }
    
    [baseObject release];
    //this will create the back button on the navigation bar
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    number = [arrayRestaurants count];
    NSLog(@"Reloading restaurantTable");
    //[self.restaurantTable reloadData];
    restaurantTable.delegate=self;
    restaurantTable.dataSource = self;
    searchRestaurant.delegate=self;
    searchAddress.delegate=self;
    TDMAppDelegate * TMDdelegate = (TDMAppDelegate*)[UIApplication sharedApplication].delegate;
    [TMDdelegate startGPSScan];
    TMDdelegate.delegate = self;
}

- (void)viewDidUnload
{
    [self setSegmentControl:nil];
    [self setSearchRestaurant:nil];
    [self setSearchAddress:nil];
    [self setRestaurantTable:nil];
    [self deallocContentsInView];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [segmentControl release];
    [searchRestaurant release];
    [searchAddress release];
    [restaurantTable release];
    [restaurantDetails release];
    [super dealloc];
}
- (IBAction)segmentClick:(id)sender 
{
    if(segmentControl.selectedSegmentIndex == 0)
    {
        searchAddress.hidden = YES;
        searchRestaurant.hidden = YES;
        restaurantTable.frame = CGRectMake(0, 150, 320, 480);
        [self.restaurantTable reloadData];
    }
    else
    {
        searchAddress.hidden = NO;
        searchRestaurant.hidden = NO;
        restaurantTable.frame = CGRectMake(0, 250, 320, 480);
        [self.restaurantTable reloadData];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL retValue= YES;
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        retValue=NO;
    }
    return retValue; 
}
#pragma  mark TableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [restaurantsHeadersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc]init]autorelease];
    TDMBaseViewController *baseObject = [[TDMBaseViewController alloc]init];
    arrayRestaurants = [baseObject getBusinessFromDatabaseWithType:kBUSINESS_REST_TYPE];
    [baseObject release];
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    [cell release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    restaurantDetails = [[NSMutableDictionary alloc]init];
    restaurantDetails = [restaurantsHeadersArray objectAtIndex:indexPath.row];
    NSLog(@"Hai:%@",restaurantDetails);
    NSString *ids = [restaurantDetails objectForKey:@"id"];
    [ClassFinder setRestaurantId:ids];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)startNotifications {
    
    // register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:self.view.window];
}
-(void)keyboardWillShow:(id)sender
{
    NSLog(@"Keyboard displayed");
}
-(void)keyboardWillHide:(id)sender
{
    NSLog(@"keyBoard hide");
    
}
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow
{
    if ([[aCell.contentView subviews] count]) {
        NSLog(@"the cell contentview count:%d",[[aCell.contentView subviews] count]);
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    NSDictionary *header = [[NSDictionary alloc]init];
    header = [restaurantsHeadersArray objectAtIndex:aRow];
    UIView *businessCustomCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:kCELL_IMAGEVIEW_FRAME];
    //NSString *imageNameString = [NSString stringWithFormat:@"business%d.jpg",aRow+1];
    cellImageView.image = [UIImage imageNamed:@"imageNotAvailable"];
    cellImageView.backgroundColor =[UIColor clearColor];
    //cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    [businessCustomCellView addSubview:cellImageView];
    REMOVE_FROM_MEMORY(cellImageView)
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    businessNameLabel.text = [header objectForKey:@"name"];
    businessNameLabel.font = kGET_REGULAR_FONT_WITH_SIZE(16.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    
    UILabel *businessAddressLabel = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    businessAddressLabel.text = [header objectForKey:@"city"];//business.address;
    businessAddressLabel.font = kGET_REGULAR_FONT_WITH_SIZE(12.0f);
    [businessCustomCellView addSubview:businessAddressLabel];
    REMOVE_FROM_MEMORY(businessAddressLabel)
    
    UILabel *staticCategoriesLabel = [[UILabel alloc]initWithFrame:kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME];
    staticCategoriesLabel.font = kGET_BOLD_FONT_WITH_SIZE(11.0f);
    staticCategoriesLabel.text = @"Categories:";
    [businessCustomCellView addSubview:staticCategoriesLabel];
    REMOVE_FROM_MEMORY(staticCategoriesLabel)
    
    UILabel *categoriesInputLabel = [[UILabel alloc]initWithFrame:kBUSINESS_CATERIES_INPUT_LABEL_FRAME];
    categoriesInputLabel.font = kGET_REGULAR_FONT_WITH_SIZE(11.0f);
    categoriesInputLabel.text = @"";//criteria.type;
    [businessCustomCellView addSubview:categoriesInputLabel];
    REMOVE_FROM_MEMORY(categoriesInputLabel)
    
    [aCell.contentView addSubview:businessCustomCellView];
    REMOVE_FROM_MEMORY(businessCustomCellView)
   // imageNameString = nil;
}
- (void)deallocContentsInView{
    REMOVE_FROM_MEMORY(restaurantTable)
    
}
-(void)currentLocationDidSaved:(CLLocation *)location {
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
    TDMBusinessDetailsProviderAndHandler *businessDetailsHandler = [[TDMBusinessDetailsProviderAndHandler alloc] init];
    businessDetailsHandler.businessDetailsDelegate = self;
    if (typeOfBusiness == 1) {
         [businessDetailsHandler getCurretLocationBusinessdetailsForQuery:@"restaurants" forLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }
    else
    {
         [businessDetailsHandler getCurretLocationBusinessdetailsForQuery:@"nightlife" forLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }
   
}

-(void)gotRestaurantDetails {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
    self.tabBarItem.enabled = YES;
    [restaurantsHeadersArray removeAllObjects];
    NSLog(@"restaurant array before:%@",restaurantsHeadersArray);
    if (typeOfBusiness == 1) {
          restaurantsHeadersArray = [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders mutableCopy];
    }
   else
   {
        restaurantsHeadersArray = [[TDMRestaurantDetails sharedBarDetails].barHeaders mutableCopy];
   }
    NSLog(@"restaurant array %@",restaurantsHeadersArray);
    
    [restaurantTable reloadData];

}

-(void)failedToFetchRestaurantDetails {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}
#pragma textfield delegates


@end
