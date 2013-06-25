//
//  DeleteSavedAddressSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface DeleteSavedAddressSubscription : RequestSubscription

@property (nonatomic, strong) NSNumber *saveAddressId;

- (id) initWithSavedAddressId:(NSNumber*)saveAddressId withContext:(ModelContext*)context;

@end
