//
//  MySettingsViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataViewController.h"
#import "LoginViewController.h"
#import "SocialManager.h"

typedef enum {
    MySettingsMyAccountSection,
    MySettingsSocialManagerSection,
    MySettingsCustomerSupportSection,
    MySettingsFAQSection,
    MySettingsSectionsNUM
} MySettingsSections;

typedef enum {
    MyAccountProfileCell,
    MyAccountChangePasswordCell,
    MyAccountLoggedInCellNUM
} MyAccountLoggedInCell;

typedef enum {
    MyAccountLoginCell,
    MyAccountSignUpCell,
    MyAccountLoggedOutCellNUM
} MyAccountLoggedOutCell;

typedef enum {
    SocialManagerFacebookCell,
    SocialManagerNUM
}MySetttingsSocialManagerSectionCell;


typedef enum {
    MySettingsCustomerSupportPhoneCell,
    MySettingsCustomerSupportEmailCell,
    MySettingsCustomerSupportSectionCellNUM
}MySettingsCustomerSupportSectionCell;

typedef enum{
    MySettingsFAQOrdersCell,
    MySettingsFAQPaymentCell,
    MySettingsFAQReturnsCell,
    MySettingsFAQPromotionAndGiftCell,
    MySettingsFAQNUM
}MySettingsFAQSectionCell;


@interface MySettingsViewController :  BaseDataViewController <LoginViewControllerDelegate, SocialManagerDelegate>

@end
