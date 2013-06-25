//
//  NavigationControlManager.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationControlManager.h"
#import "CheckoutViewController.h"
#import "StepOneViewController.h"
#import "StepTwoViewController.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"

@interface NavigationControlManager()

- (void) handleNavigationForViewController:(PlndrBaseViewController *)pbvc;

//Helper Methods
- (void) changeToStepOneOnCheckoutController:(CheckoutViewController*)cvc;
- (void) changeToStepTwoOnCheckoutController:(CheckoutViewController*)cvc;

//Error Handler Helper Methods
- (void)handleErrorCreditCardWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorManageShippingAddressWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorManageBillingAddressWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorCheckoutOptionsWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorDiscountsWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorMyCartWithViewContoller:(PlndrBaseViewController *)pbvc;
- (void)handleErrorStepOneWithViewContoller:(PlndrBaseViewController *)pbvc;

@end

@implementation NavigationControlManager

#pragma mark - LifeCycle Methods

+ (NavigationControlManager *)instance {
    static NavigationControlManager *sharedInstance_ = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance_ = [[self alloc] init];
    });
    
    return sharedInstance_;
}

- (id)init {
    self = [super init];
    if (self) {
        _errorResolution = XLCheckoutErrorResolutionNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidAppear:) name:kNotificationDidAppear object:nil];
    }
    return self;
}

#pragma Mark - Setter Method

- (void)setErrorType:(XLCheckoutErrorResolution)error forViewController:(PlndrBaseViewController *)pbvc {
    _errorResolution = error;
    [self handleNavigationForViewController:pbvc];
}


#pragma mark - Notification Methods

- (void)viewControllerDidAppear:(NSNotification *)notification {
    PlndrBaseViewController *pbvc = (PlndrBaseViewController *)[notification object];
    _currentController = pbvc;
    [self handleNavigationForViewController:pbvc];
    return;
}

#pragma mark - Navigation Handler Methods

- (void)handleNavigationForViewController:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    if (controllerType == ViewControllerIrrelevent){
        _errorResolution = XLCheckoutErrorResolutionNone;
        return;
    } else {
        switch (_errorResolution) {
            case XLCheckoutErrorResolutionNone:
                return;
                break;
            case XLCheckoutErrorResolutionCreditCard:
                [self handleErrorCreditCardWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionManageShippingAddress:
                [self handleErrorManageShippingAddressWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionManageBillingAddress:
                [self handleErrorManageBillingAddressWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionCheckoutOptions:
                [self handleErrorCheckoutOptionsWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionDiscounts:
                [self handleErrorDiscountsWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionMyCart:
                [self handleErrorMyCartWithViewContoller:pbvc];
                break;
            case XLCheckoutErrorResolutionStepOne:
                [self handleErrorStepOneWithViewContoller:pbvc];
                break;
            default:
                break;
        }
    }
}


#pragma mark - Error Handler Helper Methods

- (void) changeToStepOneOnCheckoutController:(CheckoutViewController*)cvc {
    [cvc changeToStep:CheckoutViewControllerStepOne];
}

- (void) changeToStepTwoOnCheckoutController:(CheckoutViewController*)cvc {
    [cvc changeToStep:CheckoutViewControllerStepTwo];
}

- (void)handleErrorCreditCardWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];

    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne: 
        {
            StepOneViewController *stepOneVC = (StepOneViewController *)pbvc;
            _errorResolution = XLCheckoutErrorResolutionNone;
            [stepOneVC pushCreditCard];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepOneOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }
}

- (void)handleErrorManageShippingAddressWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne: 
        {
            StepOneViewController *stepOneVC = (StepOneViewController *)pbvc;
            _errorResolution = XLCheckoutErrorResolutionNone;
            [stepOneVC pushAddress:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepOneOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }    
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }    
}



- (void)handleErrorManageBillingAddressWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne: 
        {
            StepOneViewController *stepOneVC = (StepOneViewController *)pbvc;
            _errorResolution = XLCheckoutErrorResolutionNone;
            [stepOneVC pushAddress:NO];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepOneOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }    
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }  
}

- (void)handleErrorCheckoutOptionsWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne:
        {
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepTwoOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            StepTwoViewController *stepTwoVC = (StepTwoViewController *)pbvc;
            _errorResolution = XLCheckoutErrorResolutionNone;
            [stepTwoVC pushShippingOptions];
            break;
        }
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }
}

