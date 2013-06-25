//
//  TDMForgotPasswordHandlerAndProvider.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
#import "ASIHTTPRequest.h"

@protocol TDMForgotPasswordHandlerAndProviderDelegate <NSObject>
@required
-(void)emailSent;
-(void)invalidEmail;
@end

@interface TDMForgotPasswordHandlerAndProvider : TDMBaseHttpHandler
{
    id <TDMForgotPasswordHandlerAndProviderDelegate> forgotPasswordDelegate;
}

@property (nonatomic, retain) id <TDMForgotPasswordHandlerAndProviderDelegate> forgotPasswordDelegate;
@end
