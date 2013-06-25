//
//  KPIModel.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPIModel : NSObject

@property (nonatomic,assign) int afeCount;
@property (nonatomic,assign) double totalBudget;
@property (nonatomic,strong) NSString *totalBudgetAsStr;
@property (nonatomic,assign) double totalFieldEst;
@property (nonatomic,assign) double totalFieldEstPercent;
@property (nonatomic,strong) NSString *totalFieldEstAsStr;
@property (nonatomic,assign) double totalActuals;
@property (nonatomic,strong) NSString *totalActualsAsStr;
@property (nonatomic,assign) double totalActualsPercent;
@property (nonatomic,assign) double avgAFEDuration;
@property (nonatomic,assign) double avgAFEBudget;
@property (nonatomic,strong) NSString *avgAFEBudgetASsStr;
@property (nonatomic,assign) double actualsPlusAccruals;
@property (nonatomic,strong) NSString *actualsPlusAccrualsASsStr;
@property (nonatomic,assign) double avgConsumption;


@end
