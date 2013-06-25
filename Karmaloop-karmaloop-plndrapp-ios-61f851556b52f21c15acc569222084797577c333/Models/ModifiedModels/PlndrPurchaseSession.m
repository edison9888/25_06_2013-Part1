//
//  PlndrPurchaseSession.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlndrPurchaseSession.h"
#import "Constants.h"
#import "Address.h"
#import "SavedAddress.h"
#import "ShippingMethod.h"
#import "ShippingOption.h"
#import "AppliedDiscountCode.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "DiscountCode.h"
#import "ShippingDetails.h"
#import "CheckoutSummary.h"
#import "Utility.h"
#import "NSNumber+JSON.h"
#import "CreditCardType.h"
#import "ModelContext.h"
#import "CartItem.h"
#import "ProductSku.h"
#import "CheckoutError.h"

static const int _creditCardDoubleSums[] = {0, 2, 4, 6, 8, 1, 3, 5, 7, 9};

@interface PlndrPurchaseSession ()

- (void) setupCreditCard;
- (void) createSubscriptions;
- (void) createCountrySubscription;
- (void) createGetCreditCardOptionSubscription;
- (void) createExpiryDataSource;
- (BOOL) isExpiryDateValid;
- (void) createCreditCardDataSource;
- (NSDictionary*) getCreditCardInfoAPIDictionary;
- (NSDate*) getCreditCardExpiryAsDate;

@end

@implementation PlndrPurchaseSession

@synthesize creditCardTypeIndex = _creditCardTypeIndex, nameOnCard = _nameOnCard, creditCardNumber = _creditCardNumber, expiryYearIndex = _expiryYearIndex, expiryMonthIndex = _expiryMonthIndex, creditCardCVV = _creditCardCVV, shippingMethods = _shippingMethods, shippingMethodsSelectedIndex = _shippingMethodsSelectedIndex, yearOptions = _yearOptions, monthOptions = _monthOptions, creditCardOptions = _creditCardOptions;
@synthesize isBillingAddressSameAsShippingAddress = _isBillingAddressSameAsShippingAddress;
@synthesize countrySubscription = _countrySubscription;
@synthesize countries = _countries;
@synthesize checkoutSummary = _checkoutSummary;
@synthesize intermediateCheckoutSummary = _intermediateCheckoutSummary;
@synthesize purchaseBillingAddress = _purchaseBillingAddress;
@synthesize purchaseShippingAddress = _purchaseShippingAddress;
@synthesize checkoutComplete = _checkoutComplete;
@synthesize getCreditCardOptionSubscription = _getCreditCardOptionSubscription;
@synthesize checkoutErrors = _checkoutErrors;
@synthesize intermediateCheckoutErrors = _intermediateCheckoutErrors;
@synthesize lastDisplayedCheckoutError = _lastDisplayedCheckoutError;

- (id)init {
    self = [super init];
    if (self) {
        [self setupCreditCard];
    }
    return self;
}

- (void)setupCreditCard {
    [self createExpiryDataSource];
    [self createCreditCardDataSource];
    
    // Create subscriptions after init is finished.
    [self performSelector:@selector(createSubscriptions) withObject:nil afterDelay:0.0f];
}

- (void)dealloc {
    [self.countrySubscription cancel];
    [self.getCreditCardOptionSubscription cancel];
}

- (void) createSubscriptions {
    [self createCountrySubscription];
    [self createGetCreditCardOptionSubscription];
}

- (void) createCountrySubscription {
    [_countrySubscription cancel]; //Cancel any previously set up subscription
    _countrySubscription = [[CountrySubscription alloc] initWithContext:[ModelContext instance]];
    _countrySubscription.delegate = self;
    [self subscriptionUpdatedState:_countrySubscription];
}

- (void)createGetCreditCardOptionSubscription {
    [_getCreditCardOptionSubscription cancel]; //Cancel any previously set up subscription
    _getCreditCardOptionSubscription = [[GetCreditCardOptionSubscription alloc] initWithContext:[ModelContext instance]];
    _getCreditCardOptionSubscription.delegate = self;
    [self subscriptionUpdatedState:_getCreditCardOptionSubscription];
}

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        //Nothing to do here 
    } else if (subscription == self.countrySubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            // Country and state data is ready.
        } else if ((subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable)) {
            // Error getting country and state data. The user won't be able to complete shipping and billing address.
            // We should throw up an error if they try to enter those areas, and attempt to get country and state data again.
        }
    } else if (subscription ==self.getCreditCardOptionSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            // CreditCardOption data is ready.
        } else if ((subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable)) {
            // Error getting CreditCardOption data. The user won't be able to complete credit card.
            // We should throw up an error if they try to enter those areas, and attempt to get data again.
        }
    }

}

