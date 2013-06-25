//
//  TDMBusinessDetails.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 15/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMBusinessDetails : NSObject
{
     NSMutableArray * barHeaders;
     NSMutableArray *restaurantHeaders;
     NSMutableArray *reviewListHeaders;
     NSMutableArray *signatureDishHeaders;
     NSMutableArray *favoritesHeaders;
     NSMutableArray *cityGuideBusinessHeaders;
    NSMutableArray *bestDishHeaders;
    
}

@property (nonatomic, retain) NSMutableArray *restaurantHeaders;
@property (nonatomic, retain) NSMutableArray * barHeaders;
@property (nonatomic, retain) NSMutableArray *reviewListHeaders;
@property (nonatomic, retain) NSMutableArray *signatureDishHeaders;
@property (nonatomic, retain) NSMutableArray *favoritesHeaders;
@property (nonatomic, retain) NSMutableArray *cityGuideBusinessHeaders;
@property (nonatomic, retain) NSMutableArray *bestDishHeaders;

+(TDMBusinessDetails *)sharedBusinessDetails;
-(void)initializeBarHeaders:(NSMutableArray *)incomingBarHeaders;
-(void)initializeRestaurantHeaders:(NSMutableArray *)incomingRestaurantHeaders;
-(void)initializeReviewListHeaders:(NSMutableArray *)incomingReviewListHeaders;
-(void)initializeSignatureDishHeaders:(NSMutableArray *)incomingSignatureDishHeaders;
- (void)initializeFavoritesHeaders:(NSMutableArray *)incomingFavoritesHeaders;
- (void)initializeCityGuideHeaders:(NSMutableArray *)incomingCityGuideHeaders;
- (void)initializebestDishHeaders:(NSMutableArray *)incomingbestDishHeaders;


@end
