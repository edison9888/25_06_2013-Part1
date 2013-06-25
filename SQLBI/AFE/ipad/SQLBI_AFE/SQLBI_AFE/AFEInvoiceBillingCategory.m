//
//  AFEInvoiceBillingCategory.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEInvoiceBillingCategory.h"

@implementation AFEInvoiceBillingCategory

@synthesize billingCategoryName;
@synthesize billingCategoryID;
@synthesize actual;
@synthesize actualsAsStr;
@synthesize fieldEstimate;
@synthesize fieldEstimateAsStr;
@synthesize invoiceCount;
@synthesize actualPlusAccrual;
@synthesize actualsPlusAccrualAsStr;
@synthesize budgetAmount;
@synthesize budgetAmountAsStr;
@synthesize code;

-(id) init {
    self = [super init];
    if (self) {
        self.billingCategoryName = @"";
        self.billingCategoryID = @"";
        self.actual = 0;
        self.actualsAsStr = @"";
        self.fieldEstimate = 0;
        self.fieldEstimateAsStr = @"";
        self.invoiceCount = 0;
        self.actualPlusAccrual = 0;
        self.actualsPlusAccrualAsStr = @"";
        self.budgetAmount = 0;
        self.budgetAmountAsStr = @"";
        self.code = @"";
    }
    return  self;
    
}
-(void)dealloc {
    self.billingCategoryName = nil;
    self.billingCategoryID = nil;
    self.actualsAsStr = nil;
    self.fieldEstimateAsStr = nil;
    self.actualsPlusAccrualAsStr = nil;
    self.budgetAmountAsStr = nil;
    self.code = nil;
}


@end
