//
//  TDMBusinessDetails.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 03/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMBusinessDetails : NSObject
{
    NSMutableArray *sharedBusinessDetails;
}

@property (nonatomic, retain)NSMutableArray *sharedBusinessDetails;

+(TDMBusinessDetails *)sharedCurrentBusinessDetails;

-(void)initializeBusinessHeaders:(NSMutableArray *)incomingBusinessHeaders;
@end
