//
//  ForgotPasswordSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface ForgotPasswordSubscription : RequestSubscription

@property (nonatomic, strong) NSString *email;

- (id) initWithEmail:(NSString *)email context:(ModelContext *)context;

@end
