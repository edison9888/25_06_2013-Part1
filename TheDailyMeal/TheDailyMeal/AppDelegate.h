//
//  AppDelegate.h
//  TheDailyMeal
//
//  Created by Apple on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TDMSplashScreenView.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    UITabBarController *tabBarController;
    id <FBLoginDelegate> logindelegate;
    TDMSplashScreenView *modalViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (assign, nonatomic) BOOL isAppMinimized;
@property (assign) id <FBLoginDelegate> logindelegate;


- (void)showSplash;
- (void)selectTabItem:(int)selectedTabIndex;
@end
