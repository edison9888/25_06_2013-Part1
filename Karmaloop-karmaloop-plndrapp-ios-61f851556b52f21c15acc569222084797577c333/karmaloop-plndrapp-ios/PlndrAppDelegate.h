//
//  PlndrAppDelegate.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlndrBaseViewController;

@interface PlndrAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property int currentTabBarIndex;
@property (nonatomic, strong) UIButton *myCartBadge;

- (void) switchToTabIndex:(int)index;
- (void) updateCartBadge;
- (void) moveToHomePage;
- (PlndrBaseViewController*) getDeepestUnauthorizedControllerInTab;
- (void) updateNavBarAppearanceToDefault:(BOOL) isDefault;
@end
