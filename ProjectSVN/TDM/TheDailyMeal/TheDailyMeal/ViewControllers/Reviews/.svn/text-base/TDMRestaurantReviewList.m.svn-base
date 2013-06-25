//
//  TDMRestaurantReviewList.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMRestaurantReviewList.h"
#import "TDMReviewRestaurant.h"
#import "TDMRestaurantReviewDetailView.h"
#define kBARS_CELL_HEIGHT 75;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 0, 200, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 46, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 46, 134, 21)


@implementation TDMRestaurantReviewList

@synthesize cell;
@synthesize displayTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
        [self createAddReviewButtonOnNavBar];
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
}

- (void)viewDidUnload
{

    [self setDisplayTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [cell release];
    [displayTable release];
    [super dealloc];
}
#pragma tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [[UITableViewCell alloc]init];
    [self cofigureCell:cell withRow:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row clicked %d",indexPath.row);
    TDMRestaurantReviewDetailView *restaurantReview = [[TDMRestaurantReviewDetailView alloc]init];
    [self.navigationController pushViewController:restaurantReview animated:YES];
    [restaurantReview release];
    NSLog(@"API");
}
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
    [businessCustomCellView addSubview:cellImageView];
    REMOVE_FROM_MEMORY(cellImageView)
    
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:kBUSINESS_NAME_LABEL_FRAME];
    businessNameLabel.text = @"Review";
    businessNameLabel.font = kGET_REGULAR_FONT_WITH_SIZE(16.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    
    UILabel *businessAddressLabel = [[UILabel alloc]initWithFrame:kBUSINESS_ADDRESS_LABEL_FRAME];
    businessAddressLabel.text = @"Review";
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
    categoriesInputLabel.text = @"Review";
    [businessCustomCellView addSubview:categoriesInputLabel];
    REMOVE_FROM_MEMORY(categoriesInputLabel)

    [aCell.contentView addSubview:businessCustomCellView];
    //REMOVE_FROM_MEMORY(businessCustomCellView)
    imageNameString = nil;
}

@end
