//
//  TDMFoursquareSearchService.m
//  TheDailyMeal
//
//  Created by Apple on 26/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMFoursquareSearchService.h"
#import "BussinessModel.h"
#import "Constants.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Bearing.h"

@implementation TDMFoursquareSearchService

@synthesize searchDelegate,searchItems,restaurantName;

//- (void)searchForName:(NSString *)text
- (void)searchForName:(NSString *)text withSearchType:(SearchType)searchType_
{
    if ([Reachability connected]) {
        searchType = searchType_;
        text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
        NSString *longitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE]];
        NSString *latitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE]];
        
        NSString *apiString = [NSString stringWithFormat:@"%@v2/venues/search?&radius=9999&client_id=%@&client_secret=%@&ll=%@,%@&query=%@",FOURSQURE_SERVER_URL,FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,latitude, longitude,text];
        
        [self getRequest:apiString];

    }
    else
    {
        if(self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(networkError)])
        {
            [self.searchDelegate networkError];
        }
    }
}

- (void)searchForBrowseName:(NSString *)text
{
    text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    NSString *longitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE]];
    NSString *latitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE]];
    
    NSString *apiString = [NSString stringWithFormat:@"%@v2/venues/search?intent=browse&radius=9999&client_id=%@&client_secret=%@&ll=%@,%@&query=%@",FOURSQURE_SERVER_URL,FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,latitude, longitude,text];
    
    ;
    [self getRequest:apiString];
}

- (void)searchForName:(NSString *)name withAddress:(NSString *)address withSearchType:(SearchType)searchType_{
    
    self.restaurantName = name;
    isAddressSearch = YES;
    searchType = searchType_;
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    
//    NSString *apiString = [NSString stringWithFormat:@"http://open.mapquestapi.com/nominatim/v1/search?countrycodes=US&format=json&polygon=0&addressdetails=1&q=%@",address];

    NSString *apiString = [NSString stringWithFormat:@"http://www.mapquestapi.com/geocoding/v1/address?key=%@&inFormat=kvp&outFormat=json&location=%@",MAPQUEST_APPKEY,address];

    [self getRequest:apiString];
}

