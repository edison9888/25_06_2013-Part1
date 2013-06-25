//
//  LocationManager.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
@end

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <LocationManagerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+(LocationManager*)sharedManager;
-(void)startGPSScan;
-(void)stopGPSScan;
@end
