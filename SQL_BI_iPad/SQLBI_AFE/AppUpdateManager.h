//
//  AppUpdateManager.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFEUpdatesAPIHandler.h"
#import "AppVersion.h"

@protocol AppUpdateManagerDelegate <NSObject>
@required
-(void) didFindNewVersionOfTheApplication:(AppVersion*) newVersion;

@optional
-(void) didFailToReceiveLatestVersionFromService;
-(void) willInstallTheNewApplication;
-(void) didFailInstallationOfTheNewVersion;
-(void) didNotFindANewVersionOfTheApplication;

@end

@interface AppUpdateManager : NSObject<AFEUpdatesAPIHandlerDelegate>

@property(nonatomic, assign) __unsafe_unretained NSObject<AppUpdateManagerDelegate> *delegate;

+(AppUpdateManager*) sharedManager;

-(void) checkForNewVersion;
-(void) installTheLatestVersion;

@end
