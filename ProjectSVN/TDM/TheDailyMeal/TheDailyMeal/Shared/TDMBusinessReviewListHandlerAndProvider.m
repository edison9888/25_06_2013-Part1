//
//  TDMBusinessReviewListHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBusinessReviewListHandlerAndProvider.h"

@implementation TDMBusinessReviewListHandlerAndProvider

-(void)getReviewListForVenueID:(int)venueID {
    NSString * reviewListAPIURLString = [NSString stringWithFormat:@"%@%d%@",@"/app/tdm_node/",venueID,@"/restaurant_review"];
    
    [self getRequest:reviewListAPIURLString withRequestType:kTDMBusinessReviewList];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM Review List Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 


@end
