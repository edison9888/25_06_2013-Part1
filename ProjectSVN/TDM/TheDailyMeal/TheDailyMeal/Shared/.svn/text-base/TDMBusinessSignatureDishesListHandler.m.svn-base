//
//  TDMBusinessSignatureDishesListHandler.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBusinessSignatureDishesListHandler.h"

@implementation TDMBusinessSignatureDishesListHandler
-(void)getSignatureDishesListForVenue:(int)venueID {
    NSString * signatureDishAPIURLString = [NSString stringWithFormat:@"%@%d%@",@"/tdm_node/",venueID,@"/signature_dish"];
    
    [self getRequest:signatureDishAPIURLString withRequestType:kTDMBusinessSignatureDishes];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM List of Restaurants Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 

@end
