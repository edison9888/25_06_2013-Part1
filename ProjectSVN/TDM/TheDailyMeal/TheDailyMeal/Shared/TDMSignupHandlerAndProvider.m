//
//  TDMSignupHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMSignupHandlerAndProvider.h"

@implementation TDMSignupHandlerAndProvider

@synthesize signupDelegate;

-(void)signUpUserWithUserName:(NSString *)userName 
               havingPassword:(NSString *)password 
                     andEmail:(NSString *)email 
                  withComment:(NSString *)comment 
         andLegalAcceptOption:(int)legalAccept 
{
   
    NSString * signupAPIURLString = [NSString stringWithFormat:@"/app/user/register"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  
    [dictionary setObject:userName forKey:@"name"];
    [dictionary setObject:password forKey:@"pass"];
    [dictionary setObject:email forKey:@"mail"];
    [dictionary setObject:comment forKey:@"comment"];
    [dictionary setObject:[NSNumber numberWithInt:legalAccept] forKey:@"legal_accept"];
    
    NSString * signupAPIBodyString = [dictionary JSONRepresentation];
    
    [dictionary release];
    
    [self postRequest:signupAPIURLString RequestBody:signupAPIBodyString withRequestType:kTDMSignup];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [signupDelegate signupFailed];
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDMSignup Request Finished %@",[[request responseString] JSONValue]);
    
    if (request.responseStatusCode == 200) {
        [signupDelegate signupSuccess];
        
    }

    else if(request.responseStatusCode == 406) {
        NSDictionary *dictionary = [[[request responseString] JSONValue] objectForKey:@"form_errors"];
        if ([dictionary objectForKey:@"mail"] != nil) {
            if ([dictionary objectForKey:@"name"] != nil) {
                NSLog(@"Username and email already taken");
                [signupDelegate usernameAndEmailTaken];
            }
            else {
                NSLog(@"Email already taken");
                [signupDelegate emailTaken];
            }
        }
        else if([dictionary objectForKey:@"name"] !=nil)
        {
            NSLog(@"Username already taken");
            [signupDelegate usernameTaken];
        }
    }

    [delegate requestCompletedSuccessfully:request];
} 

@end
