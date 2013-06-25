//
//  TDMFilterShared.m
//  TheDailyMeal
//
//  Created by Apple on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMFilterShared.h"
static TDMFilterShared *shared;
@implementation TDMFilterShared
@synthesize guideName;
@synthesize isARestaurant;
@synthesize isCriteriaSearch;
@synthesize criteriaCountry;
@synthesize filterdelegate;
+(TDMFilterShared *)sharedFilterDetails
{
    if(!shared)
        shared = [[TDMFilterShared alloc]init];
    return shared;
}
-(void)initializeFilter:(NSString *)incomingFilterText
{

    [TDMFilterShared sharedFilterDetails].guideName = incomingFilterText;
    self.guideName  = incomingFilterText;
    NSLog(@"self.gideName %@",guideName);
    NSLog(@"in shared class %@",[TDMFilterShared sharedFilterDetails].guideName);
    [filterdelegate gotFilterCriteria];
}
@end
