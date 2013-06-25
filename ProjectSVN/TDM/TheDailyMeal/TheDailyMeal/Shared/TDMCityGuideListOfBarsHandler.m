//
//  TDMCityGuideListOfBarsHandler.m
//  TheDailyMeal
//
//  Created by Apple on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMCityGuideListOfBarsHandler.h"
#import "TDMRestaurantDetails.h"

@implementation TDMCityGuideListOfBarsHandler
@synthesize barDelegate;
-(void)getListOfBarsForCity:(NSString *)cityName : (NSString *)guideType :(int) count:(int)offset{
    
    //NSLog(@"city name before replacing %@",cityName);
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    guideType = [guideType stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString * listOfBarsAPIURLString = [NSString stringWithFormat:@"%@%@%@%@%@%d%@%d",@"/app/guide?parameters[city_name]=",cityName,@"&parameters[guide_type]=",guideType,@"&parameters[count]=",count,@"&parameters[offset]=",offset];
    listOfBarsAPIURLString = [listOfBarsAPIURLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //NSLog(@"%@",listOfBarsAPIURLString);
    //listOfBarsAPIURLString = @"/app/guide?parameters[city_name]=Austin&parameters[guide_type]=Best%20Bars";
    [self getRequest:listOfBarsAPIURLString withRequestType:kTDMCityGuideListOfRestaurants];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error in finding bars");
    [self trackRequestError:request];
    //[restaurantDelegate errorInNetwork];
    [barDelegate errorInFindingBars];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"Found bars in city %@",request.responseString);
    //NSLog(@"From TDM List of Restaurants Request Finished %@",[[request responseString] JSONValue]);
    NSMutableArray *restaurantsJSONResponseArray = [request.responseString JSONValue];
    if([restaurantsJSONResponseArray count] == 0)
    {
        //[restaurantDelegate noCityRestaurantsFound];
        [barDelegate noCityBarsFound];
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
            NSDictionary *restaurantImage  = [field_venue_image
                                              objectAtIndex:0];
            //NSLog(@"image is %@\n",[restaurantImage objectForKey:@"value"]);
            [tempdictionary setObject:[restaurantImage objectForKey:@"value"] forKey:@"image"];
            //NSLog(@"Before tempDictionary %@",tempdictionary);
            [finalDictionaryArray addObject:tempdictionary];
            
            //[tempdictionary removeAllObjects];
            //NSLog(@"******added object %@ to final array %@ to array index %d******\n",tempdictionary,finalDictionaryArray,[finalDictionaryArray count]-1);
            //        NSLog(@"Latitude is %@",[tempdictionary objectForKey:@"latitude"]);
            //        NSLog(@"Longitude is %@",[tempdictionary objectForKey:@"longitude"]);
            //        
            [tempdictionary release];
        }

        [[TDMRestaurantDetails sharedCityBarDetails]initializeCityBarHeaders:finalDictionaryArray];

        [barDelegate foundCityBars];
    }
    [delegate requestCompletedSuccessfully:request];
}

@end
