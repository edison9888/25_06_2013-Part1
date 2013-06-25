//
//  TDMForgotPasswordHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMForgotPasswordHandlerAndProvider.h"

@implementation TDMForgotPasswordHandlerAndProvider

@synthesize forgotPasswordDelegate;

-(void)sendForgotPasswordEmail:(NSString *)emailAddress {
    NSString *forgotPasswordAPIURLString = [NSString stringWithFormat:@"/app/tdm_user/forgot"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:emailAddress forKey:@"email"];
    
    NSString *forgotPassWordString = [dictionary JSONRepresentation];
    
    [dictionary release];
    
    [self postRequest:forgotPasswordAPIURLString RequestBody:forgotPassWordString withRequestType:kTDMForgotPassword];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDMForgotPassword Request Finished %d",request.responseStatusCode);
    NSLog(@"From TDMForgotPassword Request Finished %@",[[request responseString] JSONValue]);
    
    
    if([[request.responseString substringWithRange:NSMakeRange(2, 5)] isEqualToString:@"Sorry"]) {
        [forgotPasswordDelegate invalidEmail];
    }
    else {
        [forgotPasswordDelegate emailSent];
    }

    
    [delegate requestCompletedSuccessfully:request];
} 


@end
