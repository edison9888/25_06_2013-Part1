 //
//  AppDelegate.m
//  TheDailyMeal
//
//  Created by Apple on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TDMCustomTabBar.h"
#import "DatabaseManager.h"
#import "TDMCityGuideViewController.h"
#import "TDMChannelsViewController.h"
#import "TDMDataStore.h"
#import "TDMSplashScreenView.h"
#import "TDMBarsViewController.h"
#import "TDMRestaurantsViewController.h"
#import "TDMMyFavoritesViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tabBarController;
@synthesize isAppMinimized,logindelegate;

NSString * const kUrlScheme  = @"thedailymeal"; // See Info.plist


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window makeKeyAndVisible];
    
    [self showSplash];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:K_CURRENT_LATITUDE] == nil || 
        [[NSUserDefaults standardUserDefaults] objectForKey:K_CURRENT_LONGITUDE] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setDouble:KDEFAULTLATITUDE forKey:K_CURRENT_LATITUDE];
        [[NSUserDefaults standardUserDefaults] setDouble:KDEFAULTLONGITUDE forKey:K_CURRENT_LONGITUDE];
        [[NSUserDefaults standardUserDefaults] setDouble:KDEFAULTLATITUDE forKey:@"StartLatitude"];
        [[NSUserDefaults standardUserDefaults] setDouble:KDEFAULTLONGITUDE forKey:@"StartLongitude"];

    }
    [TDMDataStore sharedStore].needToUpdateCityList = YES;
    
    return YES;
}
- (void)showSplash
{
    modalViewController = [[TDMSplashScreenView alloc] initWithNibName:@"TDMSplashScreenView" bundle:nil];
   
    [self.window addSubview:modalViewController.view];

    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2.0];
    [modalViewController release];
    modalViewController = nil;
}

- (void)hideSplash
{
    
    [modalViewController.view removeFromSuperview];

    TDMCustomTabBar *customTabBar=[[TDMCustomTabBar alloc]initWithNibName:@"TDMCustomTabBar" bundle:nil];
    self.tabBarController = customTabBar;
    self.tabBarController.delegate = self;
    [self.window addSubview:self.tabBarController.view];
    REMOVE_FROM_MEMORY(customTabBar)
    
    [[DatabaseManager sharedManager]CREATEDATABASE:@"TDM.db"];
    
    NSDictionary *userDetails  =[[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    if(userDetails)
    {
        [TDMDataStore sharedStore].isLoggedIn = YES;
    }
    else
    {
        [TDMDataStore sharedStore].isLoggedIn  =NO;
    }

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    self.isAppMinimized = YES;
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isAppMinimized = YES;
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
//    [[LocationManager sharedManager] startGPSScan];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
        
        
         self.isAppMinimized = NO;

    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}

- (IBAction)updateLocation
{
    [[LocationManager sharedManager].locationManager stopUpdatingLocation];
    [[LocationManager sharedManager].locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [TDMUtilities clearCookies];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    self.isAppMinimized = YES;
}

- (void)selectTabItem:(int)selectedTabIndex
{
    [self.tabBarController setSelectedIndex:selectedTabIndex - 1];
    if (selectedTabIndex == 5) 
    {
        NSArray *viewControllers = [self.tabBarController viewControllers];
        TDMNavigationController *channelNavigationController = [viewControllers objectAtIndex:5];
        TDMChannelsViewController *channelController = (TDMChannelsViewController *)[channelNavigationController visibleViewController];
        [channelController refreshView];
        [self.tabBarController setSelectedIndex:selectedTabIndex];
    }
    if (selectedTabIndex == 4) {
//
//        NSArray *viewControllers = [self.tabBarController viewControllers];
//        TDMNavigationController *cityNavigationController = [viewControllers objectAtIndex:4];
//        TDMCityGuideViewController *cityController = (TDMCityGuideViewController *)[cityNavigationController topViewController];
//        [cityController releaseFilterController];
        [self.tabBarController setSelectedIndex:selectedTabIndex];
    }
    else if (selectedTabIndex ==  6) 
    {
//        TDMCustomTabBar *tab = (TDMCustomTabBar *)self.tabBarController;
//        [tab selectTabAtIndex:6];
        NSArray *navigationsResultArray = self.tabBarController.viewControllers;
        UINavigationController *navigationcontroller = [navigationsResultArray objectAtIndex:selectedTabIndex];
        [navigationcontroller popToRootViewControllerAnimated:YES];
        
         TDMMyFavoritesViewController *favController = (TDMMyFavoritesViewController *)[navigationcontroller visibleViewController];
        [favController setIsAnimated:YES];
        
        [self.tabBarController setSelectedIndex:selectedTabIndex];
    }
    else if (selectedTabIndex ==  3) 
    {
        [self.tabBarController setSelectedIndex:selectedTabIndex];
        TDMCustomTabBar *tab = (TDMCustomTabBar *)self.tabBarController;
        [tab selectTabAtIndex:3];
        
        //[self.tabBarController
    }
    else if (selectedTabIndex == 1) 
    {
        [self.tabBarController setSelectedIndex:selectedTabIndex];
        TDMCustomTabBar *tab = (TDMCustomTabBar *)self.tabBarController;
        [tab selectTabAtIndex:1];
    }
    else if (selectedTabIndex == 0) 
    {
        [self.tabBarController setSelectedIndex:selectedTabIndex];
        TDMCustomTabBar *tab = (TDMCustomTabBar *)self.tabBarController;
        [tab selectTabAtIndex:0];
    }
}


- (BOOL)tabBarController:(UITabBarController *)tabBarControler shouldSelectViewController:(UIViewController *)viewController {
    
    if(viewController == tabBarControler.moreNavigationController)
        return NO;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self application:application handleOpenURL:url];
    
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
    
    NSLog(@"url scheme:-  %@",url.scheme);
    if ([kUrlScheme isEqualToString:url.scheme]) {
        return YES;
    }

    return [logindelegate handleOpenURL:url];
}

@end
