//
//  TDMHTTPForgotPasswordService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMHTTPForgotPasswordService.h"
#import "Reachability.h"

@implementation TDMHTTPForgotPasswordService
@synthesize forgotPasswordDelegate;

-(void)sendForgotPasswordEmail:(NSString *)emailAddress 
{
    NSString *forgotPasswordAPIURLString = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/app/tdm_user/forgot"];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:emailAddress forKey:@"email"];
    
    NSString *forgotPassWordString = [dictionary JSONRepresentation];
    
    [dictionary release];
    
    if([Reachability connected])
    {
        [self postRequest:forgotPasswordAPIURLString RequestBody:forgotPassWordString];
    }
    else
    {
        if(self.forgotPasswordDelegate && [self.forgotPasswordDelegate respondsToSelector:@selector(networkErroInForgotPassword)])
            [self.forgotPasswordDelegate networkErroInForgotPassword];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[request.responseString substringWithRange:NSMakeRange(2, 5)] isEqualToString:@"Sorry"]) {
        [forgotPasswordDelegate invalidEmail];
    }
    else {
        [forgotPasswordDelegate emailSent];
    }
    
    
    [delegate requestCompletedSuccessfully:request];
} 

@end
