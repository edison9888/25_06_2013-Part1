//
//  SaleDetail.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenderCategory.h"

@class Sale;

@interface SaleDetail : NSObject

@property (nonatomic, strong) Sale *sale;
@property (nonatomic, strong) NSMutableArray *productIds;
@property (nonatomic, strong) NSArray *filterCategories;
@property GenderCategory genderCategory;
@property int currentFilterCategoryIndex;
@property int currentFilterSizeIndex;
@property (nonatomic, strong) NSDate *lastTimeProductsWereFetched;
@property BOOL hasMoreProductsToFetch;

- (id) initFromSale:(Sale*)sale;
- (void) updateCurrentCategoryFilterIndex:(int)categoryIndex;
- (void) updateCurrentSizeFilterIndex:(int)sizeIndex;
- (NSArray*) getSizesForCurrentCategory;
- (void) removeAllProducts;
- (void) addProductId:(NSNumber*)productId;
- (NSString*) getCurrentCategoryId;
- (NSString*) getCurrentCategoryDisplayString;
- (NSString*) getCurrentSizeValue;
- (NSString*) getCurrentSizeDisplayString;
@end
