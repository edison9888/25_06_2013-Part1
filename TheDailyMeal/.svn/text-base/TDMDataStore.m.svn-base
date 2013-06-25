//
//  TDMDataStore.m
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMDataStore.h"

static TDMDataStore *sharedInstance;

static BOOL userNeedsLocationUpdate;

//static NSDate *lastLocationUpdateDateTime;

@implementation TDMDataStore

@synthesize lastLocationUpdateDateTime;
@synthesize isLoggedIn;
@synthesize cityName;
@synthesize guideType;
@synthesize isCriteriaSearch;
@synthesize isNotificationON;
@synthesize needToUpdateCityList;
@synthesize cityListArray;



+ (TDMDataStore *)sharedStore
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[TDMDataStore alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark - Location Update Supported?
//Used to set and check whether user need location update

- (BOOL)doesUserNeedChangeOnLocationUpdate
{
    return userNeedsLocationUpdate;
}

- (void)setUserNeedsChangeOnLocationUpdate:(BOOL)updateFlag
{
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE] == nil)
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:updateFlag forKey:K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE];
//    }
    
    [[NSUserDefaults standardUserDefaults] setBool:updateFlag forKey:K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE];
    
    userNeedsLocationUpdate = updateFlag;
}

- (BOOL)checkIsUserNeedsUpdateFlagPresentInUserDefaults
{
    BOOL isPresent = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE] != nil)
    {
        isPresent = YES;
    }
    else
    {
        userNeedsLocationUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE];
    }
    
    return isPresent;
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
    //logic to delete teh current usre from the database  
    isLoggedIn  =NO;
}


@end
