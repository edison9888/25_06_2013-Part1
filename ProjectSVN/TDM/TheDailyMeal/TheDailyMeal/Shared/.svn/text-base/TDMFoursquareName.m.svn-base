//
//  TDMFoursquareName.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMFoursquareName.h"

@implementation TDMFoursquareName

-(void)makeFourSquareNameRequestWithQuery:(NSString *)query 
                              forLatitude:(float)latitude 
                             andLongitude:(float)longitude 
{
    //https://api.foursquare.com/v2/venues/search?&radius=9999&client_id=%s&client_secret=%s&ll=%f,%f&query=%s
    
    NSString * apiURLString = [NSString stringWithFormat:@"/v2/venues/search?&radius=9999&client_id=%@&client_secret=%@&ll=%f,%f&query=%@",FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,latitude,longitude,query];
    
    NSLog(@"%@",apiURLString);
    
    [self getRequest:apiURLString withRequestType:kTDMFoursquareName];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM Foursquare Name Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 
@end
