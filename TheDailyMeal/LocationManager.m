//
//  LocationManager.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//


#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DatabaseManager.h"
#import "TDMDataStore.h"

#define TDM_LOCATION_STATUS_CHECK_TAG 114433

@interface LocationManager ()

- (CLAuthorizationStatus)getLocationAutherizationStatus;
- (void)promptLocationUpdateStatusVerificationAlert;
- (CLLocationDistance) distanceBetweenCoordinate:(CLLocation *)originCoordinate andCoordinate:(CLLocation *)destinationCoordinate ;

@end

@implementation LocationManager

@synthesize locationManager;
@synthesize delegate;

static LocationManager *m_objLocationManager;

+(LocationManager*)sharedManager
{
    if (!m_objLocationManager)
    {
        m_objLocationManager=[[LocationManager alloc] init];
    }
    
    return m_objLocationManager;
}

- (id) init
{
    self = [super init];
	
    if (self != nil)
    {
        CLLocationManager *location = [[CLLocationManager alloc] init];
		self.locationManager = location;
        [location release];
        
        self.locationManager.delegate = self;
        

//        Discussion:
//        *      Specifies the minimum update distance in meters. Client will not be notified of movements of less 
//        *      than the stated value, unless the accuracy has improved. Pass in kCLDistanceFilterNone to be 
//        *      notified of all movements. By default, kCLDistanceFilterNone is used.
        [self.locationManager setDistanceFilter:kCLLocationAccuracyHundredMeters];  //Location update will happen only if atleast 500 mtrs horizontal change for device.

        
//        Sets the desiredAccuracy for the LocationManager
//        *  Discussion:
//        *      The desired location accuracy. The location service will try its best to achieve
//        *      your desired accuracy. However, it is not guaranteed. To optimize
//        *      power performance, be sure to specify an appropriate accuracy for your usage scenario 
//        (eg, *      use a large accuracy value when only a coarse location is needed). Use kCLLocationAccuracyBest to
//        *      achieve the best possible accuracy. Use kCLLocationAccuracyBestForNavigation for navigation.
//        *      By default, kCLLocationAccuracyBest is used.
//        [self.locationManager setDesiredAccuracy:kCLH];
        
        if ([self getLocationAutherizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
//            if([[[UIDevice currentDevice] systemVersion] intValue]<4.0)
//            {
//                locationServicesDisabled = [CLLocationManager locationServicesEnabled];
//                
//                if ([CLLocationManager locationServicesEnabled] == NO)
//                {
//                    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be re-enabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [servicesDisabledAlert show];
//                    [servicesDisabledAlert release];
//                }
//            }
//            else
//            {
//                //iPhone OS 4.0
//                if([CLLocationManager locationServicesEnabled] == NO)
//                {
//                    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be re-enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [servicesDisabledAlert show];
//                    [servicesDisabledAlert release];
//                }
//            }
            
            if([CLLocationManager locationServicesEnabled] == NO)
            {
                UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be re-enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [servicesDisabledAlert show];
                [servicesDisabledAlert release];
                servicesDisabledAlert = nil;
            }
            else
            {
                [[TDMDataStore sharedStore] setUserNeedsChangeOnLocationUpdate:YES];
                if ([[TDMDataStore sharedStore] checkIsUserNeedsUpdateFlagPresentInUserDefaults] == NO)
                {
                    [self promptLocationUpdateStatusVerificationAlert];
                }
            }
        }
        else
        {
            [self checkLocationAutherizationStatus];
        }
    }
	return self;
}

- (CLAuthorizationStatus)getLocationAutherizationStatus
{
    return [CLLocationManager authorizationStatus];
}

- (void)checkLocationAutherizationStatus
{
    if ([self getLocationAutherizationStatus] == kCLAuthorizationStatusRestricted)
    {
        [TDMUtilities showAlert:TDM_TITLE message:MSG_LOCATION_AUTHERIZATION_RESTRICTED delegateObject:nil];
    }
    else if ([self getLocationAutherizationStatus] == kCLAuthorizationStatusDenied)
    {
        [TDMUtilities showAlert:TDM_TITLE message:MSG_LOCATION_AUTHERIZATION_DENIED delegateObject:nil];
    }
    else if ([self getLocationAutherizationStatus] == kCLAuthorizationStatusAuthorized)
    {
//        [TDMUtilities showAlert:TDM_TITLE message:MSG_LOCATION_AUTHERIZED delegateObject:nil];
        if([CLLocationManager locationServicesEnabled] == NO)
        {
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be re-enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [servicesDisabledAlert show];
            [servicesDisabledAlert release];
            servicesDisabledAlert = nil;
        }
        else
        {
            [[TDMDataStore sharedStore] setUserNeedsChangeOnLocationUpdate:YES];
            if ([[TDMDataStore sharedStore] checkIsUserNeedsUpdateFlagPresentInUserDefaults] == NO)
            {
                [self promptLocationUpdateStatusVerificationAlert];
            }
        }
    }
    else
    {
        [TDMUtilities showAlert:TDM_TITLE message:@"Unknown location autherization state" delegateObject:nil];
    }
}

-(void)startGPSScan
{
	[self.locationManager startUpdatingLocation];
}

-(void)stopGPSScan
{
	[self.locationManager stopUpdatingLocation];
}

-(void) checkWishListWithLocation:(CLLocation *)currentLocation
{
    
    NSMutableArray *wishListArray = [[DatabaseManager sharedManager] getBusinessInWishListFromDataBase];
    NSMutableArray *distanceArray = [[NSMutableArray alloc]init];
    NSMutableArray *nearByBusinessArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *wishListDictionary in wishListArray) {
        
        double lat  =[[wishListDictionary objectForKey:@"latitude"] doubleValue];
        double lon = [[wishListDictionary objectForKey:@"longitude"] doubleValue];
        
        CLLocation *wishListItemLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
        int distance = [currentLocation distanceFromLocation:wishListItemLocation];

        if(distance <=500)
        {
            [nearByBusinessArray addObject:wishListDictionary];
            NSNumber *number = [NSNumber numberWithFloat:distance];
            [distanceArray addObject:number];
        }
    }
    if([nearByBusinessArray count]>0)
    {
        NSString *alertMessage =@"";
        NSString *business;
        for (int i=0; i<[nearByBusinessArray count]; i++) {
            
            
            NSMutableDictionary *businessDictionary = [nearByBusinessArray objectAtIndex:i];
            
            NSString *businessName =[businessDictionary objectForKey:@"name"];
            
            
            business = [NSString stringWithFormat:@"%@%@%@%@",businessName,@" -(",[distanceArray objectAtIndex:i],@" meters away)\n"];
            alertMessage =[alertMessage stringByAppendingFormat:business];
            business = @"";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        [alert release];  
        
    }
    [nearByBusinessArray release];
    [distanceArray release];
    
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Notification"] isEqualToString:@"YES"])
    {
        [TDMDataStore sharedStore].isNotificationON = YES;
    }
    CLLocationDistance tempDistance;
    CLLocationDegrees lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"StartLatitude"];
    CLLocationDegrees lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"StartLongitude"];
    
    CLLocation *phoneStartingLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
        if ([[TDMDataStore sharedStore] doesUserNeedChangeOnLocationUpdate])
        {
            if (phoneStartingLocation) {
                
                tempDistance = [self distanceBetweenCoordinate:newLocation andCoordinate:phoneStartingLocation];
                if (tempDistance>500) {
                    
                    [[NSUserDefaults standardUserDefaults] setDouble:newLocation.coordinate.latitude forKey:K_CURRENT_LATITUDE];
                    [[NSUserDefaults standardUserDefaults] setDouble:newLocation.coordinate.longitude forKey:K_CURRENT_LONGITUDE];
                    [[NSUserDefaults standardUserDefaults] setDouble:newLocation.coordinate.latitude forKey:@"StartLatitude"];
                    [[NSUserDefaults standardUserDefaults] setDouble:newLocation.coordinate.longitude forKey:@"StartLongitude"];
                    
                    if([TDMDataStore sharedStore].isNotificationON)
                    {
                        [self checkWishListWithLocation:newLocation];
                    }
                    
                    [self.delegate locationUpdate:newLocation];
                    
                    
                }
                else{

                    [[NSUserDefaults standardUserDefaults] setDouble:phoneStartingLocation.coordinate.latitude forKey:K_CURRENT_LATITUDE];
                    [[NSUserDefaults standardUserDefaults] setDouble:phoneStartingLocation.coordinate.longitude forKey:K_CURRENT_LONGITUDE];
                    
                }    
            }
        }
    
    [[TDMDataStore sharedStore] setLastLocationUpdateDateTime:[NSDate date]];
}

- (CLLocationDistance)  distanceBetweenCoordinate:(CLLocation *)originCoordinate andCoordinate:(CLLocation *)destinationCoordinate {
        
    //below ones gives out the meter difference from the two coordinates.
    //just check if distance is more than 500. if it is more than 500 then it will fire the refreshing process in each viewControllers again
    CLLocationDistance distance = [originCoordinate distanceFromLocation:destinationCoordinate];
    
    return distance;
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

#pragma mark    -
#pragma mark    
- (void)promptLocationUpdateStatusVerificationAlert
{
    kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, @"Location Changed")

}

#pragma mark    -
#pragma mark    UIAlertView Delegate Methods
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == TDM_LOCATION_STATUS_CHECK_TAG)
    {
        BOOL statusFlag = NO;
        
        if (buttonIndex == 1)   //Clicked "Yes"
        {
            statusFlag = YES;
        }
        else if (buttonIndex == 0)  //Clicked "No"
        {
        }
        
        [[TDMDataStore sharedStore] setUserNeedsChangeOnLocationUpdate:YES];
    }
}

- (void)dealloc
{
    self.locationManager = nil;
    
    [super dealloc];
}

@end
