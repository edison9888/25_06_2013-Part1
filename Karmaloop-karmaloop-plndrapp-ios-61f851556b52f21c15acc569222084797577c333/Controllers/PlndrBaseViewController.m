//
//  PlndrBaseViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlndrBaseViewController.h"
#import "Constants.h"
#import "RequestSubscription.h"
#import "PopupUtil.h"
#import "LoginViewController.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "PlndrAppDelegate.h"
#import "NavigationControlManager.h"
#import "ConnectionErrorViewController.h"
#import "CheckoutError.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"

@implementation PlndrBaseViewController

@synthesize parentScrollView = _parentScrollView;
@synthesize loadingView = _loadingView;
@synthesize spinner = _spinner;
@synthesize pullDownView = _pullDownView;
@synthesize defaultErrorPopup = _defaultErrorPopup;
@synthesize isPresentingAuthenticationDueToInterruption = _isPresentingAuthenticationDueToInterruption;
@synthesize hasViewAppeared = _hasViewAppeared;
@synthesize isPresentingConnectionErrorPopup = _isPresentingConnectionErrorPopup;

- (void)dealloc {
    self.pullDownView.delegate = nil;
    self.parentScrollView.delegate = nil;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.loadingView = nil;
    self.spinner = nil;
    self.pullDownView.delegate = nil;
    self.pullDownView = nil;
    self.parentScrollView.delegate = nil;
    self.parentScrollView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kPlndrBgGrey;
    [self initLoadingView];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.hasViewAppeared = YES;
    if (self.isPresentingConnectionErrorPopup) {
        [self handleConnectionError];
    } else if (self.isPresentingAuthenticationDueToInterruption) {
        [self abortForAuthentication];
    }
    [NavigationControlManager instance];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidAppear object:self];
}

- (void)initLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:[self loadingViewFrame]];
    self.loadingView.backgroundColor = [self loadingViewBackgroundColor];
    self.spinner = [[UIActivityIndicatorView alloc] init];
    self.spinner.center = CGPointMake(self.loadingView.frame.size.width/2, self.loadingView.frame.size.height/2);
    self.spinner.color = kPlndrTextGold;
    [self.loadingView addSubview:self.spinner];
}

- (CGRect)loadingViewFrame {
    return self.view.frame;
}

- (UIColor*) loadingViewBackgroundColor {
    return kPlndrBgGrey;
}

- (void)showLoadingView {
    [self.view addSubview:self.loadingView];
    [self.spinner startAnimating];
}

- (void) hideLoadingView {
    [self.loadingView removeFromSuperview];
    [self.spinner stopAnimating];
}

- (CGRect) defaultFrame {
    return CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - self.navigationController.navigationBar.frame.size.height - kTabBarHeight);
}

+ (UIButton *)createNavBarButtonWithText:(NSString *)text {
    return [self createNavBarButtonWithText:text withNormalColor:kPlndrWhite withHighlightColor:kPlndrBlack];
}

+ (UIButton *)createNavBarButtonWithText:(NSString *)text withNormalColor:(UIColor *)normalColor withHighlightColor:(UIColor *)highlightColor {
    UIImage *navBarButtonImage = [[UIImage imageNamed:@"header_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *navBarButtonImageHl = [[UIImage imageNamed:@"header_btn_hl.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *navBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBarButton setTitle:text forState:UIControlStateNormal];
    navBarButton.titleLabel.font = kBarButtonItemFont;
    [navBarButton setTitleColor:normalColor forState:UIControlStateNormal];
    [navBarButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [navBarButton setBackgroundImage:navBarButtonImage forState:UIControlStateNormal];
    [navBarButton setBackgroundImage:navBarButtonImageHl forState:UIControlStateHighlighted];
    [navBarButton sizeToFit];
    navBarButton.frame = CGRectMake(0, 0, navBarButton.frame.size.width + 10, navBarButton.frame.size.height);
    
    return navBarButton;

}

- (void) displayAPIErrorWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString *)buttonTitle usingPopup:(PopupViewController *__autoreleasing *)viewControllerPtr {
    
    NSString *popupTitle = title;
    if (title.length <= 0) {
        popupTitle = kBasicFatalErrorTitle;
    }
    
    NSString *popupMessage = message;
    if (message.length <= 0) {
        popupMessage = kBasicFatalErrrorMessage;
    }
    
    NSString *popupButtonTitle = buttonTitle;
    if (buttonTitle.length <= 0) {
        popupButtonTitle = @"OK";
    }
    
    PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:popupTitle message:popupMessage buttonOneTitle:popupButtonTitle];
    *viewControllerPtr = popup;
    [PopupUtil presentPopup:popup withDelegate:self];
}

