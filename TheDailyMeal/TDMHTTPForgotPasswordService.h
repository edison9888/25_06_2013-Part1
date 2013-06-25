//
//  TDMHTTPForgotPasswordService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMForgotPasswordHandlerAndProviderDelegate <NSObject>
@required
-(void)emailSent;
-(void)invalidEmail;
-(void)networkErroInForgotPassword;
@end

@interface TDMHTTPForgotPasswordService : TDMBaseHttpHandler
{
    id <TDMForgotPasswordHandlerAndProviderDelegate> forgotPasswordDelegate;
    
}

@property (nonatomic, retain) id <TDMForgotPasswordHandlerAndProviderDelegate> forgotPasswordDelegate; 

-(void)sendForgotPasswordEmail:(NSString *)emailAddress;
@end
