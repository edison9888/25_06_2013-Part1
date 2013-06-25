//
//  CartStockSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by xtremelabs on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartStockSubscription.h"

@implementation CartStockSubscription
- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    return ([subscription isKindOfClass:[self class]]);
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] postCartStockSubscriptionWithDelegate:self.context];
}

@end