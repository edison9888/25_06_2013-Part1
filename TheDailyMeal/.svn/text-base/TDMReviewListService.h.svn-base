//
//  TDMReviewListService.h
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMReviewListServiceDelegate <NSObject>
@required

-(void) reviewListserviceResponse:(NSMutableArray *)responseArray;
-(void) reviewListFetchFailed;
-(void) networkErrorInFindingReview;
@end


@interface TDMReviewListService : TDMBaseHttpHandler {
    
    BOOL bCheck;
}

@property (nonatomic, assign) id <TDMReviewListServiceDelegate> reviewListserviceDelegate;

- (id)initWithDelegate:(id)_delegate;
-(void) getReviewListServiceForVenueID:(int)venueID;
-(void)clearDelegate;
@end

