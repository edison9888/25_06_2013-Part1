//
//  AccountDetailsSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountDetailsSubscription.h"
#import "ModelContext.h"
#import "LoginSession.h"

@implementation AccountDetailsSubscription

- (BOOL) isDataAvailable {
	return self.context.loginSession.accountDetails != nil;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return [subscription isKindOfClass:[self class]];
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] requestAccountDetailsWithDelegate:self.context];
}

@end
