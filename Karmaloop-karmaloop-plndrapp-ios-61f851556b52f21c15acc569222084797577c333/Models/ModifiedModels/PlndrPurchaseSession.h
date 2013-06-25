//
//  PlndrPurchaseSession.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountrySubscription.h"
#import "GetCreditCardOptionSubscription.h"

@class Address, AppliedDiscountCode, CheckoutSummary, ShippingDetails, CheckoutCompleteResponse, CheckoutError;

@interface PlndrPurchaseSession : NSObject <SubscriptionDelegate>

// Subscriptions
@property (nonatomic, strong) CountrySubscription *countrySubscription;
@property (nonatomic, strong) GetCreditCardOptionSubscription *getCreditCardOptionSubscription;

// For CreditCardVC
@property (nonatomic, strong) NSNumber* creditCardTypeIndex;
@property (nonatomic, strong) NSString* nameOnCard;
@property (nonatomic, strong) NSString* creditCardNumber;
@property (nonatomic, strong) NSNumber *expiryYearIndex;
@property (nonatomic, strong) NSNumber *expiryMonthIndex;
@property (nonatomic, strong) NSString* creditCardCVV;

// For AddressVC
@property BOOL isBillingAddressSameAsShippingAddress;
@property (nonatomic, strong) Address *purchaseBillingAddress;
@property (nonatomic, strong) Address *purchaseShippingAddress;


// For ShippingMethodsVC
@property (nonatomic, strong) NSArray *shippingMethods;
@property int shippingMethodsSelectedIndex;

// "Static" Data
@property (nonatomic, strong) NSArray *yearOptions;
@property (nonatomic, strong) NSArray *monthOptions;

// "Dynamic" Fetched Data
@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSArray *creditCardOptions;

// Checkout
@property (nonatomic, strong) CheckoutSummary *checkoutSummary;
@property (nonatomic, strong) CheckoutSummary *intermediateCheckoutSummary; // Used by DiscountViewController and others when performing validation
@property (nonatomic, strong) CheckoutCompleteResponse *checkoutComplete;

// Checkout Errors
@property (nonatomic, strong) NSArray /*<CheckoutError>*/ *checkoutErrors;
@property (nonatomic, strong) NSArray /*<CheckoutError>*/ *intermediateCheckoutErrors;

//Previous Error 
@property (nonatomic, strong) CheckoutError *lastDisplayedCheckoutError;

// Step One
- (NSArray*) getCreditCardSummaryStrings;
- (BOOL) isPaymentOptionsComplete;
- (Address*) getPurchaseBillingAddress;
- (Address*) getPurchaseShippingAddress;
- (BOOL) isCountriesAvailable;
- (void) initializeShippingAddress:(Address*)shippingAddress billingAddress:(Address*)billingAddress;

// CCType
- (NSString*) getCreditCardDisplayString;
- (NSString*) getCreditCardDisplayStringForIndex:(NSNumber*)index;
- (NSArray*) getCreditCardOptions;
- (NSArray*) getCreditCardIndexArray;
- (NSString*) getCreditCardDisplayStringFromPickerIndexArray:(NSArray *)array;
- (void) setCreditCardIndexFromArray:(NSArray*)array;

// Expiry
- (NSString*) getExpiryString;
- (NSString*) getExpiryStringForMonthIndex:(int)expiryMonthIndex yearIndex:(int)expiryYearIndex;
- (NSArray*) getExpiryOptions;
- (NSArray*) getExpiryMonthAndYearIndexes;
- (NSString*) getExpiryStringFromMonthAndYearIndexesArray:(NSArray*)monthAndYear;
- (void) setExpiryMonthAndYearIndexes:(NSArray*)monthAndYear;

// CC Number
- (BOOL) isCreditCardNumberValid:(NSString*)ccNumber;

// CVV
- (BOOL) isCreditCardCVVValid:(NSString*)cvv;

// Shipping Methods
- (NSArray *) getShippingMethodsSummaryStrings;
- (void) resetShippingMethods;

// Checkout
- (NSArray*) getDiscounts;
- (ShippingDetails*) getShippingDetails;
- (void) resetPurchaseSession:(BOOL)clearCart;


- (NSDictionary*) getPaymentAPIDictionary;

//Checkout Errors
- (void)flagCartItemsAsUnavailableIsIntermediate:(BOOL)isIntermediate;

@end
