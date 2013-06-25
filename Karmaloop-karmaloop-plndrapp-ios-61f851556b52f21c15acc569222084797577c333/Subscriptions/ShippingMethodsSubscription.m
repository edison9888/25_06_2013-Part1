//
//  ShippingMethodsSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShippingMethodsSubscription.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"

@implementation ShippingMethodsSubscription
@synthesize address = _address;
@synthesize cartItems = _cartItems;

- (id) initWithAddress:(Address *)address cartItems:(NSArray *)cartItems context:(ModelContext *)context {
    self.address = address;
    self.cartItems = cartItems;
    self = [super initWithContext:context];
    
    return self;
}

- (BOOL) isDataAvailable {
	return self.context.plndrPurchaseSession.shippingMethods.count > 0;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
    if ([subscription isKindOfClass:[self class]] && [self.address isEqual:((ShippingMethodsSubscription*)subscription).address] && [self.cartItems isEqual:((ShippingMethodsSubscription*)subscription).cartItems]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    [[ModelContext instance] plndrPurchaseSession].checkoutErrors = nil;
	return [[APIRequestManager sharedInstance] requestCheckoutOptionsWithAddress:self.address cartItems:self.cartItems delegate:self.context];
}

@end
