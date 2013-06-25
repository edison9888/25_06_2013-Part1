//
//  CreateSavedAddressSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"
#import "SavedAddress.h"


@class Address;

@interface CreateSavedAddressSubscription : RequestSubscription

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *isPrimary;
@property SavedAddressTypes type;

- (id)initWithAddress:(Address *)address withName:(NSString *)name isPrimary:(NSNumber*) isPrimary WithType:(SavedAddressTypes) type withContext:(ModelContext *)context;

@end
