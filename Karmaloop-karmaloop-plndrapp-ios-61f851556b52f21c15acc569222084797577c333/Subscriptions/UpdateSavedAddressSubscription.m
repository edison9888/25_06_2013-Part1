//
//  UpdateSavedAddressSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateSavedAddressSubscription.h"
#import "ModelContext.h"
#import "Utility.h"
#import "SavedAddress.h"

@implementation UpdateSavedAddressSubscription

@synthesize savedAddress = _savedAddress;

- (id)initWithSavedAddress:(SavedAddress *)savedAddress WithContext:(ModelContext *)context {
    self.savedAddress = savedAddress;
    self = [super initWithContext:context];
    return  self;
}


- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    return [subscription isKindOfClass:[self class]]
    && [self.savedAddress isEqual:((UpdateSavedAddressSubscription*)subscription).savedAddress];
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] putUpdateSavedAddress:self.savedAddress delegate:self.context];
}

@end