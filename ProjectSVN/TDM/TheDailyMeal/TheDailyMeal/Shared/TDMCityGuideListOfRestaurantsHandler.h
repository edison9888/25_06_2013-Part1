//
//  TDMCityGuideListOfRestaurantsHandler.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
@protocol TDMCityGuideListOfRestaurantsHandlerDelegate <NSObject>
@required
-(void) foundCityRestaurants;
-(void) noCityRestaurantsFound;
-(void) errorInNetwork;

@end

@interface TDMCityGuideListOfRestaurantsHandler : TDMBaseHttpHandler {
 
    id <TDMCityGuideListOfRestaurantsHandlerDelegate> restaurantDelegate;
}

@property (nonatomic, retain) id <TDMCityGuideListOfRestaurantsHandlerDelegate> restaurantDelegate;

@end
