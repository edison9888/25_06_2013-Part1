//
//  AFEBurnDownItem.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFEBurnDownItem : NSObject


@property (nonatomic,assign) double fieldEstimate; //Accruals
@property (nonatomic,strong) NSString *fieldEstimateAsStr;

@property (nonatomic,assign) double actual; 
@property (nonatomic,strong) NSString *actualsAsStr;

@property (nonatomic,assign) double cumulativeActual;//Actual Cumulative
@property (nonatomic,strong) NSString *cumulativeActualAsStr;

@property (nonatomic,assign) double actualPlusAccrual;//Total
@property (nonatomic,strong) NSString *actualPlusAccrualAsString;

@property (nonatomic,assign) double actualPlusAccrualCumulative;
@property (nonatomic,strong) NSString *actualPlusAccrualCumulativeAsString;

@property (nonatomic,assign) double budget;
@property (nonatomic,strong) NSString *budgetAsString;

@property (nonatomic,strong) NSDate *date;

//below items are not mapped in pList
@property (nonatomic,strong) NSString *dateAsStr;

@property (nonatomic,assign) double cumulativeFieldEstimate;
@property (nonatomic,strong) NSString *CumulativeFieldEstimateAsStr;

@property (nonatomic,assign) double exceedeActualsPlusAccrual;

@end
