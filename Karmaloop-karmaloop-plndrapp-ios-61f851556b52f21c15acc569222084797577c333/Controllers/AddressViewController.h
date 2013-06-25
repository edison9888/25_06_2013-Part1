//
//  AddressViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"
#import "CountrySubscription.h"
#import "CreateSavedAddressSubscription.h"
#import "UpdateSavedAddressSubscription.h"
#import "DeleteSavedAddressSubscription.h"

@class SavedAddress;

@protocol AddressViewControllerDelegate <NSObject>

- (BOOL) isNewAddress;
- (SavedAddress*) getSavedAddress;
- (NSNumber*) isPrimaryAddress;
- (SavedAddressTypes) getSavedAddressType;
- (void) addressDidChange:(SavedAddress*)newSavedAddress;

@end

typedef enum {
    AddressSectionError,
    AddressSectionCell,
    AddressSectionNUM
}AddressSectionTypes;

typedef enum {
    AddressCellNickname,
    AddressCellFirstName,
    AddressCellLastName,
    AddressCellAttention,
    AddressCellFirstAddress,
    AddressCellSecondAddress,
    AddressCellThirdAddress,
    AddressCellCountry,
    AddressCellState,
    AddressCellCity,
    AddressCellZipCode,
    AddressCellDaytimePhone,
    AddressCellNUM
} AddressCell;

@interface AddressViewController : BaseModalViewController <SubscriptionDelegate>

@property (nonatomic, strong) SavedAddress *savedAddress;
@property (nonatomic, weak) id<AddressViewControllerDelegate> addressDelegate;
@property (nonatomic, strong) CountrySubscription *countrySubscription;
@property (nonatomic, strong) CreateSavedAddressSubscription *createSavedAddressSubscription;
@property (nonatomic, strong) UpdateSavedAddressSubscription *updateSavedAddressSubscription;
@property (nonatomic, strong) DeleteSavedAddressSubscription *deleteSavedAddressSubscription;
@property (nonatomic, strong) PopupViewController *createErrorPopup;
@property (nonatomic, strong) PopupViewController *deleteConfirmationPopup;
@property (nonatomic, strong) PopupViewController *updateErrorPopup;
@property (nonatomic, strong) PopupViewController *deleteErrorPopup;

- (id)initWithAddressDelegate:(id<AddressViewControllerDelegate>)addressDelegate;

@end
