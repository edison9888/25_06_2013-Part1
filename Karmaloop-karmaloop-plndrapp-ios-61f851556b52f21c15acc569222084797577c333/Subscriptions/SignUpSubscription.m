//
//  SignUpSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpSubscription.h"

@implementation SignUpSubscription

@synthesize email = _email;
@synthesize password = _password;
@synthesize confirmPassword = _confirmPassword;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;


- (id)initWithEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword withFirstName:(NSString *)firstName withLastName:(NSString *)lastName withContext:(ModelContext *)context {
    self.email = email;
    self.password = password;
    self.confirmPassword = confirmPassword;
    self.firstName = firstName;
    self.lastName = lastName;
    self = [super initWithContext:context];
    return self;
}

- (BOOL) isDataAvailable {
    return NO;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]]
        && [self.email isEqualToString:((SignUpSubscription*)subscription).email]
        && [self.password isEqualToString:((SignUpSubscription*)subscription).password]
        && [self.confirmPassword isEqualToString:((SignUpSubscription*)subscription).confirmPassword]
        && [self.firstName isEqualToString:((SignUpSubscription*)subscription).firstName]
        && [self.lastName isEqualToString:((SignUpSubscription*)subscription).lastName]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] postSignUpWithEmail:self.email withPassword:self.password withConfirmPassword:self.confirmPassword withFirstName:self.firstName withLastName:self.lastName delegate:self.context];
}

@end
