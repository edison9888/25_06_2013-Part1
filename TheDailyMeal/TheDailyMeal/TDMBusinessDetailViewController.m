//
//  TDMBusinessDetailsViewController.m
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessDetailViewController.h"
#import "TDMBusinessDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "TDMBusinessDetails.h"
#import "SignatureDishModel.h"
#import "BusinessReviewModel.h"
#import "DatabaseManager.h"
#import "TDMDataStore.h"
#import "ShareViewController.h"
#import "TDMReviewRestaurant.h"
#import "TDMRestaurantReviewList.h"
#import "AppDelegate.h"
#import "TDMAddSignatureDishViewController.h"
#import "TDMBestDishList.h"
#import "TDMLoginViewController.h"

@interface TDMBusinessDetailViewController (Private)
- (void)getBestDishAndReviewDetails;
- (void)enableLoggedInMode;
- (void)enableLoggedOutMode;
- (void)removeOverlayView;
- (void)showOverlayView ;
- (void)getReviewList;
- (void)getBestDish ;
@end

@implementation TDMBusinessDetailViewController
@synthesize reviewPopUpButton;
@synthesize businessDetailView;
@synthesize businessNameLabel;
@synthesize bestDishContainer;
@synthesize businessAddressLabel;
@synthesize businessPhoneLabel;
@synthesize businessCategoriesLabel;
@synthesize businessWebsiteLabel;
@synthesize scrollContainer;
@synthesize businessNoteLabel;
@synthesize bestDishDescriptionTextView;
@synthesize reviewThisRestaurantButton;
@synthesize addBestDishButton;
@synthesize addToWishListButton;
@synthesize shareButton;
@synthesize makeReservationButton;
@synthesize bussinessAddressTextView;
@synthesize businessHoursLabel;
@synthesize businessPhoneValueLabel;
@synthesize businessCategoriesValueLabel;
@synthesize businessWebsiteValueLabel;
@synthesize businessNoteValueLabel;
@synthesize businessHoursValueLabel;
@synthesize businessDishScrollView;
@synthesize businessReviewView;
@synthesize bestDishAsynView;
@synthesize reviewAsyncImage;
@synthesize reviewUserName;
@synthesize reviewDescriptionWebView;
@synthesize businessDetailId;
@synthesize bussiness;
@synthesize businessId;
@synthesize isTDMRegistered;
@synthesize adView;
@synthesize foursquareId;
@synthesize callButton;
//@synthesize popUpButton;
@synthesize businessType;
@synthesize reviewModel;
@synthesize signatureModel;
@synthesize noReviewLabel;
@synthesize bestDishNameLabel;
@synthesize makeReservationVenueId;
@synthesize facebook;
@synthesize facebookShareContent;
@synthesize isBusinessDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
- (void)showCategoryImages {
    
    int x = 5;
    int categoryImageCount = [bussiness.categoryImages count];
    @try {
        for (int i = 0; i < categoryImageCount; i++)
        {
            TDMAsyncImage * asyncImageView = [[TDMAsyncImage alloc]initWithFrame:CGRectMake(x+3, 6, 55, 55)];
            asyncImageView.tag = 9999;
            
            UIButton *zoomImageButton=[[UIButton alloc]initWithFrame:CGRectMake(x+3, 6, 55, 55)];
            zoomImageButton.tag=i;
            //zoomImageButton.backgroundColor=[UIColor redColor];
            NSString *imageUrl = [bussiness.categoryImages objectAtIndex:i];
            [zoomImageButton addTarget:self action:@selector(onTouchUpZoomImageButton:) forControlEvents:UIControlEventTouchUpInside];

            @try {

                NSURL *url = [[NSURL alloc] initWithString:imageUrl];
                NSLog(@"ShowCategoryURL%@",url);
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:@"containerDishimagePath"];
//                [url release];
//                url = nil;
            }
            @catch (NSException *exception) {
                NSLog(@"Exception %@",exception);
            }
            [businessDishScrollView addSubview:asyncImageView];
            [businessDishScrollView addSubview:zoomImageButton];
            x  = x + 70; 
            [asyncImageView release];
            asyncImageView = nil;
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTDMIconImage];
    [self setAsynchImage];
    self.addToWishListButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    self.addBestDishButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    self.reviewThisRestaurantButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    self.makeReservationButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    self.shareButton.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    [self initialiseDetails];
    [self createAdView];
    if(businessType == 0)
    {
        self.reviewThisRestaurantButton.titleLabel.text = @"Review This Bar";
        self.reviewThisRestaurantButton.titleLabel.textAlignment = UITextAlignmentCenter;
    }
    if (!makeReservationVenueId) 
    {
        self.makeReservationButton.hidden = YES;
    }
    else
    {
        self.makeReservationButton.hidden = NO;
    }
    if (bussiness.categoryImages!=nil) {
        if([bussiness.categoryImages count])
            [self showCategoryImages];
        else
            [businessDishScrollView setHidden:YES];    
    }
    int contentSizeScroll = 5 + (70 * [bussiness.categoryImages count]);
    self.businessDishScrollView.contentSize = CGSizeMake(contentSizeScroll, 0);    

    [businessDishScrollView.layer setBorderWidth:1.0];
    [businessDishScrollView.layer setCornerRadius:5.0];
    [businessDishScrollView.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    
    [businessDetailView.layer setCornerRadius:5.0];
    
    [businessReviewView.layer setBorderWidth:0.8];
    [businessReviewView.layer setCornerRadius:5.0];
    [businessReviewView.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    
    [bestDishContainer.layer setBorderWidth:0.8];
    [bestDishContainer.layer setCornerRadius:5.0];
    [bestDishContainer.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor]];
    
    [self setupView];
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    [self showOverlayView];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (animated) {
        [self getBestDishAndReviewDetails];

    }  

    [self showNavigationBar];
    [self removeOverlayView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self removeOverlayView];

}


- (void)showNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)navBarButtonClicked:(id)sender
{
    if (kBACK_BAR_BUTTON_TYPE)
    {
        if(reviewListService){
            [reviewListService clearDelegate];
        }
        if(bestDishService){
            [bestDishService clearDelegate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self removeOverlayView];
    [reviewListService clearDelegate];
    [super viewWillDisappear:animated];
}

-(void)setAsynchImage{
    
    bestDishAsynView=[[TDMAsyncImage alloc]initWithFrame:CGRectMake(7, 10, 66, 66)];
    [self.bestDishContainer addSubview:self.bestDishAsynView];
    popUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    popUpButton.frame=CGRectMake(7, 10, 66, 66);
    [popUpButton addTarget:self action:@selector(onTouchUpPopUpButton:) forControlEvents:UIControlEventTouchUpInside];
    //[popUpButton bringSubviewToFront:bestDishAsynView];
    
    [self.bestDishContainer addSubview:popUpButton];
            
    
}
- (void)setViewFrames {

    int y = 270;
    self.reviewDescriptionWebView.backgroundColor = [UIColor clearColor];
    self.businessDishScrollView.hidden =NO;
    if([bussiness.categoryImages count] == 0)
    {
        y  = 200;
        self.businessDishScrollView.hidden = YES;
    }
    int yPadding = 50;
    int yPaddingForContainer = 105;
    
    
    [self.addBestDishButton setFrame:CGRectMake(20, y, 280, 39)];
    y = y + yPadding;
    
    [self.bestDishContainer setFrame:CGRectMake(20, y, 280, 87)];
    y = y + yPaddingForContainer;
    if(!self.signatureModel){
        self.bestDishNameLabel.frame=CGRectMake(80, 20, 148, 21);
        self.bestDishDescriptionTextView.frame=CGRectMake(72,32 , 184, 66);
        self.bestDishDescriptionTextView.text = @"No best dishes";
        self.bestDishDescriptionTextView.textColor=[UIColor lightGrayColor];
        popUpButton.hidden=TRUE;
        
        
        self.bestDishDescriptionTextView.font=[UIFont fontWithName:@"Trebuchet MS" size:13];
    }
    
    [self.reviewThisRestaurantButton setFrame:CGRectMake(20, y, 280, 39)];
    y = y + yPadding;
    
    [self.businessReviewView setFrame:CGRectMake(20, y, 280, 87)];
    y = y + yPaddingForContainer;
    if(!reviewModel){
        //self.reviewUserName.text=@"Reviews";
        self.noReviewLabel.text = @"No reviews present";
        self.reviewUserName.frame=CGRectMake(80, 22, 126, 24);
        self.noReviewLabel.frame=CGRectMake(80, 40, 113, 21);
        self.reviewDescriptionWebView.hidden=YES;
        self.noReviewLabel.textColor=[UIColor lightGrayColor];
    }
    else{
        self.reviewUserName.frame=CGRectMake(78, 2, 200, 24);
        //self.reviewUserName.text=@"Reviews";
        self.noReviewLabel.hidden = YES;
        self.reviewDescriptionWebView.hidden=NO;
        //self.reviewDescriptionWebView.frame=CGRectMake(72, 28, 148, 44);
    }
    [self.addToWishListButton setFrame:CGRectMake(20, y, 280, 39)];
    y = y + yPadding;
    [self.shareButton setFrame:CGRectMake(20, y, 280, 39)];
    y = y + yPadding;
    [self.makeReservationButton setFrame:CGRectMake(20, y, 280, 39)];

    [self.scrollContainer setContentSize:CGSizeMake(320, y+100)];
}

- (void)enableLoggedInMode {
    
    //hide unnecessary items
    [self setViewFrames];
    [self.reviewThisRestaurantButton setHidden:NO];
    [self.addBestDishButton setHidden:NO];
    [self.addToWishListButton setHidden:NO];
    [self.shareButton setHidden:NO];
    if (!makeReservationVenueId) 
    {
        self.makeReservationButton.hidden = YES;
    }
    else
    {
        self.makeReservationButton.hidden = NO;
    }

    CGRect bdScrollViewRect = businessDishScrollView.frame;
    [businessDishScrollView setFrame:bdScrollViewRect];
    
    //[scrollContainer setContentSize:CGSizeMake(320, 800)];
}

- (void)enableLoggedOutMode {
    
    //hide unnecessary items
    [self setViewFrames];
    [self.reviewThisRestaurantButton setHidden:YES];
    [self.addBestDishButton setHidden:YES];
    [self.addToWishListButton setHidden:YES];
    [self.shareButton setHidden:NO];
    [self.makeReservationButton setHidden:YES];
    businessReviewView.hidden = YES;
    businessDishScrollView.hidden = NO;
    bestDishContainer.hidden = YES;
    
    //set frame
    CGRect rtrButtonRect = reviewThisRestaurantButton.frame;
    CGRect bestDishContainerRect = bestDishContainer.frame;
    bestDishContainerRect.origin = rtrButtonRect.origin;
    [bestDishContainer setFrame:bestDishContainerRect];
    shareButton.frame = CGRectMake(20, 320, 280, 39);
    [scrollContainer setContentSize:CGSizeMake(320, 400)];
    
}

- (void)setupView {
    
    [self enableLoggedInMode];
//    if(reviewModel)
//        [self loadReviewContainer];
//    if(signatureModel)
//        [self loadBestDishContainer];

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
#pragma mark - button clicks

- (IBAction)onTouchUpReviewThisRestaurant:(id)sender {
    
  
    
    [[NSUserDefaults standardUserDefaults]setObject:self.businessNameLabel.text forKey:@"reviewRestaurantName"];
   
        if (self.businessId && [TDMDataStore sharedStore].isLoggedIn) {
            
              [[NSUserDefaults standardUserDefaults]setObject:@"review" forKey:kIS_TO_LOGIN];
            TDMReviewRestaurant *restaurantReview = [[TDMReviewRestaurant alloc]init];
            [restaurantReview setRestaurantName:self.businessNameLabel.text];
            restaurantReview.businessId = self.businessId;
            [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
           
            [self.navigationController pushViewController:restaurantReview animated:YES];
            [restaurantReview release];
            
        }
        else
        {
            if ([TDMDataStore sharedStore].isLoggedIn)             
            {
                if (!self.businessId)
                {
                    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been added to TDM and hence we can't add a review")
                }
                else
                {
                    [self redirectToLoginPage];
                }
            }
            
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"fromBusinessDetail" forKey:kIS_TO_LOGIN];
                [self redirectToLoginPage];
            }
            


        }
}

- (IBAction)onTouchUpAddBestDish:(id)sender {
   
         if (self.businessId && [TDMDataStore sharedStore].isLoggedIn) {
             
            [[NSUserDefaults standardUserDefaults]setObject:@"bestDish" forKey:kIS_TO_LOGIN];
            TDMAddSignatureDishViewController *signatureDish = [[TDMAddSignatureDishViewController alloc]initWithNibName:@"TDMAddSignatureDishViewController" bundle:nil];
            signatureDish.isFromBusinessHome = 1;
            signatureDish.businessType = businessType;
            NSString *businesseId= [NSString stringWithFormat:@"%@",bussiness.venueId];
            [TDMUtilities setRestaurantId:businesseId];
            [TDMUtilities setRestaurantName:self.bussiness.name];
             [[NSUserDefaults standardUserDefaults]setObject:@" " forKey:kIS_TO_LOGIN];
            [self.navigationController pushViewController:signatureDish animated:YES];
            [signatureDish release];
             
             
         }
        else
        {
            if ([TDMDataStore sharedStore].isLoggedIn)             
            {
                if (!self.businessId)
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
                [[NSUserDefaults standardUserDefaults]setObject:@"fromBusinessDetail" forKey:kIS_TO_LOGIN];
                [self redirectToLoginPage];
            }

        }
    
}

- (void)onTouchUpPopUpButton:(id)sender{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"bestDishimagePath"];
    if (![url isEqualToString:@""]) {
        zoomImage = [[TDMImageZoomHelper alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"bestDishimagePath"])
        {
            zoomImage.imagePath =[[NSUserDefaults standardUserDefaults] objectForKey:@"bestDishimagePath"];
        }
        zoomImage.navigationBardelegate = self;
        [zoomImage showImage];
        [self.view addSubview:zoomImage];
//        [zoomImage release];
//        zoomImage =nil;
        self.navigationController.navigationBarHidden = YES;
     
    }
}

- (void)onTouchUpZoomImageButton:(UIButton *)sender{
    //NSURL *url=[[NSUserDefaults standardUserDefaults]objectForKey:@"containerDishimagePath"];

        zoomImage = [[TDMImageZoomHelper alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"containerDishimagePath"])
        {
            zoomImage.imagePath =[bussiness.defaultCategoryImages objectAtIndex:sender.tag];
        }
        //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"containerDishimagePath"];
        zoomImage.navigationBardelegate = self;
        [zoomImage showImage];
        [self.view addSubview:zoomImage];
//        [zoomImage release];
//         zoomImage=nil;
        self.navigationController.navigationBarHidden = YES;
       
}
-(IBAction)onTouchUpReviewPopUpButton:(id)sender{
    zoomImage=[[TDMImageZoomHelper alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"reviewPopUp"]){
        zoomImage.imagePath=[[NSUserDefaults standardUserDefaults]objectForKey:@"reviewPopUp"];
        
    }
   
    zoomImage.navigationBardelegate=self;
    [zoomImage showImage];
    [self.view addSubview:zoomImage];
//    [zoomImage release];
//    zoomImage =nil;
    self.navigationController.navigationBarHidden=YES;
    
}
- (IBAction)onTouchUpAddToWishList:(id)sender {
    
    if([self checkForLogin])
    {
        NSDictionary *diction;
        if (![self.bussiness.fourSquareId isEqualToString:@""]) 
        {
            diction = [[DatabaseManager sharedManager]getWishListForFoursquareId:self.bussiness.fourSquareId];
        }
        else
        {
            diction = [[DatabaseManager sharedManager]getWishListForBusinessId:[NSString stringWithFormat:@"%@", self.bussiness.venueId]];
        }
            if (diction) 
            {
                kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Business already exists!!!")
            }
            else
            {
                NSDictionary *dict = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
                NSString *userId = [dict objectForKey:@"userid"];
                NSString *bussinessType = [NSString stringWithFormat:@"%d",businessType];
                [[DatabaseManager sharedManager]insertIntoFavoritesTable:bussiness userId:userId type:bussinessType];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                                message:@"Business Added To Wish List"
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }

//        }
//        else
//        {
//            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"This business has not been registered with foursquare and hence we cannot add to the wishlist")
//        }

    }
}


- (IBAction)onTouchUpMakeReservation:(id)sender {
    if([self checkForLogin])
    {
        
        NSString *businessName = bussiness.name;
        businessName = [businessName lowercaseString];
        businessName= [businessName stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        char lastChar = [businessName characterAtIndex:businessName.length-1];
        NSString * cityName = [[bussiness.locationCity lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *url;

        if (lastChar  == '-') 
        {
            url = [NSString stringWithFormat: @"http://www.opentable.com/%@reservations-%@?rid=%@&ref=8926",businessName,cityName,
                   makeReservationVenueId];
        }
        else
        {
            url = [NSString stringWithFormat: @"http://www.opentable.com/%@-reservations-%@?rid=%@&ref=8926",businessName,cityName,
                   makeReservationVenueId];
        }
        if ([url isEqualToString:@""]) {
            url = [NSString stringWithFormat: @"http://www.opentable.com/%@reservations-%@?rid=%@&ref=8926",businessName,cityName,
                   makeReservationVenueId];
            
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
    }
}

- (IBAction)onTouchUpRecentReview:(id)sender {
    
    if([self checkForLogin]){
        TDMRestaurantReviewList *review = [[TDMRestaurantReviewList alloc]init];
        review.restaurantNameTitle = self.businessNameLabel.text;
        [self.navigationController pushViewController:review animated:YES];
        [review release];
    }
}

#pragma mark - Call Action

- (IBAction)onClickCallAction:(id)sender 
{
    if (![phoneNumber isEqualToString:@""]) 
    {
        NSString *trimmed = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *phoneURLString = [NSString stringWithFormat:@"tel://%@", trimmed];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneURLString]])
        {
            NSString *message = [NSString stringWithFormat:@"%@", bussiness.contactFormattedPhone];
            
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
           // NSLog(@"Device does not support voice calls.");
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

#pragma mark - Website

- (IBAction)onClickShowWebsite:(id)sender 
{
    if (![businessWebsiteValueLabel.text isEqualToString:@" "]) 
    {
        NSString *url = [NSString stringWithFormat: @"%@",
                         businessWebsiteValueLabel.text];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
    }
    
}

#pragma mark - share click

- (IBAction)onTouchUpShare:(id)sender {
    
    if(shareViewController){
        [shareViewController release];
        shareViewController = nil;
    }
    shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.parentController = self;
    shareViewController.parentController = self;
    shareViewController.restauraName  = self.businessNameLabel.text;
    shareViewController.isFromBusinessHome = YES;
    
    NSString *twiterText = [NSString stringWithFormat:@"I vote for %@",self.bussiness.name];
    shareViewController.twitterBody = twiterText;
    //shareViewController.restauraAddress = self.bussinessAddressTextView.text;
    shareViewController.restauraCategory = self.businessCategoriesValueLabel.text;
    NSLog(@"venue image : %@",self.bussiness.imageURL);
    if (self.bussiness.categoryImages) {
        shareViewController.imagePath = [self.bussiness.categoryImages lastObject];
    }
    else if(self.bussiness.imageURL)
    {
        NSString *urlString;
        if([self.bussiness.imageURL rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,self.bussiness.imageURL];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@",self.bussiness.imageURL];
        }
        
        shareViewController.imagePath = urlString;
    }

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:shareViewController.view];
}

#pragma mark share delegates

- (void)onMailButtonClickWithBody:(NSString *)body
{
    isBusinessDetail=YES; 

    if ([MFMailComposeViewController canSendMail]) 
    {
        
        MFMailComposeViewController *picker = 
        [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;    
        [picker.visibleViewController.navigationItem setTDMTitle:@"Share with mail"];
        
        [picker setMessageBody:body isHTML:YES];
        NSString *tittle=[NSString stringWithFormat:@"What's the best dish at %@",bussiness.name];
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

- (IBAction)onTouchBestDish:(id)sender
{
    if([self checkForLogin]){
        TDMBestDishList *bestdish = [[TDMBestDishList alloc]init];
        bestdish.restaurantNameTitle = [bussiness.name stringByAppendingFormat:@" Best Dishes"];
        [self.navigationController pushViewController:bestdish animated:YES];
        [bestdish release];
        bestdish = nil;
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{
    [controller dismissModalViewControllerAnimated:YES];
}



- (void)initialiseDetails 
{
    businessNameLabel.text = bussiness.name;
    if(![bussiness.locationAddress isEqualToString:@""]&&![bussiness.locationCity isEqualToString:@""]&&![bussiness.locationCountry isEqualToString:@""])
    {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@, %@",
                                             bussiness.locationAddress,
                                             bussiness.locationCity,
                                             bussiness.locationCountry];
      
        
    }
    else  if(![bussiness.locationAddress isEqualToString:@""])
    {
        if (![bussiness.locationCity isEqualToString:@""]) {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                             bussiness.locationAddress,bussiness.locationCity];
        }
        else if(![bussiness.locationCountry isEqualToString:@""])
        {
        bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                         bussiness.locationAddress,bussiness.locationCountry];
        }
        else
        {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@",
                                             bussiness.locationAddress];
        }

    }
    else  if(![bussiness.locationCity isEqualToString:@""])
    {
        if (![bussiness.locationAddress isEqualToString:@""]) {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                             bussiness.locationAddress,bussiness.locationCity];
        }
        else if(![bussiness.locationCountry isEqualToString:@""])
        {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                             bussiness.locationCity,bussiness.locationCountry];
        }
        else
        {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@",
                                             bussiness.locationCity];
        }
        
    }
    else  if(![bussiness.locationCountry isEqualToString:@""])
    {
        if (![bussiness.locationAddress isEqualToString:@""]) {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                             bussiness.locationAddress,bussiness.locationCity];
        }
        else if(![bussiness.locationCity isEqualToString:@""])
        {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@, %@",
                                             bussiness.locationCity,bussiness.locationCountry];
        }
        else
        {
            bussinessAddressTextView.text = [NSString stringWithFormat:@"%@",
                                             bussiness.locationCountry];
        }
        
    }
    if (bussiness.url) 
    {
        if(![bussiness.url isEqualToString:@""])
        {
            businessWebsiteValueLabel.text = bussiness.url;
        }
        else
        {
            businessWebsiteValueLabel.text = @"";
        }
    }
    
    phoneNumber = self.bussiness.contactPhone;
    if ([phoneNumber isEqualToString:@""]) 
    {
        callButton.userInteractionEnabled = NO;
    }
    else
    {
        callButton.userInteractionEnabled = YES;
    }
    businessPhoneValueLabel.text = bussiness.contactFormattedPhone;
    if (![ bussiness.contactFormattedPhone isEqualToString:@""]) 
    {
        self.businessPhoneValueLabel.text =  bussiness.contactFormattedPhone;
    }
    else if (![bussiness.contactPhone isEqualToString:@""]) 
    {
        NSString *contactFormated =  @"";
        if([bussiness.contactPhone length] == 10)
        {
            NSString* initialContactNumber = [NSString stringWithFormat:@"(%@)",[bussiness.contactPhone substringToIndex:3]];
            NSString *middledigits = [bussiness.contactPhone substringWithRange:NSMakeRange(3, 3)];
            NSString* lastdigits = [bussiness.contactPhone substringFromIndex:6];
            initialContactNumber = [NSString stringWithFormat:@"%@-%@-%@",initialContactNumber,middledigits,lastdigits];
            
            contactFormated = initialContactNumber;
            self.businessPhoneValueLabel.text = contactFormated;
            bussiness.contactFormattedPhone = contactFormated;
        }
        else
        {
           self.businessPhoneValueLabel.text = bussiness.contactPhone ;
        }
        
    }
    else
    {
        self.businessPhoneValueLabel.text = @"";
        
    }
    businessCategoriesValueLabel.text = bussiness.categoryName;
    
    
    
    
    if([self.businessNoteValueLabel isKindOfClass:NSClassFromString(@"NSNull")] || self.businessNoteValueLabel.text.length == 0)
    {
        self.businessNoteValueLabel.text = @"";
    }
    
    if([self.businessHoursValueLabel isKindOfClass:NSClassFromString(@"NSNull")] || self.businessHoursValueLabel.text.length == 0)
    {
        self.businessWebsiteValueLabel.text = @"";
    }
}

