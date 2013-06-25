//
//  ProductDetailSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailSubscription.h"
#import "ModelContext.h"
#import "Product.h"
#import "Utility.h"
#import "Constants.h"

@implementation ProductDetailSubscription

@synthesize productId = _productId;

- (id) initWithProductId:(NSNumber*)productId context:(ModelContext*)context forceFetch:(BOOL)forceFetch{
    self.productId = productId;
    self = [super initWithContext:context forceFetch:forceFetch];
    
    return self;
}

- (BOOL) isDataAvailable {
    Product *product = [self.context getProduct:self.productId];

    return (product.zooms.count > 0 || product.skus.count > 0) && [Utility isCacheStillValid:product.lastTimeProductDetailsWereFetched cacheTime:kCacheTimeSalesAndProducts];
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]] && [self.productId isEqual:((ProductDetailSubscription*)subscription).productId]) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] requestProductDetailWithProductId:self.productId delegate:self.context];
}

@end
