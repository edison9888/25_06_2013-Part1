//
//  TDMDataStore.h
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMDataStore : NSObject {
        BOOL isLoggedIn;
}
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic) BOOL needToUpdateCityList;
@property (nonatomic) BOOL isCriteriaSearch;
@property (nonatomic) BOOL isNotificationON;
@property (retain, nonatomic) NSDate *lastLocationUpdateDateTime;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *guideType;
@property (nonatomic, retain) NSMutableArray *cityListArray;

+ (TDMDataStore *)sharedStore;

-(BOOL) isUserLoggedIn;
-(void) loginNewUser;
-(void) logoutCurrentUser;
- (BOOL)doesUserNeedChangeOnLocationUpdate;
- (void)setUserNeedsChangeOnLocationUpdate:(BOOL)updateFlag;
- (BOOL)checkIsUserNeedsUpdateFlagPresentInUserDefaults;

//#pragma mark    Last Lcoation Update Date Time
//- (NSDate *)getLastLocationUpdateDateTime;
//- (void)setLastLocationUpdateDateTime:(NSDate *)locationUpdateDateTime;

@end
