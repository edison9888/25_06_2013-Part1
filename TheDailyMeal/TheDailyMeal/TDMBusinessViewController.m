//
//  TDMBusinessViewController.m
//  TheDailyMeal
//
//  Created by Apple on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessViewController.h"
#import "TDMBusinessDetails.h"
#import "BussinessModel.h"
#import "BussinessModel.h"
#import "BussinessModel.h"
#import "TDMBusinessDetailViewController.h"
#import "TDMBestDishListService.h"
#import "TDMReviewListService.h"
#import "SignatureDishModel.h"
#import "BusinessReviewModel.h"
#import "TDMReviewRestaurant.h"
#import "TDMAsyncImage.h"
#import "TDMDataStore.h"
#import "TDMAddSignatureDishViewController.h"
#import "TDMMapViewAddress.h"
#import "BussinessModel.h"
#import "TDMNavigationController.h"
#import "DisplayMap.h"
#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TDMMakeReservationService.h"
#import "TDMRestaurantReviewList.h"
#import "TDMMakeReservationModel.h"
#import "TDMBusinessIDService.h"
#import "TDMBestDishList.h"
#import "TDMLoginViewController.h"
#import "TDMCustomTabBar.h"

@class AppDelegate;


@interface TDMBusinessViewController ()

#pragma mark    Map View Management
- (void)putAnnotationsToMapView;

- (void)removeOverlayView;
- (void)showOverlayView ;

- (void)getReviewList;
- (void)getBestDish ;
    
- (void)adjustView;
- (void)removeOverlayAndSetview;
- (void) getBusinessVenueIDFofBusiness;
@end

@implementation TDMBusinessViewController
@synthesize callButton;

@synthesize businessScrollView;
@synthesize addSignatureDish;
@synthesize businessReviewButton;
@synthesize addToWishListButton;
@synthesize shareButton;
@synthesize bestDishImageView;
@synthesize makeReservationButton;
@synthesize bestDishView;
@synthesize userReviewView;
@synthesize bestDishContainer;
@synthesize reviewContainer;
@synthesize staticCategoryLabel;
@synthesize mapView;
@synthesize businessDetailView;
@synthesize reviewUserImageView;
@synthesize foursquarePoweredLabel;
@synthesize foursquareLabel;
@synthesize bussinessAddress;
@synthesize bestDishDescription;
@synthesize bussinessCategory;
@synthesize businessNameLabel;
@synthesize businessPhoneLabel;
@synthesize businessCityLabel;
@synthesize bestDishArrowImageView;
@synthesize userReviewArrowImageView;
@synthesize businessArrowImageView;
@synthesize businessDetailButton;
@synthesize bestDishButton;
@synthesize userReviewButton;
@synthesize bestDishNameLabel;
@synthesize userReviewWebView;
@synthesize reviewUserNameLabel;
@synthesize tpyeForBusiness;
@synthesize indexForBusiness;
@synthesize currentBusinessObject;
@synthesize fourSquareImageView;
@synthesize bID;
@synthesize bussinesses;
@synthesize model;
@synthesize venuesID;
@synthesize cityName;
@synthesize reviewDishActivity;
@synthesize bestDishActivity;
@synthesize noReviewLabel;
@synthesize businessViewBgImage;
@synthesize reviewModel;
@synthesize signatureModel;
@synthesize businessImage;
@synthesize facebook,facebookShareContent;
@synthesize isFromShare;
@synthesize isBusinessHome;

#pragma mark - Memory Management



- (void)releaseVariables {
    
        
    [self setBusinessScrollView:nil];
    [self setAddSignatureDish:nil];
    [self setBusinessReviewButton:nil];
    [self setAddToWishListButton:nil];
    [self setShareButton:nil];
    [self setMakeReservationButton:nil];
    [self setBestDishView:nil];
    [self setUserReviewView:nil];
    [self setMapView:nil];
    [self setFoursquarePoweredLabel:nil];
    [self setFoursquareLabel:nil];
    [self setBestDishImageView:nil];
    [self setBusinessDetailView:nil];
    [self setBusinessNameLabel:nil];
    [self setBusinessPhoneLabel:nil];
    [self setBusinessCityLabel:nil];
    [self setBestDishArrowImageView:nil];
    [self setUserReviewArrowImageView:nil];
    [self setBusinessArrowImageView:nil];
    [self setBusinessDetailButton:nil];
    [self setBestDishButton:nil];
    [self setUserReviewButton:nil];
    [self setBestDishNameLabel:nil];
    [self setUserReviewWebView:nil];
    [self setReviewUserNameLabel:nil];
    [self setBussinessAddress:nil];
    [self setBussinessCategory:nil];
    [self setBestDishContainer:nil];
    [self setBestDishDescription:nil];
    [self setReviewUserImageView:nil];
    [self setBestDishContainer:nil];
    [self setBusinessViewBgImage:nil];
    [self setStaticCategoryLabel:nil];
    
//    self.reviewDishActivity = nil;
//    self.bestDishActivity = nil;
    if(shareViewController){
        [shareViewController release];
        shareViewController = nil;
    }
    
    
}


