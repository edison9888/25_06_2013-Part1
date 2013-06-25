//
//  InviteFriendsViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlndrBaseViewController.h"
#import "SocialManager.h"
#import "LoginViewController.h"
#import "AccountDetailsSubscription.h"
#import "PopupNotificationViewController.h"
#import "PopupViewController.h"

typedef enum {
    InviteFriendEmailButton,
    InviteFriendFacebookButton,
    InviteFriendTwitterButton,
    InviteFriendSMSButton
} InviteFriendButonTypes;

@interface InviteFriendsViewController : PlndrBaseViewController <UIScrollViewDelegate, SocialManagerDelegate, LoginViewControllerDelegate, SubscriptionDelegate>

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) AccountDetailsSubscription *accountDetailsSubscription;

@end
