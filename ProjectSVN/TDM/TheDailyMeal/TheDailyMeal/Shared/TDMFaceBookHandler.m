//
//  TDMFaceBookHandler.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMFaceBookHandler.h"

@implementation TDMFaceBookHandler
#pragma mark Login APIs
NSString * const kFacebookLoginApi = @"/home/signup_with_fb_access_key";

#pragma mark- RBLoginHandler Methods
- (void)sendFacebookLoginWithCookie:(NSString *)accessToken
{
    
    NSLog(@"FB access token: %@",accessToken);
    
    NSString *apiName = kFacebookLoginApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [ClassFinder urlEncodedParamStringFromString:@"access_token"];
    NSString * value = [ClassFinder urlEncodedParamStringFromString:accessToken];
    
    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:kFacebookLogin];
    
    [postParams release];
    postParams = nil;
    
}
#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * response = [request responseString];
    
    NSDictionary * responseDictionary = [response JSONValue];
    NSLog(@"facebookLoginRequestCompleted :- responseDict: %@", responseDictionary);
    
    BOOL ResultValue = [[responseDictionary objectForKey:@"success"] boolValue];
    if (ResultValue)
    {
        // cookie code begin
        [self saveTheCookie:request];
        // cookie code end
    }
    
    [delegate requestCompletedSuccessfully:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"facebookLoginRequest failed");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}
#pragma mark -
@end
