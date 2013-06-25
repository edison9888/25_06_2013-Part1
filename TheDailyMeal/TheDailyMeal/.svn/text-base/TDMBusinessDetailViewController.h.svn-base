//
//  TDMBusinessDetailsViewController.h
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "TDMAsyncImage.h"
#import "TDMBestDishListService.h"
#import "TDMReviewListService.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TDMBusinessImageService.h"
#import "TDMOverlayView.h"
#import "ShareViewController.h"
#import "BusinessReviewModel.h"
#import "SignatureDishModel.h"
#import "TDMBusinessImageService.h"
#import "FBConnect.h"
#import "TDMImageZoomHelper.h"

@interface TDMBusinessDetailViewController : TDMBaseViewController <MFMailComposeViewControllerDelegate,TDMBestDishListServiceDelegate, TDMReviewListServiceDelegate,FBDialogDelegate,FBSessionDelegate,ShowNavigationBar>{
    NSMutableArray *detailsArray;
    BussinessModel * bussiness;
    int businessId;
    BOOL isTDMRegistered;
    NSString *phoneNumber;
    
    BOOL isReviewPresent;
    BOOL isBestDishPresent;
    UIButton *popUpButton;
    TDMOverlayView *overlayView;
    ShareViewController *shareViewController;
    TDMImageZoomHelper *zoomImage;
    TDMReviewListService *reviewListService;
    TDMBestDishListService *bestDishService;
    
    Facebook *facebook;
    
    SignatureDishModel *signatureModel;
    
}
@property (retain, nonatomic) Facebook *facebook;
@property (retain, nonatomic) NSString *facebookShareContent;
@property (retain, nonatomic) IBOutlet UILabel *noReviewLabel;

@property (retain, nonatomic) IBOutlet UILabel *bestDishNameLabel;
@property (nonatomic, retain) NSString *makeReservationVenueId;
@property (nonatomic, retain) BusinessReviewModel * reviewModel;
@property (nonatomic, retain) SignatureDishModel *signatureModel;
@property (retain, nonatomic) BussinessModel * bussiness;
@property (assign, nonatomic) int businessDetailId;
@property (retain, nonatomic) IBOutlet UIView *businessDetailView;
@property (retain, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (retain, nonatomic) IBOutlet UIView *bestDishContainer;
@property (retain, nonatomic) IBOutlet UILabel *businessAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessPhoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessCategoriesLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessWebsiteLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollContainer;
@property (retain, nonatomic) IBOutlet UILabel *businessNoteLabel;
@property (retain, nonatomic) IBOutlet UITextView *bestDishDescriptionTextView;
@property (retain, nonatomic) IBOutlet UIButton *reviewThisRestaurantButton;
@property (retain, nonatomic) IBOutlet UIButton *addBestDishButton;
@property (retain, nonatomic) IBOutlet UIButton *addToWishListButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet UIButton *makeReservationButton;
@property (retain, nonatomic) IBOutlet UITextView *bussinessAddressTextView;
@property (retain, nonatomic) IBOutlet UILabel *businessHoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessPhoneValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessCategoriesValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessWebsiteValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessNoteValueLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessHoursValueLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *businessDishScrollView;
@property (retain, nonatomic) IBOutlet UIView *businessReviewView;
//@property (retain, nonatomic) IBOutlet TDMAsyncImage *bestDishAsynView1;
@property (retain, nonatomic) IBOutlet TDMAsyncImage *reviewAsyncImage;
@property (retain, nonatomic) IBOutlet UILabel *reviewUserName;
@property (retain, nonatomic) IBOutlet UIWebView *reviewDescriptionWebView;
@property (nonatomic,retain) IBOutlet UIWebView *adView;
@property (retain,nonatomic)TDMAsyncImage *bestDishAsynView;

@property (assign) int businessId;
@property (nonatomic) BOOL isTDMRegistered;
@property(nonatomic) BOOL isBusinessDetail;
@property (nonatomic, assign)int businessType;
@property (nonatomic, retain) NSString *foursquareId;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
//@property (retain, nonatomic) IBOutlet UIButton *popUpButton;
@property (retain, nonatomic) IBOutlet UIButton *reviewPopUpButton;

- (IBAction)onTouchUpReviewThisRestaurant:(id)sender;
- (IBAction)onTouchUpAddBestDish:(id)sender;
- (IBAction)onTouchUpAddToWishList:(id)sender;
- (IBAction)onTouchUpShare:(id)sender;
- (IBAction)onTouchUpMakeReservation:(id)sender;
- (IBAction)onTouchUpRecentReview:(id)sender;
- (IBAction)onClickCallAction:(id)sender;
- (IBAction)onClickShowWebsite:(id)sender;
- (void)onTouchUpPopUpButton:(id)sender;
- (void)onTouchUpZoomImageButton:(id)sender;
-(IBAction)onTouchUpReviewPopUpButton:(id)sender;
//- (void) getCategoryImages;
- (void)initialiseDetails;
- (void)makeACall;
- (void)setupView;
- (void)loadReviewContainer;
- (void)loadBestDishContainer;
- (void)onMailButtonClickWithBody:(NSString *)body;
- (IBAction)onTouchBestDish:(id)sender;
-(void)setAsynchImage;
- (void)showNavigationBar;

@end
