//
//  AppliedDiscountCode.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppliedDiscountCode.h"
#import "DiscountCode.h"

@implementation AppliedDiscountCode

NSString *kAppliedDiscountCodeTotalDiscountKey = @"kAppliedDiscountCodeTotalDiscountKey";

- (id)initWithDiscountCode:(DiscountCode *)discountCode {
    self = [super init];
    if (self) {
        _name = discountCode.name;
        _type = discountCode.type;
        _totalDiscount = [NSNumber numberWithFloat:0.0f];
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@:name=%@ cost=%.02f, type=%@", [self class], self.name, [self.totalDiscount floatValue], self.type];
}

@end
