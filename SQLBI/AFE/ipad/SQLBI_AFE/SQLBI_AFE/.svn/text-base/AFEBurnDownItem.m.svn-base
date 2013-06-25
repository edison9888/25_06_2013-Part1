//
//  AFEBurnDownItem.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEBurnDownItem.h"

@implementation AFEBurnDownItem
@synthesize date;
@synthesize dateAsStr;
@synthesize actual;
@synthesize actualsAsStr;
@synthesize fieldEstimate;
@synthesize fieldEstimateAsStr;
@synthesize cumulativeActual;
@synthesize cumulativeFieldEstimate;
@synthesize cumulativeActualAsStr;
@synthesize CumulativeFieldEstimateAsStr;

@synthesize actualPlusAccrual;
@synthesize actualPlusAccrualAsString;
@synthesize actualPlusAccrualCumulative;
@synthesize actualPlusAccrualCumulativeAsString;
@synthesize budget;
@synthesize budgetAsString;


-(id) init {
    self = [super init];
    if (self) {
        self.date = nil;
        self.dateAsStr = @"";
        self.actual = 0;
        self.actualsAsStr = @"";
        self.fieldEstimate = 0;
        self.fieldEstimateAsStr = @"";
        self.cumulativeActual = 0;
        self.cumulativeFieldEstimate = 0;
        self.cumulativeActualAsStr =@"";
        self.CumulativeFieldEstimateAsStr =@"";
        
        self.actualPlusAccrual = 0;
        self.actualPlusAccrualAsString = @"";
        self.actualPlusAccrualCumulative = 0;
        self.actualPlusAccrualCumulativeAsString = @"";
        self.budget = 0;
        self.budgetAsString = @"";
    }
    return  self;

}

//-(void) setDate:(NSDate *) dateNew
//{
//    if([dateNew isKindOfClass:[NSString class]])
//    {
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"MM/dd/yyyy"];
//        
//        date = [df dateFromString:(NSString*)dateNew]; //[NSString stringWithFormat:@"%d", [dateNew intValue]];
//    }
//    else
//    {
//        date = dateNew;
//    }
//    
//}

-(void) setDateAsStr:(NSString *)dateAsStrNew
{
    dateAsStr = dateAsStrNew;
    
    if(dateAsStr)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM/dd/yyyy"];
                
        self.date = [df dateFromString:dateAsStrNew];
    }
}

-(void)dealloc {
    self.date = nil;
    self.dateAsStr = nil;
    self.actualsAsStr = nil;
    self.fieldEstimateAsStr = nil;
    self.cumulativeActualAsStr = nil;
    self.CumulativeFieldEstimateAsStr = nil;
    self.actualPlusAccrualAsString = nil;
    self.actualPlusAccrualCumulativeAsString =nil;
    self.budgetAsString =nil;
}
@end
