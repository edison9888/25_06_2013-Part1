//
//  ChartDataPoint.m
//  SQLandBIiPad
//
//  Created by Apple on 05/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChartDataPoint.h"

@implementation ChartDataPoint

@synthesize yValue,xDateValue, entityID, stackPercntAcrual, stackPercntActual, cumulativeValue, afeEstimate, exceededActualsPlusAccruals, fieldEstimate, actual;

-(id)init
{
    if( self = [super init])
    {
        yValue = 0;
        stackPercntAcrual = 0;
        cumulativeValue = 0;
        stackPercntActual = 0;
        afeEstimate = 0;
        xDateValue = nil;
        entityID = @"null";
        exceededActualsPlusAccruals = 0;
        actual = 0;
        fieldEstimate = 0;
        
    }
    
    return self;
}

-(void) dealloc
{
    xDateValue = nil;
    entityID = nil;
}


@end
