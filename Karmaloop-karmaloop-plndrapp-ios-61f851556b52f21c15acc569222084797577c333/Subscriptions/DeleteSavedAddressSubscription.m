//
//  DeleteSavedAddressSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeleteSavedAddressSubscription.h"
#import "Utility.h"

@implementation DeleteSavedAddressSubscription

@synthesize saveAddressId = _saveAddressId;

- (id)initWithSavedAddressId:(NSNumber *)savedAddressId withContext:(ModelContext *)context {
    self.saveAddressId = savedAddressId;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    return [subscription isKindOfClass:[self class]] && [Utility isEqualNumber:self.saveAddressId number2:((DeleteSavedAddressSubscription*)subscription).saveAddressId];
        
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] deleteSavedAddressWithSavedAddressId:self.saveAddressId  delegate:self.context];
}

@end
