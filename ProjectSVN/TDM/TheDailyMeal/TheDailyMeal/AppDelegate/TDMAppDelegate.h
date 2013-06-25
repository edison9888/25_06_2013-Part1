//
//  TDMAppDelegate.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@protocol TDMLocationDelegate <NSObject>
@optional
//it will call after the new location gets saved.
- (void)currentLocationDidSaved:(CLLocation*)location ;
//it will call just after the location fetched, before checking the zipcode for its service availablity
//Overlay removal is more suitable inside this delegate method
- (void)locationFetchCompletedSuccessfully;
//it will called while the fetched location is not a valid one.
- (void)locationFetchCompletedWithErrors;
@end

@interface TDMAppDelegate : UIResponder <UIApplicationDelegate,LocationManagerDelegate,TDMLocationDelegate,CLLocationManagerDelegate>{
    
    UITabBarController *tabBarController; 
    id <TDMLocationDelegate> delegate;
}

@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,retain) UITabBarController *tabBarController;
@property (assign) id <TDMLocationDelegate> delegate;
@property (assign) id <FBLoginDelegate> logindelegate;

- (void)startGPSScan;
- (void)fetchLatitudeAndLongitudeForLocation:(CLLocation*)location ;

@end
