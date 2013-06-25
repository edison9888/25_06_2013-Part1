//
//  DiscountCode.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscountCodeObject.h"

@class AppliedDiscountCode;

typedef enum { 
    GiftCode,
    RepCode,
    PromoCode
} DiscountType;

@interface DiscountCode : DiscountCodeObject

- (id)initWithType:(DiscountType)type;
- (id)initWithAppliedDiscountCode:(AppliedDiscountCode*)appliedDiscountCode;

+ (NSArray*) getAPIDiscountsFromDiscountCodes:(NSArray*)discountCodes;

@end
