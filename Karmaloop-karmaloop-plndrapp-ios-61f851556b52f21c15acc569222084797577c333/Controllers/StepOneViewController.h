//
//  StepOneViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataViewController.h"
#import "CheckoutViewController.h"
#import "ManageAddressViewController.h"
#import "AddressViewController.h"
#import "GetSavedAddressesSubscription.h"
#import "PopupNotificationViewController.h"
#import "PopupViewController.h"

typedef enum {
    CheckoutStepOneSectionsError,
    CheckoutStepOneSectionCreditCard,
    CheckoutStepOneSectionShipping,
    CheckoutStepOneSectionBilling,
    CheckoutStepOneSectionNUM
} CheckoutStepOneSections;

typedef enum {
    CheckoutCreditCardInfoCell
} CheckoutCreditCardSectionCell;

typedef enum {
    CheckoutBillingAddressInfoCell
} CheckoutBillingSectionCell;

typedef enum {
    CheckoutShippingAddressInfoCell
} CheckoutShippingSectionCell;

@interface StepOneViewController : BaseDataViewController <CheckoutViewControllerDelegate, ManageAddressViewControllerDelegate, AddressViewControllerDelegate, SubscriptionDelegate>

@property BOOL isCurrentlyEditingShippingAddress;
@property (nonatomic, strong) GetSavedAddressesSubscription *getSavedAddressesSubscription;

- (void) pushCreditCard;
- (void) pushAddress:(BOOL) isShipping;

@end
