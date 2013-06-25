//
//  LoginSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginSubscription.h"

@implementation LoginSubscription

@synthesize username = _username, password = _password;

- (id) initWithUsername:(NSString *)username password:(NSString *)password context:(ModelContext *)context {
    self.username = username;
    self.password = password;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]] && [self.username isEqualToString:((LoginSubscription*)subscription).username] && [self.password isEqualToString:((LoginSubscription*)subscription).password]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] postLoginUsername:self.username password:self.password delegate:self.context];
}

@end
