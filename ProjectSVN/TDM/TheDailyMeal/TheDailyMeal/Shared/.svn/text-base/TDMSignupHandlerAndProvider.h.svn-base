//
//  TDMSignupHandlerAndProvider.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"

@protocol TDMSignupHandlerAndProviderDelegate <NSObject>
@required
-(void)signupFailed;
-(void)signupSuccess;
-(void)usernameTaken;
-(void)emailTaken;
-(void)usernameAndEmailTaken;
@end

@interface TDMSignupHandlerAndProvider : TDMBaseHttpHandler
{
    id <TDMSignupHandlerAndProviderDelegate> signupDelegate;
}

@property (nonatomic, retain) id <TDMSignupHandlerAndProviderDelegate> signupDelegate;


@end