- (NSArray *)getCreditCardSummaryStrings {
    if ([self isPaymentOptionsComplete]) {
		int numOfCharactersToRedact = self.creditCardNumber.length - 4;
        NSString *cardTypeString = [self getCreditCardDisplayString];
        NSString *cardSuffix = [self.creditCardNumber substringFromIndex:numOfCharactersToRedact];
        NSString *cardNumberString = @"";
		for (int i = 0; i < numOfCharactersToRedact; i++) {
			cardNumberString = [NSString stringWithFormat:@"%@x", cardNumberString];
		}
		cardNumberString = [NSString stringWithFormat:@"%@%@",cardNumberString, cardSuffix];
        
        return [NSArray arrayWithObjects:cardTypeString, cardNumberString, nil];
    } else {
        return nil;
    }
}


- (NSString *)getExpiryString {
    return [self getExpiryStringForMonthIndex:self.expiryMonthIndex.intValue yearIndex:self.expiryYearIndex.intValue];
}

- (NSString*) getExpiryStringForMonthIndex:(int)expiryMonthIndex yearIndex:(int)expiryYearIndex {
    return [NSString stringWithFormat:@"%02d/%02d", ((NSNumber*)[self.monthOptions objectAtIndex:expiryMonthIndex]).intValue, ((NSNumber*)[self.yearOptions objectAtIndex:expiryYearIndex]).intValue];
}

- (NSArray*) getExpiryOptions {
    return [NSArray arrayWithObjects:self.monthOptions, self.yearOptions, nil];
}

- (NSArray*) getExpiryMonthAndYearIndexes {
    return [NSArray arrayWithObjects:self.expiryMonthIndex, self.expiryYearIndex, nil];
}

- (NSString*) getExpiryStringFromMonthAndYearIndexesArray:(NSArray*)monthAndYear {
    int expiryMonthIndex = [[monthAndYear objectAtIndex:0] intValue];
    int expiryYearIndex = [[monthAndYear objectAtIndex:1] intValue];
    return [self getExpiryStringForMonthIndex:expiryMonthIndex yearIndex:expiryYearIndex];
}

- (void) setExpiryMonthAndYearIndexes:(NSArray*)monthAndYear {
    self.expiryMonthIndex = [monthAndYear objectAtIndex:0];
    self.expiryYearIndex = [monthAndYear objectAtIndex:1];
}

- (BOOL)isPaymentOptionsComplete {
    return ((self.creditCardTypeIndex != nil) && self.nameOnCard.length > 0 && [self isCreditCardNumberValid:self.creditCardNumber] && self.creditCardCVV.length > 0);
}


- (NSString*)getCreditCardDisplayString {
    CreditCardType *creditCardType = [self.creditCardOptions objectAtIndex:self.creditCardTypeIndex.intValue];
    if (creditCardType.name.length > 0) {
        return creditCardType.name;
    }
    return kRequired;
}

- (NSString *)getCreditCardDisplayStringForIndex:(NSNumber*)index {
    return ((CreditCardType*)[self.creditCardOptions objectAtIndex:index.intValue]).name;
}

- (NSArray*) getCreditCardOptions {
    NSMutableArray *creditCardOptions = [NSMutableArray array];
    for (CreditCardType *creditCardType in self.creditCardOptions) {
        [creditCardOptions addObject:creditCardType.name];
    }
    
    return [NSArray arrayWithObject:[NSArray arrayWithArray:creditCardOptions]];
}

- (NSArray *)getCreditCardIndexArray {
    return [NSArray arrayWithObject:self.creditCardTypeIndex];
}

- (NSString*) getCreditCardDisplayStringFromPickerIndexArray:(NSArray *)array {
    if (array.count == 0) {
        return @"";
    }
    NSNumber *creditCardTypeIndex = [array objectAtIndex:0];
    return ((CreditCardType*)[self.creditCardOptions objectAtIndex:creditCardTypeIndex.intValue]).name;
}

- (void)setCreditCardIndexFromArray:(NSArray *)array {
    self.creditCardTypeIndex = [array objectAtIndex:0];
}

