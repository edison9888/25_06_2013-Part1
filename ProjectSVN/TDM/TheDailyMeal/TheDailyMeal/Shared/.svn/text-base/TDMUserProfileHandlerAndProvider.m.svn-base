//
//  TDMUserProfileHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMUserProfileHandlerAndProvider.h"

@implementation TDMUserProfileHandlerAndProvider

-(void)getUserProfileForUserID:(NSString *)userID {
    NSString * userProfileAPIURLString = [NSString stringWithFormat:@"%@%@%@",@"/app/tdm_user/",userID,@"/person_profile_page"];
    
    [self getRequest:userProfileAPIURLString withRequestType:kTDMUserProfile];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM User Profile Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 


@end
