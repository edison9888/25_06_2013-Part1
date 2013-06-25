//
//  Torq361AppDelegate.h
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Home;

@interface Torq361AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;

    Home *home;
	
	float appVersion;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Home *home;

-(void)databaseCheck;
-(void)createFolderStructureInDocumentDirectory:(NSString*)CompanyID;
-(void)deleteteFolderStructureInDocumentDirectory:(NSString*)CompanyID;
@end