- (void)displayAPIErrorWithTitle:(NSString *)title message:(NSString *)message usingPopup:(PopupViewController *__autoreleasing *)viewControllerPtr {
    [self displayAPIErrorWithTitle:title message:message buttonTitle:nil usingPopup:viewControllerPtr];
}

- (void)presentAuthRequired {
    if ([[ModelContext instance].loginSession isLoggedIn]) {
        [[ModelContext instance].loginSession logout];
    }
    LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginDelegate:self hasSessionExpired:YES];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentModalViewController:navController animated:YES];
    self.isPresentingAuthenticationDueToInterruption = NO;
}

- (void) abortForAuthentication {
    self.isPresentingAuthenticationDueToInterruption = YES;
    PlndrBaseViewController *authorizationResponder = [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) getDeepestUnauthorizedControllerInTab];
    if (self.hasViewAppeared) {
        [authorizationResponder handleAbortForAuthentication];
    }
}

- (void) handleAbortForAuthentication {
    // Override
}

- (void)presentConnectionErrorModal {
    ConnectionErrorViewController *connectionErrorVC = [[ConnectionErrorViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:connectionErrorVC];
    [self presentModalViewController:navController animated:YES];
    self.isPresentingConnectionErrorPopup = NO;
}

- (void)handleConnectionError {
    [self presentConnectionErrorModal];
}

- (void)setFlagForCartItemForViewController:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    if ([CheckoutError isThereFirstCheckoutErrorForAffectedAreaType:checkoutErrorSkuArea inCheckoutErrors:[[ModelContext instance] plndrPurchaseSession].checkoutErrors]) {
        if(controllerType == ErrorHandlingCheckoutViewControllerDiscount || controllerType == ErrorHandlingCheckoutViewControllerShippingOptions) {
            [[[ModelContext instance] plndrPurchaseSession] flagCartItemsAsUnavailableIsIntermediate:YES];
        } else {
            [[[ModelContext instance] plndrPurchaseSession] flagCartItemsAsUnavailableIsIntermediate:NO];
        }
    }
}
#pragma mark - LoginViewControllerDelegate

- (void) loginModalDidDisappear {
    // Override if default is not just dismiss
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    if (sender == self.defaultErrorPopup) {
        self.defaultErrorPopup = nil;
    }
}

- (BOOL)isStillVisible:(id)sender {
    return  [[NavigationControlManager instance] isControllerVisible:self];
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:popupViewController];
}

#pragma mark - pull down view

- (void)initPullDownViewOnParentView:(UIScrollView*)parentView {
    [self.pullDownView removeFromSuperview];
    [self resetPullDownView];
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -70.0f, parentView.frame.size.width, 70.0f) arrowImageName:@"grayArrow.png" textColor:kPlndrMediumGreyTextColor];
    view.delegate = self;
    self.parentScrollView = parentView;
    self.parentScrollView.delegate = self;
    [self.parentScrollView addSubview:view];
    self.pullDownView = view; 

}

- (void) transferPullDownViewToParentView:(UIScrollView*)newParentView {
    CGPoint currentOffset = self.parentScrollView.contentOffset;    
    [self.pullDownView removeFromSuperview];

    self.pullDownView.delegate = self;
    self.parentScrollView = newParentView;
    self.parentScrollView.delegate = self;
    [self.parentScrollView addSubview:self.pullDownView];
    self.parentScrollView.contentOffset = currentOffset;
}

- (void) pullPullDownView {
    self.parentScrollView.contentOffset = CGPointMake(0.0, -1*self.pullDownView.frame.size.height);
    [self.pullDownView egoRefreshScrollViewDidEndDragging:self.parentScrollView];
}

#pragma mark - ScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scroll willDecelerate:(BOOL)decelerate {
	// Forward scroll activity to the pull down view
    if (scroll == self.parentScrollView) {
        [self.pullDownView egoRefreshScrollViewDidEndDragging:scroll];
    }	
}

- (void) scrollViewDidScroll:(UIScrollView *)scroll {
    if (scroll == self.parentScrollView) {
        [self.pullDownView egoRefreshScrollViewDidScroll:scroll];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self pullDownToRefreshContent];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return [self pullDownIsLoading];
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{	
	return [NSDate date]; // should return date data source was last changed	
}

- (void)resetPullDownView {
    [self.pullDownView egoRefreshScrollViewDataSourceDidFinishedLoading:self.parentScrollView];
}

#pragma mark - SimplifiedEGORefreshTableHeaderDelegate Methods

- (void)pullDownToRefreshContent {
    //For subclass to overwrite
}

- (BOOL)pullDownIsLoading{
    return YES; // For subclass to overwrite
}



@end
