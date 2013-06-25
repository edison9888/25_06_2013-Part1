//
//  LoginSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface LoginSubscription : RequestSubscription

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (id) initWithUsername:(NSString*)username password:(NSString*)password context:(ModelContext*)context;

@end
