//
//  TDMHTTPLoginService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMHTTPLoginService.h"
#import "Reachability.h"

@implementation TDMHTTPLoginService
@synthesize loginHandlerDelegate;
@synthesize isFBLogin;



- (void)loginUserWithFBUid:(NSString *)uid andRedirectUrl:(NSString *)redirect_url {
    NSString *loginAPIURLString = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_user/fb_login"];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
 
    [dictionary setObject:uid forKey:@"fb_access_token"];

    NSString *loginAPIJSONBody = [dictionary JSONRepresentation];
    
    if([Reachability connected])
    {
        isFBLogin = YES;
        [self postRequest:loginAPIURLString RequestBody:loginAPIJSONBody];
    }
    else
    {
        if(self.loginHandlerDelegate && [self.loginHandlerDelegate respondsToSelector:@selector(networkError)])
        {
            [self.loginHandlerDelegate networkError];
        }
       
    }
    [dictionary release];
}

- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password {
    NSString *loginAPIURLString = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/user/login"];
        
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:userName forKey:@"username"];
    [dictionary setObject:password forKey:@"password"];
    
    NSString *loginAPIJSONBody = [dictionary JSONRepresentation];
    
    if([Reachability connected])
    {
        [self postRequest:loginAPIURLString RequestBody:loginAPIJSONBody];
    }
    else
    {
        NSLog(@"%@",self.loginHandlerDelegate );
        if(self.loginHandlerDelegate && [self.loginHandlerDelegate respondsToSelector:@selector(networkError)])
        {
            [self.loginHandlerDelegate networkError];
        }
       // kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
    }
    [dictionary release];
}


- (void)FBLoginParseResponse:(NSDictionary *)resultDictionary {

    NSString * userID = [resultDictionary objectForKey:@"uid"];
//    NSString *uri = [resultDictionary objectForKey:@"uri"];
        
    [[DatabaseManager sharedManager]insertIntoUserTable:@"" 
                                                  email:@"" 
                                                 userID:userID 
                                              sessionID:@"" 
                                              userImage:nil];
    
    
    
    [loginHandlerDelegate loggedInSuccessfully];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    if (request.responseStatusCode == 200)  
    {
        NSLog(@"FB LOGIN RSPONSE:- %@",[request responseString]);
        NSDictionary *resultDictionary = [[request responseString] JSONValue];
        [self saveTheCookie:request];
//        if(isFBLogin){
//            [self FBLoginParseResponse:resultDictionary];
//            
//        }
//        else{
        NSDictionary *userDictionary = [resultDictionary objectForKey:@"user"] ? [resultDictionary objectForKey:@"user"] : @"";
        NSString * sessionID         = [resultDictionary objectForKey:@"sessid"] ? [resultDictionary objectForKey:@"sessid"] : @"";
        NSString * userName         = [userDictionary objectForKey:@"name"] ? [userDictionary objectForKey:@"name"] : @"";
        NSString * emailAddress     = [userDictionary objectForKey:@"mail"] ? [userDictionary objectForKey:@"mail"] : @"";
        NSString * userID           = [userDictionary objectForKey:@"uid"] ? [userDictionary objectForKey:@"uid"] : @"";
        NSString *picture           = [userDictionary objectForKey:@"picture"] ?[userDictionary objectForKey:@"picture"] : @"";
        NSString *pic = @"";
        if (![picture isEqualToString:@""]) {
            pic = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,picture];
        }
                   
        [[DatabaseManager sharedManager]insertIntoUserTable:userName 
                                                      email:emailAddress 
                                                     userID:userID 
                                                  sessionID:sessionID 
                                                  userImage:pic];

        [loginHandlerDelegate loggedInSuccessfully];
//        }
    }
    else 
    {
        NSString *serverError = [NSString stringWithFormat:@"Server Error %d",request.responseStatusCode];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:serverError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        [loginHandlerDelegate loginFailed];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestCompletedSuccessfully)]) {
         [delegate requestCompletedSuccessfully:request];
    }
   
} 

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];    
    [loginHandlerDelegate loginFailed];
}


@end
