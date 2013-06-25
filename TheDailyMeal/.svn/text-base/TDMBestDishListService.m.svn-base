//
//  TDMBestDishListService.m
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBestDishListService.h"
#import "SignatureDishModel.h" 
#import "Reachability.h"
#import "TDMBusinessDetails.h"

@implementation TDMBestDishListService
@synthesize bestDishListserviceDelegate;

-(void) getBestDishListServiceForVenueID:(int)venueID
{
    if ([Reachability connected]) 
    {
        NSString *url = [NSString stringWithFormat:@"%@%@%d%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_node/",venueID,@"/signature_dish"];

        [self getRequest:url];
    }
    else
    {
        if(self.bestDishListserviceDelegate && [self.bestDishListserviceDelegate respondsToSelector:@selector(networkErrorInFindingBestDish)])
        {
            [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders removeAllObjects];

            [self.bestDishListserviceDelegate networkErrorInFindingBestDish];
        }
        kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);

    }
   
    
}

-(void)clearDelegate{
    bCheck = YES;
    self.bestDishListserviceDelegate=nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request 
{    
    if(bCheck){
        self.bestDishListserviceDelegate=nil;
    }
    [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders removeAllObjects];
    if(request.responseStatusCode ==200) {
        NSMutableArray *finalDictionaryArray = [[NSMutableArray alloc]init];
        if([[request.responseString JSONValue] isKindOfClass:NSClassFromString(@"NSMutableArray")]) {
                NSMutableArray *responseArray = [request.responseString JSONValue];
                for (NSDictionary *responseDictionary in responseArray) {
                    SignatureDishModel *tempSignatureDishModel = [[SignatureDishModel alloc]init];
                    if([[responseDictionary objectForKey:@"title"] isKindOfClass:NSClassFromString(@"NSString")]) {
                        tempSignatureDishModel.signatureDishTitle = [responseDictionary objectForKey:@"title"];
                    }
                    if([[responseDictionary objectForKey:@"body"] isKindOfClass:NSClassFromString(@"NSString")])
                    {
                        tempSignatureDishModel.reviewText = [responseDictionary objectForKey:@"body"];
                    }
                    if([[responseDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")]) {
                        tempSignatureDishModel.userName = [responseDictionary objectForKey:@"name"];
                    }
                    
                    if([[responseDictionary objectForKey:@"field_signature_dish_photo"] isKindOfClass:NSClassFromString(@"NSArray")])
                    {
                        if([[responseDictionary objectForKey:@"field_signature_dish_photo"] count]>0)
                        {
                        NSArray *imageArray = [responseDictionary objectForKey:@"field_signature_dish_photo"];
                            if([[imageArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSDictionary")])
                            {
                            NSDictionary *imageDictionary = [imageArray objectAtIndex:0];
                                if([[imageDictionary objectForKey:@"filepath"] isKindOfClass:NSClassFromString(@"NSString")])
                                {
                                    tempSignatureDishModel.signatureDishImage =[imageDictionary objectForKey:@"filepath"];
                                    NSLog(@"best dish image %@",tempSignatureDishModel.signatureDishImage);
                                }
                            }
                        }
                    }
                    
                    if([[responseDictionary objectForKey:@"picture"] isKindOfClass:NSClassFromString(@"NSString")]) {
                        tempSignatureDishModel.userImage = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,[responseDictionary objectForKey:@"picture"]];
                    }
                    [finalDictionaryArray addObject:tempSignatureDishModel];
                    [tempSignatureDishModel release];
                    tempSignatureDishModel = nil;
                }
                
                [[TDMBusinessDetails sharedBusinessDetails] initializeSignatureDishHeaders:finalDictionaryArray];
                if (self.bestDishListserviceDelegate && [self.bestDishListserviceDelegate  respondsToSelector:@selector(bestDishListserviceResponse:)]) {
                    [self.bestDishListserviceDelegate bestDishListserviceResponse:finalDictionaryArray];
                }
        }
        [finalDictionaryArray release];
        finalDictionaryArray =nil;
    }
    
    else
    { 
         if (self.bestDishListserviceDelegate && [self.bestDishListserviceDelegate  respondsToSelector:@selector(bestDishFetchFailed)]) {
        [self.bestDishListserviceDelegate bestDishFetchFailed];
         }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];
    [[TDMBusinessDetails sharedBusinessDetails].signatureDishHeaders removeAllObjects];

    if (self.bestDishListserviceDelegate && [self.bestDishListserviceDelegate  respondsToSelector:@selector(bestDishFetchFailed)]) {
        [self.bestDishListserviceDelegate bestDishFetchFailed];
    }
}

- (void)dealloc {
    
    self.bestDishListserviceDelegate = nil;
    [super dealloc];
}

@end
