//
//  PlndrBaseViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "PopupNotificationViewController.h"
#import "LoginViewControllerDelegate.h"

@class CellMetaData, RequestSubscription;

@interface PlndrBaseViewController : UIViewController <SimplifiedEGORefreshTableHeaderDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate, PopupViewControllerDelegate, PopupNotificationDelegate, LoginViewControllerDelegate>

@property (nonatomic, weak) UIScrollView *parentScrollView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) EGORefreshTableHeaderView *pullDownView;
@property (nonatomic, strong) PopupViewController *defaultErrorPopup;
@property BOOL isPresentingAuthenticationDueToInterruption;
@property BOOL isPresentingConnectionErrorPopup;
@property BOOL hasViewAppeared;

- (void) initLoadingView;
- (CGRect) loadingViewFrame;
- (UIColor*) loadingViewBackgroundColor;
- (void) showLoadingView;
- (void) hideLoadingView;

- (CGRect) defaultFrame;
+ (UIButton*) createNavBarButtonWithText:(NSString*)text;
+ (UIButton*) createNavBarButtonWithText:(NSString *)text withNormalColor:(UIColor*) normalColor withHighlightColor:(UIColor*) highlightColor;

// Pull Down view
- (void)initPullDownViewOnParentView:(UIScrollView*)parentView;
- (void) transferPullDownViewToParentView:(UIScrollView*)newParentView;
- (void)resetPullDownView;
- (void) pullPullDownView;

// Error Handling
- (void) displayAPIErrorWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle usingPopup:(PopupViewController**)viewControllerPtr;
- (void) displayAPIErrorWithTitle:(NSString*)title message:(NSString*)message usingPopup:(PopupViewController**)viewControllerPtr;
- (void) presentAuthRequired;
- (void) abortForAuthentication;
- (void) handleAbortForAuthentication;
- (void) presentConnectionErrorModal;
- (void) handleConnectionError;
- (void)setFlagForCartItemForViewController:(PlndrBaseViewController *)pbvc;
@end
