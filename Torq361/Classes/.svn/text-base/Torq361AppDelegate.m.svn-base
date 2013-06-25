//
//  Torq361AppDelegate.m
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Torq361AppDelegate.h"
#import "Home.h"
#import "LoginViewController.h"
#import "ConnectivityCheck.h"
#import "DatabaseManager.h"
#import "Constants.h"


@implementation Torq361AppDelegate

@synthesize window;
@synthesize home;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// Current App Version Number
	appVersion = 1.0;
	
	[self databaseCheck];	
    
    // Override point for customization after app launch. 
    [self.window addSubview:home.view];
	//file://localhost/Users/rinishrvs/Desktop/Torq361
    [self.window makeKeyAndVisible];
	
	//NSInteger temp1 = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
		
				
		//NSInteger temp = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus];
		
		//NSString *authToken = [[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken];
		
		// User already logged In
		
		NSData *userData = [[NSUserDefaults standardUserDefaults]objectForKey:kUserCredentials];
		
		if (userData != nil) {
			
			[NSKeyedUnarchiver unarchiveObjectWithData:userData];
		}
		
		[home onSuccessfulLogin];
		
	}
	else {
		
		// User Not logged In
		//[home onSuccessfulLogin];
		[home showLogin];

	}

	return YES;
}

-(void)databaseCheck{
	
	if([[DatabaseManager sharedManager] CREATEDATABASE:@"Torq361.db"]) {
		
		// Created DataBase as there wasn't a database of name " Torq361.db "
		
	}
	
	else {
		
		// Torq361.db already exists, So check whether to replacing the DB based on the App version number
		
		// Replace the DB if the current app is of a higher version
		
		
		if (![[DatabaseManager sharedManager] checkForVersionTable:appVersion]) {
			
			[[DatabaseManager sharedManager] removeOldDbAndCreateNewOne];
			
		}
	}

	
}

-(void)createFolderStructureInDocumentDirectory:(NSString*)CompanyID{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	NSString *strCompanyId= [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"CompanyId",CompanyID]];
	NSString *strCatalogThumb= [strCompanyId stringByAppendingPathComponent:@"CatalogThumb"];
	NSString *strCategoryThumb= [strCompanyId stringByAppendingPathComponent:@"CategoryThumb"];
	NSString *strProductThumb= [strCompanyId stringByAppendingPathComponent:@"ProductThumb"];	
	NSString *strProductimageContent=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/image/tmp"];
    NSString *strProductpdfContent=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/pdf/tmp"];
    NSString *strProductvideoContent=[strCompanyId stringByAppendingPathComponent:@"ProductContent/Portrait/video/tmp"];
	
	/*NSString *strBackgroundImages=[documentPath stringByAppendingPathComponent:@"backgroundimages/tmp"];
	NSString *strLoginNotes=[documentPath stringByAppendingPathComponent:@"login_notes/tmp"];
	NSString *strLoginNotesfolder=[documentPath stringByAppendingPathComponent:@"login_notes"];*/
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:strCompanyId]) 
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:strCompanyId withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:strCatalogThumb ]) 
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:strCatalogThumb withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:strCategoryThumb ]) 
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:strCategoryThumb withIntermediateDirectories:YES attributes:nil error:&error];
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:strProductThumb ]) 
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:strProductThumb	withIntermediateDirectories:YES attributes:nil error:&error];
	}	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:strProductimageContent ]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strProductimageContent withIntermediateDirectories:YES attributes:nil error:&error];
    }    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strProductpdfContent ]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strProductpdfContent withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strProductvideoContent ]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strProductvideoContent withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
	//[[NSFileManager defaultManager] createDirectoryAtPath:strLoginNotes withIntermediateDirectories:YES attributes:nil error:&error];*/
	
}

-(void)deleteteFolderStructureInDocumentDirectory:(NSString*)CompanyID{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];
	
	NSString *strCompanyId= [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"CompanyId",CompanyID]];
		
	if ([[NSFileManager defaultManager] fileExistsAtPath:strCompanyId]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:strCompanyId error:nil];
	}
	
/*	if ([[NSFileManager defaultManager] fileExistsAtPath:strCatalogThumb ]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:strCatalogThumb error:nil];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:strCategoryThumb ]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:strCategoryThumb error:nil];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:strProductThumb ]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:strProductThumb error:nil];
	}	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:strProductimageContent ]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath:strProductThumb error:nil];
    }    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strProductpdfContent ]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strProductpdfContent withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:strProductvideoContent ]) 
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:strProductvideoContent withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
	//[[NSFileManager defaultManager] createDirectoryAtPath:strLoginNotes withIntermediateDirectories:YES attributes:nil error:&error];*/
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
 
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
  
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
    [home release];
	
    [window release];
	
    [super dealloc];
}


@end
