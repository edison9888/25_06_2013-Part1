//
//  NavigationControlManager.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "CheckoutError.h"
#import "PlndrBaseViewController.h"

typedef enum {
    ViewControllerIrrelevent = 0,
    ErrorHandlingCheckoutViewControllerCheckout,
    ErrorHandlingCheckoutViewControllerStepOne,
    ErrorHandlingCheckoutViewControllerStepTwo,
    ErrorHandlingCheckoutViewControllerShippingOptions,
    ErrorHandlingCheckoutViewControllerDiscount 
} ErrorHandlingCheckoutViewController;

@interface NavigationControlManager : NSObject {
    XLCheckoutErrorResolution _errorResolution;
    PlndrBaseViewController *_currentController;
}

+ (NavigationControlManager *)instance;
- (void)setErrorType:(XLCheckoutErrorResolution)error forViewController:(PlndrBaseViewController *)pbvc;

+ (BOOL)shouldErrorResolution:(XLCheckoutErrorResolution)errorResolution resultInNavigationFromController:(PlndrBaseViewController*)pbvc;
+ (ErrorHandlingCheckoutViewController)getErrorHandlingCheckoutViewControllerForString:(NSString *)viewControllerName;
- (BOOL)isInTransitionState;
- (BOOL)isControllerVisible:(PlndrBaseViewController *)pbvc;

@end
