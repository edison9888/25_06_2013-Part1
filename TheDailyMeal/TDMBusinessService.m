//
//  TDMBusinessService.m
//  TheDailyMeal
//
//  Created by Apple on 14/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessService.h"

#import "BussinessModel.h"
#import "Reachability.h"

@implementation TDMBusinessService

@synthesize  serviceDelegate;

-(void) getBars {
    //searchCriteria = SEARCH_BAR_CRITERIA;
    [self callService:SEARCH_BAR_CRITERIA];
}

-(void) getRestauarnts {    
    
    //searchCriteria = SEARCH_RESTURANT_CRITERIA;
    [self callService:SEARCH_RESTURANT_CRITERIA];        
}

-(void) getCityGuide{
    
    NSString *url = [[TDMDataStore sharedStore].guideType stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [self callService:url];
}

-(void) callService:(NSString *)searchText{
    
        if ([Reachability connected]) 
        {
            NSString *url = [NSString stringWithFormat:@"%@%@",FOURSQURE_SERVER_URL,kBusinessAndStatusApi];
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSMutableDictionary * getParams = [[NSMutableDictionary alloc] init];
            [getParams setObject:FOURSQUARE_CLIENTID forKey:kFourSquareClientID];
            [getParams setObject:FOURSQUARE_SECRETID forKey:kFourSquareSecretID]; 
            [getParams setObject:LATITUDE_And_LONGITUDE forKey:kLatitudeAndLongitude];
            [getParams setObject:searchText forKey:FOURSQUARE_QUERY];
            [getParams setObject:[self getCurrentDateFormat] forKey:DATE_STRING];
            [self getRequest:url withParams:getParams];
            [getParams release];
            getParams = nil;   
            if(pool)
                [pool drain];
        }
        else
        {
                if (self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(networkError)]) {
                    [serviceDelegate networkError];
                }

        }
}

