//
//  ChangePasswordViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataViewController.h"
#import "PopupViewController.h"
#import "PasswordChangeSubscription.h"

@class PopupNotificationViewController;

typedef enum {
    ChangePasswordCellOldPassword,
    ChangePasswordCellNewPassword,
    ChangePasswordCellConfirmPassword
} ChangePasswordCell;

@interface ChangePasswordViewController : BaseDataViewController <SubscriptionDelegate>

@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *neuePassword;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) PopupNotificationViewController *successPopup;

@property (nonatomic, strong) PasswordChangeSubscription *changePasswordSubscription;

@end
