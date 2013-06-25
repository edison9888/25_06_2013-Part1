//
//  TDMAccountsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMLogoutService.h"
#import "TDMNavigationController.h"
#import "TDMOverlayView.h"
#import "TDMHTTPLoginService.h"
#import "TDMMFBHelper.h"
//#import "FBSession.h"
//#import "SHK.h"
#import "FBConnect.h"

@interface TDMAccountsViewController : TDMBaseViewController<TDMLogoutHandlerDelegate,TDMLoginHandlerDelegate,FBSessionDelegate>{
    
    TDMLogoutService *logoutHandler;
    TDMOverlayView *overlayView;
    NSString *overlayTitle;
//    TDMMFBHelper *fbHelper;

    Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;
@property (retain, nonatomic) IBOutlet UIButton *myProfileButton;
@property (retain, nonatomic) IBOutlet UIButton *loginsignupButton;
@property (retain, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (retain, nonatomic) IBOutlet UIButton * notificationsButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutUsButton;
@property (retain, nonatomic) IBOutlet UISwitch *locationNotificationSwitch;
@property (retain, nonatomic) IBOutlet UIButton *FBLogInButton;
@property (retain, nonatomic) IBOutlet UIButton *signUpButton;

- (void)sentLogoutRequest;

- (IBAction)loginClicked:(id)sender;
- (IBAction)aboutUsClicked:(id)sender;
- (IBAction)myProfileClicked:(id)sender;
- (IBAction)notificationAction:(id)sender;
- (IBAction)FBLogInButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;

@end
