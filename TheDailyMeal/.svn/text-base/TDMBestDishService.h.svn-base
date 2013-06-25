//
//  TDMBestDishService.h
//  TheDailyMeal
//
//  Created by Nibin Varghese on 24/03/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMBestDishServiceDelegate <NSObject>

- (void)requestCompletedSuccessfullyWithData:(NSMutableArray *)bestDishArray;
- (void)requestFailed;
- (void)networkError;
@end

@interface TDMBestDishService : TDMBaseHttpHandler
{
    id<TDMBestDishServiceDelegate> bestDishdelegate;
}

@property (assign, nonatomic) id<TDMBestDishServiceDelegate>bestDishdelegate;

- (void)getBestDishesVenu;

@end
