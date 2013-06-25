//
//  UpdateSavedAddressSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@class SavedAddress;

@interface UpdateSavedAddressSubscription : RequestSubscription

@property (nonatomic, strong) SavedAddress *savedAddress;

- (id) initWithSavedAddress:(SavedAddress*) savedAddress WithContext:(ModelContext*)context;

@end