-(BOOL)isCreditCardNumberValid:(NSString *)ccNumber {
    if (ccNumber.length == 0) {
        return NO;
    }
    
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"(\\d+)"
                                  options:0
                                  error:&error];
    NSRange range   = [regex rangeOfFirstMatchInString:ccNumber
                                               options:0 
                                                 range:NSMakeRange(0, [ccNumber length])];
    BOOL doubleSum = NO;
    long checksum = 0;
    
    for (int index = ccNumber.length - 1; index >= 0; index--) {
        long digit = [ccNumber substringWithRange:NSMakeRange(index, 1)].intValue;
        checksum += doubleSum ? _creditCardDoubleSums[digit] : digit;
        doubleSum = !doubleSum;
    }
    return (range.location == 0 && range.length == ccNumber.length) && ((checksum % 10) == 0);
}


- (BOOL)isCreditCardCVVValid:(NSString *)cvv {
    if (cvv.length != 3) {
        return NO;
    }
    NSError  *error  = NULL;
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:@"(\\d+)"
                                  options:0
                                  error:&error];
    NSRange range   = [regex rangeOfFirstMatchInString:cvv
                                               options:0 
                                                 range:NSMakeRange(0, [cvv length])];
    
    return (range.location == 0 && range.length == cvv.length);
}


- (NSArray *)getShippingMethodsSummaryStrings {
    if (self.shippingMethods) {
        NSMutableArray *shippingMethodsSummaryStrings = [[NSMutableArray alloc] init];
        ShippingMethod *shippingMethods = [self.shippingMethods objectAtIndex:self.shippingMethodsSelectedIndex];
        NSString *shippingMethodsString = shippingMethods.name;
        [shippingMethodsSummaryStrings addObject:shippingMethodsString];
        
        return shippingMethodsSummaryStrings;
    } else {
        return [NSArray array];
    }
}

- (void)resetShippingMethods {
    self.shippingMethods = nil;
    self.shippingMethodsSelectedIndex = 0;
    // Remove Previous CheckoutSummary as the Shipping Details has changed
    self.checkoutSummary = nil;
}

- (void)flagCartItemsAsUnavailableIsIntermediate:(BOOL)isIntermediate {
    //Grab Sku Errors
    NSMutableArray *skuErrors = [NSMutableArray array];
    BOOL isCartStale;
    
    NSArray *checkoutErrors;
    if (isIntermediate) {
        checkoutErrors = self.intermediateCheckoutErrors;
    } else {
        checkoutErrors = self.checkoutErrors;
    }
    
    for (CheckoutError *checkoutError in checkoutErrors) {
        NSString *skuAffectedArea = [CheckoutError getCheckoutAreaString:checkoutErrorSkuArea];
        if ([checkoutError.affectedArea isEqualToString:skuAffectedArea]) {
            isCartStale = YES;
        }
        if ([checkoutError isUnrecoverableSkuError]) {
            [skuErrors addObject:checkoutError];
        }
    }
    
    //Flag Cart
    if (isCartStale) {
        [ModelContext instance].isCartStockStale = YES;
    }
    //Flag Cart Items
    NSMutableArray *cartItems = [[ModelContext instance] cartItems];
    for (CheckoutError *skuError in skuErrors) {
        for (CartItem *cartItem in cartItems) {
            ProductSku *cartSku = cartItem.size;
            if ([Utility isEqualNumber:cartSku.skuId number2:skuError.skuId]) {
                cartItem.isUnavailableDueToError = YES;
                break;
            }
        }
    }
}

#pragma mark - private

- (BOOL) isExpiryDateValid {
    return (self.expiryYearIndex && self.expiryMonthIndex && self.expiryYearIndex.intValue >= 0 && self.expiryYearIndex.intValue < self.yearOptions.count 
            && self.expiryMonthIndex.intValue >= 0 && self.expiryMonthIndex.intValue < self.monthOptions.count);
}

- (void)createExpiryDataSource {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *yearComponent = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    int year = [yearComponent year];
    NSMutableArray *yearArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [yearArray addObject:[NSNumber numberWithInt:year + i]];
    }
    self.yearOptions = [NSArray arrayWithArray:yearArray];
    
    self.monthOptions = [NSArray arrayWithObjects:
            [NSNumber numberWithInt:1],
            [NSNumber numberWithInt:2],
            [NSNumber numberWithInt:3],
            [NSNumber numberWithInt:4],
            [NSNumber numberWithInt:5],
            [NSNumber numberWithInt:6],
            [NSNumber numberWithInt:7],
            [NSNumber numberWithInt:8],
            [NSNumber numberWithInt:9],
            [NSNumber numberWithInt:10],
            [NSNumber numberWithInt:11],
            [NSNumber numberWithInt:12], nil];
    
    self.expiryYearIndex = [NSNumber numberWithInt:0];
    self.expiryMonthIndex = [NSNumber numberWithInt:0];
}

