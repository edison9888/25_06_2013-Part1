//
//  TDMBusinessViewController.h
//  TheDailyMeal
//
//  Created by Apple on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TDMBestDishListService.h"
#import "TDMReviewListService.h"
#import "TDMAsyncImage.h"
#import "ShareViewController.h"
#import "TDMMakeReservationService.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BussinessModel.h"
#import "TDMBusinessIDService.h"
#import "TDMOverlayView.h"
#import "BusinessReviewModel.h"
#import "SignatureDishModel.h"
#import "TDMBusinessImageService.h"
#import "FBConnect.h"

@interface TDMBusinessViewController : TDMBaseViewController<MFMailComposeViewControllerDelegate,TDMBestDishListServiceDelegate,TDMReviewListServiceDelegate,MKMapViewDelegate,TDMMakeReservationServiceDelegate,TDMBusinessIDServiceDelegate,TDMBusinessImageServiceDelegate,FBDialogDelegate,FBSessionDelegate,UIAlertViewDelegate>
{
    int indexForBusiness;
    int tpyeForBusiness;
    id currentBusinessObject;
     NSMutableArray *detailsArray;
    int bID;
    BOOL isTDMRegistered;
    NSString *businessID;
    NSString *fourSquaresId;
    NSMutableArray *bussinesses;
    BussinessModel *model;
    BOOL isReviewFetched;
    BOOL isBestDishPresent;
    NSString *phoneNumber;
    TDMOverlayView *overlayView;
    NSString *cityName;
    ShareViewController *shareViewController;
    
    //services
    TDMBusinessIDService *serviceID;
    TDMReviewListService *reviewListService;
    TDMBestDishListService *bestDishService;
    TDMMakeReservationService *makeReservation;
    TDMBusinessImageService *businessImage;
    BOOL isMakeReservation;
    
    UIActivityIndicatorView *reviewDishActivity;
    UIActivityIndicatorView *bestDishActivity;
    Facebook *facebook;
}
@property (retain, nonatomic) Facebook *facebook;
@property (retain, nonatomic) NSString *facebookShareContent;
@property (retain, nonatomic) IBOutlet UILabel *noReviewLabel;

@property (retain, nonatomic) IBOutlet UIImageView *businessViewBgImage;
@property (nonatomic, retain) BusinessReviewModel * reviewModel;
@property (nonatomic, retain) SignatureDishModel *signatureModel;
@property (nonatomic, retain) TDMBusinessImageService *businessImage;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, strong) NSNumber *venuesID;
@property (retain, nonatomic) IBOutlet UIScrollView *businessScrollView;
@property (retain, nonatomic) IBOutlet UIButton *addSignatureDish;
@property (retain, nonatomic) IBOutlet UIButton *businessReviewButton;
@property (retain, nonatomic) IBOutlet UIButton *addToWishListButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet TDMAsyncImage *bestDishImageView;
@property (retain, nonatomic) IBOutlet UIButton *makeReservationButton;
@property (retain, nonatomic) IBOutlet UIView *bestDishView;
@property (retain, nonatomic) IBOutlet UIView *userReviewView;
@property (retain, nonatomic) IBOutlet UIView *bestDishContainer;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIView *businessDetailView;
@property (retain, nonatomic) IBOutlet TDMAsyncImage *reviewUserImageView;
@property (retain, nonatomic) IBOutlet UILabel *foursquarePoweredLabel;
@property (retain, nonatomic) IBOutlet UIImageView *fourSquareImageView;
@property (retain, nonatomic) IBOutlet UILabel *foursquareLabel;
@property (retain, nonatomic) IBOutlet UILabel *bussinessAddress;
@property (retain, nonatomic) IBOutlet UITextView *bestDishDescription;
@property (retain, nonatomic) IBOutlet UILabel *bussinessCategory;
@property (retain, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessPhoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *businessCityLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bestDishArrowImageView;
@property (retain, nonatomic) IBOutlet UIImageView *userReviewArrowImageView;
@property (retain, nonatomic) IBOutlet UIImageView *businessArrowImageView;
@property (retain, nonatomic) IBOutlet UIButton *businessDetailButton;
@property (retain, nonatomic) IBOutlet UIButton *bestDishButton;
@property (retain, nonatomic) IBOutlet UIButton *userReviewButton;
@property (retain, nonatomic) IBOutlet UILabel *bestDishNameLabel;
@property (retain, nonatomic) IBOutlet UIWebView *userReviewWebView;
@property (retain, nonatomic) IBOutlet UILabel *reviewUserNameLabel;
@property (assign) int bID;
@property (retain, nonatomic) NSMutableArray *bussinesses;
@property (retain, nonatomic) BussinessModel *model;
@property (retain, nonatomic) IBOutlet UIView *reviewContainer;
@property (retain, nonatomic) IBOutlet UILabel *staticCategoryLabel;
@property(nonatomic)BOOL isBusinessHome;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *reviewDishActivity;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *bestDishActivity;
//@property (retain, nonatomic) TDMBusinessIDService *serviceID;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
@property (assign) BOOL isFromShare;
@property (nonatomic) int indexForBusiness;
@property (nonatomic) int tpyeForBusiness;
@property (retain, nonatomic) id currentBusinessObject;


- (void) setFrame;
- (void)redirectToLoginPage;
- (void) selectBusinessType;
- (void) addBusinessToWishList;
//- (void) initializeView;
- (void)sentMakeReservationCall;
- (void)onMailButtonClickWithBody:(NSString *)body;
- (IBAction)onClickCallAction:(id)sender;
- (void)setFoursquareLabelFrame;
- (void)disableUserInteraction;
- (void)enableUserInteraction;
-(void) getCategoryImages;



- (IBAction)businessDetailButtonClick:(id)sender;
- (IBAction)bestDishButtonClick:(id)sender;
- (IBAction)userReviewButtonClick:(id)sender;
- (IBAction)addDishButtonClick:(id)sender;
- (IBAction)reviewBusinessButtonClick:(id)sender;
- (IBAction)addToWishListButtonClick:(id)sender;
- (IBAction)shareButtonClick:(id)sender;
- (IBAction)makeReservationButtonClick:(id)sender;

@end
