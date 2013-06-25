//
//  ManageAddressViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "AddressViewController.h"
#import "GetSavedAddressesSubscription.h"
#import "PopupNotificationViewController.h"
#import "UpdateSavedAddressSubscription.h"

@class Address, SavedAddress;

@protocol ManageAddressViewControllerDelegate <NSObject>

- (SavedAddressTypes) typeOfAddress;
- (BOOL) doesSupportSameAs;
- (NSString*) navTitle;

- (NSString*) getErrorHeaderMessage;

- (BOOL) isCheckout;

@optional
// Required if isCheckout can return YES
- (void) saveSelectedAddress:(SavedAddress*)savedAddress;

// Required if doesSupportSameAs can return YES
- (BOOL) isSameAsShippingAddress;
- (void) saveSameAsShippingAddress:(BOOL)isSame;

// Implement one of:
- (int) getSelectedAddressIndex;
- (Address*) getSelectedAddress;

// Implement one of:
- (int) getShippingAddressIndex;
- (Address*) getShippingAddress;

@end

typedef enum{
    ManageAddressSectionError,
    ManageAddressSectionSameAs,
    ManageAddressSectionCell,
    ManageAddressSectionNUM
}ManageAddressSections;

typedef enum{
    ManageAddressAddMoreCell,
    ManageAddressAddressCell
} ManageAddressCell;

@interface ManageAddressViewController : BaseModalViewController <AddressViewControllerDelegate, SubscriptionDelegate>

@property int currentSelectedAddressIndex;
@property int currentEditingAddressIndex;
@property (nonatomic, weak) id<ManageAddressViewControllerDelegate> manageDelegate;
@property (nonatomic, strong) UIButton *topAreaButton;
@property (nonatomic, strong) GetSavedAddressesSubscription *getSavedAddressesSubscription;
@property (nonatomic, strong) UpdateSavedAddressSubscription *updateSavedAddressSubscription;
@property (nonatomic, strong) PopupViewController *updateErrorPopup;
@property (nonatomic, strong) SavedAddress *recentlyUpdatedSavedAddress;

- (id) initWithManageDelegate:(id<ManageAddressViewControllerDelegate>)manageDelegate;

@end
