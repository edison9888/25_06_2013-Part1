//
//  CheckoutSummary.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutSummary.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "Constants.h"
#import "DiscountCode.h"

@implementation CheckoutSummary

- (AppliedDiscountCode *)getRepCode {
    for (AppliedDiscountCode *code in self.appliedDiscounts) {
        if ([code.type isEqualToString:kAppliedDiscountRepCode]) {
            return code;
        }
    }
    return nil;
}

- (AppliedDiscountCode *)getPromoCode {
    for (AppliedDiscountCode *code in self.appliedDiscounts) {
        if ([code.type isEqualToString:kAppliedDiscountPromoCode]) {
            return code;
        }
    }
    return nil;
}

- (NSArray *)getGiftCertificates {
    NSMutableArray *giftCodes = [NSMutableArray array];
    for (AppliedDiscountCode *code in self.appliedDiscounts) {
        if ([code.type isEqualToString:kAppliedDiscountGiftCode]) {
            [giftCodes addObject:code];
        }
    }
    return giftCodes;
}

- (BOOL)hasDiscount {
    NSObject *discount = [self getRepCode];
    if (discount) {
        return YES;
    }
    
    discount = [self getPromoCode];
    if (discount) {
        return YES;
    }
    
    discount = [self getGiftCertificates];
    if ([((NSArray*)discount) count] > 0) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)getDiscounts {
    NSMutableArray *discounts = [NSMutableArray array];
    
    NSObject *discount = [self getRepCode];
    if (discount) {
        DiscountCode *repCode = [[DiscountCode alloc] initWithAppliedDiscountCode:(AppliedDiscountCode*)discount];
        [discounts addObject:repCode];
    }
    
    discount = [self getPromoCode];
    if (discount) {
        DiscountCode *promoCode = [[DiscountCode alloc] initWithAppliedDiscountCode:(AppliedDiscountCode*)discount];
        [discounts addObject:promoCode];
    }
    
    discount = [self getGiftCertificates];
    for (AppliedDiscountCode *applidedGiftCode in (NSArray*)discount) {
        DiscountCode *giftCode = [[DiscountCode alloc] initWithAppliedDiscountCode:applidedGiftCode];
        [discounts addObject:giftCode];
    }
    
    return discounts;
}

@end
