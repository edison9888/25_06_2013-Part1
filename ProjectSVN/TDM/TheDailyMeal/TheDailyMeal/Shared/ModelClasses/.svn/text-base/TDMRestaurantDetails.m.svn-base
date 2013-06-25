//
//  TDMRestaurantDetails.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMRestaurantDetails.h"

static TDMRestaurantDetails * sharedRestaurants;
static TDMRestaurantDetails * cityRestaurants;
static TDMRestaurantDetails * cityBars;
static TDMRestaurantDetails * sharedBars;
static TDMRestaurantDetails * sharedCriteria;

@implementation TDMRestaurantDetails

@synthesize restaurantHeaders;
@synthesize barHeaders;
@synthesize cityRestaurantsHeaders;
@synthesize cityBarsHeaders;
@synthesize criteriaSearchHeaders;

+(TDMRestaurantDetails *)sharedResturantDetails {
    if (!sharedRestaurants) {
        sharedRestaurants = [[TDMRestaurantDetails alloc] init];
    }
    
    return sharedRestaurants;
}
+(TDMRestaurantDetails *)sharedBarDetails
{
    if(!sharedBars)
    {
        sharedBars = [[TDMRestaurantDetails alloc]init];
    }
    return sharedBars;
}
+(TDMRestaurantDetails *)sharedCityRestaurantDetails
{
    if(!cityRestaurants){
        cityRestaurants = [[TDMRestaurantDetails alloc]init];
    }
    return cityRestaurants;
}
+(TDMRestaurantDetails *)sharedCityBarDetails
{
    if(!cityBars){
        cityBars = [[TDMRestaurantDetails alloc]init];
    }
    return cityBars;
}
+(TDMRestaurantDetails *)sharedCriteriaSearchDetails
{
    if(!sharedCriteria)
        sharedCriteria = [[TDMRestaurantDetails alloc]init];
    return sharedCriteria;
}
-(void)initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders {
    if (!restaurantHeaders) {
        restaurantHeaders = [[NSMutableArray alloc] init ];
    }
    if([restaurantHeaders count]>0)
        [restaurantHeaders removeAllObjects];
    NSLog(@"restaurant header just before adding %@",restaurantHeaders);
    [restaurantHeaders addObjectsFromArray:incomingRestaurantHeaders];
    NSLog(@"restaurant header just after adding %@",restaurantHeaders);
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
-(void)initializeCityRestaurantHeaders:(NSMutableArray *)incomingCityRestaurantHeaders
{
    if(!cityRestaurantsHeaders)
        cityRestaurantsHeaders  =[[NSMutableArray alloc]init];
    if([cityRestaurantsHeaders count]>0)
        [cityRestaurantsHeaders removeAllObjects];
    [cityRestaurantsHeaders addObjectsFromArray:incomingCityRestaurantHeaders];
}
-(void)initializeCityBarHeaders:(NSMutableArray *)incomingCityBarHeaders
{
    if(!cityBarsHeaders)
        cityBarsHeaders =[[NSMutableArray alloc]init];
    if([cityBarsHeaders count]>0)
        [cityBarsHeaders removeAllObjects];
    [cityBarsHeaders addObjectsFromArray:incomingCityBarHeaders];
}
-(void)initializeCriteriaHeaders:(NSMutableArray *)incomingCriteriaSearchHeaders
{
    if(!criteriaSearchHeaders)
        criteriaSearchHeaders  =[[NSMutableArray alloc]init];
    if([criteriaSearchHeaders count]>0)
        [criteriaSearchHeaders removeAllObjects];
    [criteriaSearchHeaders addObjectsFromArray:incomingCriteriaSearchHeaders];
}
@end
