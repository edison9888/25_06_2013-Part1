//
//  AFEInvoice.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEInvoice.h"

@implementation AFEInvoice

@synthesize accountingDate;
@synthesize billingCategoryID;
@synthesize billingCategory;
@synthesize grossExpense;
@synthesize grossExpenseAsStr;
@synthesize invoiceAmount;
@synthesize invoiceAmountAsStr;
@synthesize invoiceDate;
@synthesize invoiceID;
@synthesize invoiceLink;
@synthesize invoiceNumber;
@synthesize propertyID;
@synthesize propertyName;
@synthesize propertyType;
@synthesize serviceDate;
@synthesize vendorID;
@synthesize vendorName;

@synthesize actual;
@synthesize actualsAsStr;
@synthesize fieldEstimate;
@synthesize fieldEstimateAsStr;
@synthesize accountingDateAsStr;
@synthesize invoiceDateAsStr;

-(id)init {
    self= [super init];
    if(self){
        
        self.actual             = 0;
        self.actualsAsStr       = @"";
        self.fieldEstimate      = 0;
        self.fieldEstimateAsStr = @"";
        self.invoiceDateAsStr   = @"";
        self.accountingDateAsStr=@"";
        
        
        self.accountingDate=nil;
        self.billingCategoryID= @"";
        self.billingCategory= @"";
        self.invoiceNumber= @"";
        self.grossExpense= 0;
        self.grossExpenseAsStr= @"";
        self.invoiceAmount= 0;
        self.invoiceAmountAsStr= @"";
        self.invoiceDate=nil;
        self.invoiceID= @"";
        self.invoiceLink= @"";
        self.invoiceNumber= @"";
        self.propertyID= @"";
        self.propertyName= @"";
        self.propertyType= @"";
        self.serviceDate=nil;
        self.vendorID= 0;
        self.vendorName= @"";
    }
    return self;

}
-(void)dealloc {
    self.invoiceNumber = nil;
    self.billingCategoryID = nil;
    self.billingCategory = nil;
    self.actual = 0;
    self.actualsAsStr = nil;
    self.fieldEstimate = 0;
    self.fieldEstimateAsStr = nil;
    self.propertyName = nil;
    self.propertyType = nil;
    self.invoiceDate = nil;
    self.invoiceDateAsStr = nil;
    self.accountingDate = nil;
    self.accountingDateAsStr =nil;
    self.vendorName = nil;
    self.grossExpenseAsStr= nil;
    self.invoiceAmountAsStr= nil;
    self.invoiceID= nil;
    self.invoiceLink= nil;
    self.invoiceNumber= nil;
    self.propertyID= nil;
}

@end
