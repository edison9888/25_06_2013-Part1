//
//  TDMBestDishNameService.h
//  TheDailyMeal
//
//  Created by Apple on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"
#import "TDMSignatureDishModel.h"

@protocol TDMBestDishNameServiceDelegate <NSObject>

-(void) bestDishNameServiceResponse:(NSMutableArray *)responseArray;
-(void) networkErrorInBestDishNameService;

@end

@interface TDMBestDishNameService : TDMBaseHttpHandler
{
    id <TDMBestDishNameServiceDelegate> bestDishNameDelegate;
}

@property (retain, nonatomic)     id <TDMBestDishNameServiceDelegate> bestDishNameDelegate;
@property (retain, nonatomic) TDMSignatureDishModel *signaturedishModel;
@property (nonatomic) int index;
@property (retain, nonatomic) NSMutableArray *signatureDishHeaders;

-(void) getBestDishNameForSignatureDish:(TDMSignatureDishModel *)bestDishModel forIndex:(int)index;
@end
