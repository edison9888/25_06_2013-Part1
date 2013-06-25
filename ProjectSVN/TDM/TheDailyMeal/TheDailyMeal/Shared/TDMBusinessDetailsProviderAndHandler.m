//
//  TDMBusinessDetailsProviderAndHandler.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//
#import "TDMBusinessDetailsProviderAndHandler.h"
#import "Business.h"
#import "TDMRestaurantDetails.h"

@implementation TDMBusinessDetailsProviderAndHandler

@synthesize businessDetailsDelegate;
@synthesize groups;
@synthesize responseDictionary;
@synthesize response     ;
@synthesize insideDictionary;
@synthesize itemsArray ;
@synthesize itemDictionary;    
@synthesize contacts;
@synthesize location;
@synthesize categories; 
@synthesize categoryInsideCategories;
@synthesize parentArray;
@synthesize stats;
@synthesize specials;
@synthesize hereNow;        
@synthesize businessDetailsArary;
@synthesize searchCriteria;

#pragma mark -



#pragma mark - API Params


#pragma mark -

#pragma mark TDMBusinessDetailsProviderAndHandler Methods
-(void)dealloc
{
     [groups release];
     [responseDictionary release];
     [response release];
     [insideDictionary release];
     [itemsArray release];
     [itemDictionary release];    
     [contacts release];
     [location release];
     [categories release]; 
     [categoryInsideCategories release];
     [parentArray release];
     [stats release];
     [specials release];
     [hereNow release];        
     [businessDetailsArary release];    
}
- (void)getCurretLocationBusinessdetailsForQuery:(NSString *)query 
                             forLatitude:(double)latitude 
                            andLongitude:(double)longitude
{

    searchCriteria = [NSString stringWithString:query];
    NSLog(@"query %@",query);
    NSString * const kLatitudeAndLongitude = @"ll";
    NSString * const kFourSquareClientID = @"client_id";
    NSString * const kFourSquareSecretID = @"client_secret";
    NSString * const kBusinessAndStatusApi = @"/v2/venues/search?intent=browse&radius=9999&";
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = kBusinessAndStatusApi;
    
    NSMutableDictionary * getParams = [[NSMutableDictionary alloc] init];
    
    NSString * keyFourSquareclientID = kFourSquareClientID;
    NSString * valueFourSquareClientID= FOURSQUARE_CLIENTID;
    [getParams setObject:valueFourSquareClientID forKey:keyFourSquareclientID];
    
    
    NSString * keyFousquareSecretID = kFourSquareSecretID;
    NSString * valueFourSquareSecretID = FOURSQUARE_SECRETID;
    [getParams setObject:valueFourSquareSecretID forKey:keyFousquareSecretID];
    
    
    NSString *latitudeAndLongitude = [NSString stringWithFormat:@"%f,%f",latitude,longitude];
    NSString * keyLatitudeAndLongitude = kLatitudeAndLongitude;
    NSString * valueLatitudeAndLongitude = latitudeAndLongitude;
    [getParams setObject:valueLatitudeAndLongitude forKey:keyLatitudeAndLongitude];
    
    
    NSString *queryString = [NSString stringWithString:@"query"];
    NSString *queryValue = [NSString stringWithString:query];
    [getParams setObject:queryValue forKey:queryString];
    
    
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate];
    NSInteger day = [dateComponents day];
    dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:currentDate];
    NSInteger month = [dateComponents month];
    dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:currentDate];
    NSInteger year = [dateComponents year];
    NSLog(@"%@ %d %d %d",currentDate,year,month,day);
    
    
    NSString *date = [NSString stringWithString:@"v"];
    NSString *dateValue = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    [getParams setObject:dateValue forKey:date];
    NSLog(@"getParams %@",getParams);
    
   
    [self getRequest:apiName withParams:getParams withRequestType:kCurrentLocationBusinessDetails];
    
    [getParams release];
    getParams = nil;    
    
    if(pool)
        [pool drain];
}

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
    NSDictionary * jsonResponseDictionary = [[request responseString] JSONValue];
    if ([jsonResponseDictionary count]!=0)
    {
        response = [jsonResponseDictionary objectForKey:@"response"];
        NSArray * venuesArray = [response objectForKey:@"venues"];
        NSLog(@"Venue array size is %d",[venuesArray count]);
        for(NSDictionary * currentVenueDetailsDictionary in venuesArray)
        {
            NSMutableDictionary *tempdictionary = [[NSMutableDictionary alloc]init];
            //foursquareID
            NSLog(@"foursquare id %@",[currentVenueDetailsDictionary objectForKey:@"id"]);
            if([[currentVenueDetailsDictionary objectForKey:@"id"] isKindOfClass:NSClassFromString(@"NSString")])
                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"id"] forKey:@"id"];
            else
                [tempdictionary setObject:@"" forKey:@"id"];
            //title
            if([[currentVenueDetailsDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")])
                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"name"] forKey:@"name"];
            else
                [tempdictionary setObject:@"" forKey:@"name"];
            //phone
            NSDictionary *contact = [[NSDictionary alloc]init];
            contact = [currentVenueDetailsDictionary objectForKey:@"contact"];
            if([[contact objectForKey:@"phone"] isKindOfClass:NSClassFromString(@"NSString")])
               [tempdictionary setObject:[contact objectForKey:@"phone"] forKey:@"phone"];
            else
                [tempdictionary setObject:@"" forKey:@"phone"];
            //formattedPhone
            if([[contact objectForKey:@"formattedPhone"] isKindOfClass:NSClassFromString(@"NSString")])
                [tempdictionary setObject:[contact objectForKey:@"formattedPhone"] forKey:@"formattedphone"];
            else
                [tempdictionary setObject:@"" forKey:@"formattedphone"];
            location = [[NSMutableDictionary alloc]init];
            //location dictionary
            location = [currentVenueDetailsDictionary objectForKey:@"location"];
            //address
            if([[location objectForKey:@"address"] isKindOfClass:NSClassFromString(@"NSString")])
                [tempdictionary setObject:[location objectForKey:@"address"] forKey:@"address"];
            else
                [tempdictionary setObject:@"" forKey:@"address"];
            //latitude and longitude
            [tempdictionary setObject:[location objectForKey:@"lat"] forKey:@"latitude"];
            [tempdictionary setObject:[location objectForKey:@"lng"] forKey:@"longitude"];
            //postalcode
//            if([[location objectForKey:@"postalCode"] isKindOfClass:NSClassFromString(@"NSString")])
//            [tempdictionary setObject:[location objectForKey:@"postalCode"] forKey:@"postalcode"];
//            else
//                [tempdictionary setObject:[location objectForKey:@"postalCode"] forKey:@"postalcode"];
            //city
            if([[location objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")])
            [tempdictionary setObject:[location objectForKey:@"city"] forKey:@"city"];
            else
                [tempdictionary setObject:@"" forKey:@"city"];
            //state
            if([[location objectForKey:@"state"] isKindOfClass:NSClassFromString(@"NSString")])
            [tempdictionary setObject:[location objectForKey:@"state"] forKey:@"state"];
            else
                [tempdictionary setObject:@"" forKey:@"state"];
            //country
            if([[location objectForKey:@"country"] isKindOfClass:NSClassFromString(@"NSString")])
            [tempdictionary setObject:[location objectForKey:@"country"] forKey:@"country"];
            else
                [tempdictionary setObject:@"" forKey:@"country"];
            NSMutableArray *categoryArray = [[NSMutableArray alloc]init];
            categoryArray = [currentVenueDetailsDictionary objectForKey:@"categories"];
            NSDictionary *categoryDictionary = [[NSDictionary alloc]init];
            if([categoryArray count]>=1)
            {
                categoryDictionary = [categoryArray objectAtIndex:0];
            }
            //category name
            if([[categoryDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")])
            [tempdictionary setObject:[categoryDictionary objectForKey:@"name"] forKey:@"category"];
            else
                [tempdictionary setObject:@"" forKey:@"category"];
            //url
            if([[currentVenueDetailsDictionary objectForKey:@"url"] isKindOfClass:NSClassFromString(@"NSString")])
                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"url"] forKey:@"url"];
            else
                [tempdictionary setObject:@"" forKey:@"url"];
            //adding tempdictionary to array
            [finalDictionaryArray addObject:tempdictionary];
           [tempdictionary release];           
        }
        //NSLog(@"final array %@",finalDictionaryArray);
        NSLog(@"criteria search %@",searchCriteria);
    if([[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders count]>0)
    {
        [[TDMRestaurantDetails sharedResturantDetails].restaurantHeaders removeAllObjects];
    }
    if([[TDMRestaurantDetails sharedResturantDetails].barHeaders count]>0)
    {
        [[TDMRestaurantDetails sharedResturantDetails].barHeaders removeAllObjects];
    }
        if([searchCriteria isEqualToString:@"restaurants"])
        {
            NSLog(@"final restaurant array %@ at %d",finalDictionaryArray,[finalDictionaryArray count]);;
            [[TDMRestaurantDetails sharedResturantDetails] initializeRestaurantHeaders:finalDictionaryArray];
        }
        else
        {
            [[TDMRestaurantDetails sharedBarDetails]initializeBarHeaders:finalDictionaryArray];
        }
    //[finalRestaurantArray release];
    //[filteredCategoriesArray release];
    //[finalBarArray release];
    }
    [businessDetailsDelegate gotRestaurantDetails];
    [delegate requestCompletedSuccessfully:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [businessDetailsDelegate failedToFetchRestaurantDetails];
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}
#pragma mark -


@end
