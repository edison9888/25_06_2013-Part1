//
//  CheckoutSummary.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutSummaryObject.h"
#import "CheckoutError.h"


@interface CheckoutSummary : CheckoutSummaryObject

- (AppliedDiscountCode*) getPromoCode;
- (AppliedDiscountCode*) getRepCode;
- (NSArray*) getGiftCertificates;
- (BOOL) hasDiscount;
- (NSArray*) getDiscounts; //DiscountCode - for use in requesting a new checkout summary

@end
