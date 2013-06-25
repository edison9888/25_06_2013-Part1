//
//  InlandCasinosAppDelegate.m
//  InlandCasinos
//
//  Created by Nithin George on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InlandCasinosAppDelegate.h"
#import "ConnectivityCheck.h"
#import "DBHandler.h"

@implementation InlandCasinosAppDelegate

@synthesize window=_window;
@synthesize progressView;
@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.    
    [DBHandler initializeDatabase];
    
    [DownloadManager sharedManager].delegate=self;
    
    //[self loadSplashScreen];
    [self startSynching];
    
    [self.window makeKeyAndVisible];
    
    return YES;    
}

#pragma mark -Splash Screen method
-(void)loadSplashScreen
{
    splashScreenViewController=[[SplashScreenViewController alloc]initWithNibName:@"SplashScreenViewController" bundle:nil];
    
    [splashScreenViewController setDelegate:self];
    
    [self.window addSubview:splashScreenViewController.view];
}

-(void)splashMovieCompleted
{
    ConnectivityCheck *networkCheck = [[ConnectivityCheck alloc] init];
    
    if([networkCheck isHostReachable])
    {
        [self startSynching];
    }
    else
    {
        if ([self.window respondsToSelector:@selector(rootViewController)])
        {
            self.window.rootViewController = self.tabBarController;
        }
        else
        {
            [self.window addSubview:self.tabBarController.view];
        }
    }
    [networkCheck release];
    networkCheck = nil;
}

- (void)startSynching {
    
    [[DownloadManager sharedManager] startContentSyncing:YES];
    
    if ([self.window respondsToSelector:@selector(rootViewController)])
    {
        self.window.rootViewController = self.tabBarController;
    }
    else
    {
        [self.window addSubview:self.tabBarController.view];
    }
    
    progressView.lblProgress.text=@"Loading...";
    
    progressView.pgrView.progress = 0.0;
    
    [self.window addSubview:progressView];    
}


#pragma mark download Delegate
-(void)updateProgress:(float)progress {
    
    progressView.lblProgress.text=[NSString stringWithFormat:@"Loading... %0.0f%%",progress*100];
    progressView.pgrView.progress=progress;
}

- (void)removeSplashScreen
{
    
    if (progressView != nil)
   {
        [progressView removeFromSuperview];
    }   
    
    if (splashScreenViewController != nil)
    {
        [splashScreenViewController.view removeFromSuperview];
        
        [splashScreenViewController setDelegate:nil];
        
        [splashScreenViewController release];
        
        splashScreenViewController = nil;
    }
}


-(void)downloadCompleted:(id)downloadManager {
 
    [self performSelectorOnMainThread:@selector(removeSplashScreen) withObject:nil waitUntilDone:YES];

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
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [self removeSplashScreen];
    
    [_window release];    
    
    [super dealloc];
}

@end
