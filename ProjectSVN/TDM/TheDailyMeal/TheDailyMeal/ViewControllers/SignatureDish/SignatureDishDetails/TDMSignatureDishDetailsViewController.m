//
//  TDMSignatureDishDetailsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSignatureDishDetailsViewController.h"
#import "TDMAddReviewViewController.h"
#import "ASIHTTPRequest.h"
#import "TDMBaseHttpHandler.h"
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "TDMBusinessHomeViewController.h"
#import "TDMAddSignatureDishWishList.h"
NSString * const kAllJobsAndStatusApi = @"/v2/venues/search?";

#define FOURSQUARE_CLIENTID @"3OSVSBMMMMAKYBN2QY4FKTHOCW4P3JDN4LCAVRNEBMDH5KD1"
#define FOURSQUARE_SECRETID @"XYT24E2M5SGZKD3GF2NFTO54BDWKWYOO1RO5UV3QIWF4G0AK"

#pragma mark - API Params
NSString * const kLatitudeAndLongitude = @"ll";
NSString * const kFourSqureclientID = @"client_id";
NSString * const kFourSquresecretID = @"client_secret";
@interface TDMSignatureDishDetailsViewController()
//private
- (void)customiseCurrentView;
- (void)addSignatuteDishImage;
- (void)addSignatureDishDetail;
- (void)setButtonFrames;
- (void)addReviewDishDetails;
@end

@implementation TDMSignatureDishDetailsViewController
@synthesize backgroundImageView;
@synthesize contentView;
@synthesize scrollView;
@synthesize dishNameLabel;
@synthesize dishByLabel;
@synthesize dishAuthorLabel;
@synthesize dishQuestonLabel;
@synthesize reviewButton;
@synthesize wishListButton;
@synthesize restaurantButton;
@synthesize titleImageView;
@synthesize titleImageViewTitle;
@synthesize addButton;
@synthesize responseData;
@synthesize selectedDishID;
@synthesize signatureDish;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self customiseCurrentView];
    [self.navigationItem setRBIconImage];
    
    //setting the view title name
    self.titleImageViewTitle.text = @"SignatureDish Detail";
    self.titleImageViewTitle.textColor = [UIColor whiteColor];
    self.titleImageViewTitle.font = kGET_BOLD_FONT_WITH_SIZE(12);
    
    TDMAppDelegate * TMDdelegate = (TDMAppDelegate*)[UIApplication sharedApplication].delegate;
    [TMDdelegate startGPSScan];
    TMDdelegate.delegate = self;
    
    //if add exist
    //[self.contentView setFrame:CGRectMake(0, 20, 320, 460)];
    //else [self.contentView setFrame:CGRectMake(160, 300, 320, 460)];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload {

    [self setBackgroundImageView:nil];
    [self setContentView:nil];
    [self setScrollView:nil];

    [self setDishNameLabel:nil];
    [self setDishByLabel:nil];
    [self setDishAuthorLabel:nil];
    [self setDishQuestonLabel:nil];
    [self setReviewButton:nil];
    [self setWishListButton:nil];
    [self setRestaurantButton:nil];
    [self setTitleImageView:nil];
    [self setTitleImageViewTitle:nil];
    [self setAddButton:nil];
    [self setSelectedDishID:nil];
    [self setSignatureDish:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Creations
- (void)customiseCurrentView{
    
    [self.scrollView.layer setBorderWidth:1.0];
    [self.scrollView.layer setCornerRadius:10.0];
    [self.scrollView.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
      
    [self.scrollView setContentSize:CGSizeMake(263, 850)];
    
    [self addSignatuteDishImage];
    [self addSignatureDishDetail];
    
    [self addReviewDishDetails];
    [self setButtonFrames];
    
}

- (void)addSignatuteDishImage
{
    UIButton *signatureDishImageButton = [[UIButton alloc]initWithFrame:CGRectMake(18, 10, 222, 222)];
    
    [signatureDishImageButton.layer setCornerRadius:10.0];
    [signatureDishImageButton setUserInteractionEnabled:NO];
    [signatureDishImageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"dish%d.jpg",[selectedDishID intValue]+1]] forState:UIControlStateNormal];
    
    signatureDishImageButton.layer.masksToBounds = YES;
    
    [self.scrollView addSubview:signatureDishImageButton];
    REMOVE_FROM_MEMORY(signatureDishImageButton); 
    
    //set border of the image 
    UIButton *borderButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 8, 226, 228)];
    borderButton.userInteractionEnabled = NO;
    [borderButton.layer setBorderWidth:1.0];
    [borderButton.layer setCornerRadius:10.0];
    [borderButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    [self.scrollView addSubview:borderButton];
    REMOVE_FROM_MEMORY(borderButton);
}

