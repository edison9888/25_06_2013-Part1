//
//  ShippingMethodsSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"
#import "Address.h"

@interface ShippingMethodsSubscription : RequestSubscription

- (id) initWithAddress:(Address *)address cartItems:(NSArray *)cartItems context:(ModelContext *)context;

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *cartItems;

@end
