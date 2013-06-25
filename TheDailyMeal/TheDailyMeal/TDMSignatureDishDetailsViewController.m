//
//  TDMSignatureDishDetailsViewController.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSignatureDishDetailsViewController.h"
#import "TDMBusinessViewController.h"
#import "TDMMyFavoritesViewController.h"
#import "TDMAddSignatureDishViewController.h"
#import "BussinessModel.h"
#import "TDMReviewRestaurant.h"
#import "TDMLoginViewController.h"

@interface TDMSignatureDishDetailsViewController()
- (void)initializeView;
- (void)setSignatureDishDetails;
- (void)loadWebViewWithReview;
- (void)changeViewVisibility;
- (NSMutableString *)createFormattedHtmlStringWithBody:(NSString *)body;

- (IBAction)restaurantButtonTouched:(id)sender;
- (IBAction)addToWishListButtonTouched:(id)sender;
- (IBAction)shareYourThoughtButtonTouched:(id)sender;

@end

@implementation TDMSignatureDishDetailsViewController
@synthesize dishImageView;
@synthesize backgroundImageView;
@synthesize contentView;
@synthesize scrollView;
@synthesize restaurantButton;
@synthesize dishImageButton;
@synthesize dishNameLabel;
@synthesize restaurantNameLabel;
@synthesize reviewAuthorImage;
@synthesize reviewAuthorName;
@synthesize reviewDescriptionWebView;
@synthesize mainDetailsView;
@synthesize signatureDishModel;
@synthesize navigationBarTitle;
@synthesize shareThoughtsBGView;
@synthesize reviewBGView;
@synthesize shareYourThoughtButton;
@synthesize addToWishList;
@synthesize atLabel;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {        
    }
    return self;
}

#pragma mark - Memory Management
- (void)dealloc 
{
    [shareThoughtsBGView release];
    [reviewBGView release];
    [shareYourThoughtButton release];
    [addToWishList release];
    [backgroundImageView release];
    [contentView release];
    [scrollView release];
    [restaurantButton release];
    [dishImageButton release];
    [dishNameLabel release];
    [restaurantNameLabel release];
    [reviewAuthorName release];
    [reviewDescriptionWebView release];
    [mainDetailsView release];
    [dishImageView release];
    [atLabel release];
    [navigationBarTitle release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addToWishList.hidden  = YES;//for later implementation
    //this will show the Tabbar
    [self showTabbar];
    if(self.signatureDishModel.dishName)
        [self.navigationBarTitle setText:self.signatureDishModel.dishName];
    //Creates backbutton
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    
    //creates Accountbar on Navigation Bar
    [self createAccountButtonOnNavBar];
    
    //creates Adv View
    [self createAdView];
    
    [self initializeView];
}

- (void)viewDidUnload
{
    self.shareThoughtsBGView = nil;
    self.reviewBGView = nil;
    self.shareYourThoughtButton = nil;
    self.addToWishList = nil;
    [self setSignatureDishModel:nil];
    [self setBackgroundImageView:nil];
    [self setContentView:nil];
    [self setScrollView:nil];
    [self setRestaurantButton:nil];
    [self setDishImageButton:nil];
    [self setDishNameLabel:nil];
    [self setRestaurantNameLabel:nil];
    [self setReviewAuthorName:nil];
    [self setReviewDescriptionWebView:nil];
    [self setMainDetailsView:nil];
    [self setDishImageView:nil];
    [self setAtLabel:nil];
    [self setNavigationBarTitle:nil];
    [super viewDidUnload];
}

#pragma mark - View Initializations

- (void)initializeView
{
    [self.scrollView.layer setBorderWidth:1.0];
    [self.scrollView.layer setCornerRadius:10.0];
    [self.scrollView.layer setBorderColor:[[UIColor colorWithWhite:0.5 alpha:0.1] CGColor]];
    
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
        [self.scrollView setContentSize:CGSizeMake(263, 900)];
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake(263, 800)];
    }
    
    [self setSignatureDishDetails];
}

#pragma mark - Button Action
- (IBAction)restaurantButtonTouched:(id)sender
{
    TDMBusinessViewController *businessView = [[TDMBusinessViewController alloc] 
                                               initWithNibName:@"TDMBusinessViewController"
                                               bundle:nil];
    businessView.tpyeForBusiness =3;
    businessView.model = self.signatureDishModel.businessModel;
    businessView.model.imageURL = self.signatureDishModel.venuImagePath;
    businessView.model.name = self.signatureDishModel.venuTitle;
    [self.navigationController pushViewController:businessView animated:YES];
    [businessView release];
    businessView = nil;
}

