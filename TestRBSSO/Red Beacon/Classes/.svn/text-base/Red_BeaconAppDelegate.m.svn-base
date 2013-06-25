//
//  Red_BeaconAppDelegate.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Red_BeaconAppDelegate.h"
#import "JobRequest.h"
#import "SBJson.h"
#import "RBAlertMessageHandler.h"
#import "ManagedObjectContextHandler.h"

@interface Red_BeaconAppDelegate (Private)
- (void)newLocationSaved;
- (void)successfulLocationUpdate;
- (void)failedLocationUpdate;
@end

@implementation Red_BeaconAppDelegate

@synthesize window=_window;
@synthesize delegate;
@synthesize logindelegate;
@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:kRedBeaconDidEnterBackground object:nil];
    
    [[RBSavedStateController sharedInstance] persistToDisk];

    if ([RBBaseHttpHandler isSessionInfoAvailable])
    {
        [RBBaseHttpHandler saveSession];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRedBeaconDidEnterForground object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[RBSavedStateController sharedInstance] persistToDisk];
}

- (void)dealloc
{
    self.delegate = nil;
    self.logindelegate = nil;
    [_window release];
    [_navigationController release];
    [super dealloc];
}

#pragma mark - GPS Location Scanning
- (void)startGPSScan 
{
    [self stopGPSScan];
    [[LocationManager sharedManager] startGPSScan];
    [[LocationManager sharedManager] setDelegate:self];
}

- (void)stopGPSScan 
{
    [[LocationManager sharedManager] stopGPSScan];
    [[LocationManager sharedManager] setDelegate:nil];
}

- (void)locationUpdate:(CLLocation *)location 
{
    [self stopGPSScan];
    [self fetchZipcodeForLocation:location];
    self.delegate = nil;
}

- (void)locationError:(NSError *)error 
{
    [self stopGPSScan];
    [RBAlertMessageHandler showAlert:@"Your location cannot be identified"
                      delegateObject:nil];
    
    //save to datastore
    JobRequest * jobRequest  = [[RBSavedStateController sharedInstance] jobRequest];
    [jobRequest.location setValue:nil forKey:KEY_LOCATION_ZIP];
    [jobRequest.location setValue:LOCATION_TYPE_GPS forKey:KEY_LOCATION_TYPE];
    
    [self failedLocationUpdate];
    self.delegate = nil;
}

- (void)fetchZipcodeForLocation:(CLLocation*)newLocation 
{
    
    NSError * error = nil;
    NSString * urlString = kGoogleAPIToFetchZipCode;
    urlString = [urlString stringByAppendingFormat:@"latlng=%0.7f,%0.7f&sensor=true", 
                 newLocation.coordinate.latitude,
                 newLocation.coordinate.longitude];
    

    //test URL for dummy values- as we cant test GPS in here;
   // urlString = @"http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true";
    
    //give latitude and longitude and get the zipcode, from Google: reverse geocoding
    NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]  
                                                        encoding:NSUTF8StringEncoding 
                                                           error:&error];
    NSMutableDictionary * responseDictionary = [responseString JSONValue];    

    //parse the response
    NSString * zipCode = [self getZipCodeFromResponse:responseDictionary];    

    //valid zipcode only in US.
    if ([zipCode length]==5) {
        
        //tells that succesffully completed the zipcode fetch
        [self successfulLocationUpdate];
        
        //check the zipcode
        if ([self isValidZipCode:zipCode]) 
        {
            //save to datastore
            NSString * cityName = [[ManagedObjectContextHandler sharedInstance] getCityNameForZipcode:zipCode];
            JobRequest * jobRequest  = [[RBSavedStateController sharedInstance] jobRequest];
            [jobRequest.location setValue:zipCode forKey:KEY_LOCATION_ZIP];
            [jobRequest.location setValue:LOCATION_TYPE_GPS forKey:KEY_LOCATION_TYPE];
            [jobRequest.location setValue:cityName forKey:KEY_LOCATION_CITYNAME];
            [self newLocationSaved];
        }
        
    }   
    else {
        
        //zipcode fetching resulted in errors
        [self failedLocationUpdate];
        
        [RBAlertMessageHandler showAlert:@"Your location cannot be identified"
                          delegateObject:nil];
    }
}

- (NSString*)getZipCodeFromResponse:(NSMutableDictionary*)response 
{
    NSString * zipCode = nil;
    NSMutableArray * results = [response valueForKey:@"results"];
    
    for (NSDictionary * result in results) {        
        NSArray * types = [result valueForKey:@"types"];
        
        for (NSString * type in types) {
            if ([type isEqualToString:@"postal_code"]) {
                NSArray * addressComponents = [result valueForKey:@"address_components"];
                
                for (NSDictionary * component in addressComponents) {
                    NSArray * types = [component valueForKey:@"types"];
                    for (NSString * type in types) {
                        if ([type isEqualToString:@"postal_code"]) {
                            zipCode = [component valueForKey:@"long_name"];
                        }
                        else if ([type isEqualToString:@"locality"]){
                            
                        }
                    } 
                }
            }
        }
        
    }
    return zipCode;
}
- (BOOL)isValidZipCode:(NSString*)zipcode 
{
    BOOL isValid;
    isValid = [[ManagedObjectContextHandler sharedInstance] isZipcodeExists:zipcode];
    if (!isValid) {
        [RBAlertMessageHandler showAlertWithTitle:AS_INVALID_ZIPCODE_ALERT_TITLE 
                                          message:AS_INVALID_ZIPCODE_ALERT_MESSAGE 
                                   delegateObject:nil 
                                          viewTag:1 
                                 otherButtonTitle:@"OK" 
                                       showCancel:NO];
        
    }
    return isValid;
}

- (void)newLocationSaved {
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(newLocationDidSaved)])
        [self.delegate newLocationDidSaved];
}

- (void)failedLocationUpdate
{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(locationFetchCompletedWithErrors)])
        [self.delegate locationFetchCompletedWithErrors];
}

- (void)successfulLocationUpdate
{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(locationFetchCompletedSuccessfully)])
        [self.delegate locationFetchCompletedSuccessfully];
}

#pragma mark- Facebook Delegates

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [logindelegate handleOpenURL:url];

}


@end
