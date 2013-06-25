//
//  SignUpSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface SignUpSubscription : RequestSubscription

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (id) initWithEmail:(NSString*)email withPassword:(NSString*)password withConfirmPassword:(NSString*)confirmPassword withFirstName:(NSString*)firstName withLastName:(NSString*)lastname withContext:(ModelContext*) context;

@end
