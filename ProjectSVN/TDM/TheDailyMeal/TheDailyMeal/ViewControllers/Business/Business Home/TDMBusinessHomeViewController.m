//
//  TDMBusinessHomeViewController.m
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessHomeViewController.h"
#import "TDMMapViewAddress.h"
#import "Business.h"
#import "SignatureDish.h"
#import "Review.h"
#import "Reachability.h"
#import "TDMAddSignatureDishViewController.h"
#import "TDMAddReviewViewController.h"
#import "TDMRestaurantReviewList.h"
#import "TDMFavoritesViewController.h"
#import "TDMBusinessDetailsViewController.h"
#import "TDMUserLogin.h"
#import "DatabaseManager.h"
//#import "SHK.h"
#import "TDMBusinessDetails.h"
#import "TDMGetSignatureDishHandlerAndProvider.h"
#import "TDMSharedSignatureDishDetails.h"
#import "TDMAsyncImage.h"
#import "TDMBusinessReviewHandlerAndProvider.h"

#define SHKFacebookClass @"SHKFacebook"
#define SHKTwitterClass  @"SHKTwitter"
#define SHKMailClass     @"SHKMail"

#define ADD_SIGNATURE                             1
#define ADD_REVIEW                                2
#define ADD_SIGNATURE_WITHOUT_SIGNATUREDISH       3
#define ADD_REVIEW_WITHOUT_REVIEW                 4
#define ADD_FAVORITE                              5
#define SHARE                                     6
#define MAKE_RESERVATION                          7

#define NAV_TITLE @"Business Home"

#define BUSINESS_MAPVIEW_RECT CGRectMake(0, 0, 320, 170)
#define BUSINESS_DETAIL_RECT CGRectMake(0, 0, 320, 100)
#define SIGNATURE_DISH_DETAIL_RECT CGRectMake(25, 12, 270, 80)
#define REVIEW_DETAIL_RECT CGRectMake(25, 0, 270, 80)
#define BUTTON_RECT_WITH_SIGNATURE_OR_REVIEW CGRectMake(25, 3, 270, 40)
#define BUTTON_RECT CGRectMake(25, 0, 270, 40)


#define ACTIONSHEET_TITLE   @" "
#define ACTIONSHEET_FACEBOOK_BUTTON_TITLE   @"Facebook"
#define ACTIONSHEET_TWITTER_BUTTON_TITLE    @"Twitter"
#define ACTIONSHEET_MAIL_BUTTON_TITLE       @"Email"
#define ACTIONSHEET_CANCEL_BUTTON_TITLE     @"Cancel"

#define FACEBOOK_BUTTON_INDEX   0
#define TWITTER_BUTTON_INDEX    1
#define MAIL_BUTTON_INDEX       2


@interface TDMBusinessHomeViewController ()

@property (nonatomic,retain)NSMutableArray *mapDetailsArray;

- (void)checkIsSignatureDishAndReviews;
- (UIView *)addMapViewDetails;
- (UIView *)addBusinessDetails;
- (UIView *)addSignatureDishDetails;
- (UIView *)addReviewDishDetails;
- (UIView *)addButton:(CGRect)rect buttonImage:(NSString *)imagePath buttonTitle:(NSString *)title tag:(int)tagValue;

- (void)addMapLatitudeAndLogitude;
//- (void)mapIt;
- (void)makeMapViewRectInCaseOfMutlipleAnnotations;
- (void)shareBusinessDetails;
- (void)facebookButtonClicked;
- (void)twitterButtonClicked;
- (void)mailButtonClicked;
- (void) mapAllLocationsInOneView;
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body;

- (IBAction)beaconButtonClicked:(id)sender;

@end


@implementation TDMBusinessHomeViewController
@synthesize backgroundImage;
@synthesize businessTable;
@synthesize mapDetailsArray;
@synthesize businessId;
@synthesize arrayOfAddressID;
@synthesize businesType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createCustomisedNavigationTitleWithString:NAV_TITLE];
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

