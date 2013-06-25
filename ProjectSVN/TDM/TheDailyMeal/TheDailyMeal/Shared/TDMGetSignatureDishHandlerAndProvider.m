//
//  TDMGetSignatureDishHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Apple on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMGetSignatureDishHandlerAndProvider.h"
#import "TDMSharedSignatureDishDetails.h"

@implementation TDMGetSignatureDishHandlerAndProvider
@synthesize getSignatureDish;

-(void)getSignatureDishForVenueID:(NSString *)venueID   {
    //http://www.thedailymeal.com/rest/app/tdm_node/7146/signature_dish
    NSString * apiURLString = [NSString stringWithFormat:@"/app/tdm_node/"];
    apiURLString = [apiURLString stringByAppendingFormat:venueID];
    apiURLString = [apiURLString stringByAppendingFormat:@"/signature_dish"];
    [self getRequest:apiURLString withRequestType:kTDMGetSignatureDish];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error %d",request.responseStatusCode);
    [delegate requestCompletedWithErrors:request];
    [getSignatureDish failedToGetSignatureDish];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"From TDM Add Signature Dish Finished %@",request.responseString);
    
    NSMutableArray *jsonArray = [[request responseString] JSONValue];
    NSLog(@"jsonArray %@",jsonArray);
    NSMutableArray *finalArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in jsonArray) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setValue:[dictionary objectForKey:@"uid"] forKey:@"uid"];
        [tempDict setValue:[dictionary objectForKey:@"title"] forKey:@"title"];
        [tempDict setValue:[dictionary objectForKey:@"picture"] forKey:@"image"];
        [finalArray addObject:tempDict];
        tempDict = nil;
    }
    NSLog(@"final array %@",finalArray);
    TDMSharedSignatureDishDetails *sharedSignatureDish = [[TDMSharedSignatureDishDetails alloc]init];
    [sharedSignatureDish initializeSignatureDishHeaders:finalArray];
    [sharedSignatureDish release];
    [TDMSharedSignatureDishDetails sharedSignatureDishDetails].signatureDishHeaders = finalArray;
    NSLog(@"shared array %@",[TDMSharedSignatureDishDetails sharedSignatureDishDetails].signatureDishHeaders);
    [getSignatureDish retrievedSignatureDishSuccessFully];
    [delegate requestCompletedSuccessfully:request];
} 



@end
