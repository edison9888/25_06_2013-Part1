//
//  SaleFilterSizeSubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaleFilterSizeSubscription.h"
#import "ModelContext.h"
#import "Sale.h"
#import "SaleDetail.h"

@implementation SaleFilterSizeSubscription

@synthesize sale = _sale;
@synthesize categoryId = _categoryId;
@synthesize genderCategory = _genderCategory;

- (id) initWithSale:(Sale *)sale categoryId:(NSString *)categoryId genderCategory:(GenderCategory)genderCategory context:(ModelContext *)context forceFetch:(BOOL)forceFetch{
    self.sale = sale;
    self.categoryId = categoryId;
    self.genderCategory = genderCategory;
    
    self = [super initWithContext:context forceFetch:forceFetch];
    
    return self;
}

- (BOOL) isDataAvailable {
    //If there's no filters, then we need to fetch
    NSArray *sizes = [self.context getSizeFiltersForSaleId:self.sale.saleId categoryId:self.categoryId];
    if (sizes.count == 0) {
        return NO;
    }
    
    //Also, if the filters of this sale don't match my filters, then we need to fetch
    SaleDetail *saleDetail = [self.context getSaleDetailForSale:self.sale genderCategory:self.genderCategory];
    return (saleDetail.genderCategory == self.genderCategory && [saleDetail getCurrentCategoryId] == self.categoryId);
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]] &&
        self.sale.saleId == ((SaleFilterSizeSubscription*)subscription).sale.saleId &&
        self.categoryId == ((SaleFilterSizeSubscription*)subscription).categoryId &&
        self.genderCategory == ((SaleFilterSizeSubscription*)subscription).genderCategory
        ) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] requestSizeFiltersWithSaleId:self.sale.saleId categoryId:self.categoryId genderCategoryString:[[ModelContext instance] getGenderCategoryStringForGenderCategory:self.genderCategory] delegate:self.context];
}


@end