- (void)dealloc 
{
    [businessTable release];
    [backgroundImage release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkIsSignatureDishAndReviews];
    businessDetails = [TDMBusinessDetails sharedCurrentBusinessDetails].sharedBusinessDetails;
    NSLog(@"business details %@",businessDetails);
    dict = [businessDetails objectAtIndex:businessId];
    NSLog(@"%@",dict);
    
    self.businessTable.tableHeaderView = [self addMapViewDetails];
    
    TDMGetSignatureDishHandlerAndProvider *getSignatureDishObject = [[TDMGetSignatureDishHandlerAndProvider alloc]init];
    getSignatureDishObject.getSignatureDish = self;
    [getSignatureDishObject getSignatureDishForVenueID:@"7146"];
    
    
    TDMBusinessReviewHandlerAndProvider *getReviewObject = [[TDMBusinessReviewHandlerAndProvider alloc]init];
    [getReviewObject getBusinessReviewsForVenueID:7146];
    
    
    [self addMapLatitudeAndLogitude];
    [self mapAllLocationsInOneView];
    self.businessTable.autoresizesSubviews=NO;
    self.businessTable.autoresizingMask=UIViewAutoresizingNone;
    self.businessTable.backgroundColor = [UIColor clearColor];
    [self.navigationItem setRBIconImage];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (mapDetailsArray) {
        [mapDetailsArray removeAllObjects];
        NSLog(@"%@",dict);

        REMOVE_FROM_MEMORY(mapDetailsArray);

    }
}

