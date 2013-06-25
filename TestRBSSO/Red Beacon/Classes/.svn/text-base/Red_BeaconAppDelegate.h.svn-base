//
//  Red_BeaconAppDelegate.h
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "RBSavedStateController.h"
#import "RBBaseHttpHandler.h"
#import "LoginViewController.h"

@protocol RBLocationDelegate <NSObject>
@optional
//it will call after the new location gets saved.
- (void)newLocationDidSaved;
//it will call just after the location fetched, before checking the zipcode for its service availablity
//Overlay removal is more suitable inside this delegate method
- (void)locationFetchCompletedSuccessfully;
//it will called while the fetched location is not a valid one.
- (void)locationFetchCompletedWithErrors;
@end

@interface Red_BeaconAppDelegate : NSObject <UIApplicationDelegate, LocationManagerDelegate> {

    id <RBLocationDelegate> delegate;
    id <FBLoginDelegate> logindelegate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (assign) id <RBLocationDelegate> delegate;
@property (assign) id <FBLoginDelegate> logindelegate;

- (void)startGPSScan;
- (void)fetchZipcodeForLocation:(CLLocation*)newLocation;
- (NSString*)getZipCodeFromResponse:(NSMutableDictionary*)response;
- (void)stopGPSScan;
- (BOOL)isValidZipCode:(NSString*)zipcode;

@end
