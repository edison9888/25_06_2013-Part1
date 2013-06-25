//
//  TDMRestaurantDetails.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMRestaurantDetails : NSObject {
    NSMutableArray * restaurantHeaders;
    NSMutableArray * barHeaders;
    NSMutableArray * cityRestaurantsHeaders;
    NSMutableArray * cityBarsHeaders;
    NSMutableArray * criteriaSearchHeaders;
}

@property (nonatomic, retain) NSMutableArray * cityRestaurantsHeaders;
@property (nonatomic, retain) NSMutableArray * restaurantHeaders;
@property (nonatomic, retain) NSMutableArray * barHeaders;
@property (nonatomic, retain) NSMutableArray * cityBarsHeaders;
@property (nonatomic, retain) NSMutableArray *criteriaSearchHeaders;
+(TDMRestaurantDetails *)sharedResturantDetails;
+(TDMRestaurantDetails *)sharedBarDetails;
+(TDMRestaurantDetails *)sharedCityRestaurantDetails;
+(TDMRestaurantDetails *)sharedCityBarDetails;
+(TDMRestaurantDetails *)sharedCriteriaSearchDetails;
-(void)initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders;
-(void)initializeBarHeaders:(NSMutableArray *)incomingBarHeaders;
-(void)initializeCityRestaurantHeaders:(NSMutableArray *)incomingCityRestaurantHeaders;
-(void)initializeCityBarHeaders:(NSMutableArray *)incomingCityBarHeaders;
-(void)initializeCriteriaHeaders:(NSMutableArray *)incomingCriteriaSearchHeaders;
@end
