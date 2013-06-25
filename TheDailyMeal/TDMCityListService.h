//
//  TDMCityListService.h
//  TheDailyMeal
//
//  Created by Apple on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMCityListServiceDelegate <NSObject>
@required
-(void) gotCityList:(NSMutableArray *)responseArray;
-(void) failedToGetCityList;
- (void)networkError;
@end

@interface TDMCityListService : TDMBaseHttpHandler
{
    id <TDMCityListServiceDelegate> cityListDelegate;
}

@property (assign, nonatomic)  id <TDMCityListServiceDelegate> cityListDelegate;
-(void) getListOfCities;
@end
