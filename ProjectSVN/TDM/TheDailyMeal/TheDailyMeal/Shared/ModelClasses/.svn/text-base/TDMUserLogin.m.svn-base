//
//  TDMUserLogin.m
//  TheDailyMeal
//
//  Created by Apple on 24/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMUserLogin.h"
TDMUserLogin *sharedObject;
@implementation TDMUserLogin
@synthesize isLoggedIn;

+(TDMUserLogin *)sharedLoginDetails
{
    if(!sharedObject)
        sharedObject = [[TDMUserLogin alloc]init];
    return sharedObject;
}
-(BOOL)isUserLoggedIn
{
    return isLoggedIn;
}
-(void)loginNewUser
{
    isLoggedIn = YES;
}
-(void)logoutCurrentUser
{
    isLoggedIn  =NO;
}
@end
