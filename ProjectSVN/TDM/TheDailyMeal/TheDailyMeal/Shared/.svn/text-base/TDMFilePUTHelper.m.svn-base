//
//  TDMFilePUTHelper.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMFilePUTHelper.h"

@implementation TDMFilePUTHelper

-(void)putFileWithFID:(NSString *)fid {
    
    //Get current user id from database. Dummy value for now
    NSString * userID = [NSString stringWithFormat:@"6338"];
    
    NSString * apiURLString = [NSString stringWithFormat:@"/app/tdm_user_picture/%@",userID];
    
    NSLog(@"%@",apiURLString);
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:fid forKey:@"fid"];
    
    NSString * requestBodyString = [dictionary JSONRepresentation];
    
    [self putRequest:apiURLString RequestBody:requestBodyString withRequestType:kTDMFilePUT];
    [dictionary release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error: %@ %d",request.responseString,request.responseStatusCode);
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM File PUT Finished %@",[[request responseString] JSONValue]);
    
    [delegate requestCompletedSuccessfully:request];
}
@end
