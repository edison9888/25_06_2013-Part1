//
//  CartItem.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartItem.h"
#import "Product.h"
#import "ProductSku.h"
#import "Utility.h"

@implementation CartItem

@synthesize product = _product;
@synthesize size = _size;
@synthesize saleId = _saleId;
@synthesize quantity = _quantity;
@synthesize isUnavailableDueToError = _isUnavailableDueToError;

NSString *kCartItemProductKey = @"kCartItemProductKey";
NSString *kCartItemSizeKey = @"kCartItemSizeKey";
NSString *kCartItemSaleIdKey = @"kCartItemSaleIdKey";
NSString *kCartItemQuantityKey = @"kCartItemQuantityKey";

- (id) initWithProduct:(Product*)product size:(ProductSku*)size saleId:(NSNumber *)saleId{
    self = [super init];
    if (self) {
        _product = product;
        _size = size;
        _saleId = saleId;
        _quantity = 1;
        _isUnavailableDueToError = NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_product forKey:kCartItemProductKey];
    [aCoder encodeObject:_size forKey:kCartItemSizeKey];
    [aCoder encodeObject:_saleId forKey:kCartItemSaleIdKey];
    [aCoder encodeObject:[NSNumber numberWithInt:_quantity] forKey:kCartItemQuantityKey];
}

- (id)copyWithZone:(NSZone *)zone {
    CartItem *copyAddr = [[CartItem allocWithZone:zone] initWithProduct:[self.product copy] size:[self.size copy] saleId:[self.saleId copy]];
    copyAddr.quantity = self.quantity;
    
    return copyAddr;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    Product *product = [aDecoder decodeObjectForKey:kCartItemProductKey];
    ProductSku *productSize = [aDecoder decodeObjectForKey:kCartItemSizeKey];
    NSNumber *saleId = [aDecoder decodeObjectForKey:kCartItemSaleIdKey];
    int quantity = [((NSNumber*)[aDecoder decodeObjectForKey:kCartItemQuantityKey]) intValue];
    self = [self initWithProduct:product size:productSize saleId:saleId];
    if (self) {
        _quantity = quantity;
    }
    return self;
}

- (BOOL) isEqual:(CartItem*)otherItem {
    // Note: CartItems with different saleIds are equal.
    
    if (![[self class] isEqual:[otherItem class]]) {
        return NO;
    } else if (![self.product.productId isEqual:otherItem.product.productId]) {
        return NO;
    } else if (![self.size.skuId isEqual:otherItem.size.skuId]) {
        return NO;
    }
       
    return YES;
}

- (int)getRemainingFreeStock {
    return [self.size.stock intValue] - self.quantity;
}

- (BOOL) containsError {
    return (self.getRemainingFreeStock < 0) || self.isUnavailableDueToError;
}

@end
