//
//  TDMAddSignatureDishHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMAddSignatureDishHandlerAndProvider.h"


@implementation TDMAddSignatureDishHandlerAndProvider
@synthesize signatureDishDelegate;

-(void)addSignatureDishWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid withPhotoFID:(NSString *)photoFID {
    
    NSString * apiURLString = [NSString stringWithFormat:@"/app/tdm_node/"];
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:@"signature_dish" forKey:@"type"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",title] forKey:@"title"];
    [dictionary setObject:vid forKey:@"field_restaurant_venue_nid_value"];
    [dictionary setObject:@"on" forKey:@"field_res_review_terms_value"];
    [dictionary setObject:body forKey:@"body"];
    
    if (photoFID.length > 0) {
//        [dictionary setObject:@"" forKey:@"field_res_review_upload_photo_fid"];
//        [dictionary setObject:@"" forKey:@"field_res_review_upload_photo_list"];
    }
    
    NSLog(@"%@",dictionary);
    
    NSString * requestString = [dictionary JSONRepresentation];
    NSLog(@"dictionary %@",dictionary);
    [dictionary release];
    
    [self postRequest:apiURLString RequestBody:requestString withRequestType:kTDMAddSignatureDish];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error %d",request.responseStatusCode);
    [signatureDishDelegate failedToAddSignatureDish];
   // [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM Add Signature Dish Finished %@",[[request responseString] JSONValue]);
    [signatureDishDelegate signatureDishAddedSuccessFully];
    [delegate requestCompletedSuccessfully:request];
} 


@end
