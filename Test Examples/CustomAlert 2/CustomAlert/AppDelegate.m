//
//  AppDelegate.m
//  CustomAlert
//
//  Created by Aaron Crabtree on 10/14/11.
//  Copyright (c) 2011 Tap Dezign, LLC. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate
@synthesize window = _window;

#pragma mark -
#pragma mark Memory management
- (void)dealloc
{
    [_window release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor lightGrayColor];
    [self.window makeKeyAndVisible];
    
    CustomAlertView *customAlertView = [[CustomAlertView alloc]initWithTitle:@"Custom Alert View"
                                                                     message:@"CustaticallyCustaticallyCustaticallyCustaticallyCustaticallyCustaticallyCyCustaticallyCustaticallyCustaticallyCustatically."
                                                                    delegate:self
                                                           cancelButtonTitle:@"NO"
                                                           otherButtonTitles:@"YES",nil];
	[customAlertView show];
	[customAlertView release];
    
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		NSLog(@"THE 'NO' BUTTON WAS PRESSED");
	}
	if (buttonIndex == 1) {
		NSLog(@"THE 'YES' BUTTON WAS PRESSED");
	}
}

@end
