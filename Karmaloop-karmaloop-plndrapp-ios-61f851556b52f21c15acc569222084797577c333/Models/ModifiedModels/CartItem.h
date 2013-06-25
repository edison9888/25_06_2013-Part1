//
//  CartItem.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product, ProductSku;

@interface CartItem : NSObject <NSCoding>

@property (nonatomic, strong, readonly) Product* product;
@property (nonatomic, strong, readonly) ProductSku* size;
@property (nonatomic, strong, readonly) NSNumber *saleId;
@property int quantity;
@property BOOL isUnavailableDueToError;

- (id) initWithProduct:(Product*)product size:(ProductSku*)size saleId:(NSNumber*)saleId;
- (int) getRemainingFreeStock;
- (BOOL)containsError;

@end
