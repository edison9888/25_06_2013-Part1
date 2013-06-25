//
//  TDMCityGuideListOfBarsHandler.h
//  TheDailyMeal
//
//  Created by Apple on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"
@protocol TDMCityGuideListOfBarsHandlerDelegate <NSObject>
@required
-(void) foundCityBars;
-(void) noCityBarsFound;
-(void) errorInFindingBars;

@end

@interface TDMCityGuideListOfBarsHandler : TDMBaseHttpHandler
{
    id <TDMCityGuideListOfBarsHandlerDelegate> barDelegate;
}
@property (retain, nonatomic) id <TDMCityGuideListOfBarsHandlerDelegate> barDelegate;
@end
