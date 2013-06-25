//
//  PlistTutorial2AppDelegate.h
//  PlistTutorial2
//
//  Created by Kent Franks on 7/18/11.
//  Copyright 2011 St Lukes Hospital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlistTutorial2AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