- (void)addSignatureDishDetail
{
    //[self populateDummyData];
    
    self.dishNameLabel.frame = CGRectMake(40, 250, 200, 30);
    self.dishNameLabel.backgroundColor  = [UIColor clearColor];
    self.dishNameLabel.textColor = [UIColor grayColor];
    self.dishNameLabel.font = kGET_BOLD_FONT_WITH_SIZE(18);
    self.dishNameLabel.textAlignment=UITextAlignmentCenter;
    self.dishNameLabel.text = signatureDish.name;

    
    self.dishByLabel.frame = CGRectMake(70, 280, 30, 30);
    self.dishByLabel.backgroundColor  = [UIColor clearColor];
    self.dishByLabel.textColor = [UIColor grayColor];
    self.dishByLabel.font = kGET_BOLD_FONT_WITH_SIZE(15);
    //self.dishByLabel.textAlignment=UITextAlignmentCenter;
    self.dishByLabel.text= @"by";
    
    self.dishAuthorLabel.frame = CGRectMake(90, 280, 170, 30);
    self.dishAuthorLabel.backgroundColor  = [UIColor clearColor];
    self.dishAuthorLabel.textColor = [UIColor blueColor];
    self.dishAuthorLabel.font = kGET_BOLD_FONT_WITH_SIZE(15);
    //self.dishAuthorLabel.textAlignment=UITextAlignmentCenter;
    self.dishAuthorLabel.text= signatureDish.resName;
    

    
#define SIGNATURE_DISH_QUESTION @"Have you had this dish?"   
    self.dishQuestonLabel.frame = CGRectMake(50, 315, 200, 30);
    self.dishQuestonLabel.backgroundColor  = [UIColor clearColor];
    self.dishQuestonLabel.textColor = [UIColor grayColor];
    self.dishQuestonLabel.font = kGET_BOLD_FONT_WITH_SIZE(15);
    //self.dishQuestonLabel.textAlignment=UITextAlignmentCenter;
    self.dishQuestonLabel.text = SIGNATURE_DISH_QUESTION;
}

- (void)addReviewDishDetails
{

    
    NSMutableDictionary *tempDictionary = [dummyDetailsArray objectAtIndex:[selectedDishID intValue]];
    
#define REVIEW_IMAGE_FRAME CGRectMake(12,425,56,59)
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"signaturedish"                                                                         
                                                        ofType:@"png"];
    UIImage *thumbImage   = [UIImage imageWithContentsOfFile:imgPath];
    UIImageView *imageThumbnail=[[UIImageView alloc]init];
    imageThumbnail.frame=REVIEW_IMAGE_FRAME;
    imageThumbnail.backgroundColor=[UIColor clearColor];
    imageThumbnail.userInteractionEnabled = NO;
    imageThumbnail.image    = thumbImage;
    [self.scrollView addSubview:imageThumbnail];
    REMOVE_FROM_MEMORY(imageThumbnail);
    
#define REVIEW_TITLE_FRAME CGRectMake(75,425,250,15)
    // Heading
    UILabel *heading=[[UILabel alloc]initWithFrame:REVIEW_TITLE_FRAME];
    heading.font = kGET_BOLD_FONT_WITH_SIZE(12);
    heading.textColor = [UIColor grayColor];
    heading.backgroundColor  = [UIColor clearColor];
    heading.textAlignment=UITextAlignmentLeft;
    heading.text= [NSString stringWithFormat:@"Review by author %@",[tempDictionary objectForKey:@"author"]];
    [self.scrollView addSubview:heading];
    REMOVE_FROM_MEMORY(heading);
    
#define REVIEW_SUB_TITLE_FRAME CGRectMake(75,441,150,50)
    // subTitle
    UILabel *subTitle=[[UILabel alloc]initWithFrame:REVIEW_SUB_TITLE_FRAME];
    subTitle.font = kGET_REGULAR_FONT_WITH_SIZE(12);
    subTitle.textColor = [UIColor grayColor];
    subTitle.backgroundColor  = [UIColor clearColor];
    subTitle.textAlignment=UITextAlignmentLeft;
    //subTitle.lineBreakMode = UILineBreakModeCharacterWrap;
    subTitle.numberOfLines = 0;
    //subTitle.text= @"Review detail Review detail Review detail Review detail Review detail Review detail Review detailReview detail Review detail Review detail Review detail ";
    subTitle.text = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"review"]];
    
    [self.scrollView addSubview:subTitle];
    REMOVE_FROM_MEMORY(subTitle);

