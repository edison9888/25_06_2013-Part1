//
//  TDMBarDetails.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMBarDetails : NSObject
{
     NSMutableArray * barHeaders;
    NSMutableArray *restaurantHeaders;
}


@property (nonatomic, retain) NSMutableArray * barHeaders;
@property (nonatomic, retain) NSMutableArray *restaurantHeaders;

+(TDMBarDetails *)sharedBarDetails;
-(void)initializeBarHeaders:(NSMutableArray *)incomingBarHeaders;
-(void)initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders;
@end
