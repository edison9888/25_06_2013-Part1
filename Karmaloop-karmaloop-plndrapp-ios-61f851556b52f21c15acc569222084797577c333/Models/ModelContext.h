//
//  ModelContext.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncRequestController.h"
#import "GenderCategory.h"

@class CartItem, PlndrPurchaseSession, LoginSession, SignupSession, Sale, SaleDetail, Product, ProductSku;

@interface ModelContext : NSObject <AsyncRequestDelegate> {
    GenderCategory _genderCategory; // Required because we don't synthesize genderCategory
}

@property (nonatomic, strong) NSArray *mensSales;
@property (nonatomic, strong) NSArray *womensSales;
@property (nonatomic, strong) NSArray *allSales;
@property (nonatomic, strong) NSMutableDictionary *saleIdToSaleDetail;
@property (nonatomic, strong) NSMutableDictionary *productIdToProduct;
@property GenderCategory genderCategory;

@property (nonatomic, strong) NSMutableArray *cartItems;
@property BOOL isCartStockStale;

@property (nonatomic, strong) PlndrPurchaseSession  *plndrPurchaseSession;
@property (nonatomic, strong) LoginSession *loginSession;
@property (nonatomic, strong) SignupSession *signupSession;

- (void) clearSales;
- (SaleDetail*) getSaleDetailForSale:(Sale*)sale genderCategory:(GenderCategory)genderCategory;
- (void) addSaleDetailToCache:(SaleDetail*)saleDetail;

- (NSArray*) getProductsForSaleId:(NSNumber*)saleId;
- (Product*) getProduct:(NSNumber*)productId;
- (void) addProductToCache:(Product*)product;
- (NSArray*) getCategoryFiltersForSaleId:(NSNumber*)saleId;
- (NSArray*) getSizeFiltersForSaleId:(NSNumber*)saleId categoryId:(NSString*)categoryId;

- (int) getCurrentCategoryFilterIndexForSaleId:(NSNumber*)saleId;
- (int) getCurrentSizeFilterIndexForSaleId:(NSNumber*)saleId;
- (NSString*) getCurrentCategoryIdFilterForSaleId:(NSNumber*)saleId;
- (NSString*) getCurrentGenderCategoryStringForSaleId:(NSNumber*)saleId;
- (NSString*)getGenderCategoryStringForGenderCategory:(GenderCategory)genderCategory;

- (int) getNumberOfItemsInCart;
- (double) getTotalCostOfItemsInCart;

- (NSString*) getCartBadgeString;
- (void) addCartItemToCart:(CartItem*)cartItem;
- (CartItem*) getCartItemWithSkuId:(NSNumber*)skuId;
- (void) removeAllQuantityOfCartItemFromCart:(CartItem*)cartItem;
- (void) removeAllQuantityOfCartItemAtIndex:(int)index;
- (void) decrementQuantityOfCartItemFromCart:(CartItem*)cartItem;
- (void) decrementQuantityOfCartItemAtIndex:(int)index;
- (void) deleteCart;
- (NSArray*) getCartItemsForAPI;
- (BOOL) isCartValid;

- (void) saveLoginSessionToDisk;
- (int) additionalStockAvailableForProduct:(Product*)product sku:(ProductSku*)sku;
- (BOOL) isProductSoldOut:(Product*) product;
- (void) updateCartItemWithSkuStocks:(NSArray*)skuStocks;


+ (ModelContext*)instance;

@end
