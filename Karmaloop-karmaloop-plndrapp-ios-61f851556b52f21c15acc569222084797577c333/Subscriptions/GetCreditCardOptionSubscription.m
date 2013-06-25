//
//  GetCreditCardOptionSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetCreditCardOptionSubscription.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"


@implementation GetCreditCardOptionSubscription

- (BOOL) isDataAvailable {
	return self.context.plndrPurchaseSession.creditCardOptions.count > 0;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return [subscription isKindOfClass:[self class]];
}

- (APIRequestController*) apiRequest {
	return [[APIRequestManager sharedInstance] requestCreditCardOptionsWithDelegate:self.context];
}



@end
