//
//  TDMMakeReservationService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 20/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TDMMakeReservationServiceDelegate <NSObject>
@required

-(void) makeReservationServiceResponse:(NSMutableArray *)response;
-(void) makeReservationResponse;
@end
@interface TDMMakeReservationService : TDMBaseHttpHandler
{
        BOOL bCheck;
}

@property (nonatomic, assign) id <TDMMakeReservationServiceDelegate> makeReservationDelegate;
- (void)makeReservationCall:(NSString *)businessId;
-(void)clearDelegate;
@end
