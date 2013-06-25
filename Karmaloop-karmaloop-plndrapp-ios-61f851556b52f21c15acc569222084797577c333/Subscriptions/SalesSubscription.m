//
//  SalesSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SalesSubscription.h"
#import "ModelContext.h"

@implementation SalesSubscription

- (BOOL) isDataAvailable {
    int totalSales = self.context.allSales.count + self.context.womensSales.count + self.context.mensSales.count;
	return totalSales > 0;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return [subscription isKindOfClass:[self class]];
}

- (APIRequestController*) apiRequest {
	return [[APIRequestManager sharedInstance] requestSalesWithDelegate:self.context];
}

@end
