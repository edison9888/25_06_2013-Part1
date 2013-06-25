//
//  PasswordChangeSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface PasswordChangeSubscription : RequestSubscription

@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *neuePassword;
@property (nonatomic, strong) NSString *confirmPassword;

- (id) initWithOldPassword: (NSString *) oldPassword neuePassword:(NSString*) neuePassword confirmPassword:(NSString*) confirmPassword context:(ModelContext*)context;

@end