//    //Button
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = SIGNATURE_DISH_DETAIL_RECT;
//    [button addTarget:self action:@selector(reviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [reviewView addSubview:button];
    
}


- (void)setButtonFrames
{
    self.reviewButton.frame = CGRectMake(11, 360, 240, 45);
    self.wishListButton.frame = CGRectMake(11, 535, 240, 45);
    self.restaurantButton.frame = CGRectMake(11, 595, 240, 45);
}

#pragma mark - Button Actions
- (IBAction)addToFavButtonClick:(id)sender {

    TDMAddSignatureDishWishList *addWishListController = (TDMAddSignatureDishWishList *)[self getClass:@"TDMAddSignatureDishWishList"];
    [self.navigationController pushViewController:addWishListController animated:YES];

}

- (IBAction)addReviewButtonClick:(id)sender {
    
    TDMAddReviewViewController *addReviewController = (TDMAddReviewViewController *)[self getClass:kADDREVIEW_CLASS];
    [self.navigationController pushViewController:addReviewController animated:YES];
}

- (IBAction)goToRestBarButtonClick:(id)sender {
    TDMBusinessHomeViewController *addBusinessController = (TDMBusinessHomeViewController *)[self getClass:kBUSINESSHOME_CLASS];
    [self.navigationController pushViewController:addBusinessController animated:YES];
}
- (IBAction)addButtonClicked:(id)sender {
}

#pragma mark Memory Management
- (void)dealloc {

    [backgroundImageView release];
    [contentView release];
    [scrollView release];
    [dishNameLabel release];
    [dishByLabel release];
    [dishAuthorLabel release];
    [dishQuestonLabel release];
    [reviewButton release];
    [wishListButton release];
    [restaurantButton release];
    [titleImageView release];
    [titleImageViewTitle release];
    [addButton release];
    [selectedDishID release];
    [dummyDetailsArray release];
    [super dealloc];
}
- (void)currentLocationDidSaved:(CLLocation*)location 
{
    TDMBusinessDetailsProviderAndHandler *businessDetailsHandler = [[TDMBusinessDetailsProviderAndHandler alloc] init];
    businessDetailsHandler.businessDetailsDelegate = self;
    [businessDetailsHandler getCurretLocationBusinessdetailsForQuery:@"restaurants" forLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];}

-(void)populateDummyData {
    dummyDetailsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    [tempDictionary setObject:@"Plah Sahm Rote" forKey:@"dishname"];
    [tempDictionary setObject:@"Nathan Horwitz" forKey:@"author"];
    [tempDictionary setObject:@"Delicious Thai Dish" forKey:@"review"];
    [dummyDetailsArray addObject:tempDictionary];
    [tempDictionary release];
    
    NSMutableDictionary *tempDictionary1 = [[NSMutableDictionary alloc] init];
    [tempDictionary1 setObject:@"Tortilla Soup" forKey:@"dishname"];
    [tempDictionary1 setObject:@"Brendon Fraser" forKey:@"author"];
    [tempDictionary1 setObject:@"The best starter" forKey:@"review"];
    [dummyDetailsArray addObject:tempDictionary1];
    [tempDictionary1 release];
    
    NSMutableDictionary *tempDictionary2 = [[NSMutableDictionary alloc] init];
    [tempDictionary2 setObject:@"Bruschetta" forKey:@"dishname"];
    [tempDictionary2 setObject:@"John Dalton" forKey:@"author"];
    [tempDictionary2 setObject:@"The best fried chicken" forKey:@"review"];
    
    [dummyDetailsArray addObject:tempDictionary2];
    [tempDictionary2 release];
    
    
    NSMutableDictionary *tempDictionary3 = [[NSMutableDictionary alloc] init];
    [tempDictionary3 setObject:@"Mini Ice Cream Sandwiches" forKey:@"dishname"];
    [tempDictionary3 setObject:@"James Franklin" forKey:@"author"];
    [tempDictionary3 setObject:@"The perfect dessert" forKey:@"review"];

    [dummyDetailsArray addObject:tempDictionary3];
    [tempDictionary3 release];
    
    NSMutableDictionary *tempDictionary4 = [[NSMutableDictionary alloc] init];
    [tempDictionary4 setObject:@"Black Bean Amuse Bouche" forKey:@"dishname"];
    [tempDictionary4 setObject:@"Gustavo Actosta" forKey:@"author"];
    [tempDictionary4 setObject:@"Nice alternative to chips and salsa" forKey:@"review"];
    
    [dummyDetailsArray addObject:tempDictionary4];
    [tempDictionary4 release];
    
    //NSLog(@"%@",dummyDetailsArray);
    

}
-(void)gotRestaurantDetails{}
-(void)failedToFetchRestaurantDetails{}

@end
