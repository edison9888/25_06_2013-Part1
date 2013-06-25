//
//  CheckoutSummarySubscription.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestSubscription.h"
#import "ShippingDetails.h"

@interface CheckoutSummarySubscription : RequestSubscription

@property (nonatomic, strong) NSArray *discounts; //NSArray<DiscountCodes>
@property (nonatomic, strong) ShippingDetails *shippingDetails;
@property BOOL isIntermediateValidation;

- (id) initWithDiscounts:(NSArray*)discounts shippingDetails:(ShippingDetails*)shippingDetails isIntermediateValidation:(BOOL)isIntermediateValidation withContext:(ModelContext*)context;

@end
