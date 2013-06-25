//
//  TDMBusinessIDService.h
//  TheDailyMeal
//
//  Created by Apple on 26/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BussinessModel.h"
#import "TDMBaseHttpHandler.h"

@protocol TDMBusinessIDServiceDelegate <NSObject>

-(void) businessIDFetchedWithVenueID:(int)venueID;
-(void) failedTOFetchBusinessID;
@end

@interface TDMBusinessIDService : TDMBaseHttpHandler
{
    id <TDMBusinessIDServiceDelegate> businessIDdelegate;
    BOOL bCheck;
}
@property (nonatomic, assign) id <TDMBusinessIDServiceDelegate> businessIDdelegate;

-(void) getBusinessVenueIDFofBusiness:(BussinessModel *)businessDetails;
-(void)clearDelegate;
@end
