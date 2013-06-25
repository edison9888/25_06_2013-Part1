//
//  AppDelegate.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLBITabbarController.h"
#import "InformationViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,InfrmatnViewDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) SQLBITabbarController *tabBarController;

-(void) jumpToAFESearchAndSearchAFEWithID:(NSString*) afeID;

@end
