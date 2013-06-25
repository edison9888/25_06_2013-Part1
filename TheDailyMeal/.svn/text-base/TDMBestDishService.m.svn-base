//
//  TDMBestDishService.m
//  TheDailyMeal
//
//  Created by Nibin Varghese on 24/03/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBestDishService.h"
#import "TDMSignatureDishModel.h"
#import "BussinessModel.h"
#import "Reachability.h"
#import "TDMBusinessDetails.h"



@implementation TDMBestDishService
@synthesize bestDishdelegate;

- (void)getBestDishesVenu
{   
    if ([Reachability connected]) 
    {
        NSString *longitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LONGITUDE]];
        NSString *latitude = [NSString stringWithFormat:@"%f", [[NSUserDefaults standardUserDefaults] doubleForKey:K_CURRENT_LATITUDE]];
//        
//      Added on 27/03/2012 to hardcode the latitude and longitude
//      NSString *latitude = [NSString stringWithFormat:@"%f", 40.739864];
//      NSString *longitude = [NSString stringWithFormat:@"%f", -73.990983];

        NSString *apiString = [NSString stringWithFormat:@"%@/rest/app/guide?&parameters[radius]=111&parameters[lat]=%@&parameters[lon]=%@&parameters[type]=location_list",DAILYMEAL_SEVER_PROD, latitude, longitude];
        
        NSLog(@"%@",apiString);
        
        [self getRequest:apiString];
    }
    else 
    {
        
        if (bestDishdelegate && [bestDishdelegate respondsToSelector:@selector(networkError)]) 
        {
            [bestDishdelegate networkError];        
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    NSString * responseString = [request responseString];
    id response = [responseString JSONValue];
    if ([response count] > 0 && [response isKindOfClass:[NSArray class]])
    {

        NSMutableArray *bestDishArray = [[NSMutableArray alloc] init];

        int limit;
        
        if([response count] <=9)
        {
            limit =[response count];
        }
        else
        {
            limit =10;
        }
        
        for(int i=0;i < limit ;i++)
        {
            
            NSDictionary *currentDictionary = [response objectAtIndex:i];
            
            TDMSignatureDishModel *signatureDishModel = [[TDMSignatureDishModel alloc] init];

            if ([currentDictionary objectForKey:@"title"]) 
            {
                signatureDishModel.venuTitle = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"title"]];
            }
//            if ([currentDictionary objectForKey:@"body"])
//            {
//                signatureDishModel.reviewDescription = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"body"]];
//            }
//            //dish name
//            if ([currentDictionary objectForKey:@"name"]) 
//            {
//                signatureDishModel.dishName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"name"]];
//            }
            
            //Staff Details
            //Staff First Name;
            if ([currentDictionary objectForKey:@"field_author_first_name"] && [[currentDictionary objectForKey:@"field_author_first_name"] isKindOfClass:[NSArray class]]) 
            {
                NSArray *tmpFirstName = [currentDictionary objectForKey:@"field_author_first_name"];
                if ([tmpFirstName count]) 
                {
//                    signatureDishModel.staffFirstName = [NSString stringWithFormat:@"%@",[[tmpFirstName objectAtIndex:0] objectForKey:@"value"]];
                }
            }
            
            //Staff LastName
            if ([currentDictionary objectForKey:@"field_author_last_name"] && [[currentDictionary objectForKey:@"field_author_last_name"] isKindOfClass:[NSArray class]]) 
            {
                NSArray *tmpFirstName = [currentDictionary objectForKey:@"field_author_last_name"];
                if ([tmpFirstName count]) 
                {
//                    signatureDishModel.staffLastName = [NSString stringWithFormat:@"%@",[[tmpFirstName objectAtIndex:0] objectForKey:@"value"]];
                }
            }           

            if ([currentDictionary objectForKey:@"picture"]) 
            {
//                signatureDishModel.staffImagePath = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"picture"]];
            }
            
            //Venu Image
            if ([[currentDictionary objectForKey:@"field_venue_image"] isKindOfClass:[NSArray class]]) 
            {
                NSArray *tmpVenuArray = [currentDictionary objectForKey:@"field_venue_image"];
                if ([tmpVenuArray count] && [[tmpVenuArray objectAtIndex:0] objectForKey:@"value"]) 
                {
//                    signatureDishModel.venuImagePath = [NSString stringWithFormat:@"%@", [[tmpVenuArray objectAtIndex:0] objectForKey:@"value"]];
                }
            }

            //populating businessModel class
            BussinessModel *tmpBusinessmodel = [[BussinessModel alloc] init];

            if([currentDictionary objectForKey:@"nid"])
            {
                tmpBusinessmodel.venueId = [currentDictionary objectForKey:@"nid"];   
            }
            
            if ([[currentDictionary objectForKey:@"venue_location_data"] isKindOfClass:[NSDictionary class]]) 
            {
                NSDictionary *venuLocationDict = [currentDictionary objectForKey:@"venue_location_data"];
                if ([venuLocationDict objectForKey:@"venue_id"]) 
                {
                    NSNumber *venueID = [venuLocationDict objectForKey:@"nid"];
                    if(tmpBusinessmodel.venueId<0)
                    {
                        tmpBusinessmodel.venueId = venueID;
                    }
                }
                if ([venuLocationDict objectForKey:@"foursquare_id"]) 
                {
                    tmpBusinessmodel.fourSquareId = [NSString stringWithFormat:@"%@", [venuLocationDict objectForKey:@"foursquare_id"]];
                }
                if ([venuLocationDict objectForKey:@"address1"]) 
                {
                    tmpBusinessmodel.locationAddress =  [NSString stringWithFormat:@"%@",[venuLocationDict objectForKey:@"address1"]];                                               
                }
                if ([venuLocationDict objectForKey:@"primary_category_name"]) 
                {
                    tmpBusinessmodel.categoryName = [NSString stringWithFormat:@"%@",[venuLocationDict objectForKey:@"primary_category_name"]];
                }
                if ([venuLocationDict objectForKey:@"distance"]) 
                {
                    tmpBusinessmodel.locationDistance = [NSString stringWithFormat:@"%@",[venuLocationDict objectForKey:@"distance"]];
                }

            }

            if ([currentDictionary objectForKey:@"location"] && [[currentDictionary objectForKey:@"location"] isKindOfClass:[NSDictionary class]]) 
            {
                NSDictionary *locationDict = [currentDictionary objectForKey:@"location"];
                if ([locationDict objectForKey:@"name"]) 
                {
                    tmpBusinessmodel.name = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"name"]];
                }
                if ([locationDict objectForKey:@"street"]) 
                {
                    tmpBusinessmodel.locationStreet = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"street"]];
                }
                if ([locationDict objectForKey:@"city"]) 
                {
                    tmpBusinessmodel.locationCity = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"city"]];
                }
                if ([locationDict objectForKey:@"province"]) 
                {
                    tmpBusinessmodel.locationState = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"province"]];
                }
                if ([locationDict objectForKey:@"postal_code"]) 
                {
                    tmpBusinessmodel.locationPostalCode = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"postal_code"]];
                }
                if ([locationDict objectForKey:@"country_name"]) 
                {
                    tmpBusinessmodel.locationCountry = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"country_name"]];
                }
                if ([locationDict objectForKey:@"phone"]) 
                {
                    tmpBusinessmodel.contactPhone = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"phone"]];
                }
                if ([locationDict objectForKey:@"latitude"]) 
                {
                    tmpBusinessmodel.locationLatitude = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"latitude"]];
                }
                if ([locationDict objectForKey:@"longitude"]) 
                {
                    tmpBusinessmodel.locationLongitude = [NSString stringWithFormat:@"%@",[locationDict objectForKey:@"longitude"]];
                }                    
            }

            if ([currentDictionary objectForKey:@"field_venue_website"] && [[currentDictionary objectForKey:@"field_venue_website"] isKindOfClass:[NSArray class]]) 
            {
                NSArray *tmpWebSiteData = [currentDictionary objectForKey:@"field_venue_website"];
                if ([tmpWebSiteData count]) 
                {
                    tmpBusinessmodel.url = [NSString stringWithFormat:@"%@",[[tmpWebSiteData objectAtIndex:0] objectForKey:@"url"]];
                }
            }
            signatureDishModel.businessModel = tmpBusinessmodel;
            [tmpBusinessmodel release];
            tmpBusinessmodel = nil;

            [bestDishArray addObject:signatureDishModel];
            [signatureDishModel release];
            signatureDishModel = nil;                
        }
        if (bestDishdelegate && [bestDishdelegate respondsToSelector:@selector(requestCompletedSuccessfullyWithData:)]) 
        {
            [bestDishdelegate requestCompletedSuccessfullyWithData:bestDishArray];
        }

        [bestDishArray release];
        bestDishArray = nil;
    }
    else 
    {
        NSLog(@"Some error occured while fetching data from the server");
        if (bestDishdelegate && [bestDishdelegate respondsToSelector:@selector(requestCompletedSuccessfullyWithData:)]) 
        {
            [bestDishdelegate requestCompletedSuccessfullyWithData:nil];
        }     
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    if (bestDishdelegate && [bestDishdelegate respondsToSelector:@selector(requestFailed)]) 
    {
        [bestDishdelegate requestFailed];        
    }
}


@end
