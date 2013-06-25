//
//  TDMAppDelegate.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAppDelegate.h"
#import "TDMChannelsViewController.h"
#import "TDMCustomTabBar.h"
#import "TDMSyncManager.h"
#import "DatabaseManager.h"
#import "TDMUserLogin.h"

#define LOCATION_NOT_FOUND @"Your location cannot be identified"

@interface TDMAppDelegate()
//private
- (void)checkForUpdatesInServer;
- (void)insertDefaultEntriesToCoreData;
@end
@implementation TDMAppDelegate

@synthesize window = _window;
@synthesize tabBarController;
@synthesize delegate;
@synthesize logindelegate;

- (void)dealloc
{
    REMOVE_FROM_MEMORY(_window)
    REMOVE_FROM_MEMORY(tabBarController)
    self.delegate = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //this will insert teh default entries in the CoreData
    //[self insertDefaultEntriesToCoreData];
    //this will check for the server updates.
    //[self checkForUpdatesInServer];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabBarController = [[[UITabBarController alloc]init] autorelease];

    TDMCustomTabBar *customTabBar=[[TDMCustomTabBar alloc]initWithNibName:@"TDMCustomTabBar" bundle:nil];
    self.tabBarController = customTabBar;
    [self.window addSubview:self.tabBarController.view];
    
    REMOVE_FROM_MEMORY(customTabBar)
    
    [[DatabaseManager sharedManager]CREATEDATABASE:@"TDM.db"];
    NSDictionary *userDetails  =[[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSLog(@"user details %@",userDetails);
    if(userDetails)
    {
        [TDMUserLogin sharedLoginDetails].isLoggedIn = YES;
        NSLog(@"APP DELEGATE loggedUser.isLoggedIn %d",[TDMUserLogin sharedLoginDetails].isLoggedIn);
    }
    else
    {
        [TDMUserLogin sharedLoginDetails].isLoggedIn  =NO;
        NSLog(@"APP DELEGATE loggedUser.isLoggedIn %d",[TDMUserLogin sharedLoginDetails].isLoggedIn);
        
    }
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    self.delegate=self;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    [self startGPSScan];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [TDMUserLogin sharedLoginDetails].isLoggedIn = NO;
    [[DatabaseManager sharedManager]deleteUserDataBase];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Helpers
//this will check the updates on the server
- (void)checkForUpdatesInServer{
    TDMSyncManager *syncManager = [[TDMSyncManager alloc]init];
    [syncManager checkForUpdates];
    REMOVE_FROM_MEMORY(syncManager)
}

//this will insert the defaultEntriesTo Core data at the first launch.
- (void)insertDefaultEntriesToCoreData{
    TDMSyncManager *syncManager = [[TDMSyncManager alloc]init];
    [syncManager insertInitialLastModifiedDataToCoreData];
    REMOVE_FROM_MEMORY(syncManager)
}

#pragma mark - GPS Location Scanning

- (void)stopGPSScan 
{
    [[LocationManager sharedManager] stopGPSScan];
    [[LocationManager sharedManager] setDelegate:nil];
}

- (void)startGPSScan 
{
    [self stopGPSScan];
    
//    LocationManager *locationManager = LOCATE(LocationManager);
//    [locationManager startGPSScan];
    
    [[LocationManager sharedManager] startGPSScan];
    [[LocationManager sharedManager] setDelegate:self];
}

- (void)locationUpdate:(CLLocation *)location 
{
    [self stopGPSScan];
    [self fetchLatitudeAndLongitudeForLocation:location];
    self.delegate = nil;
}

- (void)locationError:(NSError *)error 
{
    [self stopGPSScan];
     kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE,LOCATION_NOT_FOUND );
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(locationFetchCompletedWithErrors)])
        [self.delegate locationFetchCompletedWithErrors];

}

- (void)fetchLatitudeAndLongitudeForLocation:(CLLocation*)location 
{

    //NSLog(@"CURRENT_LOCATION IS %@",[location description]);
    
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(currentLocationDidSaved:)])
        [self.delegate currentLocationDidSaved:location];
}

-(void)currentLocationDidSaved:(CLLocation *)location {
    NSLog(@"Location fetched in AppDelegate %@",location.description);
    
    [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.latitude forKey:@"CurrentLattitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:location.coordinate.longitude forKey:@"CurrentLongitude"];

}

-(NSMutableArray *)computeTheClosestLocationsNearMe:(CLLocation *)location {
    return nil;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}
@end