- (void)dealloc 
{
    if(serviceID){
        [serviceID clearDelegate];
        
    }

    if(makeReservation){
        [makeReservation clearDelegate];
        
      
    }

    if(makeReservation){
        [makeReservation release];
        
         
    }
    if(serviceID){
        [serviceID release];
       
    }
    if(reviewListService){
        
        reviewListService.reviewListserviceDelegate = nil;
        [reviewListService release];
       
    }
    if(bestDishService){
       
         bestDishService.bestDishListserviceDelegate = nil;
        [bestDishService release];
       
    }
    if(facebook){
        [facebook release];
        
    }
    
    
    
    makeReservation = nil;
    serviceID = nil;
    makeReservation = nil;
    
    reviewListService = nil;
   
    bestDishService = nil;
    makeReservation = nil;
    facebook = nil;
    [callButton release];
    [noReviewLabel release];
    [self releaseVariables];
    [super dealloc];
}


- (void)viewDidUnload
{
    [self releaseVariables];
    [self setCallButton:nil];
    [self setNoReviewLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.navigationItem setTDMIconImage];
    }
    return self;
}

- (void)showIndicator {
    
    [self.reviewDishActivity startAnimating]; 
    [self.bestDishActivity startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self createNavigationBarButtonOfType:kHOME_BAR_BUTTON_TYPE];
    
    [self setFrame];
    [self adjustView];
    [self showIndicator];
}
-(void) viewWillAppear:(BOOL)animated
{
   
    [self putAnnotationsToMapView];
    [self selectBusinessType];
    if (animated) {
        if(!isFromShare)
        [self getBusinessVenueIDFofBusiness];
    }
//    else if(!(self.bID<=0)|| self.model.venueId)
//    {
//        [self getBusinessVenueIDFofBusiness];
//    }
//    else
//    {
//        [self getReviewList];
//    }

    
        
  
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}
#pragma mark - initialize


-(void) selectBusinessType {
    
    self.venuesID = model.venueId;
    phoneNumber = model.contactPhone;
    if ([phoneNumber isEqualToString:@""]) 
    {
        callButton.userInteractionEnabled = NO;
    }
    else
    {
        callButton.userInteractionEnabled = YES;
    }
    self.businessNameLabel.text = model.name;
    NSString * addressValue = @"";
    if (![model.locationAddress isEqualToString:@""] ) {
        addressValue = model.locationAddress;
    }
    if (![model.locationCity isEqualToString:@""]) {
        if (addressValue.length>0) {
            addressValue = [addressValue stringByAppendingString:@", "];
        }
        addressValue = [addressValue stringByAppendingString:model.locationCity];
    }
    if (![model.locationCountry isEqualToString:@""]) {
        if (addressValue.length>0) {
            addressValue = [addressValue stringByAppendingString:@", "];
        }
        addressValue = [addressValue stringByAppendingString:model.locationCountry];
    }
    self.bussinessAddress.text = addressValue;
    if (![model.contactFormattedPhone isEqualToString:@""]) 
    {
    self.businessPhoneLabel.text = model.contactFormattedPhone;
    }
    else if (![model.contactPhone isEqualToString:@""]) 
    {
        NSString *contactFormated =  @"";
        if([model.contactPhone length] == 10)
        {
            NSString* initialContactNumber = [NSString stringWithFormat:@"(%@)",[model.contactPhone substringToIndex:3]];
            NSString *middledigits = [model.contactPhone substringWithRange:NSMakeRange(3, 3)];
            NSString* lastdigits = [model.contactPhone substringFromIndex:6];
            initialContactNumber = [NSString stringWithFormat:@"%@-%@-%@",initialContactNumber,middledigits,lastdigits];
            
            contactFormated = initialContactNumber;
            self.businessPhoneLabel.text = contactFormated;
            model.contactFormattedPhone = contactFormated;
        }
        else
        {
            self.businessPhoneLabel.text = model.contactPhone;
        }
    }
    else
    {
        self.businessPhoneLabel.text = @"";
        
    }
    if(model.categoryName.length > 0)
    {
        self.bussinessCategory.text = model.categoryName;
        self.bussinessCategory.hidden= NO;
        self.staticCategoryLabel.hidden= NO;
    }
    else
    {
        self.bussinessCategory.hidden= YES;
        self.staticCategoryLabel.hidden= YES;
    }
}


#pragma mark - Adjust View

- (void)setFoursquareLabelFrame {
    
    //foursquare labels
    [self.foursquarePoweredLabel setFrame:CGRectMake(40, 680, 100, 37)];
    [self.foursquareLabel setFrame:CGRectMake(150, 670, 140, 37)];
    [self.fourSquareImageView setFrame:CGRectMake(145, (670 + 13), 15, 15)];

}

