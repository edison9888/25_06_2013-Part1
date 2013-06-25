//
//  TDMAddSignatureDishViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMPlaceHolderTextView.h"
#import "TDMOverlayView.h"
#import "TDMAddDishService.h"
#import "TDMPhotoUploadService.h"
#import "TDMAddSignatureDishThanks.h"

@interface TDMAddSignatureDishViewController : TDMBaseViewController<UITextViewDelegate,TDMAddDishServiceDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TDMPhotoUploadServiceDelegate,UIAlertViewDelegate>{

    UIImageView *backgroungImageView;
    UIImageView *titleViewImage;
    UILabel *viewTitleImageTitle;

    UIButton *submitButton;
    UILabel *reviewDescriptionLabel;
    UIButton *adButton;
    int icontentsize;
    BOOL position;
	BOOL bcontentflag;
    NSString *imageName;
    TDMPlaceHolderTextView *dishName;
    TDMOverlayView *overlayView;
    TDMPlaceHolderTextView *dishDescription;
    BOOL isPhotoUploaded;
    BOOL isFromBusinessHome;
    BOOL isPhotoPresent;
    BOOL isFromLogin;
    BOOL isActionSheetPresent;
    UIImageView *backgroundImage;
}
@property (nonatomic, retain) NSData* imageData;
@property (nonatomic, retain)NSString *imageName;
@property (nonatomic, assign) BOOL isFromLogin;
@property (nonatomic, assign)  BOOL isFromBusinessHome;
@property (retain, nonatomic) TDMPlaceHolderTextView *dishName;
@property (retain, nonatomic) TDMPlaceHolderTextView *dishDescription;
@property (assign, nonatomic) int venueId;
@property (assign, nonatomic) int businessType;
@property (retain, nonatomic)  UIScrollView *addDishScrollView;

@property (retain, nonatomic) UIImageView *backgroungImageView;
@property (retain, nonatomic) IBOutlet UIButton *findRestaurantBtn;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;

@property (retain, nonatomic)  UIImageView *titleViewImage;
@property (retain, nonatomic)  UILabel *viewTitleImageTitle;

@property (retain, nonatomic)  UIButton *submitButton;
@property (retain, nonatomic)  UILabel *reviewDescriptionLabel;
@property (retain, nonatomic)  UIButton *adButton;

- (void)takePhoto;
- (void)addFromLibrary;
- (BOOL)isDeviceHasCamera;
- (NSString *)getDirectoryPath;
- (void)uploadImage:(NSData* )imageData;
- (UIImage *)compressImage:(UIImage *)imageToCompress;
- (IBAction)addDishFindRestaurantClicked:(id)sender;
- (IBAction)addDishAndUploadImage:(id)sender;
- (IBAction)addNewImage:(id)sender;
- (void)submitAddDishDetails;
- (void)registerKeyboardNotifications;
- (void)unregisterKeyboardNotifications;
@end
