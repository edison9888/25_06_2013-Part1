//
//  CheckoutCompleteSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutCompleteSubscription.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"

@implementation CheckoutCompleteSubscription

- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    return ([subscription isKindOfClass:[self class]]);
}

- (APIRequestController*) apiRequest {
    [[ModelContext instance] plndrPurchaseSession].checkoutErrors = nil;
    [[ModelContext instance] plndrPurchaseSession].lastDisplayedCheckoutError = nil;
    return [[APIRequestManager sharedInstance] postCheckoutCompleteWithDelegate:self.context];
}

@end