- (void)adjustView
{

    int y = 230;
    int yPadding = 50;
    int yPaddingForContainer = 105;
    
    //add dish button
    [self.addSignatureDish setFrame:CGRectMake(20,y, 280,37)];
    y = y + yPadding;
    
    //best dish container
    [self.bestDishContainer setFrame:CGRectMake(20, y, 280,87)];
    y = y + yPaddingForContainer;
    if(isBestDishPresent){
        [self.bestDishActivity setHidden:YES];
        if(self.bestDishDescription.text.length == 0){
            self.bestDishNameLabel.frame=CGRectMake(80, 20, 148, 26);
            self.bestDishDescription.frame=CGRectMake(72, 32, 184, 60);
            self.bestDishDescription.text = @"No Best dishes";
            self.bestDishDescription.textColor=[UIColor lightGrayColor];
        }
           }
    if(!isBestDishPresent){
        [self.bestDishActivity setHidden:NO];
        self.bestDishNameLabel.frame=CGRectMake(80, 2, 148, 26);
       }
    
    //review button
    [self.businessReviewButton setFrame:CGRectMake(20,y, 280,37)];
    y = y + yPadding;
    
    //review container
    [self.userReviewView setFrame:CGRectMake(20, y, 280,87)];
    y = y + yPaddingForContainer;
    if(isReviewFetched){
        if(self.reviewUserNameLabel.text.length == 0 || [self.reviewUserNameLabel.text isEqualToString:@"Reviews"]){
            self.reviewUserNameLabel.frame=CGRectMake(80, 25, 163, 21);
            self.noReviewLabel.frame=CGRectMake(80, 40, 104, 20);
            self.reviewUserNameLabel.text = @"Reviews";
            self.noReviewLabel.text = @"No reviews present";
            self.noReviewLabel.textColor=[UIColor lightGrayColor];
            self.userReviewWebView.hidden=YES;
             [self.reviewDishActivity setHidden:NO];
            self.noReviewLabel.hidden=NO;
        }
        else{
            self.reviewUserNameLabel.frame=CGRectMake(80, 1, 163, 30);
            self.noReviewLabel.frame=CGRectMake(80, 20, 104, 20);
            self.noReviewLabel.hidden=YES;
        }
        [self.reviewDishActivity setHidden:YES];
    }

   
    //add to wish list button
    [self.addToWishListButton setFrame:CGRectMake(20,y, 280,37)];
    y = y + yPadding;
    
    //share button
    [self.shareButton setFrame:CGRectMake(20, y, 280, 37)];
    y = y + yPadding;
    
        if (isMakeReservation) 
        {
            //make reservation button
             makeReservationButton.hidden = NO;
            [self.makeReservationButton setFrame:CGRectMake(20, y, 280, 37)];
            y = y + yPadding;
            
            //foursquare labels
            [self.foursquarePoweredLabel setFrame:CGRectMake(40, y, 100, 37)];
            [self.foursquareLabel setFrame:CGRectMake(150, y, 140, 37)];
            [self.fourSquareImageView setFrame:CGRectMake(145, (y + 13), 15, 15)];
            
            //scroll content size
            [self.businessScrollView setContentSize:CGSizeMake(320, 730)];
        }
      else
      {
          makeReservationButton.hidden = YES;
          [self.foursquarePoweredLabel setFrame:CGRectMake(40, y, 100, 37)];
          [self.foursquareLabel setFrame:CGRectMake(150, y, 140, 37)];
          [self.fourSquareImageView setFrame:CGRectMake(145, (y + 11), 15, 15)];
          
          //scroll content size
          [self.businessScrollView setContentSize:CGSizeMake(320, 675)];
          
      }
    CGRect imageFrame = businessViewBgImage.frame;
    imageFrame.size.height = businessScrollView.contentSize.height ;
    businessViewBgImage.frame = imageFrame;
    

}

#pragma mark - reservation call

- (void)sentMakeReservationCall
{
    NSString *venue = [NSString stringWithFormat:@"%@",model.venueId];
    makeReservation = [[TDMMakeReservationService alloc]init];
    makeReservation.makeReservationDelegate = self;
    [makeReservation makeReservationCall: venue];
}

- (void)makeReservationServiceResponse:(NSMutableArray *)response
{
   
    if(makeReservation){
        makeReservation.makeReservationDelegate = nil;
        [makeReservation release];
        makeReservation = nil;
    }
    isMakeReservation = 1;
    for (int i =0; i <[response count]; i++) 
    {
        TDMMakeReservationModel *reservationModel = [response objectAtIndex:i];
        businessID = reservationModel.businessId;
        self.cityName = reservationModel.cityName;
    }
    [self adjustView];
    if(!self.model.categoryImages)
    {
        [self getCategoryImages];   
    }
    else
    {
        [self enableUserInteraction];
    }

    
}

//fail response
-(void) makeReservationResponse
{
 
    if(makeReservation){
        makeReservation.makeReservationDelegate = nil;
        [makeReservation release];
        makeReservation = nil;
    }
    isMakeReservation = 0;
    makeReservationButton.hidden = YES;
    if(!self.model.categoryImages)
    {
        [self getCategoryImages];   
    }
    else
    {
        [self enableUserInteraction];
    }
     [self adjustView];

}

#pragma mark - Button Actions

- (BOOL)checkForLogin {
    
    BOOL isLoggedIn = NO;
    if([TDMDataStore sharedStore].isLoggedIn){
        
        isLoggedIn = YES;
    }
    else {
        
        [self redirectToLoginPage];
    }
    
    return isLoggedIn;
}