- (void)parseAddressSearch:(id)result {

    //searchType = SearchTypeRestaurant;

//    NSMutableArray *clLocation = [[NSMutableArray alloc]init];
//    CLLocation *sw=nil;
//    CLLocation *ne=nil;
//    NSDictionary *placeDictionary = nil;
//    if([result isKindOfClass:[NSArray class]]){
//        
//        for (NSDictionary *location in result) {
//            CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[location objectForKey:@"lat"] doubleValue] longitude:[[location objectForKey:@"lon"] doubleValue]];
//            
//            if([location objectForKey:@"lat"] && [location objectForKey:@"lon"])
//                [clLocation addObject:loc];
//        }
//
//        BOOL needBreak = NO;
//        for (int i=0; i<[clLocation count]; i++) {
//            CLLocation *firstLoc = [clLocation objectAtIndex:i];
//            for (int j = i+1; j<[clLocation count]; j++) {
//                CLLocation *locCheck = [clLocation objectAtIndex:j];
//                NSLog(@"%f",locCheck.coordinate.latitude);
//                NSLog(@"%f",locCheck.coordinate.longitude);
//                
//                CLLocationBearing bearing = [firstLoc bearingToLocation:locCheck];
//                NSLog(@"bearring %@",NSLocalizedStringFromBearing(bearing));
//                if([NSLocalizedStringFromBearing(bearing) isEqualToString:@"SouthWest"])
//                {
//                    sw = locCheck;
//                    ne = firstLoc;
//                    
//                    NSLog(@"%f",sw.coordinate.latitude);
//                    
//                    needBreak = YES;
//                }
//            }
//        }
//         placeDictionary = [result objectAtIndex:0];
//    }
//    else
//        placeDictionary = result;
    
    NSString *latitude ;
    NSString *longitude ;
    
    NSArray *results = [result objectForKey:@"results"];
    if([results count]>0){
        NSDictionary *firstResult = [results objectAtIndex:0];
        NSArray *locations = [firstResult objectForKey:@"locations"];
        if([locations count]>0){
            
            NSDictionary *firstLocation = [locations objectAtIndex:0];
            NSDictionary *latlon = [firstLocation objectForKey:@"latLng"];
            latitude = [latlon objectForKey:@"lat"];
            longitude = [latlon objectForKey:@"lng"];
        }
    }

    
    restaurantName = [restaurantName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSString *url = [NSString stringWithFormat:@"%@/v2/venues/search?&intent=browse&client_id=%@&client_secret=%@&query=%@&ne=%f,%f&sw=%f,%f",FOURSQURE_SERVER_URL,FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,restaurantName,ne.coordinate.latitude,ne.coordinate.longitude,sw.coordinate.latitude,sw.coordinate.longitude];
    
    NSString *apiString = [NSString stringWithFormat:@"%@v2/venues/search?&radius=99999&client_id=%@&client_secret=%@&ll=%@,%@&query=%@",FOURSQURE_SERVER_URL,FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,latitude, longitude,restaurantName];

    
    NSLog(@"%@",apiString);
    isAddressSearch = NO;
    if([Reachability connected])
    {
        //searchType = SearchTypeRestaurant;
        [self getRequest:apiString];
    }
    else
    {
        if(self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(networkError)])
        {
            [self.searchDelegate networkError];
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    NSLog(@"response %@",request.responseString);
    if (request.responseStatusCode == 200) {
        NSString * responseString = [request responseString];
        NSDictionary *responseDictionary = [responseString JSONValue];
        
            if([responseDictionary count] == 0){
                [self.searchDelegate searchSuccessfullWithResults:self.searchItems];
                return;   
            }
        
        if(isAddressSearch){
            [self parseAddressSearch:responseDictionary];
            return;
        }
        NSDictionary *meta = [responseDictionary objectForKey:@"meta"];
        int status = [[meta objectForKey:@"code"] intValue];
        NSMutableArray *searchedItems = [[NSMutableArray alloc] init];
        if(status == 200){
            
            
            NSDictionary *response = [responseDictionary objectForKey:@"response"];
            NSArray *groups = [response objectForKey:@"groups"];
            NSDictionary *groupsDictionary = [groups objectAtIndex:0];
            NSString *groupsDictionaryType = [groupsDictionary objectForKey:@"type"];
            if([groupsDictionaryType isEqualToString:@"places"]){
                
                NSArray *items = [groupsDictionary objectForKey:@"items"];
                int itemsCount = [items count];
                
                for (int i = 0; i < itemsCount; i++) {
                    NSDictionary *itemDictionary = [items objectAtIndex:i];
                    BussinessModel *tempBarModel= [[BussinessModel alloc] initWithJson:itemDictionary];
                    
                    NSArray *parentsArray = nil;
                    if(searchType == SearchTypeRestaurant)
                        parentsArray = [[NSArray alloc] initWithObjects:@"Food", nil];
                    else if(searchType == SearchTypeBars)
                        parentsArray = [[NSArray alloc] initWithObjects:@"Nightlife Spots",nil];
                    
                    NSMutableSet* expectedParents = [NSMutableSet setWithArray:parentsArray];
                    NSMutableSet* recievedParents = [NSMutableSet setWithArray:tempBarModel.parent];
                    [expectedParents intersectSet:recievedParents]; //this will give you only the obejcts that are in both sets
                    
                    NSArray* result = [expectedParents allObjects];   
                    if([result count] > 0)
                        [searchedItems addObject:tempBarModel];
                    [tempBarModel release];
                    tempBarModel = nil;
                    
                    [parentsArray release];
                }
            }
        }
        
        //sort the entris using 'locationDistance'
        NSSortDescriptor *sortDescriptor;        
        sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"locationDistance"
                                                      ascending:YES] autorelease];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];      
        NSArray * sortedArray = [searchedItems sortedArrayUsingDescriptors:sortDescriptors];     
        NSMutableArray * sortedMArray = [[NSMutableArray alloc] initWithArray:sortedArray];
        self.searchItems = sortedMArray;
        [sortedMArray release];
        [searchedItems release];
        
        [self.searchDelegate searchSuccessfullWithResults:self.searchItems];

    }
    else {
        if(self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(failedToSearch)])
        {
            [self.searchDelegate failedToSearch];
        }
    }
   
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if(request.responseStatusCode == 2)
    {
        if(self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(requestTimeout)])
        {
            [self.searchDelegate requestTimeout];
        }
    }
    else{
    [self.searchDelegate failedToSearch];
    }
}

- (void)dealloc {
    
    self.restaurantName = nil;
    self.searchItems = nil;
    self.searchDelegate = nil;
    [super dealloc];
}

@end