- (void)handleErrorDiscountsWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne:
        {
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepTwoOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            StepTwoViewController *stepTwoVC = (StepTwoViewController *)pbvc;
            _errorResolution = XLCheckoutErrorResolutionNone;
            [stepTwoVC pushDiscounts];
            break;
        }
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            _errorResolution = XLCheckoutErrorResolutionNone;
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }
}

- (void)handleErrorMyCartWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne:
        {
            _errorResolution = XLCheckoutErrorResolutionNone;
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [checkoutVC.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            _errorResolution = XLCheckoutErrorResolutionNone;
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [checkoutVC.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }
}

- (void)handleErrorStepOneWithViewContoller:(PlndrBaseViewController *)pbvc {
    NSString *viewControllerName = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerName];
    
    switch (controllerType) {
        case ViewControllerIrrelevent:
            return;
            break;
        case ErrorHandlingCheckoutViewControllerStepOne:
        {
            break;
        }
        case ErrorHandlingCheckoutViewControllerStepTwo:
        {
            _errorResolution = XLCheckoutErrorResolutionNone;
            CheckoutViewController *checkoutVC = (CheckoutViewController *)pbvc.parentViewController;
            [self performSelector:@selector(changeToStepOneOnCheckoutController:) withObject:checkoutVC afterDelay:0];
            break;
        }
        case ErrorHandlingCheckoutViewControllerShippingOptions:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerDiscount:
        {
            [pbvc dismissModalViewControllerAnimated:YES];
            break;
        }
        case ErrorHandlingCheckoutViewControllerCheckout:
        {
            break;
        }
        default:
            break;
    }
}

- (BOOL)isInTransitionState {
    if(_errorResolution != XLCheckoutErrorResolutionNone) {
        return YES;
    }
    return NO;
}

- (BOOL)isControllerVisible:(PlndrBaseViewController *)pbvc {
    if(pbvc == _currentController) {
        return YES;
    } else {
        return NO;
    }
}

#pragma Mark - Class Methods

+ (BOOL)shouldErrorResolution:(XLCheckoutErrorResolution)errorResolution resultInNavigationFromController:(PlndrBaseViewController *)pbvc {
    
    if(errorResolution == XLCheckoutErrorResolutionNone) {
        return NO;
    }
    
    NSString *viewControllerString = [pbvc.class description];
    ErrorHandlingCheckoutViewController controllerType = [NavigationControlManager getErrorHandlingCheckoutViewControllerForString:viewControllerString];    
    BOOL result = YES;
    switch (controllerType) {
        case ErrorHandlingCheckoutViewControllerStepOne:
            if(errorResolution == XLCheckoutErrorResolutionStepOne)
                result = NO;
            break;
        case ErrorHandlingCheckoutViewControllerStepTwo:
            break;
        case ErrorHandlingCheckoutViewControllerShippingOptions:
            if(errorResolution  == XLCheckoutErrorResolutionCheckoutOptions)
                result = NO;
            break;
        case ErrorHandlingCheckoutViewControllerDiscount:
            if(errorResolution == XLCheckoutErrorResolutionDiscounts)
                result = NO;
            break;
        case ViewControllerIrrelevent:
            result = NO;
            break;
        default:
            break;
    }
    return result;
}


+ (ErrorHandlingCheckoutViewController)getErrorHandlingCheckoutViewControllerForString:(NSString *)viewControllerName {
    if([viewControllerName isEqualToString:@"StepOneViewController"]){
        return ErrorHandlingCheckoutViewControllerStepOne;
    } else if ([viewControllerName isEqualToString:@"StepTwoViewController"]) {
        return ErrorHandlingCheckoutViewControllerStepTwo;
    } else if ([viewControllerName isEqualToString:@"ShippingOptionsViewController"]) {
        return ErrorHandlingCheckoutViewControllerShippingOptions;
    } else if ([viewControllerName isEqualToString:@"DiscountViewController"]) {
        return ErrorHandlingCheckoutViewControllerDiscount;
    } else if ([viewControllerName isEqualToString:@"CheckoutViewController"]) {
        return ErrorHandlingCheckoutViewControllerCheckout;
    } else {
        return ViewControllerIrrelevent;
    }
}


@end
