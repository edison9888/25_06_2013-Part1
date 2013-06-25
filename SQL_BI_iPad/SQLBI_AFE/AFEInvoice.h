//
//  AFEInvoice.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFEInvoice : NSObject

@property (nonatomic,strong) NSDate *accountingDate;

@property (nonatomic,strong) NSString *billingCategoryID;
@property (nonatomic,strong) NSString *billingCategory;

@property (nonatomic,assign) double grossExpense;
@property (nonatomic,strong) NSString *grossExpenseAsStr;

@property (nonatomic,assign) double invoiceAmount;
@property (nonatomic,strong) NSString *invoiceAmountAsStr;
@property (nonatomic,strong) NSDate *invoiceDate;
@property (nonatomic,strong) NSString *invoiceID;
@property (nonatomic,strong) NSString *invoiceLink;
@property (nonatomic,strong) NSString *invoiceNumber;

@property (nonatomic,strong) NSString *propertyID;
@property (nonatomic,strong) NSString *propertyName;
@property (nonatomic,strong) NSString *propertyType;

@property (nonatomic,strong) NSDate *serviceDate;

@property (nonatomic,assign) int vendorID;
@property (nonatomic,strong) NSString *vendorName;

@property (nonatomic,assign) double actual;
@property (nonatomic,strong) NSString *actualsAsStr;
@property (nonatomic,assign) double fieldEstimate;
@property (nonatomic,strong) NSString *fieldEstimateAsStr;

@property (nonatomic,strong) NSString *accountingDateAsStr;

@property (nonatomic,strong) NSString *invoiceDateAsStr;

@end
