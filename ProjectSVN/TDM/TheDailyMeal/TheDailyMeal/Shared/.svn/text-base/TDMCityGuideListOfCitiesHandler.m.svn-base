//
//  TDMCityGuideListOfCitiesHandler.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMCityGuideListOfCitiesHandler.h"

@implementation TDMCityGuideListOfCitiesHandler
@synthesize listOfCitiesHandler;

-(void)getListOfCitiesForVenueID:(int)vid andParent:(int)parent {
    NSString * listOfCitiesAPIURLString = [NSString stringWithFormat:@"/app/taxonomy_vocabulary/getTree"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:[NSNumber numberWithInt:vid] forKey:@"vid"];
    [dictionary setObject:[NSNumber numberWithInt:parent] forKey:@"parent"];
    
    NSString * listOfCitiesAPIBodyString = [dictionary JSONRepresentation];
    
    [dictionary release];
    
    //[self postRequest:listOfCitiesAPIURLString RequestBody:listOfCitiesAPIBodyString withRequestType:kTDMCityGuideListOfCities];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [listOfCitiesHandler requestFailed];
    //[delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"From TDMCityGuide List of Cities: Request Finished %@",[[request responseString] JSONValue]);
    [listOfCitiesHandler gotListOfCites];
    //[delegate requestCompletedSuccessfully:request];
} 


@end
