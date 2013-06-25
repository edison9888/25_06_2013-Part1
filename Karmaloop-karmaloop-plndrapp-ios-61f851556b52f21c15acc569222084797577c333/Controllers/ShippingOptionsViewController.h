//
//  ShippingOptionsViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "CheckoutSummarySubscription.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"

@class CheckoutError;

typedef enum {
    ShippingOptionsSectionMethod,
    ShippingOptionsSectionOption
} ShippingOptionsSections;

@interface ShippingOptionsViewController : BaseModalViewController <SubscriptionDelegate>

@property (nonatomic, strong) NSArray *shippingMethods;
@property int currentShippingMethodIndex;
@property (nonatomic, strong) CheckoutSummarySubscription *checkoutSummarySubscription;
@property (nonatomic, strong) PopupViewController *checkoutErrorPopup;
@property (nonatomic, strong) CheckoutError *mostImportantError;
@property (nonatomic, strong) UILabel *emptyErrorLabel;
@end
