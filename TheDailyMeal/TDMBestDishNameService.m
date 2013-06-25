//
//  TDMBestDishNameService.m
//  TheDailyMeal
//
//  Created by Apple on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBestDishNameService.h"
#import "TDMSignatureDishModel.h"
#import "TDMBusinessDetails.h"
#import "Reachability.h"

@implementation TDMBestDishNameService

@synthesize signaturedishModel;
@synthesize bestDishNameDelegate;
@synthesize index;
@synthesize signatureDishHeaders;


-(void) getBestDishNameForSignatureDish:(TDMSignatureDishModel *)bestDishModel forIndex:(int)temIndex
{

    self.signatureDishHeaders = [TDMBusinessDetails sharedBusinessDetails].bestDishHeaders;
    self.index  =temIndex;
    //bestDishModel.businessModel.venueId
    self.signaturedishModel =bestDishModel;
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_node/",bestDishModel.businessModel.venueId,@"/signature_dish"];
    if([Reachability connected])
        [self getRequest:url];
    else
    {
        if(self.bestDishNameDelegate && [self.bestDishNameDelegate respondsToSelector:@selector(networkErrorInBestDishNameService)])
        {
                [self.bestDishNameDelegate networkErrorInBestDishNameService];
        }

    }
    
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    TDMSignatureDishModel *tempModel = [[TDMBusinessDetails sharedBusinessDetails].bestDishHeaders objectAtIndex:self.index];
    if([[request.responseString JSONValue] isKindOfClass:NSClassFromString(@"NSArray")])
    {
        NSArray *responseArray = [request.responseString JSONValue];
        if([responseArray count]>0)
        {
            int imageDictionaryIndex = 0;
            for (NSMutableDictionary *dictionary in responseArray) {
                imageDictionaryIndex ++;
                NSMutableArray *imageArray = [dictionary objectForKey:@"field_signature_dish_photo"];
                if([imageArray count]>0)
                {
                    if([[imageArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSDictionary")])
                    {
                        NSDictionary *imageDetailDictionary = [imageArray objectAtIndex:0];
                        
                        if([[imageDetailDictionary objectForKey:@"filepath"] isKindOfClass:NSClassFromString(@"NSString")])
                        {
                            break;                   
                        }
                    }
                }
            }
            
            if([[responseArray objectAtIndex:imageDictionaryIndex -1] isKindOfClass:NSClassFromString(@"NSDictionary")])
            {
                NSMutableDictionary *responseDictionary = [responseArray objectAtIndex:imageDictionaryIndex -1];
                if([[responseDictionary objectForKey:@"title"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempModel.dishName = [responseDictionary objectForKey:@"title"];
                }
                if([[responseDictionary objectForKey:@"name"] isKindOfClass:[NSString class]])
                {
                    tempModel.staffFirstName = [responseDictionary objectForKey:@"name"];
                }
                if([[responseDictionary objectForKey:@"picture"] isKindOfClass:[NSString class]])
                {
                    tempModel.staffImagePath = [responseDictionary objectForKey:@"picture"];
                }
                if([[responseDictionary objectForKey:@"body"] isKindOfClass:[NSString class]])
                {
                    tempModel.reviewDescription = [responseDictionary objectForKey:@"body"];
                }
                if([[responseDictionary objectForKey:@"field_signature_dish_photo"]isKindOfClass:NSClassFromString(@"NSArray")])
                {
                    NSMutableArray *imageArray = [responseDictionary objectForKey:@"field_signature_dish_photo"];
                    if([imageArray count]>0)
                    {
                        if([[imageArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSDictionary")])
                        {
                            NSDictionary *imageDetailDictionary = [imageArray objectAtIndex:0];
  
                            if([[imageDetailDictionary objectForKey:@"filepath"] isKindOfClass:NSClassFromString(@"NSString")])
                            {
                                tempModel.venuImagePath = [imageDetailDictionary objectForKey:@"filepath"];

                                 
                            }
                        }
                        
                    }
                    
                }
                if([[responseDictionary objectForKey:@"picture"] isKindOfClass:NSClassFromString(@"NSString")])
                {
                    tempModel.staffImagePath = [responseDictionary objectForKey:@"picture"];

                }
            }
            
        }
        
    }
    if(self.bestDishNameDelegate && [self.bestDishNameDelegate respondsToSelector:@selector(bestDishNameServiceResponse:)])
    {

        if(self.index == [[TDMBusinessDetails sharedBusinessDetails].bestDishHeaders count]-1)
        [self.bestDishNameDelegate bestDishNameServiceResponse:[TDMBusinessDetails sharedBusinessDetails].bestDishHeaders];
    }
}

-(void) requestFailed:(ASIHTTPRequest *)request
{

    
}


@end
