//
//  AppDelegate.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "OrganizationSummaryViewController.h"
#import "WellSearchViewController.h"
#import "AFESearchViewController.h"

#import "RVAPIRequestInfo.h"
#import "OrganizationSearchAPIHandler.h"

@interface AppDelegate ()

-(void) resetNSuserDefaultsObjects;

@end

@interface AppDelegate ()
{
    UINavigationController *orgSummaryNavController;
    UINavigationController *wellSearchNavController;
    UINavigationController *afeSearchNavController;
    
    OrganizationSummaryViewController *orgSummaryVC;
    WellSearchViewController *wellSearchVC;
    AFESearchViewController *afeSearchVC;
    UIPopoverController *infoPopOver; 
    InformationViewController *infrmtnViewCntrl;
    
}


@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self resetNSuserDefaultsObjects];
    [self createTabbarController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Methods for adding tabBars

-(void)createTabbarController{
    
    if(self.tabBarController){
        self.tabBarController = nil;
    }
    
    orgSummaryVC = [[OrganizationSummaryViewController alloc] initWithNibName:@"OrganizationSummaryViewController" bundle:nil];
    wellSearchVC = [[WellSearchViewController alloc] initWithNibName:@"WellSearchViewController" bundle:nil];
    afeSearchVC = [[AFESearchViewController alloc] initWithNibName:@"AFESearchViewController" bundle:nil];
    
    orgSummaryNavController = [[UINavigationController alloc] initWithRootViewController:orgSummaryVC];
    wellSearchNavController = [[UINavigationController alloc] initWithRootViewController:wellSearchVC];
    afeSearchNavController = [[UINavigationController alloc] initWithRootViewController:afeSearchVC];
    
    self.tabBarController = [[SQLBITabbarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:orgSummaryNavController, wellSearchNavController, afeSearchNavController, nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [button addTarget:self 
               action:@selector(showInformationView)
     forControlEvents:UIControlEventTouchDown];
        //[button setBackgroundImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateNormal];
        //[button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(950, 729, 30, 30);
    [self.tabBarController.view addSubview:button];
    
    UIImageView *logoView;
    
    if([Utility isRetina])
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SQL-BI_Logo"]];
    else
        logoView = [[UIImageView alloc] initWithImage:[Utility resizedImage:[UIImage imageNamed:@"SQL-BI_Logo"] forWidth:66 forHeight:33]];
    
    logoView.frame = CGRectMake(880, 729, 66, 33);
    logoView.backgroundColor = [UIColor clearColor];
    
    [self.tabBarController.view addSubview:logoView];
}

-(void)showInformationView{
    [self showInfrmatnViewController];
}

-(void)showInfrmatnViewController{
    
    if (infoPopOver) {
        [infoPopOver dismissPopoverAnimated:NO];
        infoPopOver = nil;
    }
    infrmtnViewCntrl = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    infrmtnViewCntrl.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:infrmtnViewCntrl];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    [navigationController.navigationItem setLeftBarButtonItem:cancelButton];
    infoPopOver = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    infoPopOver.delegate = self;
    [infoPopOver  setPopoverContentSize:CGSizeMake(400,148) animated:YES];
    [infoPopOver presentPopoverFromRect:CGRectMake(765, 15, 400, 148) inView:self.tabBarController.tabBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark -
#pragma mark - InformationViewController delegate
-(void)cancelBtnClikced{
    if (infoPopOver) {
        [infoPopOver dismissPopoverAnimated:YES];
        infoPopOver = nil;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(popoverController == infoPopOver){
    }
}
-(void) resetNSuserDefaultsObjects
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}


-(void) jumpToAFESearchAndSearchAFEWithID:(NSString*) afeID
{
    if(self.tabBarController)
    {
         int indexOfAFESearch = [self.tabBarController.viewControllers indexOfObject:afeSearchNavController];
        
        [self.tabBarController selectTab:indexOfAFESearch];
        
        if(afeSearchVC)
            [afeSearchVC performSelector:@selector(searchWithDataAFEID:) withObject:afeID afterDelay:0.1];
        
    }
}

@end
