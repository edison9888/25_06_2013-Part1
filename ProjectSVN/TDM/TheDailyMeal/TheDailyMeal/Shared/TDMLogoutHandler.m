//
//  TDMLogoutHandler.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMLogoutHandler.h"

@implementation TDMLogoutHandler
@synthesize logoutHandlerDelegate;
-(void)logoutCurrentUser {
    NSString *logoutAPIURLString = [NSString stringWithFormat:@"/app/user/logout.json"];
    [self postRequest:logoutAPIURLString RequestBody:nil withRequestType:kTDMLogout];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [logoutHandlerDelegate logOutFailed];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@ \nand the response code is%d",[request responseString],request.responseStatusCode);
    [logoutHandlerDelegate loggedOutSuccessfully];
    [delegate requestCompletedSuccessfully:request];
}

@end
