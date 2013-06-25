//
//  SaleDetail.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaleDetail.h"
#import "SaleFilterCategory.h"

@implementation SaleDetail

@synthesize sale = _sale;
@synthesize productIds = _productIds;
@synthesize filterCategories = _filterCategories;
@synthesize currentFilterCategoryIndex = _currentFilterCategoryIndex;
@synthesize currentFilterSizeIndex = _currentFilterSizeIndex;
@synthesize genderCategory = _genderCategory;
@synthesize lastTimeProductsWereFetched = _lastTimeProductsWereFetched;
@synthesize hasMoreProductsToFetch = _hasMoreProductsToFetch;

- (id)initFromSale:(Sale *)sale {
    self = [super init];
    if (self) {
        self.sale = sale;
        self.productIds = [NSMutableArray array];
        self.hasMoreProductsToFetch = YES;
    }
    return self;
}

- (void)updateCurrentCategoryFilterIndex:(int)categoryIndex {
    self.currentFilterCategoryIndex = categoryIndex;
    self.currentFilterSizeIndex = 0;
    [self removeAllProducts];
}

- (void)updateCurrentSizeFilterIndex:(int)sizeIndex {
    self.currentFilterSizeIndex = sizeIndex;
    [self removeAllProducts];
}

- (NSArray *)getSizesForCurrentCategory {
    if (self.currentFilterCategoryIndex < 0) {
        return nil;
    }
    return ((SaleFilterCategory*)[self.filterCategories objectAtIndex:self.currentFilterCategoryIndex]).sizes;
}

- (void) removeAllProducts {
    self.productIds = [NSMutableArray array];
}

- (void)addProductId:(NSNumber *)productId {
    [self.productIds addObject:productId];
}

- (NSString*) getCurrentCategoryId {
    if (self.currentFilterCategoryIndex < 0) {
        return @"";
    }
    return ((SaleFilterCategory*)[self.filterCategories objectAtIndex:self.currentFilterCategoryIndex]).categoryId;
}

- (NSString*) getCurrentCategoryDisplayString {
    if (self.currentFilterCategoryIndex < 0) {
        return @"";
    }
    return ((SaleFilterCategory*)[self.filterCategories objectAtIndex:self.currentFilterCategoryIndex]).displayName;
}

- (NSString*) getCurrentSizeValue {
    if (self.currentFilterCategoryIndex < 0 || self.currentFilterSizeIndex < 0) {
        return @"";
    }
    SaleFilterCategory *category = [self.filterCategories objectAtIndex:self.currentFilterCategoryIndex];
    return ([category.sizes count] > 0) ? ((SaleFilterSize*)[category.sizes objectAtIndex:self.currentFilterSizeIndex]).value : @"";
}

- (NSString*) getCurrentSizeDisplayString {
    if (self.currentFilterCategoryIndex < 0 || self.currentFilterSizeIndex < 0) {
        return @"";
    }
    SaleFilterCategory *category = [self.filterCategories objectAtIndex:self.currentFilterCategoryIndex];
    return ([category.sizes count] > 0) ? ((SaleFilterSize*)[category.sizes objectAtIndex:self.currentFilterSizeIndex]).displayName : @"";
}

@end
