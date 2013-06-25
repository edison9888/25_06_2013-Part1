//
//  TDMLoginHandler.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"


@protocol TDMLoginHandlerDelegate <NSObject> 
    @required
-(void)loggedInSuccessfully;
-(void)loginFailed;
- (void)invalidUser;
@end
@interface TDMLoginHandler : TDMBaseHttpHandler {
    id <TDMLoginHandlerDelegate> loginHandlerDelegate;
    
}

@property (nonatomic, retain) id <TDMLoginHandlerDelegate> loginHandlerDelegate;

@end
