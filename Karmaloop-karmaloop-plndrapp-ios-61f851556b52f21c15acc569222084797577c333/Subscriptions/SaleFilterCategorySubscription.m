//
//  SaleFilterCategorySubscription.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaleFilterCategorySubscription.h"
#import "ModelContext.h"
#import "Sale.h"
#import "SaleDetail.h"

@implementation SaleFilterCategorySubscription

@synthesize sale = _sale;
@synthesize genderCategory = _genderCategory;

- (id) initWithSale:(Sale *)sale genderCategory:(GenderCategory)genderCategory context:(ModelContext *)context forceFetch:(BOOL)forceFetch {
    self.sale = sale;
    self.genderCategory = genderCategory;
    self = [super initWithContext:context forceFetch:forceFetch];
    
    return self;
}

- (BOOL) isDataAvailable {
    
    //If there's no filters, then we need to fetch
    NSArray *categories = [self.context getCategoryFiltersForSaleId:self.sale.saleId];
    if (categories.count == 0) {
        return NO;
    }
    
    //Also, if the filters of this sale don't match my filters, then we need to fetch
    SaleDetail *saleDetail = [self.context getSaleDetailForSale:self.sale genderCategory:self.genderCategory];
    return saleDetail.genderCategory == self.genderCategory;
}

- (BOOL) subscriptionMatches:(ModelSubscription *)subscription {
    if ([subscription isKindOfClass:[self class]] &&
        self.sale.saleId == ((SaleFilterCategorySubscription*)subscription).sale.saleId &&
        self.genderCategory == ((SaleFilterCategorySubscription*)subscription).genderCategory) {
        return YES;
    }
    return NO;
}

- (APIRequestController*) apiRequest {
    return [[APIRequestManager sharedInstance] requestCategoryFiltersWithSaleId:self.sale.saleId genderCategoryString:[[ModelContext instance] getGenderCategoryStringForGenderCategory:self.genderCategory] delegate:self.context];
}

@end
