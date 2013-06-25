//
//  TDMBarDetails.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBarDetails.h"

static TDMBarDetails * sharedBars;

@implementation TDMBarDetails
@synthesize barHeaders;
@synthesize restaurantHeaders;

+(TDMBarDetails *)sharedBarDetails
{
    if(!sharedBars)
    {
        sharedBars = [[TDMBarDetails alloc]init];
    }
    return sharedBars;
}

-(void)initializeBarHeaders:(NSMutableArray *)incomingBarHeaders
{
    if(!barHeaders)
    {
        barHeaders =[[NSMutableArray alloc]init];
    }
    if([barHeaders count]>0)
        [barHeaders removeAllObjects];
    [barHeaders addObjectsFromArray:incomingBarHeaders];
}
-(void) initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders
{
    if(!restaurantHeaders)
        restaurantHeaders = [[NSMutableArray alloc]init];
    [restaurantHeaders removeAllObjects];
    [restaurantHeaders addObjectsFromArray:incomingRestaurantHeaders];
}

@end