- (void)getBestDishAndReviewDetails
{
    
    if(businessId > 0){
//        [self showOverlayView];
        [self getReviewList];
        
    }
    else
        [self setupView];
    
}

#pragma mark - data fetch 


- (void)getReviewList{
    
    [self disableBackButton:NO];
    reviewListService = [[TDMReviewListService alloc]init];
    [reviewListService getReviewListServiceForVenueID:businessId];
    reviewListService.reviewListserviceDelegate = self;
    
}

-(void)getBestDish {
    
    bestDishService = [[TDMBestDishListService alloc]init];
    [bestDishService getBestDishListServiceForVenueID:businessId];
    bestDishService.bestDishListserviceDelegate = self;
}


- (void)loadBestDishContainer {
    
    self.bestDishDescriptionTextView.text = self.signatureModel.signatureDishTitle;
    
    NSString *urlpath = nil;
    
    
    if([self.signatureModel.signatureDishImage isKindOfClass:NSClassFromString(@"NSString")]) 
    {
        if(![self.signatureModel.signatureDishImage isEqualToString:@""]) 
        {
            urlpath = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,self.signatureModel.signatureDishImage];
            NSLog(@"urlPat in best dish: %@",urlpath);
            
            [[NSUserDefaults standardUserDefaults] setObject:urlpath forKey:@"bestDishimagePath"];
            
            if (!([urlpath isKindOfClass:[NSNull class]] )) 
            {
                if(![urlpath isEqualToString:@""]) 
                {
                    NSURL *url = [[NSURL alloc] initWithString:urlpath];
                    [bestDishAsynView loadImageFromURL:url isFromHome:YES];
                    [url release];
                    url = nil;
                }
                else
                {
                    [bestDishAsynView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                }
            }
            else    
            {
                [bestDishAsynView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"bestDishimagePath"];
            [bestDishAsynView loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
        }
    }
}


- (void)bestDishListserviceResponse:(NSMutableArray *)responseArray
{

     [self disableBackButton:YES];
    if(bestDishService){
        [bestDishService release];
        bestDishService = nil;
    }
    //[self removeOverlayView];
    isBestDishPresent =  YES;
    if ([responseArray count]>0) 
    {
         if (responseArray) {
            
             if ( signatureModel && self.signatureModel) {
                 
                 @try {
                     
                      self.signatureModel = [responseArray objectAtIndex:0];
                       [self loadBestDishContainer];
                     [self setupView];

                     
                 }
                 @catch (NSException *exception) {
                      
                 }
                 @finally {
                      
                 }
             
                
                 
                 
             }
         }
       
      
    }
    
}

-(void) networkErrorInFindingBestDish
{
    //[self removeOverlayView];
     [self disableBackButton:YES];

}

-(void) bestDishFetchFailed {
    
    [self setupView];
     [self disableBackButton:YES];
   // [self removeOverlayView];
}

- (void)loadReviewContainer {
    
    [self.reviewDescriptionWebView loadHTMLString:[TDMUtilities createHTMLString:reviewModel.reviewText ] baseURL:[NSURL URLWithString:nil]];
    NSString *username = @" ";
    username = [NSString stringWithFormat:@"Review By  %@", reviewModel.userName];
    self.reviewUserName.text = username;
    NSString *urlpath = nil;

    if([reviewModel.businessImage isKindOfClass:NSClassFromString(@"NSString")])
    {
        if(![reviewModel.businessImage isEqualToString:@""])
        {
            urlpath = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,reviewModel.businessImage];
            if (!([urlpath isKindOfClass:[NSNull class]] )) {
                if(![urlpath isEqualToString:@""]) {
                    NSURL *url = [[NSURL alloc] initWithString:urlpath];
                    [reviewAsyncImage loadImageFromURL:url isFromHome:YES];
                    [[NSUserDefaults standardUserDefaults]setObject:urlpath forKey:@"reviewPopUp"];
                    [url release];
                    url = nil;
                }
                else
                {
                    [reviewAsyncImage loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                }
            }
            else    {
                [reviewAsyncImage loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
                
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"reviewPopUp"];
            [reviewAsyncImage loadExistingImage:[UIImage imageNamed:@"imageNotAvailable"]];
            
        }
    }

}

- (void)reviewListserviceResponse:(NSMutableArray *)responseArray
{
    
    if(reviewListService){
        [reviewListService release];
        reviewListService = nil;
    }
    isReviewPresent = YES;
    if([responseArray count]>0)
    {

        self.reviewModel = [responseArray objectAtIndex:0];
        
        [self loadReviewContainer];     
    }
    [self getBestDish];
    
    
}

- (void) networkErrorInFindingReview
{
     [self disableBackButton:YES];
 //   [self removeOverlayView];
}

-(void) reviewListFetchFailed {
     [self disableBackButton:YES];
    if(reviewListService){
        
        [reviewListService release];
        reviewListService = nil;
    }
   // [self removeOverlayView];
}

- (void)requestFailedWithAuthenticationError:(ASIHTTPRequest *)theRequest{
    
   // [self removeOverlayView];
     [self disableBackButton:YES];
}

#pragma mark - memory management

- (void)viewDidUnload
{
    
    [self setBusinessDetailView:nil];
    [self setBusinessNameLabel:nil];
    [self setBusinessAddressLabel:nil];
    [self setBusinessPhoneLabel:nil];
    [self setBusinessCategoriesLabel:nil];
    [self setBusinessWebsiteLabel:nil];
    [self setBusinessNoteLabel:nil];
    [self setBusinessHoursLabel:nil];
    [self setBusinessPhoneValueLabel:nil];
    [self setBusinessCategoriesValueLabel:nil];
    [self setBusinessWebsiteValueLabel:nil];
    [self setBusinessNoteValueLabel:nil];
    [self setBusinessHoursValueLabel:nil];
    [self setBusinessDishScrollView:nil];
    [self setBusinessReviewView:nil];
    [self setScrollContainer:nil];
    [self setBestDishAsynView:nil];
    [self setReviewAsyncImage:nil];
    [self setReviewUserName:nil];
    [self setReviewDescriptionWebView:nil];
    [self setBussinessAddressTextView:nil];
    [self setBestDishContainer:nil];
    [self setReviewThisRestaurantButton:nil];
    [self setAddBestDishButton:nil];
    [self setAddToWishListButton:nil];
    [self setShareButton:nil];
    [self setMakeReservationButton:nil];
    [self setBestDishDescriptionTextView:nil];
    [self setCallButton:nil];
    [self setNoReviewLabel:nil];
    [self setBestDishNameLabel:nil];
  //  [self setPopUpButton:nil];
    [self setReviewPopUpButton:nil];
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
    
    if(reviewListService){
        [reviewListService clearDelegate];
    }
    if(bestDishService){
        [bestDishService clearDelegate];
    }
    self.bussiness = nil;
    self.businessDetailView = nil;
    self.businessDetailView = nil;
    self.businessNameLabel = nil;
    self.businessAddressLabel = nil;
    self.businessPhoneLabel = nil;
    self.businessCategoriesLabel = nil;
    self.businessWebsiteLabel = nil;
    self.businessNoteLabel = nil;
    self.businessHoursLabel = nil;
    self.businessPhoneValueLabel = nil;
    self.businessCategoriesValueLabel = nil;
    self.businessWebsiteValueLabel = nil;
    self.businessNoteValueLabel = nil;
    self.businessHoursValueLabel = nil;
    self.businessDishScrollView = nil;
    self.businessReviewView = nil;
    self.scrollContainer = nil;
    self.bestDishAsynView = nil;
    self.reviewAsyncImage = nil;
    self.reviewUserName = nil;
    self.reviewDescriptionWebView = nil;
    self.bussinessAddressTextView = nil;
    self.bestDishContainer = nil;
    self.reviewThisRestaurantButton = nil;
    self.addBestDishButton = nil;
    self.addToWishListButton = nil;
    self.shareButton = nil;
    self.makeReservationButton = nil;
    self.bestDishDescriptionTextView = nil;
    [callButton release];
    self.reviewModel = nil;
    [noReviewLabel release];
    [bestDishNameLabel release];
    if(facebook){
        [facebook release];
        facebook = nil;
    }
    self.signatureModel = nil;
    signatureModel = nil;
    [zoomImage release];
    zoomImage=nil;
   
    [reviewPopUpButton release];
    [super dealloc];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 69) 
    {
        if (buttonIndex == 1)
        {
            [self makeACall];
        }
    }
    else if(alertView.tag == 66)
    {
        if (buttonIndex == 0)
        {
            TDMLoginViewController *loginVC = [[TDMLoginViewController alloc]initWithNibName:@"TDMLoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
    

    }
   
}



#pragma mark   - Overlay View Management

- (void)removeOverlayView {
    [self setupView];
    if (overlayView) {
        [overlayView removeFromSuperview];
       // [overlayView release];
        overlayView = nil;
    }
}

- (void)showOverlayView {
    
    [self removeOverlayView];
    overlayView = [[TDMOverlayView alloc] initWithSyncStyleAndTitle:@"Loading..."];
}


#pragma mark - facebook share

- (void)shareContent {
    
    NSString *restaurantsName = self.bussiness.name;
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
    
//    [facebook logout:self];
    
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
        //    }  
        
        
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



@end
