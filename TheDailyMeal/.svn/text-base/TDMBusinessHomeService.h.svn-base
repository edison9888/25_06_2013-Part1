//
//  TDMBusinessHomeService.h
//  TheDailyMeal
//
//  Created by Apple on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"


@protocol TDMBusinessHomeServiceDelegate <NSObject>
@required
-(void) businessHomeServiceResponse:(NSMutableArray *)responseArray;
@end
@interface TDMBusinessHomeService : TDMBaseHttpHandler {
    
    id <TDMBusinessHomeServiceDelegate> businessServiceDelegate;
}
@property (retain, nonatomic) id<TDMBusinessHomeServiceDelegate> businessServiceDelegate;
-(void) getbusinessHomeServiceForVenueID:(int)venueID;

@end