- (IBAction)addToWishListButtonTouched:(id)sender
{
    if([TDMDataStore sharedStore].isLoggedIn)
    {
    [self addBusinessToWishList]; 
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" message:@"Business Added To Wish List" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    }
    else
    {
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Please login to add dish")
    }
}

- (void)redirectToLoginPage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal"
                                                   message:@"Please login to access this feature." 
                                                  delegate:self 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:@"Cancel", nil];
    alert.tag = 66;
    [alert show];
    [alert release];
}

- (IBAction)shareYourThoughtButtonTouched:(id)sender
{
    if ([TDMDataStore sharedStore].isLoggedIn) 
    {
    TDMReviewRestaurant *addReview = [[TDMReviewRestaurant alloc] initWithNibName:@"TDMReviewRestaurant" bundle:nil];
    BussinessModel *tmpBusinessModel = self.signatureDishModel.businessModel;
    int venueID = [tmpBusinessModel.venueId intValue];
    addReview.businessId = venueID;
    [self.navigationController pushViewController:addReview animated:YES];
    [addReview release];
    addReview = nil;    
    }
    else
    {
        [self redirectToLoginPage];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 66)
    {
        if (buttonIndex == 0)
        {
            TDMLoginViewController *loginVC = [[TDMLoginViewController alloc]initWithNibName:@"TDMLoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
        
        
    }
    
}

#pragma mark - Helper Methods

- (void)setSignatureDishDetails
{
    if (self.signatureDishModel != nil) 
    {
        [self.scrollView addSubview:self.mainDetailsView];
        
        [self changeViewVisibility];
        
        //Setting Dish Image
            UIImage *backgroundImage;
        NSLog(@"%@",self.signatureDishModel.dishImageData);
            if(self.signatureDishModel.dishImageData)
                backgroundImage = [UIImage imageWithData:self.signatureDishModel.dishImageData];
            else
                backgroundImage = [UIImage imageNamed:@"imageNotAvailable"];
            UIImage *stretchedImage = [backgroundImage stretchableImageWithLeftCapWidth:200 topCapHeight:196];
            [self.dishImageButton setImage:stretchedImage forState:UIControlStateNormal];
            self.dishImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.dishImageButton.layer setCornerRadius:10.0];
            self.dishImageView.layer.borderWidth=1.0f;
            self.dishImageView.layer.borderColor=[[UIColor colorWithWhite:0.6 alpha:0.5]CGColor];
            [self.dishImageView.layer setMasksToBounds:YES];
            [self.dishImageView.layer setCornerRadius:10.0];
            //[[self.dishImageButton imageView]setContentMode:UIViewContentModeScaleAspectFit];
    //        [self.dishImageButton.layer setBorderColor:[[UIColor redColor]CGColor]];
            [self.dishImageButton.layer setMasksToBounds:YES];
        
        //Setting Dish Title
        NSString *dishTitle = @"";
        if ([self.signatureDishModel.dishName length]) 
        {
            dishTitle = self.signatureDishModel.dishName;                        
        }
        else 
        {    
            dishTitle = @""; 
            self.atLabel.frame=CGRectMake(55, 255, 27, 26);
            self.restaurantNameLabel.frame=CGRectMake(89, 255, 133, 21);
        }
        [self.dishNameLabel setText:dishTitle];
        
        //Setting Restaurant Name
        NSString *restaurantName = @"";
        if ([self.signatureDishModel.venuTitle length]) 
        {
            restaurantName = self.signatureDishModel.venuTitle;
            //to make the first letter capital
            restaurantName = [restaurantName stringByReplacingCharactersInRange:NSMakeRange(0,1)  
                                                                              withString:[[restaurantName  substringToIndex:1] capitalizedString]];  
        }
        else 
        {
            restaurantName = @"Restaurant name not available";
        }
        [self.restaurantNameLabel setText:restaurantName];
        
        //Setting Author Image
        reviewAuthorImage = [[TDMAsyncImage alloc] initWithFrame:CGRectMake(4, 6, 56, 59)];
        NSString *url = [NSString stringWithFormat:@"%@",self.signatureDishModel.staffImagePath];
        
        if([self.signatureDishModel.staffImagePath rangeOfString:@"http://"].location == NSNotFound)
        {
            url = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,self.signatureDishModel.staffImagePath];
        }
        else
        {
            url = [NSString stringWithFormat:@"%@",self.signatureDishModel.staffImagePath];
        }
        
        
        NSURL *authorImageUrl = [NSURL URLWithString:url];
        if(self.signatureDishModel.staffImagePath.length >0)
        {
            [reviewAuthorImage loadImageFromURL:authorImageUrl isFromHome:NO];
        }
        else
        {
            [reviewAuthorImage loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
        }
        [self.reviewBGView addSubview:reviewAuthorImage];
        [reviewAuthorImage release];
        reviewAuthorImage = nil;
        
        //Setting Review Author Name
        NSString *firstName = self.signatureDishModel.staffFirstName;
        NSString *lastName = self.signatureDishModel.staffLastName;
        NSString *authorName = @"";
        if(lastName.length == 0)
        {
            lastName = @"";
        }
        if(firstName.length == 0)
        {
            firstName = @"";
        }
        if (![firstName isEqualToString:@"<null>"] && ![lastName isEqualToString:@"<null>"]) 
        {
            authorName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];                        
        }
        else 
        {
            authorName = @"Author name not available";                        
        }
        
        [self.reviewAuthorName setText:authorName];
        
        //Setting Review Description
        [self loadWebViewWithReview];        
    }
}

