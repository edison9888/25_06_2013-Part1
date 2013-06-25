//
//  CountrySubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountrySubscription.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"

@implementation CountrySubscription

- (BOOL) isDataAvailable {
	return self.context.plndrPurchaseSession.countries.count > 0;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return [subscription isKindOfClass:[self class]];
}

- (APIRequestController*) apiRequest {
	return [[APIRequestManager sharedInstance] requestCountriesWithDelegate:self.context];
}

@end
