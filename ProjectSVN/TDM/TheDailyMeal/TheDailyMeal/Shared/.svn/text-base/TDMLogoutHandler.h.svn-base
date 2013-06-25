//
//  TDMLogoutHandler.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
#import "ASIHTTPRequest.h"
@protocol TDMLogoutHandlerDelegate <NSObject> 
@required
-(void)loggedOutSuccessfully;
-(void)logOutFailed;
@end
@interface TDMLogoutHandler : TDMBaseHttpHandler{
    
    id <TDMLogoutHandlerDelegate> logoutHandlerDelegate;
}

@property (nonatomic, retain) id <TDMLogoutHandlerDelegate> logoutHandlerDelegate;

@end
