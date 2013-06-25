//
//  CheckoutViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlndrBaseViewController.h"
#import "CheckoutCompleteSubscription.h"
#import "PopupNotificationViewController.h"

typedef enum {
    CheckoutViewControllerStepOne = 0,
    CheckoutViewControllerStepTwo
}CheckoutViewControllerSteps;

@class StepOneViewController,StepTwoViewController,CheckoutError;

// For view management. Implemented by child views.
@protocol CheckoutViewControllerDelegate

- (BOOL) stepIsComplete;

@end

// For puchase. Implemented by the CheckoutViewController
@protocol CheckoutDelegate 

- (void) updateContainerView;
- (void) doPurchase;

@end

@interface CheckoutViewController : PlndrBaseViewController <CheckoutDelegate, SubscriptionDelegate>

@property (nonatomic, strong) UIButton *stepOneButton;
@property (nonatomic, strong) UIButton *stepTwoButton;

@property (nonatomic, strong) UIView *stepContainerView;
@property (nonatomic, strong) StepOneViewController *stepOneController;
@property (nonatomic, strong) StepTwoViewController *stepTwoController;
@property (nonatomic, strong) CheckoutCompleteSubscription *checkoutCompleteSubscription;
@property (nonatomic, strong) PopupViewController *checkoutErrorPopup;
@property (nonatomic, strong) PopupViewController *lastDisplayedCheckoutPopup;

- (void)changeToStep:(CheckoutViewControllerSteps)step;    //steps are 0 or 1 for step1 or step2

@end
