//
//  ProductsSubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"
#import "GenderCategory.h"

@class Sale, ModelContext;

@interface ProductsSubscription : RequestSubscription

@property (nonatomic, strong) Sale *sale;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *sizeValue;
@property GenderCategory genderCategory;
@property BOOL fetchMore;
@property BOOL forceFetch;

- (id) initWithSale:(Sale*)sale categoryId:(NSString*)categoryId sizeValue:(NSString*)sizeValue genderCategory:(GenderCategory)genderCategory context:(ModelContext*)context fetchMore:(BOOL)fetchMore forceFetch:(BOOL)forceFetch;

@end