- (void)createCreditCardDataSource {
    self.creditCardTypeIndex = [NSNumber numberWithInt:0];
}


- (Address*) getPurchaseBillingAddress {
    if (self.isBillingAddressSameAsShippingAddress) {
        return self.purchaseShippingAddress;
    } else {
        return self.purchaseBillingAddress;
    }
}

- (Address*) getPurchaseShippingAddress {
    return self.purchaseShippingAddress;
}

- (BOOL)isCountriesAvailable {
    return self.countries != nil;
}

- (void)initializeShippingAddress:(Address *)shippingAddress billingAddress:(Address *)billingAddress {
    if (!self.purchaseShippingAddress || !self.purchaseBillingAddress) {
        self.isBillingAddressSameAsShippingAddress = NO;
    }
    
    if (!self.purchaseShippingAddress) {
        self.purchaseShippingAddress = shippingAddress;
    }
    
    if (!self.purchaseBillingAddress) {
        self.purchaseBillingAddress = billingAddress;
    }
}

- (NSArray *)getDiscounts {
    if (self.checkoutSummary) {
        return [self.checkoutSummary getDiscounts];
    } else {
        return [NSArray array];
    }
}

- (ShippingDetails *)getShippingDetails {
    Address *purchaseShippingAddress = [[[ModelContext instance] plndrPurchaseSession] getPurchaseShippingAddress];
    ShippingMethod *purchaseShippingMethod = nil;
    if (self.shippingMethods.count > 0) {
        purchaseShippingMethod = [self.shippingMethods objectAtIndex:self.shippingMethodsSelectedIndex];
    }
    

    return [[ShippingDetails alloc] initWithaddress:purchaseShippingAddress
                                             method: purchaseShippingMethod ? purchaseShippingMethod.shippingMethodValue : @""
                                            options: purchaseShippingMethod ? [purchaseShippingMethod getSelectedOptions] : [NSArray array]];
    
}

- (void)resetPurchaseSession:(BOOL)clearCart {
    [self.countrySubscription cancel];
    self.countrySubscription = nil;
    [self.getCreditCardOptionSubscription cancel];
    self.getCreditCardOptionSubscription = nil;
    
    self.nameOnCard = nil;
    self.creditCardNumber = nil;
    self.creditCardCVV = nil;
    [self setupCreditCard];
    
    self.isBillingAddressSameAsShippingAddress = NO;
    self.purchaseBillingAddress = nil;
    self.purchaseShippingAddress = nil;
    
    [self resetShippingMethods];
    self.intermediateCheckoutSummary = nil;
    self.checkoutComplete = nil;
    
    self.countries = nil;
    self.creditCardOptions = nil;
    
    Address *defaultShippingAddress = [[[[ModelContext instance] loginSession] getShippingSavedAddress] address];
    Address *defaultBillingAddress = [[[[ModelContext instance] loginSession] getBillingSavedAddress] address];
    [self initializeShippingAddress:defaultShippingAddress billingAddress:defaultBillingAddress];
    
    if (clearCart) {
        [[ModelContext instance] deleteCart];
    }
}

- (NSDictionary *)getPaymentAPIDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"NewCreditCard", @"type",
                                                    [self getCreditCardInfoAPIDictionary], @"ccInfo"
            , nil];
}

- (NSDate *)getCreditCardExpiryAsDate {
    static NSDateFormatter* creditCardExpiryFormatter = nil;
    
    if (!creditCardExpiryFormatter) {
        creditCardExpiryFormatter = [[NSDateFormatter alloc] init];
        [creditCardExpiryFormatter setTimeStyle:NSDateFormatterFullStyle];
        [creditCardExpiryFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [creditCardExpiryFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [creditCardExpiryFormatter setDateFormat:@"MM/yyyy"];
    }
    
    NSDate *d = [creditCardExpiryFormatter dateFromString:[self getExpiryString]];
    
    return d;
}

- (NSDictionary *)getCreditCardInfoAPIDictionary {
    CreditCardType *creditCardType = [self.creditCardOptions objectAtIndex:self.creditCardTypeIndex.intValue];
    return [NSDictionary dictionaryWithObjectsAndKeys:self.creditCardNumber, @"number",
                                                    [Utility iso8601FromDate:[self getCreditCardExpiryAsDate]], @"expiresOn",
                                                     self.creditCardCVV, @"cvv",
                                                     creditCardType.value, @"type",
                                                     self.nameOnCard, @"nameOnCard",
                                                     @"", @"phone",
                                                     [[NSNumber numberWithBool:NO] jsonBoolValue], @"save",
                                                    nil];
}

                                                                              
@end
