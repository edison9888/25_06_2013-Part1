//
//  PlndrAppDelegate.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlndrAppDelegate.h"

#import "HomeViewController.h"
#import "MyCartViewController.h"
#import "InviteFriendsViewController.h"
#import "MySettingsViewController.h"
#import "PortraitTabBarController.h"
#import "Constants.h"
#import "CheckoutViewController.h"
#import "ModelContext.h"
#import "GANTracker.h"

@interface PlndrAppDelegate ()

- (void) setChildClipsToBoundsForView:(UIView*)view clipsToBounds:(BOOL)clipsToBounds stopRecursing:(BOOL)stopRecursing;

@property (nonatomic, strong) NSDate *startTime; 

@end

@implementation PlndrAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize currentTabBarIndex = _currentTabBarIndex;
@synthesize myCartBadge = _myCartBadge;
@synthesize startTime = _startTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self setupAnalytics];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Hacky.... we do this and turn off clipsToBounds on switching tabs so that windows draw their content into the tab bar drop shadow
    // and the dropshadow gets its background color from the window.
    // To do this better without using a completely custom tab bar, we would need to be able to change the height of tabBarController's container views.
    self.window.backgroundColor = kPlndrBgGrey;
    
    [self updateNavBarAppearanceToDefault:NO];
    
    // Back Button
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 3)];
    UIImage *backButtonHLImage = [[UIImage imageNamed:@"back_btn_hl.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 3)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonHLImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          kPlndrWhite, UITextAttributeTextColor,
                                                          [UIColor clearColor],UITextAttributeTextShadowColor,
                                                          kFontMedium12, UITextAttributeFont,
                                                          nil]
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          kPlndrBlack, UITextAttributeTextColor,
                                                          [UIColor clearColor],UITextAttributeTextShadowColor,
                                                          kFontMedium12, UITextAttributeFont,
                                                          nil]
                                                forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(1.0f, 1.0f) forBarMetrics:UIBarMetricsDefault];
    
    self.tabBarController = [[PortraitTabBarController alloc] init];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"]];
    [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab_bar_hl.png"]];
    self.tabBarController.tabBar.opaque = NO;
    
    NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:4];

    HomeViewController *masterViewController = [[HomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    navigationController.tabBarItem = [[UITabBarItem alloc] init];
    navigationController.tabBarItem.tag = 0;
    [navigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Plndr_hl.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Plndr.png"]];
    [localControllersArray addObject:navigationController];
    
    MyCartViewController *myCartViewController = [[MyCartViewController alloc] init];
    UINavigationController *myCartNavigationController = [[UINavigationController alloc] initWithRootViewController:myCartViewController];
    myCartNavigationController.tabBarItem = [[UITabBarItem alloc] init];
    myCartNavigationController.tabBarItem.tag = 1;
    [myCartNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"mycart_hl.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"mycart.png"]];
    [localControllersArray addObject:myCartNavigationController];
    
   
    InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc] init];
    UINavigationController *inviteFriendsNavigationController = [[UINavigationController alloc] initWithRootViewController:inviteFriendsViewController];
    inviteFriendsNavigationController.tabBarItem = [[UITabBarItem alloc] init];
    inviteFriendsNavigationController.tabBarItem.tag = 2;
    [inviteFriendsNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"invite_hl.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"invite.png"]];   
    [localControllersArray addObject:inviteFriendsNavigationController];
    
    MySettingsViewController *mySettingsViewController = [[MySettingsViewController alloc] init];
    UINavigationController *mySettingsNavigationController = [[UINavigationController alloc] initWithRootViewController:mySettingsViewController];
    mySettingsNavigationController.tabBarItem = [[UITabBarItem alloc] init];
    mySettingsNavigationController.tabBarItem.tag = 3;
    [mySettingsNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settings_hl.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings.png"]];
    [localControllersArray addObject:mySettingsNavigationController];
    
    self.currentTabBarIndex = 0;
    self.tabBarController.viewControllers = localControllersArray;
    self.tabBarController.delegate = self;
    [self.window addSubview:self.tabBarController.view];
    
    self.myCartBadge = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *myCartBadgeImg = [[UIImage imageNamed:@"badge_icon.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(13, 17, 20, 17)];
    [self.myCartBadge setBackgroundImage:myCartBadgeImg forState:UIControlStateNormal];
    [self.myCartBadge.titleLabel setFont:kFontBold12];
    [self.myCartBadge setTitleEdgeInsets:UIEdgeInsetsMake(-2.5f, 0, 0, 0)];
    self.myCartBadge.enabled = NO;
    self.myCartBadge.adjustsImageWhenDisabled = NO;
    [self.tabBarController.tabBar addSubview:self.myCartBadge];
    
    [self updateCartBadge];
    [self setChildClipsToBoundsForView:self.tabBarController.view clipsToBounds:NO stopRecursing:NO];
    
    [self.window makeKeyAndVisible];
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
    
    NSDate *now = [NSDate date];
    int timeElapsed = (int) [now timeIntervalSinceDate:self.startTime];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kGANEventAppGeneral action:kGANActionLeaveApp label:kGANLabelLeaveApp value:timeElapsed withError:&error]) {
        NSLog(@"Time on app tracking error: %@", error);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    self.startTime = [NSDate date];
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

- (void)switchToTabIndex:(int)index {      
    if (self.currentTabBarIndex == kMyCartTabIndex) {
        [((UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:kMyCartTabIndex]) popToRootViewControllerAnimated:YES];
    }
    
    [self.tabBarController setSelectedIndex:index];
    self.currentTabBarIndex = index;
    
    [self setChildClipsToBoundsForView:self.tabBarController.view clipsToBounds:NO stopRecursing:NO];
}
    
- (PlndrBaseViewController *)getDeepestUnauthorizedControllerInTab {
    switch (self.currentTabBarIndex) {
        case kHomeTabIndex: {
            UINavigationController *rootController = [self.tabBarController.viewControllers objectAtIndex:self.currentTabBarIndex];
            PlndrBaseViewController *topView = [rootController.viewControllers lastObject];
            return topView;
        }
        case kMyCartTabIndex:
        case kInviteFriendsTabIndex:
        case kSettingsTabIndex:
        {
            UINavigationController *rootController = [self.tabBarController.viewControllers objectAtIndex:self.currentTabBarIndex];
            PlndrBaseViewController *rootView = [rootController.viewControllers objectAtIndex:0];
            return rootView;
        }
        default:
            return nil;
    }
}

- (void)updateCartBadge {
    NSString *cartQuantity = [[ModelContext instance] getCartBadgeString];
    if (cartQuantity) {
        self.myCartBadge.hidden = NO;
        
        CGSize cartQuantitySize = [cartQuantity sizeWithFont:self.myCartBadge.titleLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:UILineBreakModeTailTruncation];
        [self.myCartBadge setTitle:cartQuantity forState:UIControlStateNormal];
        
        // Needed to adjust the background image
        [self.myCartBadge sizeToFit];
        
        UIImage *myCartBadgeImg = [UIImage imageNamed:@"badge_icon.png"];
        int widthToMakeDivisiblityByTwoSame = (((int)self.myCartBadge.titleLabel.frame.size.width) % 2 == 1 ? 1 : 0);
        float myCartBadgeWidth = myCartBadgeImg.size.width + MAX(cartQuantitySize.width - 8, 0) + widthToMakeDivisiblityByTwoSame;
        
        CGPoint badgeOrigin = kTabBarMyCartBadgeOrigin;
        [self.myCartBadge setFrame:CGRectMake(badgeOrigin.x, badgeOrigin.y, myCartBadgeWidth, self.myCartBadge.frame.size.height)];
    } else {
        self.myCartBadge.hidden = YES;
    }
}

- (void)moveToHomePage {
    [((UINavigationController*)[self.tabBarController.viewControllers objectAtIndex:kHomeTabIndex]) popToRootViewControllerAnimated:YES];
    [self switchToTabIndex:0];// Go to home

}

- (void)updateNavBarAppearanceToDefault:(BOOL)isDefault {
    if (isDefault) {
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:nil];
    } else {
        // Customize nav bar appearance
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        // Title
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: kPlndrDarkGreyTextColor, UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, kFontBoldCond20, UITextAttributeFont, nil]];
    }
}


#pragma mark - UITabBarDelegate

// This method is used to turn off clipsToBounds on the children of the tab bar view, up until reaching the views managed by controllers
- (void) setChildClipsToBoundsForView:(UIView*)view clipsToBounds:(BOOL)clipsToBounds stopRecursing:(BOOL)stopRecursing {
    BOOL stopNextRecursion = stopRecursing;
    
    if (!view || [view isKindOfClass: [UITabBar class]] || (stopRecursing && [view class] != [UIView class])) {
        return;
    }
    
    if (view.class == [UIView class]) {
        stopNextRecursion = YES;
    }
    
    view.clipsToBounds = clipsToBounds;
    
    for (UIView *subview in [view subviews]) {
        [self setChildClipsToBoundsForView:subview clipsToBounds:clipsToBounds stopRecursing:stopNextRecursion];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[SocialManager instance] facebook] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[[SocialManager instance] facebook] handleOpenURL:url];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self switchToTabIndex:[tabBarController.viewControllers indexOfObject:viewController]];
}

#pragma mark - helper methods

-(void)setupAnalytics {
    [[GANTracker sharedTracker] startTrackerWithAccountID: kUseDebugGAN ? kGANTrackingTestID : kGANTrackingID
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    NSError *error;
    
    if (![[GANTracker sharedTracker] trackEvent:kGANEventAppGeneral
                                         action:kGANActionAppStartup
                                          label:kGANLabelAppStartup
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Startup error: %@", error);
    }
    
    [[GANTracker sharedTracker] trackPageview:kGANAppStart withError:&error];
    
    [[GANTracker sharedTracker] setAnonymizeIp:NO];
    
    [_window makeKeyAndVisible];
}

-(void)dealloc {
    [[GANTracker sharedTracker] stopTracker];
}

@end
