//
//  TDMBusinessDetails.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 03/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBusinessDetails.h"

static TDMBusinessDetails * sharedCurrentBusinessDetails;

@implementation TDMBusinessDetails
@synthesize sharedBusinessDetails;

+(TDMBusinessDetails *)sharedCurrentBusinessDetails
{
    if (!sharedCurrentBusinessDetails) 
    {
       sharedCurrentBusinessDetails =  [[TDMBusinessDetails alloc] init];
    }
    return sharedCurrentBusinessDetails;
}


-(void)initializeBusinessHeaders:(NSMutableArray *)incomingBusinessHeaders
{
    if (!sharedBusinessDetails) 
    {
        sharedBusinessDetails = [[NSMutableArray alloc]init];
    }
    if([sharedBusinessDetails count]>0)
        [sharedBusinessDetails removeAllObjects];
    NSLog(@"business header just before adding %@",sharedBusinessDetails);
    [sharedBusinessDetails addObjectsFromArray:incomingBusinessHeaders];
    NSLog(@"business header just after adding %@",sharedBusinessDetails);

}
@end
