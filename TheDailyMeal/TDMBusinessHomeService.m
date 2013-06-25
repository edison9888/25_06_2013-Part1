//
//  TDMBusinessHomeService.m
//  TheDailyMeal
//
//  Created by Apple on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessHomeService.h"
#import "Reachability.h"

@implementation TDMBusinessHomeService
@synthesize businessServiceDelegate;

-(void) getbusinessHomeServiceForVenueID:(int)venueID
{

    NSString *url = [NSString stringWithFormat:@"%@%@%d",DAILYMEAL_SEVER_PROD,@"/rest/app/node/",venueID];
    [self getRequest:url];
    

}

- (void)requestFinished:(ASIHTTPRequest *)request 
{    
    
//    NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
//    NSMutableDictionary *location = nil;
//    NSMutableDictionary *response = nil;
//    NSDictionary * jsonResponseDictionary = [request.responseString JSONValue];
//    if ([jsonResponseDictionary count]!=0)
//    {
//        response = [jsonResponseDictionary objectForKey:@"response"];
//        NSArray * venuesArray = [response objectForKey:@"venues"];
//        for(NSDictionary * currentVenueDetailsDictionary in venuesArray)
//        {
//            NSMutableDictionary *tempdictionary = [[[NSMutableDictionary alloc]init]autorelease];
//            BusinessResturantModel *tempRestaurantModel= [[[BusinessResturantModel alloc]init]autorelease];
//            //foursquareID
//            if([[currentVenueDetailsDictionary objectForKey:@"id"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"id"] forKey:@"id"];
//                tempRestaurantModel.fourSquareId = [currentVenueDetailsDictionary objectForKey:@"id"];
//            }
//            
//            else
//                [tempdictionary setObject:@"" forKey:@"id"];
//            //title
//            if([[currentVenueDetailsDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"name"] forKey:@"name"];
//                tempRestaurantModel.resturantName = [currentVenueDetailsDictionary objectForKey:@"name"];
//                NSLog(@"rest name %@",[currentVenueDetailsDictionary objectForKey:@"name"]);
//                NSLog(@"rest name %@",tempRestaurantModel.resturantName);
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"name"];
//            //phone
//            NSDictionary *contact =nil; 
//            contact = [currentVenueDetailsDictionary objectForKey:@"contact"];
//            if([[contact objectForKey:@"phone"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[contact objectForKey:@"phone"] forKey:@"phone"];
//                tempRestaurantModel.contactPhone = [contact objectForKey:@"phone"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"phone"];
//            //formattedPhone
//            if([[contact objectForKey:@"formattedPhone"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[contact objectForKey:@"formattedPhone"] forKey:@"formattedphone"];
//                tempRestaurantModel.contactFormattedPhone = [contact objectForKey:@"formattedPhone"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"formattedphone"];
//            location = nil;
//            //location dictionary
//            location = [currentVenueDetailsDictionary objectForKey:@"location"];
//            //address
//            if([[location objectForKey:@"address"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[location objectForKey:@"address"] forKey:@"address"];
//                tempRestaurantModel.locationAddress = [location objectForKey:@"address"] ;
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"address"];
//            //latitude and longitude
//            [tempdictionary setObject:[location objectForKey:@"lat"] forKey:@"latitude"];
//            tempRestaurantModel.locationLatitude = [location objectForKey:@"lat"];
//            [tempdictionary setObject:[location objectForKey:@"lng"] forKey:@"longitude"];
//            tempRestaurantModel.locationLongitude = [location objectForKey:@"lng"];
//            //postalcode
//            //            if([[location objectForKey:@"postalCode"] isKindOfClass:NSClassFromString(@"NSString")])
//            //            [tempdictionary setObject:[location objectForKey:@"postalCode"] forKey:@"postalcode"];
//            //            else
//            //                [tempdictionary setObject:[location objectForKey:@"postalCode"] forKey:@"postalcode"];
//            //city
//            if([[location objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[location objectForKey:@"city"] forKey:@"city"];
//                tempRestaurantModel.locationCity = [location objectForKey:@"city"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"city"];
//            //state
//            if([[location objectForKey:@"state"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[location objectForKey:@"state"] forKey:@"state"];
//                tempRestaurantModel.locationState = [location objectForKey:@"state"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"state"];
//            //country
//            if([[location objectForKey:@"country"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[location objectForKey:@"country"] forKey:@"country"];
//                tempRestaurantModel.locationCountry = [location objectForKey:@"country"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"country"];
//            NSMutableArray *categoryArray =nil;// [[NSMutableArray alloc]init];
//            categoryArray = [currentVenueDetailsDictionary objectForKey:@"categories"];
//            NSDictionary *categoryDictionary = nil;//[[NSDictionary alloc]init];
//            if([categoryArray count]>=1)
//            {
//                categoryDictionary = [categoryArray objectAtIndex:0];
//            }
//            //category name
//            if([[categoryDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")])
//            {
//                [tempdictionary setObject:[categoryDictionary objectForKey:@"name"] forKey:@"category"];
//                tempRestaurantModel.categoryName = [categoryDictionary objectForKey:@"name"];
//            }
//            else
//                [tempdictionary setObject:@"" forKey:@"category"];
//            //url
//            if([[currentVenueDetailsDictionary objectForKey:@"url"] isKindOfClass:NSClassFromString(@"NSString")])
//                [tempdictionary setObject:[currentVenueDetailsDictionary objectForKey:@"url"] forKey:@"url"];
//            else
//                [tempdictionary setObject:@"" forKey:@"url"];
//            //adding tempdictionary to array
//            [finalDictionaryArray addObject:tempRestaurantModel];
//        }
//    }
//    
//    //    NSLog(@"final array %@",finalDictionaryArray); 
//    //    TDMBarHandler *barHandler = [[TDMBarHandler alloc]init];
//    //    
//    //    NSMutableArray *results =  [barHandler parseResponse:request.responseString];
//    //    [barHandler release];
//    //    barHandler = nil;
//    
//    if (self.businessServiceDelegate && [self.businessServiceDelegate  respondsToSelector:@selector(businessHomeServiceResponse:)]) {
//        [self.businessServiceDelegate businessHomeServiceResponse:finalDictionaryArray];
//    }
//    //return [finalDictionaryArray autorelease];
//    
//    
//    
    
}


@end
