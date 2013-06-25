//
//  TDMSignUpService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDMSignupHandlerAndProviderDelegate <NSObject>
@required
-(void)signupFailed;
-(void)signupSuccess;
-(void)usernameTaken;
-(void)emailTaken;
-(void)usernameAndEmailTaken;
- (void)networkError;
@end

@interface TDMSignUpService : TDMBaseHttpHandler
{
    id <TDMSignupHandlerAndProviderDelegate> signupDelegate;
}

@property (nonatomic, retain) id <TDMSignupHandlerAndProviderDelegate> signupDelegate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *e_mail;
-(void)signUpUserWithUserName:(NSString *)userName 
               havingPassword:(NSString *)password 
                     andEmail:(NSString *)email 
                  withComment:(NSString *)comment 
         andLegalAcceptOption:(int)legalAccept;
@end