- (IBAction)addDishButtonClick:(id)sender 
{
    NSString *businessId= [NSString stringWithFormat:@"%@",self.model.venueId];
    [TDMUtilities setRestaurantId:businessId];
    [TDMUtilities setRestaurantName:self.model.name];
    
        if (self.bID && [TDMDataStore sharedStore].isLoggedIn) 
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"bestDish" forKey:kIS_TO_LOGIN];
            TDMAddSignatureDishViewController *signatureDish = [[TDMAddSignatureDishViewController alloc] initWithNibName:@"TDMAddSignatureDishViewController" bundle:nil];
            signatureDish.isFromBusinessHome = 1;
            signatureDish.businessType = tpyeForBusiness;
            [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
            [self.navigationController pushViewController:signatureDish animated:YES];
            [signatureDish release];
            signatureDish = nil;
            
        }
        else
        {
            if ([TDMDataStore sharedStore].isLoggedIn)             
            {
                if (!self.bID)
                {
                     kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been added to TDM and hence we can't add a dish")
                }
               else
               {
                   [self redirectToLoginPage];
               }
            }
            else
            {
                 [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
                [self redirectToLoginPage];
            }
        }
       
   
}


- (IBAction)reviewBusinessButtonClick:(id)sender 
{
     [[NSUserDefaults standardUserDefaults]setObject:self.businessNameLabel.text forKey:@"reviewRestaurantName"];
 
    if (self.bID && [TDMDataStore sharedStore].isLoggedIn) 
    {         
           [[NSUserDefaults standardUserDefaults]setObject:@"review" forKey:kIS_TO_LOGIN];
            TDMReviewRestaurant *restaurantReview = [[TDMReviewRestaurant alloc] init];
            [restaurantReview setRestaurantName:self.businessNameLabel.text];
             [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
            restaurantReview.businessId = self.bID;
            restaurantReview.businessType =tpyeForBusiness;
            [self.navigationController pushViewController:restaurantReview animated:YES];
            [restaurantReview release];
            restaurantReview = nil;
           
        }
        else
        {
            if ([TDMDataStore sharedStore].isLoggedIn)             
            {
                if (!self.bID)
                {
                    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been added to TDM and hence we can't add a dish")
                }
                else
                {
                    [self redirectToLoginPage];
                }
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
                [self redirectToLoginPage];
            }

        }

}

- (IBAction)addToWishListButtonClick:(id)sender
{
    if([self checkForLogin]){
        [self addBusinessToWishList]; 
        
    }
}

- (IBAction)shareButtonClick:(id)sender {
    
    if(shareViewController){
        [shareViewController release];
        shareViewController = nil;
    }
    isFromShare = YES;
    shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.parentController = self;
    shareViewController.restauraName  = self.businessNameLabel.text;
    //shareViewController.restauraAddress = self.businessCityLabel.text;
    shareViewController.isFromBusinessHome = YES;
   
    NSString *twiterText = [NSString stringWithFormat:@"I vote for %@",model.name];
    shareViewController.twitterBody = twiterText;
    NSLog(@"venue image : %d",self.model.imageURL.length);
    if (self.model.categoryImages) {
        shareViewController.imagePath = [self.model.categoryImages lastObject];
    }
    else if(!(self.model.imageURL.length == 6))
    {
        NSString *urlString;
        if([self.model.imageURL rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,self.model.imageURL];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@",self.model.imageURL];
        }

        shareViewController.imagePath = urlString;
    }
//    shareViewController.reviewText = reviewModel.reviewText;
       shareViewController.restauraCategory = self.bussinessCategory.text;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:shareViewController.view];

}

- (IBAction)businessDetailButtonClick:(id)sender
{
    TDMBusinessDetailViewController *businessViewController = [[TDMBusinessDetailViewController alloc]init];
    businessViewController.bussiness    = self.model;
    businessViewController.businessId   = self.bID;
    businessViewController.foursquareId = fourSquaresId;
    businessViewController.businessType = tpyeForBusiness;
    businessViewController.reviewModel  = self.reviewModel;
    businessViewController.signatureModel = self.signatureModel;
    businessViewController.makeReservationVenueId = businessID;
    [businessViewController setBussiness:model];
    [self.navigationController pushViewController:businessViewController animated:YES];
    [businessViewController release];
}

- (IBAction)bestDishButtonClick:(id)sender
{
    
    if([self checkForLogin]){
        TDMBestDishList *bestdish = [[TDMBestDishList alloc]initWithNibName:@"TDMBestDishList" bundle:nil];
      
        bestdish.restaurantNameTitle = [NSString stringWithFormat:@"Best Dishes on %@",model.name];  
        bestdish.businessModel = self.model;
        [self.navigationController pushViewController:bestdish animated:YES];
//        [bestdish release];
//        bestdish = nil;
    }
}

- (IBAction)userReviewButtonClick:(id)sender 
{
    if([self checkForLogin]){
        TDMRestaurantReviewList *review = [[TDMRestaurantReviewList alloc]init];
        review.restaurantNameTitle = self.businessNameLabel.text;
        [self.navigationController pushViewController:review animated:YES];
        [review release];
    }
    
}