- (void)viewDidUnload
{
    [self setBusinessTable:nil];
    [self setBackgroundImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Initialise Signature Dish

- (void)checkIsSignatureDishAndReviews
{
    isSignatureDish  = YES;
    isReviewList     = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    int rowCount;
    if([TDMUserLogin sharedLoginDetails].isLoggedIn)
    {

    rowCount =9;
    }
    else
    {
        rowCount = 6;
    }
//    if (isSignatureDish && isReviewList) {
//        
//        tableType = businessWithSignatureAndReview;
//        rowCount    = 9;
//    }
//    else
//    {
//        if (isSignatureDish || isReviewList) {
//            
//            tableType = businessWithEitherSignatureORReview;
//            rowCount    = 7;
//        }
//        
//        else  {
//            
//            tableType = businessWithNOSignatureANDReview;
//            rowCount    = 6;
//        }
//    }
    
    return rowCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

        return 100;
    }
        
    else
    {
        switch (tableType) 
        {
                
            case businessWithSignatureAndReview:
                
                switch (indexPath.section) 
            {
                case 1:
                    return 100;
                    break;
                    
                case 3:
                    return 100;
                    break;
                    
                default:
                    return 65;
                    break;
            }
                break;
                
            case businessWithEitherSignatureORReview:
                
                switch (indexPath.section) 
            {
                case 1:
                    if (isSignatureDish) {
                        
                        return 100;
                    }
                    else
                    {
                        return 65;
                    }
                    break;
                    
                case 2:
                    if (isReviewList) {
                        
                        return 100;
                    }
                    else
                    {
                        return 65;
                    }
                    break;
                    
                default:
                    return 65;
                    break;
            }
                break;
                
            case businessWithNOSignatureANDReview:
                
                return 65;
                break;
                
            default:
                break;
        }
  
    }
    
    return 0; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {

       [cell.contentView addSubview:[self addBusinessDetails]];

    }

    switch (tableType) {
            
        case businessWithSignatureAndReview:
            if([TDMUserLogin sharedLoginDetails].isLoggedIn)
            {
            switch (indexPath.section) {
                    
                case 1:
                    [cell.contentView addSubview:[self addSignatureDishDetails]];
                    break;
                    
                case 2:
                {
                    NSString *imagePath   = @"buttonImage";
                    NSString *title   = @"Add signature Dish";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT_WITH_SIGNATURE_OR_REVIEW buttonImage:
                                                  imagePath buttonTitle:title tag:ADD_SIGNATURE]];
                    break;
                }
                    
                case 3:
                    [cell.contentView addSubview:[self addReviewDishDetails]];
                    break;
                case 4:
                {
                   
                    NSString *imagePath   = @"buttonImage";
                    NSString *title = nil;
                    if (businesType == kBARS_TABBAR_INDEX) 
                    {
                        title   = @"Review This Bar";
                    }
                   else if (businesType == kRESTAURANTS_TABBAR_INDEX)
                   {
                      title   = @"Review This Restaurant";
                   }
                    else
                    {
                        if ([[dict objectForKey:@"type"]intValue] == 1) 
                        {
                            title   = @"Review This Restaurant";
                            
                        }
                        else
                        {
                            title   = @"Review This Bar";
                            
                        }
                        
                        
                    }
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT_WITH_SIGNATURE_OR_REVIEW buttonImage:
                                                  imagePath buttonTitle:title tag:ADD_REVIEW]];
                    
                    break;
                }
                case 5:
                {
                    if (businesType == kWISH_LIST_TABBAR_INDEX) 
                    {
                      
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Share";
                        [cell.contentView addSubview:[self addButton:
                                                      BUTTON_RECT buttonImage:
                                                      imagePath buttonTitle:title tag:SHARE]];
                    }
                    else
                    {
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Add To Wish List";
                        [cell.contentView addSubview:[self addButton:
                                                      BUTTON_RECT buttonImage:
                                                      imagePath buttonTitle:title tag:ADD_FAVORITE]]; 
                    }
                  
                    
                    break;
                }
                case 6:
                {
                    if (businesType == kWISH_LIST_TABBAR_INDEX) 
                    {
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Make Reservation";
                        [cell.contentView addSubview:[self addButton:
                                                      BUTTON_RECT buttonImage:
                                                      imagePath buttonTitle:title tag:MAKE_RESERVATION]];
                    }
                    else
                    {
                    NSString *imagePath   = @"buttonImage";
                    NSString *title   = @"Share";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT buttonImage:
                                                  imagePath buttonTitle:title tag:SHARE]];
                    }
                    break;
                }
                    
                case 7:
                {
                    if (businesType == kWISH_LIST_TABBAR_INDEX) 
                    {
                        UILabel *foursquareLabel = [[UILabel alloc]init];
                        foursquareLabel.frame = CGRectMake(40, 0, 270, 40);
                        foursquareLabel.text = @"POWERED BY FOURSQUARE";
                        foursquareLabel.backgroundColor = [UIColor clearColor];
                        foursquareLabel.textColor = [UIColor whiteColor];
                        [cell.contentView addSubview:foursquareLabel];
                        REMOVE_FROM_MEMORY(foursquareLabel);
                    }
                    else
                    {
                     NSString *imagePath   = @"buttonImage";
                     NSString *title   = @"Make Reservation";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT buttonImage:
                                                  imagePath buttonTitle:title tag:MAKE_RESERVATION]];
                    }
                    break;
                }
                case 8:
                {
                    if (businesType != kWISH_LIST_TABBAR_INDEX) 
                    {
                    UILabel *foursquareLabel = [[UILabel alloc]init];
                    foursquareLabel.frame = CGRectMake(40, 0, 270, 40);
                    foursquareLabel.text = @"POWERED BY FOURSQUARE";
                    foursquareLabel.backgroundColor = [UIColor clearColor];
                    foursquareLabel.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:foursquareLabel];
                    REMOVE_FROM_MEMORY(foursquareLabel);
                    }
                    else
                    {
                        if ([[dict objectForKey:@"type"]intValue] == 1) 
                        {
                            businesType = 1;
                        }
                        else
                        {
                            businesType = 0;
                        }
                    }
                    break;
                }

                default:
                    break;
            
            }
            }
            else
            {
                switch (indexPath.section) {
                    
                    case 1:
                    {
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Share";
                        [cell.contentView addSubview:[self addButton:
                                                      CGRectMake(25, 10, 270, 40) buttonImage:
                                                      imagePath buttonTitle:title tag:SHARE]];
                        break;
                    }
                    case 2:
                    {
                        UILabel *foursquareLabel = [[UILabel alloc]init];
                        foursquareLabel.frame = CGRectMake(40, -20, 270, 40);
                        foursquareLabel.text = @"POWERED BY FOURSQUARE";
                        foursquareLabel.backgroundColor = [UIColor clearColor];
                        foursquareLabel.textColor = [UIColor whiteColor];
                        [cell.contentView addSubview:foursquareLabel];
                        REMOVE_FROM_MEMORY(foursquareLabel);
                        
                        break;
                    }
                    default:
                        break;
            }
            }
            break;
            
        case businessWithEitherSignatureORReview:
            switch (indexPath.section) {
                    
                case 1:
                    if (isSignatureDish) {
                        
                        [cell.contentView addSubview:[self addSignatureDishDetails]];
                    }
                    else
                    {
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Add signature dish";
                        [cell.contentView addSubview:[self addButton:
                                                      BUTTON_RECT buttonImage:
                                                      imagePath buttonTitle:title tag:ADD_SIGNATURE_WITHOUT_SIGNATUREDISH]];       
                    }
                    
                    break;
                    
                case 2:
                    if (isReviewList) {
                        
                        [cell.contentView addSubview:[self addReviewDishDetails]];
                    }
                    else
                    {
                        NSString *imagePath   = @"buttonImage";
                        NSString *title   = @"Add Review";
                        [cell.contentView addSubview:[self addButton:
                                                      BUTTON_RECT buttonImage:
                                                      imagePath buttonTitle:title tag:ADD_REVIEW_WITHOUT_REVIEW]]; 
                    }
                    break;

                case 4:
                {
                    NSString *imagePath   = @"buttonImage";
                    NSString *title   = @"Add Favorite";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT buttonImage:
                                                  imagePath buttonTitle:title tag:ADD_FAVORITE]];
                }
                    break;
                case 5:
                {
                    NSString *imagePath   = @"buttonImage";
                    NSString *title   = @"Share";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT buttonImage:
                                                  imagePath buttonTitle:title tag:SHARE]];
                    break;
                }
                    
                case 6:
                {
                    NSString *imagePath   = @"buttonImage";
                    NSString *title   = @"Make Reservation";
                    [cell.contentView addSubview:[self addButton:
                                                  BUTTON_RECT buttonImage:
                                                  imagePath buttonTitle:title tag:MAKE_RESERVATION]];
                    break;
                }

                    
                default:
                    break;
                    
            }

            break;
            
        case businessWithNOSignatureANDReview:
            switch (indexPath.section) {
                    
                case 1:
                    //[cell.contentView addSubview:[self addButton:BUTTON_RECT buttonImage:nil]];
                    break;
                    
                case 2:
                    
                    //[cell.contentView addSubview:[self addButton:BUTTON_RECT buttonImage:nil]];
                    break;
                    
                case 3:
                   // [cell.contentView addSubview:[self addReviewDishDetails]];
                    break;
                case 4:
                    //[cell.contentView addSubview:[self addButton:BUTTON_RECT buttonImage:nil]];
                    break;
                case 5:
                   // [cell.contentView addSubview:[self addButton:BUTTON_RECT buttonImage:nil]];
                    break;
                default:
                    break;
                    
            }

            break;
            
        default:
            break;
    }

    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TDMBusinessDetailsViewController *details = [[TDMBusinessDetailsViewController alloc]init];
    details.businessDetailId = businessId;
    [self.navigationController pushViewController:details animated:YES];
    [details release];
}

