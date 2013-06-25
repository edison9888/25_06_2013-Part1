//
//  TDMBusinessHomeHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBusinessHomeHandlerAndProvider.h"

@implementation TDMBusinessHomeHandlerAndProvider

- (void)getBusinessReviewsForVenue
{
   //http://stage.thedailymeal.com:8080/rest/app/node/21321
    
    NSString * businessHomeDetailsAPIString = [NSString stringWithFormat:@"%@%d",@"/app/node/",21321];
    
    [self getRequest:businessHomeDetailsAPIString withRequestType:kTDMBusinessHome];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDMBusinessHome Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 

@end
