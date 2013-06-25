//
//  PasswordChangeSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PasswordChangeSubscription.h"

@implementation PasswordChangeSubscription

@synthesize oldPassword = _oldPassword, neuePassword = _neuePassword, confirmPassword = _confirmPassword;

- (id)initWithOldPassword:(NSString *)oldPassword neuePassword:(NSString *)neuePassword confirmPassword:(NSString *)confirmPassword context:(ModelContext *)context{
    self.oldPassword = oldPassword;
    self.neuePassword = neuePassword;
    self.confirmPassword = confirmPassword;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if([subscription isKindOfClass:[self class]] && ([self.oldPassword isEqualToString:((PasswordChangeSubscription*)subscription).oldPassword]) && ([self.neuePassword isEqualToString:((PasswordChangeSubscription*)subscription).neuePassword]) && ([self.confirmPassword isEqualToString:((PasswordChangeSubscription*)subscription).confirmPassword])) {
        return YES;
    } else {
        return NO;
    }
}

- (APIRequestController *)apiRequest {
    return [[APIRequestManager sharedInstance] putChangePassword:self.oldPassword neuePassword:self.neuePassword confirmPassword:self.confirmPassword delegate:self.context];
}

@end

