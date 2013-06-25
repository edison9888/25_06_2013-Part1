//
//  AFEClass.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEClass.h"

@implementation AFEClass

@synthesize afeClassID;
@synthesize afeClassName;
@synthesize budget;
@synthesize budgetAsStr;
@synthesize totalBudgetAsStr;
@synthesize afeCount;
@synthesize totActuals;
@synthesize totalActualsAsStr;
@synthesize fieldEstimate;
@synthesize fieldEstimateAsStr;
@synthesize actualsPlusAccruals;
@synthesize actualsPlusAccrualsASsStr;

- (id)init
{
    self = [super init];
    if (self) {
        self.afeClassID = @"";
        self.afeClassName = @"";
        self.budget = 0;
        self.budgetAsStr =@"";
        self.totalBudgetAsStr = @"";
        self.afeCount = 0;
        self.totActuals = 0;
        self.totalActualsAsStr =@"";
        self.fieldEstimate = 0;
        self.actualsPlusAccruals = 0;
        self.actualsPlusAccrualsASsStr = @"";
        
    }
    return self;
}

-(BOOL) isEqualTo:(AFEClass*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.afeClassID caseInsensitiveCompare:objectToCompare.afeClassID] == NSOrderedSame)
    {
        result = YES;
    }
    
    return result;
}

-(void) setAfeClassID:(NSString *)afeClassIDNew
{
    if([afeClassIDNew isKindOfClass:[NSNumber class]])
    {
        afeClassID = [NSString stringWithFormat:@"%d", [afeClassIDNew intValue]];
    }
    else
    {
        afeClassID = afeClassIDNew;
    }
    
}


- (void)dealloc{
    self.afeClassName = nil;
    self.budgetAsStr = nil;
    self.totalBudgetAsStr = nil;
    self.totalActualsAsStr = nil;
}




@end
