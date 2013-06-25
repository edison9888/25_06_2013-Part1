//
//  ProductDetailSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"

@interface ProductDetailSubscription : RequestSubscription

@property (nonatomic, strong) NSNumber *productId;

- (id) initWithProductId:(NSNumber*)productId context:(ModelContext*)context forceFetch:(BOOL) forceFetch;

@end
