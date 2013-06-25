//
//  CheckoutError.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutError.h"
#import "Constants.h"
#import "PopupNotificationViewController.h"
#import "PopupUtil.h"

NSString *kCheckoutAreaBilling = @"Billing";
NSString *kCheckoutAreaGiftCode = @"GiftCode";
NSString *kCheckoutAreaPromoCode = @"PromoCode";
NSString *kCheckoutAreaRepCode = @"RepCode";
NSString *kCheckoutAreaShipping = @"Shipping"; 
NSString *kCheckoutAreaSku = @"Sku";

@interface CheckoutError () 

+ (NSDictionary *) errorCodeToXLErrorResolution;

@end

@implementation CheckoutError

+ (CheckoutError*)getFirstCheckoutErrorForAffectedAreaType:(CheckoutErrorAreaTypes)errorAreaType inCheckoutErrors:(NSArray*)checkoutErrors {
    
    for (CheckoutError *checkoutError in checkoutErrors) {
        if ([checkoutError.affectedArea isEqualToString:[CheckoutError getCheckoutAreaString:errorAreaType]]) {
            return checkoutError;
        }
    }
    return nil;
}

+ (BOOL) isThereFirstCheckoutErrorForAffectedAreaType:(CheckoutErrorAreaTypes)errorAreaType inCheckoutErrors:(NSArray*)checkoutErrors {
    return [self getFirstCheckoutErrorForAffectedAreaType:errorAreaType inCheckoutErrors:checkoutErrors] != nil;
}

+ (NSString *)getCheckoutAreaString:(CheckoutErrorAreaTypes)checkoutAreaType {
    switch (checkoutAreaType) {
        case checkoutErrorBillingArea:
            return kCheckoutAreaBilling;
        case checkoutErrorGiftCodeArea:
            return kCheckoutAreaGiftCode;
        case checkoutErrorPromoCodeArea:
            return kCheckoutAreaPromoCode;
        case checkoutErrorRepCodeArea:
            return kCheckoutAreaRepCode;
        case checkoutErrorShippingArea:
            return kCheckoutAreaShipping;
        case checkoutErrorSkuArea:
            return kCheckoutAreaSku;
        default:
            NSLog(@"Checkout Error: getCheckoutAreaString - No Such Type %d", checkoutAreaType);
            return @"";
    }
}

+ (void)popupCheckoutError:(CheckoutError *)checkoutError delegate:(id)delegate {
    NSString *errorMessage;
    if (checkoutError) {
        errorMessage = checkoutError.generalMessage.length > 0 ? checkoutError.generalMessage : kBasicErrorMessage;
    } else {
        errorMessage = kBasicErrorMessage;
    }
    
    PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:@"Checkout Error" message:[NSString stringWithFormat: @"%@",errorMessage] buttonOneTitle:@"OK" ];
    [PopupUtil presentPopup:popup withDelegate:delegate];
}

- (XLCheckoutErrorResolution)getCheckoutErrorResolution {
    NSDictionary *errorMap = [CheckoutError errorCodeToXLErrorResolution];
    NSNumber *errorResolution = [errorMap objectForKey:self.errorCode];
    if (errorResolution) {
        return errorResolution.intValue;
    } else {
        return XLCheckoutErrorResolutionNone;
    }
}

- (BOOL)isUnrecoverableSkuError {
    // If an error is a sku error besides CartItemQuantityExceedsStock or CartItemOutOfStock, then the product cannot be purchase, regardless of what the Cart Stock API says
    if ([self.affectedArea isEqualToString:[CheckoutError getCheckoutAreaString:checkoutErrorSkuArea]]
        && ![self.errorCode isEqualToString:@"CartItemQuantityExceedsStock"] 
        && ![self.errorCode isEqualToString:@"CartItemOutOfStock"]) {
        return YES;
    }
    else return NO;
}

+ (NSDictionary *) errorCodeToXLErrorResolution {
    static NSDictionary* sErrorCodeToXLErrorResolutionDictionary = nil;
    
    if (!sErrorCodeToXLErrorResolutionDictionary) {
        sErrorCodeToXLErrorResolutionDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionManageBillingAddress], @"AnonymousCheckoutMissingBillingEmail",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"ApoShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionManageBillingAddress], @"BillingAddress",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"CanNotCombinePromoCodes",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CanNotShipCartItemToCountry",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartEmpty",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItem",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemCheckoutPrice",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemInvalidQuantity",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemNotFound",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemNull",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemOutOfStock",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemQuantityExceedsStock",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartItemWebsiteMismatch",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"CartTotalMismatch",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Charity",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CountryStateMismatch",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"CreditCardCvv",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"CreditCardDeclined",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"CreditCardExpirationDate",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"CreditCardName",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"CreditCardNumber",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CultureContext",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Customer",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CustomerDoesNotExist",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CustomerIp",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CustomerNull",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"CustomerWebsite",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Default",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"DiscountNull",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"DiscountNullName",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"DiscountUnknown",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"DuplicateGiftCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"ExistingCardExpired",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"ExpressCheckoutTokenHasExpired",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Fraud",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"GiftCertificateInCart",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"GiftCertificateInvalidQuantity",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"GiftCertificateInvalidSku",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"GiftCertificateNull",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeDoesNotBelongToCustomer",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeDoesNotExist",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeExpired",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeNotActive",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeWrongWebsite",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"GiftCodeZeroBalance",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"GiftOptionNotAllowed",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InsufficientGiftCertificatesForPayment",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCheckoutOptions], @"IntercontinentalShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCheckoutOptions], @"InternationalShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidCountryCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidExistingCard",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidExpressCheckoutToken",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidGiftCertificate",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidGiftCertificateReceiverEmail",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidGiftCertificateReceiverName",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidPayPalPaymentField",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvalidStateCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"InvoiceDoesNotExist",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"KazbahShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"LineItemDiscount",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"ManuallyReviewOrder",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"MultipleDiscountUse",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"MultiplePromoCodeUse",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"MultiplePromoGiftCodeUse",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"MultipleRepCodeUse",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"NotEnoughGiftCodesToCombine",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"OrmdShippingAddress",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"OrmdShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"PayPalTransactionReferenceIdHasExpired",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Payment",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionStepOne], @"PaymentBillingMismatch",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"PaymentGatewayGeneric",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"PaymentGatewayTimeout",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"PaymentNotApproved",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"PoBoxShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCodeAlreadyUsed",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCodeAndPromoGiftCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCodeInactive",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCodeMaxTimesUsed",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"PromoCodeWrongWebsite",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionDiscounts], @"RepCode",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionNone], @"Request",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionMyCart], @"RequestCartEmpty",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCheckoutOptions], @"SaturdayDeliveryNotAllowed",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionManageShippingAddress], @"Shipping",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionManageShippingAddress], @"ShippingAddress",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionManageShippingAddress], @"ShippingAddressNull",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCheckoutOptions], @"ShippingMethod",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCheckoutOptions], @"SignatureConfirmationNotAllowed",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"UnknownCreditCard",
                                                   [NSNumber numberWithInt:XLCheckoutErrorResolutionCreditCard], @"UnsupportedPayment",
                                                   nil];
    }
    
    return sErrorCodeToXLErrorResolutionDictionary;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - affectedArea:%@ - errorCode:%@", [self class], self.affectedArea, self.errorCode];
}

@end
