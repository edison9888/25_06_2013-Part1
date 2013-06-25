//
//  AFE.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFE : NSObject

@property (nonatomic,strong) NSDate *fromDate;
@property (nonatomic,strong) NSString *afeClassID;
@property (nonatomic,strong) NSString *afeClassName;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSDate *afeDate;
@property (nonatomic,strong) NSString *afeID;
@property (nonatomic,strong) NSString *afeNumber;

@property (nonatomic,assign) double fieldEstimate;//Accruals
@property (nonatomic,strong) NSString *fieldEstimateAsStr;
@property (nonatomic,assign) double fieldEstimatePercent;//not in response

@property (nonatomic,assign) double actual;
@property (nonatomic,strong) NSString *actualsAsStr;
@property (nonatomic,assign) double actualPercent;//not in response

@property (nonatomic,assign) double actualPlusAccrual; //Total
@property (nonatomic,strong) NSString *actualPlusAccrualAsStr; 

@property (nonatomic,assign) double budget;//AFE Estimate
@property (nonatomic,strong) NSString *budgetAsStr; 

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) double percntgConsmptn;

@property (nonatomic,strong) NSString *status;

@property (nonatomic,strong) NSURL *afeDetails;//not in response

@property (nonatomic,strong) NSString *afeDescription;

-(BOOL) isEqualTo:(AFE*) objectToCompare;


@end
