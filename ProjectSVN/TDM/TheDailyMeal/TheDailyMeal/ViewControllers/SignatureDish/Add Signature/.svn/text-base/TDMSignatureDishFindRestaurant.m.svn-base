//
//  TDMSignatureDishFindRestaurant.m
//  TheDailyMeal
//
//  Created by Apple on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMSignatureDishFindRestaurant.h"
#import "TDMRestaurantsViewController.h"
#import "Business.h"
#import "Criteria.h"
#import "TDMBaseViewController.h"
#import "TDMAddSignatureDishThanks.h"

#define kBARS_CELL_HEIGHT 71;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 2, 182, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 48, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 48, 134, 21)

@interface TDMSignatureDishFindRestaurant()
//private

- (void)customiseCurrentView;
- (void)deallocContentsInView;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
@end


@implementation TDMSignatureDishFindRestaurant
@synthesize segmentControl;
//@synthesize arrayRestaurants;
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
-(void)dealloc
{
    [cell release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    TDMBaseViewController *viewController = [[TDMBaseViewController alloc]init];
    arrayRestaurants = [viewController getBusinessFromDatabaseWithType:kBUSINESS_REST_TYPE];
    [viewController release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) addSegmentedControl 
{
    
    NSArray * segmentItems = [NSArray arrayWithObjects: @"List", @"Map", nil];
    self.segmentControl = [[[UISegmentedControl alloc] initWithItems: segmentItems] autorelease];
    [self.segmentControl setFrame:CGRectMake(210, 3, 100, 35)];
    self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget: self action: @selector(segmentControllClicked:) 
                  forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.segmentControl];
    
}
-(void)segmentControllClicked:(id)sender
{
}
#pragma mark - View Creations
- (void)customiseCurrentView{
    
    //this will show the Tabbat
    //[self showTabbar];
    
    //creates Accountbar on Navigation Bar
    //[self createAccountButtonOnNavBar];
    
}
-(void)deallocContentsInView
{
    
}
//this will configure the Cell accordingly
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow{
    
    if ([[aCell.contentView subviews] count]) {
        NSLog(@"teh cell contentview count:%d",[[aCell.contentView subviews] count]);
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    
    UIView *businessCustomCellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)];
    UIImageView *cellImageView = [[UIImageView alloc]initWithFrame:kCELL_IMAGEVIEW_FRAME];
    NSString *imageNameString = [NSString stringWithFormat:@"business%d.jpg",aRow+1];
    cellImageView.image = [UIImage imageNamed:imageNameString];
    cellImageView.backgroundColor =[UIColor clearColor];
    //cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    [businessCustomCellView addSubview:cellImageView];
    REMOVE_FROM_MEMORY(cellImageView)
    
    Business *business = (Business *)[arrayRestaurants objectAtIndex:aRow];
    Criteria *criteria = (Criteria *)[[arrayRestaurants objectAtIndex:aRow]valueForKey:@"criteriaRelation"];
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    businessNameLabel.text = business.name;
    businessNameLabel.font = kGET_REGULAR_FONT_WITH_SIZE(16.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    
    UILabel *businessAddressLabel = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    businessAddressLabel.text = business.address;
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
    categoriesInputLabel.text = criteria.type;
    [businessCustomCellView addSubview:categoriesInputLabel];
    REMOVE_FROM_MEMORY(categoriesInputLabel)
    
    [aCell.contentView addSubview:businessCustomCellView];
    REMOVE_FROM_MEMORY(businessCustomCellView)
    imageNameString = nil;
}
#pragma  mark TableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kBARS_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayRestaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self cofigureCell:cell withRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TDMAddSignatureDishThanks *thanksObject = [[TDMAddSignatureDishThanks alloc]init];
    [self.navigationController pushViewController:thanksObject animated:YES];
    [thanksObject release];
    
    NSLog(@"API Call");
    
}

@end
