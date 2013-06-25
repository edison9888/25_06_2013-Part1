//
//  TDMLogoutService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 16/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDMLogoutHandlerDelegate <NSObject> 
@required
-(void)loggedOutSuccessfully;
-(void)logOutFailed;
- (void)networkError;
@end

@interface TDMLogoutService : TDMBaseHttpHandler
{
    id <TDMLogoutHandlerDelegate> logoutHandlerDelegate;
}

@property (nonatomic, retain) id <TDMLogoutHandlerDelegate> logoutHandlerDelegate;
-(void)logoutCurrentUser ;
@end
