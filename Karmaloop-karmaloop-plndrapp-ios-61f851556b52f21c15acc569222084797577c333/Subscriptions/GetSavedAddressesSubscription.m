//
//  GetSavedAddressSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetSavedAddressesSubscription.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "Utility.h"
#import "Constants.h"

@implementation GetSavedAddressesSubscription

- (BOOL) isDataAvailable {
    return self.context.loginSession.addresses && [Utility isCacheStillValid:self.context.loginSession.lastTimeSavedAddressesWereFetched cacheTime:kCacheTimeSavedAddress];
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return [subscription isKindOfClass:[self class]];
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] requestSavedAddressesWithDelegate:self.context];
}

@end
