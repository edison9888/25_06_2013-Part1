//
//  AFE.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFE.h"

@implementation AFE
@synthesize afeID;
@synthesize name;
@synthesize afeNumber;
@synthesize status;
@synthesize fromDate;
@synthesize endDate;
@synthesize afeDate;
@synthesize budget;
@synthesize fieldEstimate;
@synthesize fieldEstimatePercent;
@synthesize fieldEstimateAsStr;
@synthesize actual;
@synthesize actualPercent;
@synthesize actualsAsStr;
@synthesize afeDetails;
@synthesize afeClassName;
@synthesize percntgConsmptn;
@synthesize actualPlusAccrual;
@synthesize actualPlusAccrualAsStr;
@synthesize budgetAsStr;
@synthesize afeClassID;
@synthesize afeDescription;




-(id)init{
    
    self = [super init];
    if(self){
        self.afeID =@"";
        self.name =@"";
        self.afeNumber =@"";
        self.status =@"";
        self.fromDate = nil;
        self.endDate = nil;
        self.afeDate = nil;
        self.budget = 0;
        self.fieldEstimate = 0 ;
        self.fieldEstimatePercent = 0;
        self.fieldEstimateAsStr =@"";
        self.actual = 0;
        self.actualPercent = 0;
        self.actualsAsStr = @"";
        self.afeDetails = nil;
        self.percntgConsmptn = 0;
        self.actualPlusAccrual = 0;
        self.actualPlusAccrualAsStr= @"";
        self.budgetAsStr = @"";
        self.afeClassID = @"";
        self.afeDescription = @"";
    }
    return self;
    
    
}

-(BOOL) isEqualTo:(AFE*) objectToCompare
{
    BOOL result = NO;
    
    if(objectToCompare && [self.afeID caseInsensitiveCompare:objectToCompare.afeID] == NSOrderedSame)
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

-(void) setActualsAsStr:(NSString *)actualsAsStrNew
{
    actualsAsStr = actualsAsStrNew;
    
//    if(actualsAsStrNew && ![actualsAsStrNew isEqualToString:@""])
//    {
//       // NSLog(@"ActualAsString: %@", actualsAsStr);
//    }
}

-(void)dealloc {
    
    self.afeID = nil;
    self.name = nil;
    self.afeNumber =nil;
    self.status =nil;
    self.fromDate = nil;
    self.endDate = nil;
    self.afeDate = nil;
    self.fieldEstimateAsStr = nil;
    self.actualsAsStr = nil;
    self.afeDetails = nil;
    self.actualPlusAccrualAsStr = nil;
    self.budgetAsStr =nil;
    self.afeClassID = nil;
    self.afeDescription = nil;
}


@end
