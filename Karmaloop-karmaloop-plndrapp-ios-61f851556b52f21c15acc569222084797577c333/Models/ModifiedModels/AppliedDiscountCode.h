//
//  AppliedDiscountCode.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppliedDiscountCodeObject.h"

@class DiscountCode;

@interface AppliedDiscountCode : AppliedDiscountCodeObject

- initWithDiscountCode:(DiscountCode*)discountCode;

@end
