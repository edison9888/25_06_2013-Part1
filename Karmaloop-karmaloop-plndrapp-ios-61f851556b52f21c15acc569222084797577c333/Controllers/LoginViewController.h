//
//  LoginViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "OHAttributedLabel.h"
#import "LoginSubscription.h"
#import "PopupViewController.h"
#import "LoginViewControllerDelegate.h"

typedef enum {
    LoginCellUsername,
    LoginCellPassword
} LoginCell;

@interface LoginViewController : BaseModalViewController <OHAttributedLabelDelegate, SubscriptionDelegate>

@property (nonatomic, weak) id<LoginViewControllerDelegate> loginDelegate;
@property (nonatomic, strong) LoginSubscription *loginSubscription;
@property BOOL hasSessionExpired;

- (id) initWithLoginDelegate:(id<LoginViewControllerDelegate>)loginDelegate hasSessionExpired:(BOOL) hasSessionExpired;

@end
