//
//  PasswordRequestPopup.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"
#import "TextEntryPopupView.h"
#import "ForgotPasswordSubscription.h"

@class PopupView;

@interface PasswordRequestPopup : PopupViewController <TextEntryPopupViewDelegate, SubscriptionDelegate>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PopupView *currentPopupView;
@property (nonatomic, strong) ForgotPasswordSubscription *forgotPasswordSubscription;

@end
