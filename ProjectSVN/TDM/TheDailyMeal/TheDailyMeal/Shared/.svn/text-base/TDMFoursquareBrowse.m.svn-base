//
//  TDMFoursquareBrowse.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMFoursquareBrowse.h"
#import "TDMRestaurantDetails.h"
@implementation TDMFoursquareBrowse

@synthesize foursquareBrowseDelgate;

-(void)makeFourSquareBrowseRequestWithQuery:(NSString *)query 
                                forLatitude:(float)latitude 
                               andLongitude:(float)longitude 
{
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate];
    NSInteger day = [dateComponents day];
    dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:currentDate];
    NSInteger month = [dateComponents month];
    dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:currentDate];
    NSInteger year = [dateComponents year];
    NSLog(@"%@ %d %d %d",currentDate,year,month,day);
    
    //https://api.foursquare.com/v2/venues/search?intent=browse&radius=9999&client_id=%s&client_secret=%s&ll=%f,%f&query=%s
    query =[query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * apiURLString = [NSString stringWithFormat:@"/v2/venues/search?intent=browse&radius=9999&client_id=%@&client_secret=%@&ll=%f,%f&query=%@&v=%@",FOURSQUARE_CLIENTID,FOURSQUARE_SECRETID,latitude,longitude,query,[NSString stringWithFormat:@"%d%02d%02d",year,month,day]];
    NSLog(@"%@",apiURLString);
    

    
    [self getRequest:apiURLString withRequestType:kTDMFoursquareBrowse];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM Foursquare Browse Request Finished %@",[[request responseString] JSONValue]);
    NSLog(@"response string %@",request.responseString);
    NSDictionary * jsonResponseDictionary = [[request responseString] JSONValue];
    if ([jsonResponseDictionary count]!=0)
    {
        NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
        NSDictionary * response = [jsonResponseDictionary objectForKey:@"response"];
    
        NSArray * venuesArray = [response objectForKey:@"venues"];
    
        for (NSDictionary * currentVenueDetailsDictionary in venuesArray) 
        {
            NSMutableDictionary *tempdictionary = [[NSMutableDictionary alloc]init];
            NSLog(@"name is %@",[currentVenueDetailsDictionary objectForKey:@"name"]);
            [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"name"] forKey:@"title"];
            NSDictionary *location = [[NSDictionary alloc]init];
            location = [currentVenueDetailsDictionary objectForKey:@"location"];
            NSLog(@"address is %@",[[[location objectForKey:@"address"] class] description]);
            
            if([[location objectForKey:@"address"] isKindOfClass:NSClassFromString(@"NSString")])
            {
                [tempdictionary setObject:[location objectForKey:@"address"] forKey:@"street"];
            }
            else
            {
                [tempdictionary setObject:@"" forKey:@"street"];
            }
            NSLog(@"latitude is %@",[location objectForKey:@"lat"]);
            [tempdictionary setObject:[location objectForKey:@"lat"] forKey:@"latitude"];
            NSLog(@"longitude is %@",[location objectForKey:@"lng"]);
            [tempdictionary setObject:[location objectForKey:@"lng"] forKey:@"longitude"];
            //this data is not there in the foursquare api, but whic is in the tdm api
            //so hard coding the data
            [tempdictionary setObject:@"" forKey:@"city"];
            [tempdictionary setObject:@"" forKey:@"phone"];
            [tempdictionary setObject:@"" forKey:@"postal_code"];
            [tempdictionary setObject:@"" forKey:@"province"];
            [tempdictionary setObject:@"" forKey:@"url"];
            [tempdictionary setObject:@"" forKey:@"image"];
            
            [finalDictionaryArray addObject:tempdictionary];
            [tempdictionary release];
            
        }

        NSLog(@"final array %@",finalDictionaryArray);
        [[TDMRestaurantDetails sharedCriteriaSearchDetails] initializeCriteriaHeaders:finalDictionaryArray];
    [foursquareBrowseDelgate criteriaSearchFinishedSuccessfully];
    [delegate requestCompletedSuccessfully:request];
    }

    else
    {
        [foursquareBrowseDelgate criteriaSearchNoResult];
    }
    
} 

@end
