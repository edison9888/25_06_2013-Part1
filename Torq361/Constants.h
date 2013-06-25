//
//  Constants.h
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol Constants

//CMS URL
#define CMSLink @"http://107.20.179.230:8080/Torq361"

//production server url : http://www.torq361.com

#define CMSLinkk @"http://192.168.1.32:8080/Torq361/sync"

//Sync API
#define SyncAPI @"/synctorq361"



//Keys
#define kLoginStatus @"loginStatus"
#define kAuthToken @"authTocken"
#define kUserEmailID @"userEmailID"
#define kUserCredentials @"userCredentials"
#define kPreviousRollId @"previousRollId"         // Roll id of the user last logged in.
#define kPreviousCompanyId @"previousCompanyId"   // Company id of the user last logged in.

//images 
#define kImageType @"png"
#define kDefaultDisplayImage @"default_image"
#define kNewBanner @"NewBanner"
#define kTick @"tick_icon"

@end
