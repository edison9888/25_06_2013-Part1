//
//  TDMLoginHandler.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMLoginHandler.h"
#import "ASIHTTPRequest.h"
#import "DatabaseManager.h"
#define kPICTURE_URL @"http://stage.thedailymeal.com:8081/"

@implementation TDMLoginHandler

@synthesize loginHandlerDelegate;

- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password {
    NSString *loginAPIURLString = [NSString stringWithFormat:@"/app/user/login"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:userName forKey:@"username"];
    [dictionary setObject:password forKey:@"password"];
    
    NSString *loginAPIJSONBody = [dictionary JSONRepresentation];
    
    [self postRequest:loginAPIURLString RequestBody:loginAPIJSONBody withRequestType:kTDMLogin];

    [dictionary release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%d",request.responseStatusCode);
    NSLog(@"Request Failed due to server error");
    [loginHandlerDelegate invalidUser];
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    if (request.responseStatusCode == 200) 
    {
        NSDictionary *resultDictionary = [[request responseString] JSONValue];
        
        NSDictionary *userDictionary = [resultDictionary objectForKey:@"user"];
        NSString * sessionID = [resultDictionary objectForKey:@"sessid"];
        NSString * userName = [userDictionary objectForKey:@"name"];
        NSString * emailAddress = [userDictionary objectForKey:@"mail"];
        NSString * userID = [userDictionary objectForKey:@"uid"];
        NSString *picture = [userDictionary objectForKey:@"picture"];
        NSString *pic = [NSString stringWithFormat:@"%@%@",kPICTURE_URL,picture];
        NSLog(@"%@Picture:",pic);
        NSLog(@"Inserting values: %@ %@ %@ %@",userName,emailAddress,userID,sessionID);
        
        [[DatabaseManager sharedManager]insertIntoUserTable:userName 
                                                      email:emailAddress 
                                                     userID:userID 
                                                  sessionID:sessionID 
                                                  userImage:pic];
        
        [[DatabaseManager sharedManager] getUserDetailsFromDataBase];
        
        [loginHandlerDelegate loggedInSuccessfully];
    }
    else 
    {
        [loginHandlerDelegate loginFailed];
    }
    //NSLog(@"From TDMLoginHandler Request Finished %@",[request responseString] );
    [delegate requestCompletedSuccessfully:request];
} 

@end
