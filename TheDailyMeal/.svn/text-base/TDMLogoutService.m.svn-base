//
//  TDMLogoutService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMLogoutService.h"
#import "Reachability.h"


@implementation TDMLogoutService
@synthesize logoutHandlerDelegate;
-(void)logoutCurrentUser 
{
    NSString *logoutAPIURLString = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/user/logout.json"];
    
    if([Reachability connected])
    {
        [self postRequest:logoutAPIURLString RequestBody:nil];
    }
    else
    {
        if(self.logoutHandlerDelegate && [logoutHandlerDelegate respondsToSelector:@selector(networkError)])
        {
            [self.logoutHandlerDelegate networkError];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    [self trackRequestError:request];
    [logoutHandlerDelegate logOutFailed];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        if (self.logoutHandlerDelegate && [self.logoutHandlerDelegate respondsToSelector:@selector(loggedOutSuccessfully)])
        {
            [logoutHandlerDelegate loggedOutSuccessfully];
        }
    }
    else {
        if (self.logoutHandlerDelegate && [self.logoutHandlerDelegate respondsToSelector:@selector(logOutFailed)])
        {
            [logoutHandlerDelegate logOutFailed];
        }
    }
        
}

@end
