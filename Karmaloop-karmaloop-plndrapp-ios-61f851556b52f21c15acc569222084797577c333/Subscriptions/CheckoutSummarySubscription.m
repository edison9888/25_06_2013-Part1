//
//  CheckoutSummarySubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutSummarySubscription.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "ShippingDetails.h"

@implementation CheckoutSummarySubscription

@synthesize discounts = _discounts;
@synthesize shippingDetails = _shippingDetails;
@synthesize isIntermediateValidation = _isIntermediateValidation;

- (id)initWithDiscounts:(NSArray *)discounts shippingDetails:(ShippingDetails *)shippingDetails isIntermediateValidation:(BOOL)isIntermediateValidation withContext:(ModelContext *)context {
    self.discounts = discounts;
    self.shippingDetails = shippingDetails;
    self.isIntermediateValidation = isIntermediateValidation;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
    if (self.discounts || self.shippingDetails) {
        return NO; // We are doing a one-off check, such as to verify shipping details
    } else {
        return [[[ModelContext instance] plndrPurchaseSession] checkoutSummary] != nil;
    }
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    // TODO: does isEqual do a deep check in the discount array?
    if ([subscription isKindOfClass:[self class]]
        && [self.discounts isEqual:((CheckoutSummarySubscription*)subscription).discounts]
        && [self.shippingDetails isEqual:((CheckoutSummarySubscription*)subscription).shippingDetails]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    if (self.isIntermediateValidation) {
        [[ModelContext instance] plndrPurchaseSession].intermediateCheckoutErrors = nil;
    } else {
        [[ModelContext instance] plndrPurchaseSession].checkoutErrors = nil;
    }
    NSArray *discounts;
    if (self.discounts) {
        discounts = self.discounts;
    } else {
        discounts = [[[ModelContext instance] plndrPurchaseSession] getDiscounts];
    }
    
    ShippingDetails *shippingDetails;
    if (self.shippingDetails) {
        shippingDetails = self.shippingDetails;
    } else {
        shippingDetails = [[[ModelContext instance] plndrPurchaseSession] getShippingDetails];
    }
    
    return [[APIRequestManager sharedInstance] postCheckoutSummaryWithDiscounts:discounts shippingDetails:shippingDetails isIntermediateValidation:self.isIntermediateValidation delegate:self.context];
}

@end