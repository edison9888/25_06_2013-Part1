//
//  CheckoutError.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutErrorObject.h"

typedef enum {
    checkoutErrorBillingArea,
    checkoutErrorGiftCodeArea,
    checkoutErrorPromoCodeArea,
    checkoutErrorRepCodeArea,
    checkoutErrorShippingArea,
    checkoutErrorSkuArea
}CheckoutErrorAreaTypes;

typedef enum {
    XLCheckoutErrorResolutionNone,
    XLCheckoutErrorResolutionCreditCard,
    XLCheckoutErrorResolutionManageShippingAddress,
    XLCheckoutErrorResolutionManageBillingAddress,
    XLCheckoutErrorResolutionCheckoutOptions,
    XLCheckoutErrorResolutionDiscounts,
    XLCheckoutErrorResolutionMyCart,
    XLCheckoutErrorResolutionStepOne
}XLCheckoutErrorResolution;


@interface CheckoutError : CheckoutErrorObject

+ (CheckoutError*)getFirstCheckoutErrorForAffectedAreaType:(CheckoutErrorAreaTypes)errorAreaType inCheckoutErrors:(NSArray*)checkoutErrors;
+ (BOOL) isThereFirstCheckoutErrorForAffectedAreaType:(CheckoutErrorAreaTypes)errorAreaType inCheckoutErrors:(NSArray*)checkoutErrors;

+ (NSString*) getCheckoutAreaString:(CheckoutErrorAreaTypes) checkoutAreaType;
+ (void)popupCheckoutError:(CheckoutError *)checkoutError delegate:(id)delegate;

- (XLCheckoutErrorResolution) getCheckoutErrorResolution;
- (BOOL) isUnrecoverableSkuError;

@end
