//
//  TDMBestDishListService.h
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMBestDishListServiceDelegate <NSObject>
@required

-(void) bestDishListserviceResponse:(NSMutableArray *)responseArray;
-(void) bestDishFetchFailed;
-(void) networkErrorInFindingBestDish;
@end

@interface TDMBestDishListService : TDMBaseHttpHandler {
    
        BOOL bCheck;
}

@property (nonatomic, retain) id <TDMBestDishListServiceDelegate> bestDishListserviceDelegate;

-(void) getBestDishListServiceForVenueID:(int)venueID;
-(void)clearDelegate;
@end
