//
//  InlandCasinosAppDelegate.h
//  InlandCasinos
//
//  Created by Nithin George on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenViewController.h"
#import "DownloadManager.h"
#import "ProgressView.h"

@interface InlandCasinosAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,DownloadManagerDelegate,SplashScreenViewControllerDelegate> {
    
    float appVersion;
    
    ProgressView *progressView;
    
    SplashScreenViewController *splashScreenViewController;
}

@property (nonatomic, retain) IBOutlet UIView *progressView;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

//For checking the database
-(void)loadSplashScreen;
-(void)startSynching;

-(void)removeSplashScreen;

@end
