//
//  SaleFilterSizeSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"
#import "GenderCategory.h"

@class Sale;

@interface SaleFilterSizeSubscription : RequestSubscription

@property (nonatomic, strong) Sale *sale;
@property (nonatomic, strong) NSString *categoryId;
@property GenderCategory genderCategory;

- (id) initWithSale:(Sale*)sale categoryId:(NSString*)categoryId genderCategory:(GenderCategory)genderCategory context:(ModelContext*)context forceFetch:(BOOL) forceFetch;

@end
