//
//  TDMCityGuideListOfRestaurantsHandler.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMCityGuideListOfRestaurantsHandler.h"
#import "TDMRestaurantDetails.h"

@implementation TDMCityGuideListOfRestaurantsHandler
@synthesize restaurantDelegate;

-(void)getListOfRestaurantsForCity:(NSString *)cityName:(NSString *)guideType:(int) count:(int)offset{
    
    //NSLog(@"city name before replacing %@",cityName);
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    guideType = [guideType stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    //NSLog(@"guide type %@",guideType);
    NSString * listOfRestaurantsAPIURLString = [NSString stringWithFormat:@"%@%@%@%@",@"/app/guide?parameters[city_name]=",cityName,@"&parameters[guide_type]=",guideType];
    //NSLog(@"sending request %@",listOfRestaurantsAPIURLString);
    [self getRequest:listOfRestaurantsAPIURLString withRequestType:kTDMCityGuideListOfRestaurants];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error restaurant json");
    [self trackRequestError:request];
    [restaurantDelegate errorInNetwork];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"restaurant json%@",request.responseString);
    //NSLog(@"From TDM List of Restaurants Request Finished %@",[[request responseString] JSONValue]);
    NSMutableArray *restaurantsJSONResponseArray = [request.responseString JSONValue];
    if([restaurantsJSONResponseArray count] == 0)
    {
        [restaurantDelegate noCityRestaurantsFound];
    }
    //NSLog(@"response Dictionary is %@",restaurantsJSONResponseArray);
    //NSLog(@"size is %d",[restaurantsJSONResponseArray count]);
    
    //NSMutableDictionary *cityRestaurantsDictionay = [[NSMutableDictionary alloc]init];
    else
    {

    NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *dictionay in restaurantsJSONResponseArray) {
        
        NSMutableDictionary *tempdictionary = [[NSMutableDictionary alloc]init];
        
        //NSLog(@"title of restaurant %@\n",[dictionay objectForKey:@"title"]);
        [tempdictionary setObject:[dictionay objectForKey:@"title"] forKey:@"title"];
        NSMutableDictionary *location  =[dictionay objectForKey:@"location"];
        //NSLog(@"street is %@\n",[location objectForKey:@"street"]);
        [tempdictionary setObject:[location objectForKey:@"street"] forKey:@"street"];
        //NSLog(@"city is %@\n",[location objectForKey:@"city"]);
        [tempdictionary setObject:[location objectForKey:@"city"] forKey:@"city"];
        //NSLog(@"province is %@\n",[location objectForKey:@"province"]);
        [tempdictionary setObject:[location objectForKey:@"province"] forKey:@"province"];
        //NSLog(@"postal_code is %@\n",[location objectForKey:@"postal_code"]);
        [tempdictionary setObject:[location objectForKey:@"postal_code"] forKey:@"postal_code"];
        //NSLog(@"phone is %@\n",[location objectForKey:@"phone"]);
        [tempdictionary setObject:[location objectForKey:@"phone"] forKey:@"phone"];
        [tempdictionary setObject:[location objectForKey:@"latitude"] forKey:@"latitude"];
        [tempdictionary setObject:[location objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSMutableArray *field_venue_website = [dictionay objectForKey:@"field_venue_website"];
        NSDictionary *websiteDictionary  = [field_venue_website objectAtIndex:0];
        //NSLog(@"web site is %@\n",[websiteDictionary objectForKey:@"url"]);
        [tempdictionary setObject:[websiteDictionary objectForKey:@"url"] forKey:@"url"];
        NSMutableArray *field_venue_image = [dictionay objectForKey:@"field_venue_image"];
        NSDictionary *restaurantImage  = [field_venue_image objectAtIndex:0];
        //NSLog(@"image is %@\n",[restaurantImage objectForKey:@"value"]);
        if([[restaurantImage objectForKey:@"value"] isKindOfClass:NSClassFromString(@"NSString")])
            [tempdictionary setObject:[restaurantImage objectForKey:@"value"] forKey:@"image"];
        else
            [tempdictionary setObject:@"" forKey:@"image"];
        [finalDictionaryArray addObject:tempdictionary];
        [tempdictionary release];
    }
        NSLog(@"final array %@",finalDictionaryArray);
        if([[TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders count]>0)
        {
            [[TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders removeAllObjects];
        }
        
        
        NSLog(@"Before initializing %@",[TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders);   
        
    [[TDMRestaurantDetails sharedCityRestaurantDetails] initializeCityRestaurantHeaders:finalDictionaryArray];
    NSLog(@"final dictionary array %@",finalDictionaryArray);
         NSLog(@"After initializing %@",[TDMRestaurantDetails sharedCityRestaurantDetails].cityRestaurantsHeaders);
    [restaurantDelegate foundCityRestaurants];
    }
    [delegate requestCompletedSuccessfully:request];
} 

@end