- (void)changeViewVisibility
{
    CGRect shareThoughtFrame = self.shareThoughtsBGView.frame;
    CGRect addToWishlistButtonFrame = self.addToWishList.frame;
    int padding = 10;
    
//    if ([TDMDataStore sharedStore].isLoggedIn) 
//    {
        [self.shareThoughtsBGView setHidden:NO];
        
        CGRect reviewBGFrame = self.reviewBGView.frame;
        reviewBGFrame.origin.y = shareThoughtFrame.origin.y + shareThoughtFrame.size.height + padding;
        self.reviewBGView.frame = reviewBGFrame;
        
        [self.addToWishList setHidden:YES];
        
        CGRect goToRestaurantFrame = self.shareYourThoughtButton.frame;
        goToRestaurantFrame.origin.y = addToWishlistButtonFrame.origin.y + addToWishlistButtonFrame.size.height + padding;
        goToRestaurantFrame.origin.x = padding - 2;
//        self.restaurantButton.frame = goToRestaurantFrame;
//    }
//    else 
//    {
//        [self.shareThoughtsBGView setHidden:NO];
//        
//        CGRect reviewBGFrame = self.reviewBGView.frame;
//        reviewBGFrame.origin.y = shareThoughtFrame.origin.y;
//        self.reviewBGView.frame = reviewBGFrame;
//        
//        [self.addToWishList setHidden:YES];
//        
//        CGRect goToRestaurantFrame = self.restaurantButton.frame;
//        goToRestaurantFrame.origin.y = reviewBGFrame.origin.y + reviewBGFrame.size.height + padding;
//        self.restaurantButton.frame = goToRestaurantFrame;
//    }
}

#pragma mark  -  UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        return NO;
    }
    return YES;
}
- (void)loadWebViewWithReview
{    
    NSMutableString *htmlText = [self createFormattedHtmlStringWithBody:self.signatureDishModel.reviewDescription];

    [self.reviewDescriptionWebView loadHTMLString:htmlText baseURL:nil];
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
        reviewDescriptionWebView.frame=CGRectMake(67, 29, 175, 50);
        reviewBGView.frame=CGRectMake(5, 399, 253, 50);
//        restaurantButton.frame=CGRectMake(8, 480, 246, 40);
        [self.scrollView setContentSize:CGSizeMake(263, 800)];
        
    }    
       
    [htmlString appendFormat: @"\n </body>"];
    [htmlString appendFormat: @"\n </html>"];
    
    return htmlString;
}

#pragma mark - Handle orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)addBusinessToWishList
{
    NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    BussinessModel *detailsDict = self.signatureDishModel.businessModel;
    NSString *userId = [dict objectForKey:@"userid"];
    NSString *businessType = @"0";
    [[DatabaseManager sharedManager]insertIntoFavoritesTable:detailsDict userId:userId type:businessType];
}

- (IBAction)onClickGoToRestaurant:(id)sender {
    TDMBusinessViewController *businessView = [[TDMBusinessViewController alloc] 
                                               initWithNibName:@"TDMBusinessViewController"
                                               bundle:nil];
    businessView.tpyeForBusiness =3;
    businessView.model = self.signatureDishModel.businessModel;
    
    NSLog(@"*****************business ID %d",businessView.bID);
    businessView.model.imageURL = self.signatureDishModel.venuImagePath;
    [self.navigationController pushViewController:businessView animated:YES];
    [businessView release];
    businessView = nil;

}
@end
