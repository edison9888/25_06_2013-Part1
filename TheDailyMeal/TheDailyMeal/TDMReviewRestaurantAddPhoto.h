//
//  TDMReviewRestaurantAddPhoto.h
//  TheDailyMeal
//
//  Created by Apple on 19/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "TDMPhotoUploadService.h"
#import "TDMOverlayView.h"
#import "ShareViewController.h"
#import "FBConnect.h"
#import "TDMAddBusinessReviewService.h"

@interface TDMReviewRestaurantAddPhoto : TDMBaseViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,TDMPhotoUploadServiceDelegate,MFMailComposeViewControllerDelegate,FBSessionDelegate,FBDialogDelegate,TDMAddBusinessReviewServiceDelegate> {
    
    TDMOverlayView *overlayView;
    ShareViewController *shareViewController;
    Facebook *facebook;
}

@property (assign, nonatomic) int businessId;
@property (retain, nonatomic) NSString *reviewText;
@property (retain, nonatomic) NSString *reviewTitle;
@property (retain, nonatomic) NSString *reviewDescription;
@property (retain, nonatomic) NSString *restaurantName;
@property (retain, nonatomic) NSString *facebookShareContent;
@property (retain, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (retain, nonatomic) IBOutlet UIButton *skipButton;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, retain) NSData *imageData;

- (IBAction)addPhotoClick:(id)sender;
- (IBAction)skipButtonClick:(id)sender;

@end