#pragma mark -

- (UIView *)addMapViewDetails
{
    
    mapView = [[MKMapView alloc] initWithFrame:BUSINESS_MAPVIEW_RECT];
    mapView.delegate = self;
    return mapView;
}

- (UIView *)addBusinessDetails
{
    #define BUSINESS_IMAGE_FRAME CGRectMake(15,15,60,60)
    
    UIView *businessView = [[[UIView alloc]initWithFrame:BUSINESS_DETAIL_RECT] autorelease];
    businessView.backgroundColor = [UIColor whiteColor];
    businessView.layer.cornerRadius = 5;
   
    #define BUSINESS_TITLE_FRAME CGRectMake(30,17,210,15)
    // Heading
    UILabel *heading=[[UILabel alloc]initWithFrame:BUSINESS_TITLE_FRAME];
    heading.font = kGET_BOLD_FONT_WITH_SIZE(16);
    heading.backgroundColor  = [UIColor clearColor];
    heading.textAlignment=UITextAlignmentLeft;
    heading.text= [dict objectForKey:@"name"];
    [businessView addSubview:heading];
    REMOVE_FROM_MEMORY(heading);
    
    
    #define BUSINESS_DEATL_FRAME CGRectMake(30,35,200,15)
    // detail
    UILabel *detail=[[UILabel alloc]initWithFrame:BUSINESS_DEATL_FRAME];
    detail.font = kGET_REGULAR_FONT_WITH_SIZE(13);
    detail.backgroundColor  = [UIColor clearColor];
    detail.textAlignment=UITextAlignmentLeft;
     if ([dict objectForKey:@"city"]) {
    detail.text= [dict objectForKey:@"city"];
     }
    else
    {
         detail.text= [dict objectForKey:@"address"];
    }
    [businessView addSubview:detail];
    REMOVE_FROM_MEMORY(detail);
    
    
    #define BUSINESS_PHONE_FRAME CGRectMake(30,53,200,15)
    // phone
    UILabel *phone=[[UILabel alloc]initWithFrame:BUSINESS_PHONE_FRAME];
    phone.font = kGET_REGULAR_FONT_WITH_SIZE(13);
    phone.backgroundColor  = [UIColor clearColor];
    phone.textAlignment=UITextAlignmentLeft;
    phone.textColor = [UIColor blueColor];
    if ([dict objectForKey:@"formattedphone"]) {
        phone.text= [dict objectForKey:@"formattedphone"];
    }
    else
    {
        phone.text= [dict objectForKey:@"phoneNumber"];
    }
    [businessView addSubview:phone];
    REMOVE_FROM_MEMORY(phone);

    #define BUSINESS_CATEGORY_FRAME CGRectMake(30,70,70,15)
    // category
    UILabel *category=[[UILabel alloc]initWithFrame:BUSINESS_CATEGORY_FRAME];
    category.backgroundColor  = [UIColor clearColor];
    category.font = kGET_BOLD_FONT_WITH_SIZE(13);
    category.textAlignment=UITextAlignmentLeft;
    category.text= @"Category";
    [businessView addSubview:category];
    REMOVE_FROM_MEMORY(category);
    
    #define BUSINESS_ADDRESS_FRAME CGRectMake(100,70,200,15)
    // address
    UILabel *address=[[UILabel alloc]initWithFrame:BUSINESS_ADDRESS_FRAME];
    address.backgroundColor  = [UIColor clearColor];
    address.font = kGET_REGULAR_FONT_WITH_SIZE(13);
    address.textAlignment=UITextAlignmentLeft;
    address.text= [dict objectForKey:@"category"];
    [businessView addSubview:address];
    REMOVE_FROM_MEMORY(address);
    
    
    //arrowImgPath
#define BUSINESS_ARROW_IMAGE_IMAGE_FRAME CGRectMake(280,30,25,25)
    NSString *arrowImgPath = [[NSBundle mainBundle] pathForResource:@"arrow"                                                                         
                                                             ofType:@"png"];
    UIImage *arrowmage   = [UIImage imageWithContentsOfFile:arrowImgPath];
    UIImageView *arrowImageThumbnail=[[UIImageView alloc]init];
    arrowImageThumbnail.frame=BUSINESS_ARROW_IMAGE_IMAGE_FRAME;
    arrowImageThumbnail.backgroundColor=[UIColor clearColor];
    arrowImageThumbnail.userInteractionEnabled = NO;
    arrowImageThumbnail.image    = arrowmage;
    [businessView addSubview:arrowImageThumbnail];
    REMOVE_FROM_MEMORY(arrowImageThumbnail);

    
    return businessView;
}

