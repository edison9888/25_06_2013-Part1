//
//  TDMBusinessReviewHandlerAndProvider.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"

@protocol TDMBusinessReviewHandlerAndProviderDelegate <NSObject>
@required
-(void) gotReviewForBusiness;
-(void) failedToGetReviews;
@end

@interface TDMBusinessReviewHandlerAndProvider : TDMBaseHttpHandler
{
    id <TDMBusinessReviewHandlerAndProviderDelegate> reviewDelegate;
}
@property (retain, nonatomic) id <TDMBusinessReviewHandlerAndProviderDelegate> reviewDelegate;
@end
