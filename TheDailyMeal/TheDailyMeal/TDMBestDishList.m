//
//  TDMBestDishList.m
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBestDishList.h"
#import "TDMReviewRestaurant.h"
#import "TDMRestaurantReviewDetailView.h"
#import "TDMBusinessDetails.h"
#import "TDMAsyncImage.h"
#import "TDMNavigationController.h"
#import "BusinessReviewModel.h"
#import "TDMBusinessDetails.h"
#import "SignatureDishModel.h"
#import "TDMBestDishDetailView.h"
#import "TDMSignatureDishDetailsViewController.h"
//#define kBARS_CELL_HEIGHT 75;
//#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
//#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 0, 200, 21)
//#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 182, 21)
//#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 46, 62, 21)
//#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 46, 134, 21)


@implementation TDMBestDishList
@synthesize cell;
@synthesize displayTable;
@synthesize reviewHeaders;
@synthesize restaurantName,restaurantNameTitle,noReviewLabel;
@synthesize busibessType;
@synthesize imageCache;
@synthesize signatureDishModelObject;
@synthesize dishModel;
@synthesize overlayView;
@synthesize businessModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.restaurantName.text = self.restaurantNameTitle;
    [self createAdView];
    if([[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders count] > 0){
        [noReviewLabel setHidden:YES];
        [displayTable setHidden:NO];   
    }
    else {
        [noReviewLabel setHidden:NO];
        [displayTable setHidden:YES];   
    }
    imageCache = [[NSMutableDictionary alloc]init];
    [self.navigationItem setTDMIconImage];
    [restaurantName setText:[NSString stringWithFormat:@"%@",restaurantNameTitle]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRestaurantName:nil];
    [self setDisplayTable:nil];
    [self setRestaurantNameTitle:nil];
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
    [restaurantName release];
    [restaurantNameTitle release];
    
    [super dealloc];
}
#pragma mark - tableview Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [[UITableViewCell alloc]init];
    
    [self cofigureCell:cell withRow:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TDMBestDishDetailView *restaurantReview = [[TDMBestDishDetailView alloc]initWithNibName:@"TDMBestDishDetailView" bundle:nil];
//    restaurantReview.restaurantName.text = [NSString stringWithFormat:@"Best Dishes on %@",self.restaurantNameTitle];
//    restaurantReview.restaurantNameTitle = self.restaurantNameTitle;
//    restaurantReview.initialPageToShow=indexPath.row;
//    [self.navigationController pushViewController:restaurantReview animated:YES];
//    [restaurantReview release];
    
    [self showOverlayView];
    self.signatureDishModelObject = [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders objectAtIndex:indexPath.row];
    
    TDMSignatureDishDetailsViewController *signatureDish = [[TDMSignatureDishDetailsViewController alloc] initWithNibName:@"TDMSignatureDishDetailsViewController" bundle:nil];
    
    TDMSignatureDishModel *model = [[TDMSignatureDishModel alloc]init];
    NSLog(@"%@",self.signatureDishModelObject.signatureDishImage);
    if(self.signatureDishModelObject.signatureDishImage.length >0)
        model.dishImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,self.signatureDishModelObject.signatureDishImage]]];
    model.dishName = self.signatureDishModelObject.signatureDishTitle;
    model.businessModel = self.businessModel;
    model.staffFirstName = self.signatureDishModelObject.userName;
    model.staffImagePath = self.signatureDishModelObject.userImage;
    model.venuTitle = self.businessModel.name;
    model.reviewDescription = self.signatureDishModelObject.reviewText;
    model.venuImagePath = self.signatureDishModelObject.signatureDishImage;
    signatureDish.signatureDishModel = model;
    [self removeOverlayView];
    [self.navigationController pushViewController:signatureDish animated:YES];
    [self removeOverlayView];
    [signatureDish release];
    [model release];
    
}


- (NSMutableString *)createFormattedHtmlStringWithBody:(NSString *)body
{
    NSMutableString *htmlString = [[[NSMutableString alloc] init] autorelease];
    
    [htmlString appendFormat: @"<html>"];
    [htmlString appendFormat: @"\n <head>"];
    [htmlString appendFormat: @"\n </head>"];
    [htmlString appendFormat: @"\n <body style=\"color:#9d9d9d;font-family:Trebuchet MS;font-size:12px;\" leftmargin=\"2\" rightmargin=\"1\" topmargin=\"1\" bottommargin=\"0\" >"];
    
    if ([body length]) 
    {
        [htmlString appendFormat: @"\n %@", body]; 
    }
    else 
    {
        [htmlString appendFormat: @"\n Review description not available"];        
    }    
    
    [htmlString appendFormat: @"\n </body>"];
    [htmlString appendFormat: @"\n </html>"];
    
    return htmlString;
}


- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow{
    
    SignatureDishModel* signatureDishModel = [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders objectAtIndex:aRow];
    self.signatureDishModelObject = signatureDishModel;
    if ([[aCell.contentView subviews] count]) {
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    UIView *businessCustomCellView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)] autorelease];
    TDMAsyncImage * asyncImageView ;    
    if(signatureDishModel.signatureDishImage)   {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,signatureDishModel.signatureDishImage];
        if(![imageCache objectForKey:[NSNumber numberWithInt:aRow]] )    {
            asyncImageView  = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] ;
            asyncImageView.tag = 9999;
            
            if ([signatureDishModel.signatureDishImage isEqualToString:@""]) 
            {
                UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imageNotAvailable" ofType:@"png"]];
                [asyncImageView loadExistingImage:backgroundImage];
            }
            else
            {
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [url release];
                url = nil;
            }
            
            
            [imageCache setObject:asyncImageView forKey:[NSNumber numberWithInt:aRow]];
        } 
        else
            asyncImageView  = [imageCache objectForKey:[NSNumber numberWithInt:aRow]];
    }
    [businessCustomCellView addSubview:asyncImageView]; 
    UIWebView *businessAddressWebview = [[UIWebView alloc]initWithFrame:CGRectMake(92, 25, 200, 46)];
    [businessAddressWebview loadHTMLString:[self createFormattedHtmlStringWithBody:signatureDishModel.reviewText] baseURL:[NSURL URLWithString:nil]] ;
    businessAddressWebview.userInteractionEnabled = NO;
    [businessCustomCellView addSubview:businessAddressWebview];
    businessAddressWebview.backgroundColor = [UIColor clearColor];
    REMOVE_FROM_MEMORY(businessAddressWebview)
    
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:CGRectMake(92, 10, 182, 17)];
    businessNameLabel.text = signatureDishModel.signatureDishTitle;
    businessNameLabel.font = kGET_BOLD_FONT_WITH_SIZE(14.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)
    [aCell.contentView addSubview:businessCustomCellView];

}
-(void) noReviewsAvailable
{

}
-(void) serverError
{

}

#pragma mark    Overlay View Management
- (void)showOverlayView
{
    [self removeOverlayView];
    
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading..."];
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


@end
