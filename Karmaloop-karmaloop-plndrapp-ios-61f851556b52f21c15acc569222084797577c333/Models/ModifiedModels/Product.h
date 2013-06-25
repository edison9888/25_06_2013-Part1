//
//  Product.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductObject.h"

@interface Product : ProductObject

@property (nonatomic, strong) NSDate *availabilityEndDate;
@property (nonatomic, strong) NSDate *lastTimeProductDetailsWereFetched;

- (void) loadDetailsFromProductDetailsDictionary:(NSDictionary*)detailsDictionary;
- (int)discountPercentage;

@end
