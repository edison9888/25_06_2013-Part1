//
//  TDMHTTPLoginService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

@protocol TDMLoginHandlerDelegate <NSObject> 
@required
- (void)loggedInSuccessfully;
- (void)loginFailed;
- (void)invalidUser;
- (void)networkError;
@end

@interface TDMHTTPLoginService : TDMBaseHttpHandler
{
     id <TDMLoginHandlerDelegate> loginHandlerDelegate;

}
@property (nonatomic,assign)     BOOL isFBLogin;
@property (nonatomic, retain) id <TDMLoginHandlerDelegate> loginHandlerDelegate;

- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password;
- (void)loginUserWithFBUid:(NSString *)uid andRedirectUrl:(NSString *)redirect_url;

@end