- (UIView *)addSignatureDishDetails
{
    
    NSMutableArray *sharedSignatureArray =[TDMSharedSignatureDishDetails sharedSignatureDishDetails].signatureDishHeaders;
    NSMutableDictionary *dictionaryForSignatureDish = [sharedSignatureArray objectAtIndex:0];
    
    UIView *signatureView = [[UIView alloc]initWithFrame:SIGNATURE_DISH_DETAIL_RECT];
    signatureView.backgroundColor = [UIColor whiteColor];
    signatureView.layer.cornerRadius = 5;
    
    #define SIGNATURE_IMAGE_FRAME CGRectMake(5,6,70,68)
//    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"business1"                                                                         
//                                                        ofType:@"png"];
//    UIImage *thumbImage   = [UIImage imageWithContentsOfFile:imgPath];
//    UIImageView *imageThumbnail=[[UIImageView alloc]init];
//    imageThumbnail.frame=SIGNATURE_IMAGE_FRAME;
//    imageThumbnail.backgroundColor=[UIColor clearColor];
//    imageThumbnail.userInteractionEnabled = NO;
//    imageThumbnail.image    = thumbImage;
//    [signatureView addSubview:imageThumbnail];
//    REMOVE_FROM_MEMORY(imageThumbnail);
    
    TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:SIGNATURE_IMAGE_FRAME];
    asyncImageView.tag = 9999;
    NSString *urlpath = [[NSString alloc]init];
    urlpath = [@"http://stage.thedailymeal.com:8081/" stringByAppendingString:urlpath];
    NSLog(@"%@",[dictionaryForSignatureDish objectForKey:@"image"]);
    if([[dictionaryForSignatureDish objectForKey:@"image"] isKindOfClass:NSClassFromString(@"NSString")])
    {
        urlpath = [urlpath stringByAppendingString:[dictionaryForSignatureDish objectForKey:@"image"]];
        NSLog(@"url %@",urlpath);
            if (!([urlpath isKindOfClass:[NSNull class]] )) {
                if(![urlpath isEqualToString:@""]) {
                    NSURL *url = [[NSURL alloc] initWithString:urlpath];
                    [asyncImageView loadImageFromURL:url isFromHome:YES];
                    [url release];
                    url = nil;
                }
                else
                {
                    [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                }
            }
            else    {
                [asyncImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
        
            }
    }
    [signatureView addSubview:asyncImageView];
    
#define SIGNATURE_TITLE_FRAME CGRectMake(79,8,124,21)
    // Heading
    UILabel *heading=[[UILabel alloc]initWithFrame:SIGNATURE_TITLE_FRAME];
    heading.font = kGET_BOLD_FONT_WITH_SIZE(12);
    heading.backgroundColor  = [UIColor clearColor];
    heading.textAlignment=UITextAlignmentLeft;
    heading.text= @"Best Dishes";
    heading.textColor = [UIColor blueColor];
    [signatureView addSubview:heading];
    REMOVE_FROM_MEMORY(heading);
    
    #define SIGNATURE_SUB_TITLE_FRAME CGRectMake(80,38,124,21)
    // subTitle
    UILabel *subTitle=[[UILabel alloc]initWithFrame:SIGNATURE_SUB_TITLE_FRAME];
    subTitle.font = kGET_REGULAR_FONT_WITH_SIZE(14);
    subTitle.backgroundColor  = [UIColor clearColor];
    subTitle.textAlignment=UITextAlignmentLeft;
    subTitle.text= [dictionaryForSignatureDish objectForKey:@"title"];
    [signatureView addSubview:subTitle];
    REMOVE_FROM_MEMORY(subTitle);
    
    //arrowImgPath
    #define SIGNATURE_ARROW_IMAGE_FRAME CGRectMake(230,30,31,25)
    NSString *arrowImgPath = [[NSBundle mainBundle] pathForResource:@"arrow"                                                                         
                                                        ofType:@"png"];
    UIImage *arrowmage   = [UIImage imageWithContentsOfFile:arrowImgPath];
    UIImageView *arrowImageThumbnail=[[UIImageView alloc]init];
    arrowImageThumbnail.frame=SIGNATURE_ARROW_IMAGE_FRAME;
    arrowImageThumbnail.backgroundColor=[UIColor clearColor];
    arrowImageThumbnail.userInteractionEnabled = NO;
    arrowImageThumbnail.image    = arrowmage;
    [signatureView addSubview:arrowImageThumbnail];
    REMOVE_FROM_MEMORY(arrowImageThumbnail);
    
    //Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, 12, 270, 150);//SIGNATURE_DISH_DETAIL_RECT;
    [button addTarget:self action:@selector(signatureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[signatureView addSubview:button];
    
    return [signatureView autorelease];
}

- (UIView *)addReviewDishDetails
{
    UIView *reviewView = [[UIView alloc]initWithFrame:REVIEW_DETAIL_RECT];
    reviewView.backgroundColor = [UIColor whiteColor];
    reviewView.layer.cornerRadius = 5;
    
  #define REVIEW_IMAGE_FRAME CGRectMake(5,6,70,68)
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"signaturedish"                                                                         
                                                        ofType:@"png"];
    UIImage *thumbImage   = [UIImage imageWithContentsOfFile:imgPath];
    UIImageView *imageThumbnail=[[UIImageView alloc]init];
    imageThumbnail.frame=REVIEW_IMAGE_FRAME;
    imageThumbnail.backgroundColor=[UIColor clearColor];
    imageThumbnail.userInteractionEnabled = NO;
    imageThumbnail.image    = thumbImage;
    [reviewView addSubview:imageThumbnail];
    REMOVE_FROM_MEMORY(imageThumbnail);
    
#define REVIEW_TITLE_FRAME CGRectMake(79,8,124,21)//(100,15,124,15)
    // Heading
    UILabel *heading=[[UILabel alloc]initWithFrame:REVIEW_TITLE_FRAME];
    heading.font = kGET_BOLD_FONT_WITH_SIZE(12);
    heading.backgroundColor  = [UIColor clearColor];
    heading.textAlignment=UITextAlignmentLeft;
    heading.text= @"Review by Author";
    [reviewView addSubview:heading];
    REMOVE_FROM_MEMORY(heading);
    
#define REVIEW_SUB_TITLE_FRAME CGRectMake(80,38,124,21)//(100,50,100,12)
    // subTitle
    UILabel *subTitle=[[UILabel alloc]initWithFrame:REVIEW_SUB_TITLE_FRAME];
    subTitle.font = kGET_REGULAR_FONT_WITH_SIZE(12);
    subTitle.backgroundColor  = [UIColor clearColor];
    subTitle.textAlignment=UITextAlignmentLeft;
    subTitle.lineBreakMode = UILineBreakModeCharacterWrap;
    subTitle.numberOfLines =2;
    subTitle.text= @"Oysters and Pearls is as thick, luxurious and delicious as you";
    [reviewView addSubview:subTitle];
    REMOVE_FROM_MEMORY(subTitle);
    
    //arrowImgPath
#define REVIEW_ARROW_IMAGE_IMAGE_FRAME CGRectMake(230,30,31,25)
    NSString *arrowImgPath = [[NSBundle mainBundle] pathForResource:@"arrow"                                                                         
                                                             ofType:@"png"];
    UIImage *arrowmage   = [UIImage imageWithContentsOfFile:arrowImgPath];
    UIImageView *arrowImageThumbnail=[[UIImageView alloc]init];
    arrowImageThumbnail.frame=REVIEW_ARROW_IMAGE_IMAGE_FRAME;
    arrowImageThumbnail.backgroundColor=[UIColor clearColor];
    arrowImageThumbnail.userInteractionEnabled = NO;
    arrowImageThumbnail.image    = arrowmage;
    [reviewView addSubview:arrowImageThumbnail];
    REMOVE_FROM_MEMORY(arrowImageThumbnail);
    
    //Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = SIGNATURE_DISH_DETAIL_RECT;
    [button addTarget:self action:@selector(reviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reviewView addSubview:button];
    
    return [reviewView autorelease];
}


- (UIView *)addButton:(CGRect)rect buttonImage:(NSString *)imagePath buttonTitle:(NSString *)title tag:(int)tagValue
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame            = rect;
    button.tag              = tagValue;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imagePath ofType:@"png"]] forState:UIControlStateNormal];
    
    
    UIFont *font;
    switch (tagValue) {
        case ADD_SIGNATURE:
            font = kGET_REGULAR_FONT_WITH_SIZE(18);
            break;
        case ADD_REVIEW:
            font = kGET_REGULAR_FONT_WITH_SIZE(18);
            break;
        default:
            font = kGET_REGULAR_FONT_WITH_SIZE(18);
            break;
    }
    
    button.titleLabel.font = font;
    
    [button addTarget:self action:@selector(businessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



#pragma mark -  MapKit

- (void)addMapLatitudeAndLogitude
{
    self.arrayOfAddressID = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];

        addrModal.latitude          = [dict objectForKey:@"latitude"];
        addrModal.longitude         = [dict objectForKey:@"longitude"];
        [self.arrayOfAddressID addObject:addrModal];
        REMOVE_FROM_MEMORY(addrModal);
        
    }

}


