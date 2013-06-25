//
//  TDMBusinessReviewHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBusinessReviewHandlerAndProvider.h"

@implementation TDMBusinessReviewHandlerAndProvider
@synthesize reviewDelegate;
-(void)getBusinessReviewsForVenueID:(int)venueNID {
    NSString * businessReviewsAPIString = [NSString stringWithFormat:@"%@%d",@"/app/node/",venueNID];
    
    [self getRequest:businessReviewsAPIString withRequestType:kTDMBusinessReview];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [reviewDelegate failedToGetReviews];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDMBusinessReview Request Finished %@",request.responseString);
    [delegate requestCompletedSuccessfully:request];
    [reviewDelegate gotReviewForBusiness];
} 


@end
