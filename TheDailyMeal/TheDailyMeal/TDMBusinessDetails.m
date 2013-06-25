//
//  TDMBusinessDetails.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBusinessDetails.h"

static TDMBusinessDetails * sharedBusiness;

@implementation TDMBusinessDetails
@synthesize barHeaders;
@synthesize restaurantHeaders;
@synthesize signatureDishHeaders;
@synthesize reviewListHeaders;
@synthesize favoritesHeaders;
@synthesize cityGuideBusinessHeaders;
@synthesize bestDishHeaders;


+(TDMBusinessDetails *)sharedBusinessDetails
{
    if(!sharedBusiness)
    {
        sharedBusiness = [[TDMBusinessDetails alloc]init];
    }
    return sharedBusiness;
}

-(void)initializeBarHeaders:(NSMutableArray *)incomingBarHeaders
{
    if(!barHeaders)
    {
        barHeaders =[[NSMutableArray alloc]init];
    }
    [barHeaders removeAllObjects];
    [barHeaders addObjectsFromArray:incomingBarHeaders];
}

-(void)initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders
{
    if(!restaurantHeaders)
    {
        restaurantHeaders = [[NSMutableArray alloc]init];
    }
    [restaurantHeaders removeAllObjects];
    [restaurantHeaders addObjectsFromArray:incomingRestaurantHeaders];
}

-(void)initializeReviewListHeaders:(NSMutableArray *)incomingReviewListHeaders
{
    if(!reviewListHeaders)
    {
        reviewListHeaders = [[NSMutableArray alloc]init];
    }
    [reviewListHeaders removeAllObjects];
    [reviewListHeaders addObjectsFromArray:incomingReviewListHeaders];
}
-(void)initializeSignatureDishHeaders:(NSMutableArray *)incomingSignatureDishHeaders
{
    if(!signatureDishHeaders)
    {
        signatureDishHeaders = [[NSMutableArray alloc]init];
    }
    [signatureDishHeaders removeAllObjects];
    [signatureDishHeaders addObjectsFromArray:incomingSignatureDishHeaders];
    
}
- (void)initializeFavoritesHeaders:(NSMutableArray *)incomingFavoritesHeaders
{
    if(!favoritesHeaders)
    {
        favoritesHeaders = [[NSMutableArray alloc]init];
    }
    [favoritesHeaders removeAllObjects];
    [favoritesHeaders addObjectsFromArray:incomingFavoritesHeaders];

}
-(void)initializeCityGuideHeaders:(NSMutableArray *)incomingFavoritesHeaders
{
    if(!cityGuideBusinessHeaders)
    {
        cityGuideBusinessHeaders = [[NSMutableArray alloc]init];
    }
    [cityGuideBusinessHeaders removeAllObjects];
    [cityGuideBusinessHeaders addObjectsFromArray:incomingFavoritesHeaders];
    
}

-(void) initializebestDishHeaders:(NSMutableArray *)incomingbestDishHeaders
{
    if(!bestDishHeaders)
    {
        bestDishHeaders = [[NSMutableArray alloc]init];
    }
    [bestDishHeaders removeAllObjects];
    [bestDishHeaders addObjectsFromArray:incomingbestDishHeaders];
}

@end