- (void)mapAllLocationsInOneView{
    
    //MapViewModal *mapModal;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    NSMutableArray *arrayOfAnnotations = [[NSMutableArray alloc]init];
   
    //NSLog(@"arrayofAddressID %@",arrayOfAddressID);
    if ([arrayOfAddressID count]>0) {
        int count = 0;
        int limit =[arrayOfAddressID count];
        for (; count<limit; count++) {
            //TDMMapViewAddress *addrModal = [[TDMMapViewAddress alloc]init];
            TDMMapViewAddress *addrModal = (TDMMapViewAddress *)[self.arrayOfAddressID objectAtIndex:count];
            if (![addrModal.latitude isKindOfClass:[NSNull class]]) {
                MKCoordinateRegion region;
                region.center.latitude = [addrModal.latitude floatValue];
                region.center.longitude = [addrModal.longitude floatValue];
                region.span.longitudeDelta = 0.02f;
                region.span.latitudeDelta = 0.02f;
                [mapView setRegion:[mapView regionThatFits:region] animated:YES]; 
                DisplayMap *annotation = [[DisplayMap alloc] init];
                annotation.title = [dict objectForKey:@"name"];
                annotation.coordinate = region.center; 
                [arrayOfAnnotations addObject:annotation];
                REMOVE_FROM_MEMORY(annotation)
               
            }
        }
        
    }
    
    [mapView addAnnotations:arrayOfAnnotations];
    REMOVE_FROM_MEMORY(arrayOfAnnotations)
    [self makeMapViewRectInCaseOfMutlipleAnnotations];
}

    
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != mapView.userLocation) 
	{
		static NSString *defaultPinID = kDEFAULTPINID;
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        rightButton.tag = 10;
        
        [rightButton addTarget:self action:@selector(beaconButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        pinView.rightCalloutAccessoryView = rightButton;
        
    } 
	else {
        
		[mapView.userLocation setTitle:@"I"];
	}
	return pinView;
}


- (void)makeMapViewRectInCaseOfMutlipleAnnotations{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [mapView setVisibleMapRect:zoomRect animated:YES];
}

#pragma mark- Button Clicked

- (IBAction)beaconButtonClicked:(id)sender 
{
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Here push your view controller
    TDMBusinessHomeViewController *busHomeViewController = (TDMBusinessHomeViewController *)[self getClass:@"TDMBusinessHomeViewController"];
    NSLog(@"%@",[[view class]description]);
    [self.navigationController pushViewController:busHomeViewController animated:YES];
    
}

- (void)signatureButtonClicked:(id)sender {
}


- (void)reviewButtonClicked:(id)sender 
{
    
}

- (void)businessButtonClicked:(id)sender {
    
    UIButton *button  = (id)sender;
    
    switch (button.tag) {
        case ADD_SIGNATURE:
            NSLog(@"Add Signature Dish");
            TDMAddSignatureDishViewController *addSignatureDish = [[TDMAddSignatureDishViewController alloc]init];
            addSignatureDish.businessType = businesType;
            [self.navigationController pushViewController:addSignatureDish animated:YES];
            [addSignatureDish release];
            break;
        case ADD_REVIEW:
            NSLog(@"Review this Restaurant");
            TDMRestaurantReviewList *review = [[TDMRestaurantReviewList alloc]init];
            [self.navigationController pushViewController:review animated:YES];
            [review release];
            break;
        case ADD_FAVORITE:
            
            NSLog(@"Add To Wish List");
            TDMFavoritesViewController *favourites = [[TDMFavoritesViewController alloc]init];
            favourites.businessId = businessId;
            favourites.businessType = businesType;
            [self.navigationController pushViewController:favourites animated:YES];
            [self setTable];
            [favourites release];
            break;
        case SHARE:
            [self shareBusinessDetails];
            break;
        case MAKE_RESERVATION:
            NSLog(@"Make Reservation");
            break;
        default:
            break;
    }
    
}
- (void)setTable
{
    CGRect frame = businessTable.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    businessTable.frame = frame;
}


- (void)facebookButtonClicked
{
   
   
}

- (void)twitterButtonClicked
{
    if(objTwitter!=nil){
        [objTwitter release];
        objTwitter = nil;
    }
    objTwitter=[[Twitter alloc] initWithNibName:@"Twitter" bundle:nil];
    objTwitter.strTweetContent=@"http://www.thedailymeal.com/twitter/oauthoqrCiNqIWRX5lz6kCGZTQ?ls=1&mt=8";
    
    if(dialog!=nil){
        [dialog release];
        dialog = nil;
        
    }
    dialog=[[ShareView alloc] initWithFrame:([UIScreen mainScreen].applicationFrame) 
                                  ShareType:twitter
                                 andSubView:objTwitter.view];
    objTwitter.parentView=dialog;
    [dialog load];

}

- (void)mailButtonClicked
{
    NSString *mailContent = @"Business Details";
    NSString *subject     =[dict objectForKey:@"name"];
    [self sendEmailTo:@"" withSubject:subject withBody:mailContent];
}

- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body
{    
    if(!objEmailShare)
        objEmailShare = [[SPEmailShare alloc]init];
    
    objEmailShare.mailSubject=@"";
    objEmailShare.toRecipients=[NSArray arrayWithObjects:nil];
    objEmailShare.ccRecipients=[NSArray arrayWithObjects:nil];
    objEmailShare.bccRecipients=[NSArray arrayWithObjects:nil];
    objEmailShare.messageBody=@"";
    
    if ([objEmailShare canSendMail])    {
        
        [objEmailShare performSelectorOnMainThread:@selector(sendMail) withObject:nil waitUntilDone:NO];
    }
    else
    {
        kSHOW_ALERT_WITH_MESSAGE(@"Sorry", @" Please login to your account.");
    }
    

}

#pragma mark-
- (void)shareBusinessDetails
{
    if (![Reachability connected]) {
        
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:ACTIONSHEET_TITLE delegate:self cancelButtonTitle:ACTIONSHEET_CANCEL_BUTTON_TITLE destructiveButtonTitle:nil otherButtonTitles:ACTIONSHEET_FACEBOOK_BUTTON_TITLE,ACTIONSHEET_TWITTER_BUTTON_TITLE,ACTIONSHEET_MAIL_BUTTON_TITLE,nil];
        
        //   [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"business2.jpg"] forState:UIControlStateNormal];
        
        //    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"yourImage_Highlighted.png"] forState:UIControlStateHighlighted];
        
        [actionSheet showInView:self.tabBarController.view];
        REMOVE_FROM_MEMORY(actionSheet);
    }

}


