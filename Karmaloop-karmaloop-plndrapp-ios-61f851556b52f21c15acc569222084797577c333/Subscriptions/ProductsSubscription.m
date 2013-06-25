//
//  ProductsSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductsSubscription.h"
#import "Sale.h"
#import "SaleDetail.h"
#import "ModelContext.h"
#import "Utility.h"
#import "Constants.h"

@implementation ProductsSubscription

@synthesize sale = _sale;
@synthesize categoryId = _categoryId;
@synthesize sizeValue = _sizeValue;
@synthesize genderCategory = _genderCategory;
@synthesize fetchMore = _fetchMore;
@synthesize forceFetch = _forceFetch;

- (id) initWithSale:(Sale *)sale categoryId:(NSString *)categoryId sizeValue:(NSString *)sizeValue genderCategory:(GenderCategory)genderCategory context:(ModelContext *)context fetchMore:(BOOL)fetchMore forceFetch:(BOOL)forceFetch{
    self.sale = sale;
    self.categoryId = categoryId;
    self.sizeValue = sizeValue;
    self.genderCategory = genderCategory;
    self.fetchMore = fetchMore;
    self.forceFetch = forceFetch;
    self = [super initWithContext:context forceFetch:forceFetch];

    return self;
}

- (BOOL) isDataAvailable {
    SaleDetail *saleDetail = [[ModelContext instance] getSaleDetailForSale:self.sale genderCategory:self.genderCategory];
    
    if(([saleDetail getCurrentCategoryId] != self.categoryId 
    || [saleDetail getCurrentSizeValue] != self.sizeValue 
    || saleDetail.genderCategory != self.genderCategory
         || ![Utility isCacheStillValid:saleDetail.lastTimeProductsWereFetched cacheTime:kCacheTimeSalesAndProducts])) {
        return NO;
    }
    
    NSArray *products = [self.context getProductsForSaleId:self.sale.saleId];
    
    if (!saleDetail.hasMoreProductsToFetch && products.count > 0) {
        return YES; // There's no more to fetch
    }
    
    if (saleDetail.hasMoreProductsToFetch && (products.count == 0 || (products.count % kProductPageSize != 0))) {
        // There's more, and we don't have a complete page. Fetch more.
        // This probably happened because of partial cacheing after a memory warning.
        return NO;
    }
    
    if (self.fetchMore && saleDetail.hasMoreProductsToFetch) {
        return NO; //Fetch MORE
    }
    
    return !(products.count == 0);
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]] && self.sale.saleId == ((ProductsSubscription*)subscription).sale.saleId) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    int page;
    if (self.forceFetch) {
        page = 0;
    } else {
        // Determine the page to ask for
        int numberOfProducts = [[ModelContext instance] getProductsForSaleId:self.sale.saleId].count;
        page = numberOfProducts / kProductPageSize;  
    }
    
    return [[APIRequestManager sharedInstance] requestProductsWithSaleId:self.sale.saleId categoryId:self.categoryId sizeValue:self.sizeValue genderCategoryString:[[ModelContext instance] getGenderCategoryStringForGenderCategory:self.genderCategory] page:page delegate:self.context];
}

@end
