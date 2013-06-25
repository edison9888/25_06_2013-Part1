//
//  SignupSession.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignupSession.h"

@interface SignupSession ()

- (void)createGenderDataSource;

@end

@implementation SignupSession

@synthesize firstName = _firstName, lastName = _lastName, genderIndex = _genderIndex, email = _email, password = _password, genderOptions = _genderOptions;
@synthesize confirmPassword = _confirmPassword;

- (id)init {
    self = [super init];
    if (self) {
        [self createGenderDataSource];
    }
    return self;
}

- (NSArray*)getGenderIndexArray {
    return [NSArray arrayWithObject:[NSNumber numberWithInt:self.genderIndex.intValue]];
}

- (void)setGenderIndexFromArray:(NSArray*)array {
    self.genderIndex = [array objectAtIndex:0];
}

- (NSString *)getGenderDisplayString {
    return [self.genderOptions objectAtIndex:self.genderIndex.intValue];
}

- (NSArray *)getGenderOptions {
    return [NSArray arrayWithObject:self.genderOptions];
}

- (BOOL)isSignupSessionComplete {
	return self.firstName.length > 0 && self.lastName.length > 0 && self.email.length > 0 && self.password.length > 0 && self.confirmPassword.length > 0;
}


#pragma mark - private

- (void)createGenderDataSource {
    self.genderOptions = [[NSArray alloc] init];
    self.genderOptions = [NSArray arrayWithObjects:@"Male", @"Female", nil];
}

@end
