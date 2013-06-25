//
//  Product.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Product.h"
#import "Utility.h"
#import "ProductSku.h"

@implementation Product

@synthesize availabilityEndDate = _availabilityEndDate;
@synthesize lastTimeProductDetailsWereFetched = _lastTimeSinceProductDetailsWereFetched;

NSString* kProductAvailabilityEndDateKey = @"kProductAvailabilityEndDateKey";

- (void)loadDetailsFromProductDetailsDictionary:(NSDictionary *)detailsDictionary {
    NSArray *rawZooms = [detailsDictionary objectForKey:@"zooms"];
    _zooms = [NSArray arrayWithArray:rawZooms];
    
    NSArray *rawSkus = [detailsDictionary objectForKey:@"skus"];
    NSMutableArray *skus = [NSMutableArray arrayWithCapacity:[rawSkus count]];
    for (NSDictionary *dict in rawSkus) {
        [skus addObject:[[ProductSku alloc] initFromDictionary:dict]];
    }
    _skus = [NSArray arrayWithArray:skus];
    
    _productDescription = [detailsDictionary objectForKey:@"mobileDescription"];
    _style = [detailsDictionary objectForKey:@"styleNumber"];
}

- (void)postProcessData {
    _availabilityEndDate = [Utility dateFromISO8601:self.availabilityEndDateRaw];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: id=%@ name=%@", [self class], self.productId, self.name];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_availabilityEndDate forKey:kProductAvailabilityEndDateKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    _availabilityEndDate = [aDecoder decodeObjectForKey:kProductAvailabilityEndDateKey];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Product *product = [super copyWithZone:zone];
    product.availabilityEndDate = self.availabilityEndDate;
    return product;
}

- (int)discountPercentage {
	return (self.price.floatValue - self.checkoutPrice.floatValue) / self.price.floatValue * 100;
}

@end
