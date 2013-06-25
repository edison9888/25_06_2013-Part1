//
//  ProfileViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataViewController.h"
#import "AddressViewController.h"
#import "ManageAddressViewController.h"
#import "GetSavedAddressesSubscription.h"

typedef enum {
    ProfileSectionUser,
    ProfileSectionShipping,
    ProfileSectionBilling,
    ProfileSectionNUM
} ProfileSections;


typedef enum {
    ProfileUsernameCell
} ProfileUserSectionCell;

typedef enum {
    ProfileBillingAddressInfoCell
} ProfileBillingSectionCell;

typedef enum {
    ProfileShippingAddressInfoCell
} ProfileShippingSectionCell;

@interface ProfileViewController : BaseDataViewController <ManageAddressViewControllerDelegate, AddressViewControllerDelegate, SubscriptionDelegate>

@property BOOL isCurrentlyEditingShippingAddress;
@property (nonatomic, strong) GetSavedAddressesSubscription *getSavedAddressesSubscription;
@property (nonatomic, strong) UILabel *addressErrorLabel;

@end
