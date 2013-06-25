//
//  TDMBusinessService.h
//  TheDailyMeal
//
//  Created by Apple on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMBusinessServiceDelegate <NSObject>
@required
-(void) serviceResponse:(NSMutableArray *)responseArray;
-(void) bussinessServiceFailed;
-(void) requestTimeout;
-(void) networkError;
@end

@interface TDMBusinessService : TDMBaseHttpHandler
{
    NSString *searchCriteria;
}
@property (nonatomic, retain) id <TDMBusinessServiceDelegate> serviceDelegate;

-(void) getBars;
-(void) getRestauarnts;
-(void) getCityGuide;

-(void)clearDelegate;
-(void) callService:(NSString *)searchCriteria;
-(NSString *) getCurrentDateFormat;

@end
