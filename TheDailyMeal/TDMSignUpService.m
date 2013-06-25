//
//  TDMSignUpService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSignUpService.h"
#import "DatabaseManager.h"
#import "TDMDataStore.h"
#import "Reachability.h"

@implementation TDMSignUpService
@synthesize signupDelegate;
@synthesize username;
@synthesize e_mail;

-(void)signUpUserWithUserName:(NSString *)userName 
               havingPassword:(NSString *)password 
                     andEmail:(NSString *)email 
                  withComment:(NSString *)comment 
         andLegalAcceptOption:(int)legalAccept 
{

    
    self.username = userName;
    self.e_mail  = email;
    NSString * signupAPIURLString = [NSString stringWithFormat:@"%@/rest/app/user/register",DAILYMEAL_SEVER_PROD];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:userName forKey:@"name"];
    [dictionary setObject:password forKey:@"pass"];
    [dictionary setObject:email forKey:@"mail"];
    [dictionary setObject:@"register via REST server" forKey:@"comment"];
    [dictionary setObject:[NSNumber numberWithInt:1] forKey:@"legal_accept"];
    
    NSString * signupAPIBodyString = [dictionary JSONRepresentation];
    
    [dictionary release];
    
    if([Reachability connected])
    {
        [self postRequest:signupAPIURLString RequestBody:signupAPIBodyString];
    }
    else
    {
        if(self.signupDelegate && [self.signupDelegate respondsToSelector:@selector(networkError)])
        {
            [self.signupDelegate networkError];
          //  kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    [signupDelegate signupFailed];
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{

    if (request.responseStatusCode == 200) 
    {
        [self saveTheCookie:request];
        NSDictionary *resultDictionary = [[request responseString] JSONValue];
        NSString *userId = [resultDictionary objectForKey:@"uid"];
        [[DatabaseManager sharedManager]insertIntoUserTable:username 
                                                      email:e_mail 
                                                     userID:userId 
                                                  sessionID:@"" 
                                                  userImage:@""];
        [TDMDataStore sharedStore].isLoggedIn = YES;
        
        [signupDelegate signupSuccess];


    }
    
    else if(request.responseStatusCode == 406) 
    {
        NSDictionary *dictionary = [[[request responseString] JSONValue] objectForKey:@"form_errors"];
        if ([dictionary objectForKey:@"mail"] != nil) 
        {
            if ([dictionary objectForKey:@"name"] != nil) 
            {
                [signupDelegate usernameAndEmailTaken];
            }
            else 
            {
                [signupDelegate emailTaken];
            }
        }
        else if([dictionary objectForKey:@"name"] !=nil)
        {
            [signupDelegate usernameTaken];
        }
        else
        {
            [signupDelegate signupFailed];
        }
    }
    
    [delegate requestCompletedSuccessfully:request];
    
} 

@end
