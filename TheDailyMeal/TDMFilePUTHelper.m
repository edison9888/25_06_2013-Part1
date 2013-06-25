//
//  TDMFilePUTHelper.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMFilePUTHelper.h"
#import "DatabaseManager.h"

@implementation TDMFilePUTHelper

-(void)putFileWithFID:(NSString *)fid {
    
    //Get current user id from database. Dummy value for now
    NSDictionary *userDetails = [[DatabaseManager sharedManager]getUserDetailsFromDataBase];
    NSString *userID= [userDetails objectForKey:@"userid"];
    
    NSString * apiURLString = [NSString stringWithFormat:@"%@/rest/app/tdm_user_picture/%@",DAILYMEAL_SEVER_PROD,userID];
        
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:fid forKey:@"fid"];
    
    NSString * requestBodyString = [dictionary JSONRepresentation];
    
    [self putRequest:apiURLString RequestBody:requestBodyString];
    [dictionary release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dict = [[request responseString] JSONValue];
    NSString *picture = [dict objectForKey:@"picture"];
    NSString *image = [NSString stringWithFormat:@"%@/%@",DAILYMEAL_SEVER_PROD,picture];
    [[DatabaseManager sharedManager]updateUserTable:image];
    [delegate requestCompletedSuccessfully:request];
}
@end