-(void)clearDelegate{
    self.serviceDelegate=nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request  {   
    
    if(request.responseStatusCode == 200)
    {
        NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
        NSDictionary * jsonResponseDictionary = [request.responseString JSONValue];
        if ([jsonResponseDictionary count]>=1) {
            if ([[jsonResponseDictionary objectForKey:@"response"] isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary *response = [jsonResponseDictionary objectForKey:@"response"];
                if ([[response objectForKey:@"venues"] isKindOfClass:[NSArray class]]) {
                    NSArray * venuesArray = [response objectForKey:@"venues"];
                    for(NSDictionary * currentVenueDetailsDictionary in venuesArray) {
                        BussinessModel *tempBarModel= [[[BussinessModel alloc]init]autorelease];
                        if([[currentVenueDetailsDictionary objectForKey:@"id"] isKindOfClass:NSClassFromString(@"NSString")]) {
                            tempBarModel.fourSquareId = [currentVenueDetailsDictionary objectForKey:@"id"];
                        }
                        if([[currentVenueDetailsDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")]) {
                            tempBarModel.name = [currentVenueDetailsDictionary objectForKey:@"name"];
                        }
                        if ([[currentVenueDetailsDictionary objectForKey:@"contact"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *contact = [currentVenueDetailsDictionary objectForKey:@"contact"]; 
                            if([[contact objectForKey:@"phone"] isKindOfClass:NSClassFromString(@"NSString")]) {
                               
                                tempBarModel.contactPhone = [contact objectForKey:@"phone"];
                            }
                            if([[contact objectForKey:@"formattedPhone"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.contactFormattedPhone = [contact objectForKey:@"formattedPhone"];
                            }
                        }
                        else {
                            NSLog(@"Contact received Incorrectly");
                        }
                        if ([[currentVenueDetailsDictionary objectForKey:@"location"] isKindOfClass:[NSMutableDictionary class]]) {                    
                            NSMutableDictionary *location = [currentVenueDetailsDictionary objectForKey:@"location"];
                            if([[location objectForKey:@"address"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.locationAddress = [location objectForKey:@"address"] ;
                            }
                            tempBarModel.locationLatitude = [location objectForKey:@"lat"];
                            tempBarModel.locationLongitude = [location objectForKey:@"lng"];
                            if([[location objectForKey:@"postalCode"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.locationPostalCode = [location objectForKey:@"postalCode"] ;
                            }
                            if([[location objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.locationCity = [location objectForKey:@"city"];
                            }
                            if([[location objectForKey:@"state"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.locationState = [location objectForKey:@"state"];
                            }
                            if([[location objectForKey:@"country"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                tempBarModel.locationCountry = [location objectForKey:@"country"];
                            }
                            if([location objectForKey:@"distance"] != nil && [NSNull  null] != (NSNull *)[location objectForKey:@"distance"]) {
                                double distance = [[location objectForKey:@"distance"] doubleValue];
                                
                                tempBarModel.locationDistance = [NSString stringWithFormat:@"%0.2f",distance*0.000621371192];                            
                            }
                        }
                        else {
                            NSLog(@"Location not in correct format");                        
                        }
                        if ([[currentVenueDetailsDictionary objectForKey:@"categories"] isKindOfClass:[NSMutableArray class]]) {
                            NSMutableArray *categoryArray = [currentVenueDetailsDictionary objectForKey:@"categories"];
                            if([categoryArray count]>=1) {
                                NSDictionary *categoryDictionary = [categoryArray objectAtIndex:0];
                                if([[categoryDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                    tempBarModel.categoryName = [categoryDictionary objectForKey:@"name"];
                                }
                                else {
                                    tempBarModel.categoryName = @"";
                                }
                                if([[categoryDictionary objectForKey:@"id"] isKindOfClass:NSClassFromString(@"NSString")]) {
                                    tempBarModel.categoryID = [categoryDictionary objectForKey:@"id"];
                                }
                                NSDictionary *catergoryIcons = nil;
                                if ([categoryDictionary objectForKey:@"icon"] != nil) {
                                    catergoryIcons = [categoryDictionary objectForKey:@"icon"];
                                }
                                tempBarModel.categoryIcons = catergoryIcons;
                            }
                        }
                        //adding tempBarModel to array
                        [finalDictionaryArray addObject:tempBarModel];
                    }
                }
                else {
                    NSLog(@"Venues received Incorrectly");
                }
            }
            else {
                NSLog(@"Response received Incorrectly");
            }
        }
    //returning the BusinessResturantModel Class objects
        if (self.serviceDelegate && [self.serviceDelegate  respondsToSelector:@selector(serviceResponse:)]) {
            
            NSSortDescriptor *sortDescriptor;        
            sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"locationDistance"
                                                          ascending:YES] autorelease];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];      
            NSArray * sortedArray = [finalDictionaryArray sortedArrayUsingDescriptors:sortDescriptors];     
            NSMutableArray * sortedMArray = [[NSMutableArray alloc] initWithArray:sortedArray];
            [serviceDelegate serviceResponse:[sortedMArray autorelease]];
        }
        else {
            NSLog(@"JSon response is nil");
        }
    }
    else
    {
        if(self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(bussinessServiceFailed)])
        {
            [self.serviceDelegate bussinessServiceFailed];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    if(request.responseStatusCode == 2)
    {
        if(self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(requestTimeout)])
        {
            [self.serviceDelegate requestTimeout];
        }
    }
    else
    {
        if(self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(bussinessServiceFailed)])
        {
            [self.serviceDelegate bussinessServiceFailed];
        }
    }
    [super requestFailed:request];
}

- (NSString *)getCurrentDateFormat {
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate];
    NSInteger day = [dateComponents day];
    dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:currentDate];
    NSInteger month = [dateComponents month];
    dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:currentDate];
    NSInteger year = [dateComponents year];
    NSString *dateValue = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    return dateValue;
}


- (void)dealloc {
    
    self.serviceDelegate = nil;
    [super dealloc];
}

@end
