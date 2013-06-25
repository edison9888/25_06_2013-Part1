//
//  TDMReviewRestaurant.h
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMAddBusinessReviewService.h"
#import "TDMOverlayView.h"
#import "TDMPlaceHolderTextView.h"

@interface TDMReviewRestaurant : TDMBaseViewController<UITextViewDelegate> {
    
    TDMOverlayView *overlayView;
    BOOL edit;
}
@property (retain, nonatomic) IBOutlet UIImageView *restaurantReviewImage;
@property (retain, nonatomic) IBOutlet TDMPlaceHolderTextView *restaurantReviewTextView;
@property (retain, nonatomic) IBOutlet UIButton *restaurantReviewSubmitButton;
@property (retain, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (retain, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) NSString *restaurantName;
@property (assign, nonatomic) int businessId;
@property (retain, nonatomic) NSString *restaurantID;
@property (nonatomic, assign) int businessType;
@property (retain, nonatomic) IBOutlet TDMPlaceHolderTextView *reviewTitle;
@property (retain, nonatomic) IBOutlet UIScrollView *reviewScrollView;
@property (assign, nonatomic) BOOL isFromLogin;


- (IBAction)restaurantReviewSubmitButtonClicked:(id)sender;
- (void)showOverlayView;
- (void)addReviewTitleView;
- (void)addReviewDescriptionView;
- (void)registerKeyboardNotifications;
- (void)unregisterKeyboardNotifications;
@end
