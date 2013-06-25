//
//  TDMCityGuideService.h
//  TheDailyMeal
//
//  Created by Apple on 23/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMCityGuideServiceDelegate <NSObject>
@required
-(void) serviceResponseCityiGuide:(NSMutableArray *)responseArray;
-(void) failedToFecthCityGuideDetails;
-(void) networkErrorInCityGuide;
@end

@interface TDMCityGuideService : TDMBaseHttpHandler
{
    id <TDMCityGuideServiceDelegate> cityGuideDelegate;
}

@property (nonatomic, retain) id <TDMCityGuideServiceDelegate> cityGuideDelegate;

-(void) getCityGuideDetailsForCity:(NSString *)cityName andForGuideType:(NSString *)guideType;

@end

