//
//  StepTwoViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataViewController.h"
#import "CheckoutViewController.h"
#import "ShippingMethodsSubscription.h"
#import "CheckoutSummarySubscription.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"

@class HorizontalTableView;

typedef enum {
    CheckoutStepTwoSectionShippingOption,
    CheckoutStepTwoSectionDiscounts,
} CheckoutStepTwoSections;

typedef enum {
    CheckoutShippingOptionsCell
} CheckoutShippingOptionSectionCell;

typedef enum {
    CheckoutDiscountCell,
} CheckoutDiscountsSectionCell;

@interface StepTwoViewController : BaseDataViewController <CheckoutViewControllerDelegate, SubscriptionDelegate>

@property (nonatomic, weak) id<CheckoutDelegate> checkoutDelegate;

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) UIView *summaryViewContainer;
@property (nonatomic, strong) HorizontalTableView *summaryHorizontalTableView;
@property (nonatomic, strong) UIImageView *summaryBackgroundView;
@property (nonatomic, strong) UILabel *numberOfItemsLabel;
@property (nonatomic, strong) UILabel *subtotalAmountLabel;
@property (nonatomic, strong) UILabel *shippingAmountLabel;
@property (nonatomic, strong) UILabel *handlingAmountLabel;
@property (nonatomic, strong) UIView *summarySecondRule;
@property (nonatomic, strong) NSMutableArray *summaryDynamicViews;
@property (nonatomic, strong) PopupViewController *checkoutErrorPopup;
@property (nonatomic, strong) PopupViewController *checkoutOptionsErrorPopup;
@property (nonatomic, strong) UIButton *footerButton;

@property (nonatomic, strong) ShippingMethodsSubscription *shippingMethodsSubscription;
@property (nonatomic, strong) CheckoutSummarySubscription *checkoutSummarySubscription;

- (void) pushShippingOptions;
- (void) pushDiscounts;

@end
