//
//  SignupSession.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignupSession : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *genderIndex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;

// "Static" Data
@property (nonatomic, strong) NSArray *genderOptions;

- (NSArray*)getGenderIndexArray;
- (void)setGenderIndexFromArray:(NSArray*)array;
- (NSString*)getGenderDisplayString;
- (NSArray*)getGenderOptions;
- (BOOL)isSignupSessionComplete;

@end
