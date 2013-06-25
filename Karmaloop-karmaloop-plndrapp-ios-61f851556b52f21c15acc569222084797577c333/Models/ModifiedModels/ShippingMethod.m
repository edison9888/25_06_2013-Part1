//
//  ShippingMethod.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShippingMethod.h"
#import "ShippingOption.h"

@implementation ShippingMethod

- (id)copyWithZone:(NSZone *)zone {
    ShippingMethod *shippingMethod = [super copyWithZone:zone];
    return shippingMethod;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: name=%@ value=%@ cost=%@ options=%@", [self class], self.name, self.shippingMethodValue, self.cost, self.shippingOptions];
}

- (NSArray *)getSelectedOptions {
    NSMutableArray *shippingOptionsArray = [NSMutableArray array];
    for (ShippingOption *shippingOption in self.shippingOptions) {
        if (shippingOption.isSelected.boolValue) {
            [shippingOptionsArray addObject:shippingOption];
        }
    }
    return shippingOptionsArray;
}


@end
