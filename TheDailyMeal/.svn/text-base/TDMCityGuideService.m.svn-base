//
//  TDMCityGuideService.m
//  TheDailyMeal
//
//  Created by Apple on 23/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMCityGuideService.h"
#import "BussinessModel.h"
#import "Reachability.h"



@implementation TDMCityGuideService
@synthesize cityGuideDelegate;

-(void) getCityGuideDetailsForCity:(NSString *)cityName andForGuideType:(NSString *)guideType;
{
    cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    guideType = [guideType stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/guide?parameters[city_name]=",cityName,@"&parameters[guide_type]=",guideType];
    NSLog(@"%@",url);
    
    if([Reachability connected])
    {
        [self getRequest:url];
    }
    else
    {
        if(self.cityGuideDelegate && [self.cityGuideDelegate respondsToSelector:@selector(networkErrorInCityGuide)])
        {
            [cityGuideDelegate networkErrorInCityGuide];
           // kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
        }
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    if(request.responseStatusCode == 200)
    {
        NSMutableArray *finalDictionaryArray  =[[NSMutableArray alloc]init];
        NSMutableArray *restaurantsJSONResponseArray = [request.responseString JSONValue];
        for (NSMutableDictionary *dictionay in restaurantsJSONResponseArray) {
            BussinessModel *tempBusinessModel = [[BussinessModel alloc]init];
            
            if([[dictionay objectForKey:@"nid"] isKindOfClass:NSClassFromString(@"NSString")])
            {
                tempBusinessModel.venueId = [dictionay objectForKey:@"nid"];
            }
            if([[dictionay objectForKey:@"title"] isKindOfClass:NSClassFromString(@"NSString")]) 
            {
                tempBusinessModel.name = [dictionay objectForKey:@"title"];
            }
            if([[dictionay objectForKey:@"field_venue_image"] isKindOfClass:NSClassFromString(@"NSArray")])
            {
                    NSMutableArray *field_venue_image = [dictionay objectForKey:@"field_venue_image"];
                    if([[dictionay objectForKey:@"field_venue_image"] isKindOfClass:NSClassFromString(@"NSArray")])
                    {
                        if([field_venue_image count]>0)
                        {
                        NSDictionary *restaurantImage  = [field_venue_image objectAtIndex:0];
                        if([[restaurantImage objectForKey:@"value"] isKindOfClass:NSClassFromString(@"NSString")])
                        {
                            tempBusinessModel.imageURL = [restaurantImage objectForKey:@"value"];
                        }
                    }
                }
                if([[dictionay objectForKey:@"field_venue_website"] isKindOfClass:NSClassFromString(@"NSArray")])
                {
                    NSMutableArray *field_venue_website = [dictionay objectForKey:@"field_venue_website"];
                    
                    if([field_venue_image count]>0)
                    {
                        NSDictionary *websiteDictionary  = [field_venue_website objectAtIndex:0];
                        if([websiteDictionary isKindOfClass:NSClassFromString(@"NSDictionary")])
                        {
                            if([[websiteDictionary objectForKey:@"url"] isKindOfClass:NSClassFromString(@"NSString")])
                            tempBusinessModel.url = [websiteDictionary objectForKey:@"url"];
                        }
                    }
                }
                
            }
            if([[dictionay objectForKey:@"venue_location_data"] isKindOfClass:NSClassFromString(@"NSDictionary")])
            {
                NSMutableDictionary *venueLocation = [dictionay objectForKey:@"venue_location_data"];
                
                if([[venueLocation objectForKey:@"foursquare_id"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.fourSquareId = [venueLocation objectForKey:@"foursquare_id"];
                }
                if([[venueLocation objectForKey:@"address1"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationStreet = [venueLocation objectForKey:@"address1"];
                }
                if([[venueLocation objectForKey:@"primary_category_id"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.categoryID = [venueLocation objectForKey:@"primary_category_id"];
                }
                if([[venueLocation objectForKey:@"primary_category_name"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.categoryName = [venueLocation objectForKey:@"primary_category_name"];
                }
            }
            if([[dictionay objectForKey:@"location"] isKindOfClass:NSClassFromString(@"NSDictionary")])
            {
                NSMutableDictionary *location  =[dictionay objectForKey:@"location"];
                if([[location objectForKey:@"street"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationAddress = [location objectForKey:@"street"];
                }
                if([[location objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationCity = [location objectForKey:@"city"];
                }
                if([[location objectForKey:@"postal_code"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationPostalCode = [location objectForKey:@"postal_code"];
                }
                if([[location objectForKey:@"phone"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    NSString *contactNumber = [location objectForKey:@"phone"];
                    if([contactNumber length] >= 10){
                        NSString* initialContactNumber = [NSString stringWithFormat:@"(%@)",[contactNumber substringToIndex:3]];
                        NSString *middledigits = [contactNumber substringWithRange:NSMakeRange(3, 3)];
                        NSString* lastdigits = [contactNumber substringFromIndex:6];
                        initialContactNumber = [NSString stringWithFormat:@"%@-%@-%@",initialContactNumber,middledigits,lastdigits];
                        
                        tempBusinessModel.contactFormattedPhone = initialContactNumber;
                    }
                    tempBusinessModel.contactPhone = [location objectForKey:@"phone"];
                }
                if([[location objectForKey:@"latitude"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationLatitude  =[location objectForKey:@"latitude"];
                }
                if([[location objectForKey:@"longitude"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationLongitude = [location objectForKey:@"longitude"];
                }
                if([[location objectForKey:@"country_name"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempBusinessModel.locationCountry = [location objectForKey:@"country_name"];
                }
            }
            [finalDictionaryArray addObject:tempBusinessModel];
            
            [tempBusinessModel release];
            tempBusinessModel = nil;
        }
        if(self.cityGuideDelegate && [self.cityGuideDelegate respondsToSelector:@selector(serviceResponseCityiGuide:)])
        {
            [self.cityGuideDelegate serviceResponseCityiGuide:finalDictionaryArray];
        }
    }
    else
    {
        if(self.cityGuideDelegate && [self.cityGuideDelegate respondsToSelector:@selector(failedToFecthCityGuideDetails)])
        {
            [self.cityGuideDelegate failedToFecthCityGuideDetails];
        } 
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];
    if(self.cityGuideDelegate && [self.cityGuideDelegate respondsToSelector:@selector(failedToFecthCityGuideDetails)])
    {
        [self.cityGuideDelegate failedToFecthCityGuideDetails];
    } 
}

- (void)dealloc {
    
    self.cityGuideDelegate = nil;
    [super dealloc];
}

@end