- (IBAction)makeReservationButtonClick:(id)sender 
{
    if([self checkForLogin]){

        NSString *businessName = model.name;
        businessName = [businessName lowercaseString];
        businessName= [businessName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        self.cityName = [self.cityName lowercaseString];
        self.cityName = [self.cityName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *url = [NSString stringWithFormat: @"http://www.opentable.com/%@reservations-%@?rid=%@&ref=8926",businessName,self.cityName,
                         businessID];
        char lastChar = [businessName characterAtIndex:businessName.length-1];
        if (lastChar  == '-') 
        {
            url = [NSString stringWithFormat: @"http://www.opentable.com/%@reservations-%@?rid=%@&ref=8926",businessName,cityName,
                   businessID];
        }
        else
        {
            url = [NSString stringWithFormat: @"http://www.opentable.com/%@-reservations-%@?rid=%@&ref=8926",businessName,cityName,
                   businessID];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
    }
}


- (void)addBusinessToWishList
{ 
    NSDictionary *diction;
    if (![model.fourSquareId isEqualToString:@""]) 
    {
        diction = [[DatabaseManager sharedManager]getWishListForFoursquareId:model.fourSquareId];
    }
    else
    {
        diction = [[DatabaseManager sharedManager]getWishListForBusinessId:[NSString stringWithFormat:@"%@", model.venueId]];
    }
        if (diction) 
        {
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Business already exists!!!")
        }
        else
        {
            NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
            NSString *userId = [dict objectForKey:@"userid"];
            
            model.venueId = [NSString stringWithFormat:@"%d",bID];
            NSString *businesType = [NSString stringWithFormat:@"%d",tpyeForBusiness];
            [[DatabaseManager sharedManager]insertIntoFavoritesTable:self.model userId:userId type:businesType];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" message:@"Business Added To Wish List" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
//    }
//    else
//    {
//         kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been registered with foursquare and hence we cannot add to the wishlist")
//    }
    
}

#pragma mark - share view delegates


- (void)onMailButtonClickWithBody:(NSString *)body
{
    isBusinessHome=YES;
    if ([MFMailComposeViewController canSendMail]) 
    {
        
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;    
        [picker.visibleViewController.navigationItem setTDMTitle:@"Share with mail"];
        
        [picker setMessageBody:body isHTML:YES];
        NSString *tittle=[NSString stringWithFormat:@"What's the best dish at %@",self.model.name];
        [picker setSubject:tittle];
//        UIImage *pic = [UIImage imageNamed:@"imageNotAvailable"];
//        NSData *exportData = UIImageJPEGRepresentation(pic ,1.0);
//        [picker addAttachmentData:exportData mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
        [self.navigationController presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" 
                                                       message:@"Please check your mail configuration. We can't send e-mail from your device." 
                                                      delegate:nil 
                                             cancelButtonTitle:@"OK" 
                                             otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
}

- (IBAction)onClickCallAction:(id)sender 
{
    if (![phoneNumber isEqualToString:@""]) 
    {
        NSString *trimmed = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *phoneURLString = [NSString stringWithFormat:@"tel://%@", trimmed];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneURLString]])
        {
            NSString *message = [NSString stringWithFormat:@"%@", model.contactFormattedPhone];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                            message:message 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                                  otherButtonTitles:@"Call",nil];
            alert.tag = 69;
            [alert show];
            [alert release];
            alert = nil;
        }
        else 
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" 
                                                             message:@"Your device does not support this feature!" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"Dismiss" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
           
        }           
    }

    
}

- (void)makeACall
{
    @try {
        NSString *phoneURLString = [NSString stringWithFormat: @"tel://%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString: phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }

}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 69) {
        if (buttonIndex == 1)
        {
            [self makeACall];
        }

    }
    else if(alertView.tag == 64)
    {
        if (buttonIndex == 0)
        {
            TDMLoginViewController *loginVC = [[TDMLoginViewController alloc]initWithNibName:@"TDMLoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
       
    }
    

}

#pragma mark - mail composer delagate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - view settings

-(void) setFrame
{
    
    UIImage *accessoryImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"accessory" ofType:@"png"]];
    
    self.bestDishArrowImageView.image = accessoryImage;
    self.userReviewArrowImageView.image = accessoryImage;
    self.businessArrowImageView.image = accessoryImage;
    
    [self.bestDishArrowImageView setFrame:CGRectMake(self.bestDishArrowImageView.frame.origin.x + 23, self.bestDishArrowImageView.frame.origin.y + 4, 17, 17)];
    [self.bestDishArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.userReviewArrowImageView setFrame:CGRectMake(self.userReviewArrowImageView.frame.origin.x + 23, self.userReviewArrowImageView.frame.origin.y + 4, 17, 17)];
    [self.userReviewArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.businessArrowImageView setFrame:CGRectMake(self.businessArrowImageView.frame.origin.x + 29, self.businessArrowImageView.frame.origin.y + 3, 17, 17)];
    [self.businessArrowImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    [accessoryImage release];
    accessoryImage = nil;
    fourSquaresId = model.fourSquareId;
    [businessDetailView.layer setCornerRadius:5.0];
    [bestDishContainer.layer setBorderWidth:0.8];
    [bestDishContainer.layer setCornerRadius:5.0];
    [bestDishContainer.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    [userReviewView.layer setBorderWidth:0.8];
    [userReviewView.layer setCornerRadius:5.0];
    [userReviewView.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    if (tpyeForBusiness == 0) 
    {
        
        [businessReviewButton setTitle:@"Review This Bar" forState:UIControlStateNormal];
    }
    else
    {
        [businessReviewButton setTitle:@"Review This Restaurant" forState:UIControlStateNormal];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) getCategoryImages
{
    [self disableUserInteraction];
    businessImage = [[TDMBusinessImageService alloc]init];
    businessImage.businessImageDelegate = self;
    [businessImage getCategoryImagesForBusiness:self.model];
}

#pragma mark - getting BusinessID 

-(void) getBusinessVenueIDFofBusiness
{
    [self disableUserInteraction];
    
    self.bID = [self.model.venueId intValue];
    
    if(self.bID<=0){
        serviceID = [[TDMBusinessIDService alloc] init];
        serviceID.businessIDdelegate= self;
        serviceID.delegate= self;
        [serviceID getBusinessVenueIDFofBusiness:model];
    }
    else{
        [self getReviewList];
    }
}

-(void) businessIDFetchedWithVenueID:(int)venueID
{
   
    if(serviceID){
        serviceID.businessIDdelegate = nil;
        serviceID.delegate= nil;
        [serviceID release];
        serviceID = nil;
    }
    self.bID = venueID;
    self.model.venueId = [NSString stringWithFormat:@"%d",self.bID];
    NSLog(@"business Id: %d",self.bID);
    if(self.bID > 0){
        //get the review list
       
        [self getReviewList];
    }
  
    
}

-(void) failedTOFetchBusinessID
{
    isReviewFetched = YES;
    isBestDishPresent = YES;
    
    [self removeOverlayAndSetview];
    [self.reviewDishActivity setHidden:YES];
    [self.bestDishActivity setHidden:YES];
    if(serviceID){
        serviceID.businessIDdelegate = nil;
        serviceID.delegate= nil;
        [serviceID release];
        serviceID = nil;
    }
    self.reviewUserNameLabel.frame=CGRectMake(80, 25, 163, 21);
    self.noReviewLabel.frame=CGRectMake(80, 40, 104, 20);
    self.noReviewLabel.text = @"No reviews present";
    self.noReviewLabel.textColor=[UIColor lightGrayColor];
    self.userReviewWebView.hidden=YES;
    self.noReviewLabel.hidden=NO;
    
    self.bestDishNameLabel.frame=CGRectMake(80, 20, 148, 26);
    self.bestDishDescription.frame=CGRectMake(72, 32, 184, 60);
    self.bestDishDescription.text = @"No Best dishes";
    self.bestDishDescription.textColor=[UIColor lightGrayColor];
    
    
}

- (void)requestFailedWithAuthenticationError:(ASIHTTPRequest *)theRequest{
    
    isBestDishPresent = YES;
    isReviewFetched   = YES;
    [self removeOverlayAndSetview];
}


#pragma mark - review list

- (void)getReviewList{
    
//    if(!overlayView)
    [self disableUserInteraction];
    reviewListService = [[TDMReviewListService alloc] init];
    reviewListService.reviewListserviceDelegate = self;
    [reviewListService getReviewListServiceForVenueID:self.bID];
    
}

#pragma mark -  review list service delegate

- (void)reviewListserviceResponse:(NSMutableArray *)responseArray
{
    [self.reviewDishActivity setHidden:YES];
    
    if ([responseArray count] >0) 
    {
        isReviewFetched = NO;
        self.reviewModel = [responseArray objectAtIndex:0];
        
        NSLog(@"%@",reviewModel.reviewText);
        
        [self.userReviewWebView loadHTMLString: [TDMUtilities createHTMLString:reviewModel.reviewText ]  baseURL:[NSURL URLWithString:nil]];
        NSString *username = nil;
        username = [NSString stringWithFormat:@"Review By  %@", reviewModel.userName];
        self.reviewUserNameLabel.text = username;
        self.reviewUserNameLabel.frame=CGRectMake(80, 7, 163, 21);
        self.noReviewLabel.text=reviewModel.reviewText;
        self.noReviewLabel.frame=CGRectMake(80, 30, 104, 20);
        self.noReviewLabel.font=[UIFont fontWithName:@"Trebuchet MS" size:13];
        NSString *urlpath;
        if([reviewModel.businessImage isKindOfClass:NSClassFromString(@"NSString")])
        {
            if(![reviewModel.businessImage isEqualToString:@""])
            {
                urlpath = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,reviewModel.businessImage];//[urlpath stringByAppendingString:reviewModel.businessImage];
                if (!([urlpath isKindOfClass:[NSNull class]] )) 
                {
                    if(![urlpath isEqualToString:@""]) 
                    {
                        NSURL *url = [[NSURL alloc] initWithString:urlpath];
                        [reviewUserImageView loadImageFromURL:url isFromHome:YES];
                        [url release];
                        url = nil;
                    }
                    else
                    {
                        [reviewUserImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                    }
                }
                else    
                {
                    [reviewUserImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                    
                }
            }
            else
            {
                [reviewUserImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            }
        }
    }
    else
    {
        isReviewFetched = YES;
        self.reviewUserNameLabel.frame=CGRectMake(80, 25, 163, 21);
        self.noReviewLabel.frame=CGRectMake(80, 40, 104, 20);
//        self.reviewUserNameLabel.text = @"Reviews";
        
        if (self.reviewModel.reviewText.length ==0) {
            self.noReviewLabel.hidden=NO;
            self.noReviewLabel.text = @"No reviews present";

        }
        
        self.noReviewLabel.textColor=[UIColor lightGrayColor];
        self.userReviewWebView.hidden=YES;
        
        
    }
//    if(reviewListService){
//        reviewListService.reviewListserviceDelegate = nil;
//        [reviewListService release];
//        reviewListService = nil;
//    }
    [self getBestDish];
    
}
- (void) networkErrorInFindingReview
{
  
    [self.reviewDishActivity setHidden:YES];
    [self enableUserInteraction];
}

-(void) reviewListFetchFailed {
    
    if(!self)
        return;
    isReviewFetched = YES;
    [self.reviewDishActivity setHidden:YES];
    if(reviewListService){
        reviewListService.reviewListserviceDelegate = nil;
      //  [reviewListService release];
        reviewListService = nil;
    }
    [self getBestDish];
}

#pragma mark - bestDish

-(void)getBestDish {

    bestDishService = [[TDMBestDishListService alloc]init];
    bestDishService.bestDishListserviceDelegate = self;
    [bestDishService getBestDishListServiceForVenueID:self.bID];
    
}

-(void)bestDishListserviceResponse:(NSMutableArray *)responseArray
{
   
    
    [self.bestDishActivity setHidden:YES];
    if(bestDishService)
    {
        bestDishService.bestDishListserviceDelegate = nil;
        [bestDishService release];
        bestDishService = nil;
    }
    isBestDishPresent = YES;
    if ([responseArray count]>0) 
    {
        self.bestDishView.hidden = NO;
        self.signatureModel = [responseArray objectAtIndex:0];
        self.bestDishNameLabel.frame=CGRectMake(80, 2, 148, 26);
        self.bestDishDescription.frame=CGRectMake(72, 25, 148, 26);
        self.bestDishDescription.text = signatureModel.signatureDishTitle;
        self.bestDishDescription.font = kGET_REGULAR_FONT_WITH_SIZE(13);
        NSString *urlpath = @"";
        if([signatureModel.signatureDishImage isKindOfClass:NSClassFromString(@"NSString")])
        {
            if(![signatureModel.signatureDishImage isEqualToString:@""])
            {
                urlpath = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,signatureModel.signatureDishImage];
                
                if (!([urlpath isKindOfClass:[NSNull class]] )) 
                {
                    if(![urlpath isEqualToString:@""]) 
                    {
                        NSURL *url = [[NSURL alloc] initWithString:urlpath];
                        [bestDishImageView loadImageFromURL:url isFromHome:YES];
                        [url release];
                        url = nil;
                    }
                    else
                    {
                        [bestDishImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                    }
                }
                else   
                {
                    [bestDishImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                    
                }
            }
            else
            {
                [bestDishImageView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            }
        }
    }
    else
    {
        self.bestDishNameLabel.frame=CGRectMake(80, 20, 148, 26);
        self.bestDishDescription.frame=CGRectMake(72, 32, 184, 60);
        self.bestDishDescription.text = @"No Best dishes";
        self.bestDishDescription.textColor=[UIColor lightGrayColor];
    }

    
    if([TDMDataStore sharedStore].isLoggedIn)
    {
        [self sentMakeReservationCall];
    }
    else
    {
        if(!self.model.categoryImages)
        {
            [self getCategoryImages];   
        }
        else
        {
            [self enableUserInteraction];
        }

    }
}


-(void) networkErrorInFindingBestDish
{
    self.bestDishActivity.hidden = YES;
    [self.bestDishActivity stopAnimating];
    [self removeOverlayAndSetview];
}

- (void)bestDishFetchFailed {
    
    if(!self)
        return;
    self.bestDishActivity.hidden = YES;
    isBestDishPresent = YES;
    if(bestDishService){
        bestDishService.bestDishListserviceDelegate = nil;
        [bestDishService release];
        bestDishService = nil;
    }
 //   self.bestDishActivity.hidden = YES;
    [self.bestDishActivity stopAnimating];
    if([TDMDataStore sharedStore].isLoggedIn)
    {
        [self sentMakeReservationCall];
    }
    else
    {
        if(!self.model.categoryImages)
        {
            [self getCategoryImages];   
        }
        else
        {
            [self enableUserInteraction];
        }

    }
}


#pragma mark    -
#pragma mark    Map View Management

- (void)putAnnotationsToMapView
{
    if (self.mapView != nil)
    {
        NSString *locationLatitude = nil;
        NSString *locationLongitude = nil;        
        NSString *annotationTitle = nil;
        if (self.model.locationLatitude != nil && self.model.locationLongitude != nil)
        {
            locationLatitude = self.model.locationLatitude;
            locationLongitude = self.model.locationLongitude;
        }
        
        if (self.model.name != nil && [NSNull null] != (NSNull *)self.model.name && 
            [self.model.name length] > 0)
        {
            annotationTitle = self.model.name;
        }        
        if (locationLatitude != nil && locationLongitude != nil)
        {
            MKCoordinateRegion region;
            region.center.latitude = [locationLatitude floatValue];
            region.center.longitude = [locationLongitude floatValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        
            DisplayMap *annotation = [[DisplayMap alloc] init];
            annotation.title = annotationTitle;
            annotation.coordinate = region.center;
            [mapView setMapType:MKMapTypeStandard];
            [mapView setScrollEnabled:YES];
            [mapView setDelegate:self];
            [mapView addAnnotation:annotation];
            [annotation release];
        }
    }
}

- (void)navBarButtonClicked:(id)sender
{
    if (kBACK_BAR_BUTTON_TYPE)
    {
        if(serviceID){
            [serviceID clearDelegate];
        }
        if(reviewListService){
            [reviewListService clearDelegate];
        }
        if(makeReservation){
            [makeReservation clearDelegate];
        }
        if(bestDishService){
            [bestDishService clearDelegate];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//creates either Home Bar Button or Back Bar Button
- (void)createNavigationBarButtonOfType:(int)aButtonType
{
    UIButton *navBarButton= [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,35)];
    [navBarButton setImage:kNAV_BAR_BACK_IMAGE forState:UIControlStateNormal];
    [navBarButton setImage:kNAV_BAR_BACK_IMAGE forState:UIControlStateSelected];
    navBarButton.tag = kBACK_BAR_BUTTON_TYPE;
    navBarButton.adjustsImageWhenHighlighted = NO;
    [navBarButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [navBarButton addTarget:self action:@selector(navBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *aBarButton = [[UIBarButtonItem alloc]initWithCustomView:navBarButton];
    REMOVE_FROM_MEMORY(navBarButton)
    self.navigationItem.leftBarButtonItem = aBarButton;
    REMOVE_FROM_MEMORY(aBarButton)
}

#pragma mark    Overlay View Management

- (void)removeOverlayView {
    if (overlayView) {
        [overlayView removeFromSuperview];
        [overlayView release];
        overlayView = nil;
    }
}

- (void)showOverlayView {
    
    [self removeOverlayView];
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading..."];
}

- (void)removeOverlayAndSetview {
    
//    [self removeOverlayView];
    [self enableUserInteraction];
    [self adjustView];
}
-(void) thumbnailReceivedForBusiness:(BussinessModel *)businessModel
{
    [self enableUserInteraction];
    for (NSString *imageURL in businessModel.categoryImages) {
        if(imageURL == nil || [imageURL isKindOfClass:NSClassFromString(@"NSNull")]|| [imageURL isEqualToString:@""])
        {
            imageURL = @"";
        }
    }
    self.model.categoryImages = businessModel.categoryImages;
    
}
-(void) failedToFecthPhoto
{
    [self enableUserInteraction];
}
-(void) networkError
{
    [self enableUserInteraction];
}


- (void)redirectToLoginPage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal"
                                                   message:@"Please login to access this feature." 
                                                  delegate:self 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:@"Cancel", nil];
    alert.tag = 64;
    [alert show];
    [alert release];
}



#pragma mark - facebook share

- (void)shareContent {
    
    NSString *restaurantsName = model.name;
    NSString *description = [NSString stringWithFormat:@"I just viewed %@ and hope you would like it.",restaurantsName];

    NSMutableDictionary *params =  
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"The Daily Meal", @"name",
     @"Have a look at this.", @"caption",
     description, @"description",
     @"http://www.facebook.com/TheDailyMeal", @"link",
     nil, @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}


- (void)onFacebookButtonClick:(NSString *)body{
    
    shareViewController.isFromBusinessHome=YES;
    self.facebookShareContent = body;
    if(facebook){
        
        [facebook release];
        facebook = nil;
    }
    facebook = [[Facebook alloc] initWithAppId:FBAPP_KEY andDelegate:self];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    facebook.userFlow = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.logindelegate = facebook;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [self shareContent];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    }
}


- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self shareContent];
}

- (void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
}

- (void)disableUserInteraction
{
    self.bestDishContainer.userInteractionEnabled = NO;
    self.reviewContainer.userInteractionEnabled = NO;
    self.addSignatureDish.userInteractionEnabled = NO;
    self.addToWishListButton.userInteractionEnabled = NO;
    self.businessReviewButton.userInteractionEnabled = NO;
    self.businessDetailView.userInteractionEnabled = NO;
    self.shareButton.userInteractionEnabled = NO;
    self.makeReservationButton.userInteractionEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    self.userReviewView.userInteractionEnabled = NO;
    self.userReviewButton.userInteractionEnabled = NO;
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    TDMCustomTabBar *tabBar = (TDMCustomTabBar *)appDelegate.tabBarController;
    [tabBar changeInteratcion:NO];
 
     [self disableBackButton:NO];
}

- (void)enableUserInteraction
{
    self.bestDishContainer.userInteractionEnabled = YES;
    self.reviewContainer.userInteractionEnabled = YES;
     self.addSignatureDish.userInteractionEnabled = YES;
    self.addToWishListButton.userInteractionEnabled = YES;
    self.businessReviewButton.userInteractionEnabled = YES;
     self.businessDetailView.userInteractionEnabled = YES;
     self.shareButton.userInteractionEnabled = YES;
     self.makeReservationButton.userInteractionEnabled = YES;
    self.mapView.userInteractionEnabled = YES;
     self.userReviewView.userInteractionEnabled = YES;
    self.userReviewButton.userInteractionEnabled =YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    TDMCustomTabBar *tabBar = (TDMCustomTabBar *)appDelegate.tabBarController;
    [tabBar changeInteratcion:YES];
  
     [self disableBackButton:YES];
    
}

@end
