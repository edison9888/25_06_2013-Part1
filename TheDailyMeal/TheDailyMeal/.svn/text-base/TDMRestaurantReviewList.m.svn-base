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
#import "TDMBusinessDetails.h"
#import "TDMAsyncImage.h"
#import "TDMNavigationController.h"
#import "BusinessReviewModel.h"
#import "TDMBusinessDetails.h"




@implementation TDMRestaurantReviewList

@synthesize cell;
@synthesize displayTable;
@synthesize reviewHeaders;
@synthesize restaurantName,restaurantNameTitle,noReviewLabel;
@synthesize busibessType;
@synthesize imageCache;

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
    [self createAdView];
    
    if([[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders count] > 0){
        [noReviewLabel setHidden:YES];
        [displayTable setHidden:NO];   
    }
    else {
        [noReviewLabel setHidden:NO];
        [displayTable setHidden:YES];   
    }

    [self.navigationItem setTDMIconImage];
    [restaurantName setText:[NSString stringWithFormat:@"Reviews on %@",restaurantNameTitle]];
    imageCache = [[NSMutableDictionary alloc]init];

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
    [imageCache release];
    
    [super dealloc];
}
#pragma mark - tableview Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders count];
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
    TDMRestaurantReviewDetailView *restaurantReview = [[TDMRestaurantReviewDetailView alloc]initWithNibName:@"TDMRestaurantReviewDetailView" bundle:nil];
    [restaurantReview setRestaurantNameTitle:self.restaurantNameTitle];
    restaurantReview.initialPageToShow = indexPath.row;
    [self.navigationController pushViewController:restaurantReview animated:YES];
    [restaurantReview release];
}


- (NSMutableString *)createFormattedHtmlStringWithBody:(NSString *)body
{
    NSMutableString *htmlString = [[[NSMutableString alloc] init] autorelease];
    
    [htmlString appendFormat: @"<html>"];
    [htmlString appendFormat: @"\n <head>"];
    //[htmlString appendFormat: @"\n <meta name=\"viewport\" content=\"user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0\"/>     <meta name=\"apple-mobile-web-app-capable\" content=\"yes\"  />"];
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
    
    BusinessReviewModel * reviewModel = [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders objectAtIndex:aRow];
    if ([[aCell.contentView subviews] count]) {
        for (UIView *viewA in [aCell.contentView subviews]) {
            [viewA removeFromSuperview];
        }
    }
    UIView *businessCustomCellView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, aCell.frame.size.width, aCell.frame.size.height)] autorelease];
    
    TDMAsyncImage * asyncImageView ;    
    if(reviewModel.businessImage)   {
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,reviewModel.businessImage];
        if(![imageCache objectForKey:[NSNumber numberWithInt:aRow]] )    {
            asyncImageView  = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(10, 5, 65, 65)] ;
            asyncImageView.tag = 9999;
            
            
            if ([reviewModel.businessImage isEqualToString:@""]) 
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
    UIWebView *businessAddressWebview = [[UIWebView alloc]initWithFrame:CGRectMake(92, 22, 200, 45)];
    [businessAddressWebview loadHTMLString:[self createFormattedHtmlStringWithBody:reviewModel.reviewText] baseURL:[NSURL URLWithString:nil]] ;
    businessAddressWebview.userInteractionEnabled = NO;
    [businessCustomCellView addSubview:businessAddressWebview];
    businessAddressWebview.backgroundColor = [UIColor clearColor];
    REMOVE_FROM_MEMORY(businessAddressWebview)
    
    UILabel *businessNameLabel =  [[UILabel alloc]initWithFrame:CGRectMake(92, 10, 182, 17)];
    businessNameLabel.text = reviewModel.reviewTitle;
    businessNameLabel.font = kGET_BOLD_FONT_WITH_SIZE(14.0f);
    [businessCustomCellView addSubview:businessNameLabel];
    REMOVE_FROM_MEMORY(businessNameLabel)

    [aCell.contentView addSubview:businessCustomCellView];
    //REMOVE_FROM_MEMORY(businessCustomCellView)
    //imageNameString = nil;
}
-(void) noReviewsAvailable
{

}
-(void) serverError
{

}
@end
