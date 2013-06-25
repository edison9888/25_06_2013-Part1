//
//  DiscountCode.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscountCode.h"
#import "AppliedDiscountCode.h"

@interface DiscountCode ()

- (void) setType:(DiscountType)type;

@end

@implementation DiscountCode

// These values must be exactly as they are for API use.
NSString *kGiftCode = @"GiftCode";
NSString *kRepCode = @"RepCode";
NSString *kPromoCode = @"PromoCode";

- (id)initWithAppliedDiscountCode:(AppliedDiscountCode *)appliedDiscountCode {
    self = [super init];
    if (self) {
        _name = appliedDiscountCode.name;
        _type = appliedDiscountCode.type;
    }
    return self;
}

- (id)initWithType:(DiscountType)type {
    self = [super init];
    if (self) {
        [self setType:type];
    }
    return self;
}

- (void)setType:(DiscountType)type {
    switch (type) {
        case GiftCode:
            _type = kGiftCode;
            break;
        case RepCode:
            _type = kRepCode;
            break;
        case PromoCode:
            _type = kPromoCode;
            break;
        default:
            break;
    }
}

+ (NSArray*) getAPIDiscountsFromDiscountCodes:(NSArray*)discountCodes
{
    NSMutableArray *discountsArray = [NSMutableArray array];
    for (DiscountCode *discountCode in discountCodes) {
        NSDictionary *discountDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            discountCode.name, @"name",
                                            discountCode.type, @"type",
                                            nil];
        [discountsArray addObject:discountDictionary];
    }
    return discountsArray;
}

@end
