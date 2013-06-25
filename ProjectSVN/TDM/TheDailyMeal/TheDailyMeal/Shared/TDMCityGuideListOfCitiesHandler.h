//
//  TDMCityGuideListOfCitiesHandler.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
@protocol TDMCityGuideListOfCitiesHandlerDelegate <NSObject> 
@required
-(void)gotListOfCites;
-(void)gotNoCites;
-(void)requestFailed;
@end
//@protocol TDMCityGuideListOfCitiesHandlerDelegate <NSObject>
//@required
//-(void)finishedFetchingListofResturants;
//-(void)failedToFetchListofRestaurants;
//@end

@interface TDMCityGuideListOfCitiesHandler : TDMBaseHttpHandler
{
    id <TDMCityGuideListOfCitiesHandlerDelegate> listOfCitiesHandler;
}
@property (nonatomic, retain)id <TDMCityGuideListOfCitiesHandlerDelegate> listOfCitiesHandler;
@end
