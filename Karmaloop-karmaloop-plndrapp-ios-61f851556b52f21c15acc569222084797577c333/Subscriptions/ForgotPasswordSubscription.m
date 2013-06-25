//
//  ForgotPasswordSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordSubscription.h"

@implementation ForgotPasswordSubscription
@synthesize email = _email;

- (id) initWithEmail:(NSString *)email context:(ModelContext *)context {
    self.email = email;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
	return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
    if ([subscription isKindOfClass:[self class]] && [self.email isEqualToString:((ForgotPasswordSubscription*)subscription).email]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
	return [[APIRequestManager sharedInstance] requestPasswordWithEmail:self.email delegate:self.context];
}

@end