#pragma mark - Action sheet delegates


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (FACEBOOK_BUTTON_INDEX == buttonIndex)
    {
        [self facebookButtonClicked];
    }
    else if(TWITTER_BUTTON_INDEX == buttonIndex)
    {
        [self twitterButtonClicked];
    }
    else if(MAIL_BUTTON_INDEX == buttonIndex)
    {
        [self mailButtonClicked];  
    }
          
}

#pragma mark - mail composer

- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body {
    NSArray *toRecipients;
    MFMailComposeViewController *mailController ;
    if ([MFMailComposeViewController  canSendMail]) {
        mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        if(mailController )
            toRecipients = [NSArray arrayWithObjects:toAddress, nil]; 
        [mailController setToRecipients:toRecipients];
        [mailController setSubject:subject];
        [mailController setMessageBody:body isHTML:false];
        [self  presentModalViewController:mailController animated:true];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                              
                                                        message:@"Kindly configure your system mail"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EMailsendung fehlgeschlagen!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [controller dismissModalViewControllerAnimated:true];
}


#pragma mark - Handle Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - getSignatureDish delegates
-(void)retrievedSignatureDishSuccessFully
{
    NSLog(@"in business home %@",[TDMSharedSignatureDishDetails sharedSignatureDishDetails].signatureDishHeaders);
    [businessTable reloadData];
}
-(void)failedToGetSignatureDish
{
    
}
@end
