//
//  TDMAddDishService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 24/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAddDishService.h"
#import "Reachability.h"

@implementation TDMAddDishService
@synthesize addDishServicedelegate;

-(void)addSignatureDishWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid withPhotoFID:(NSString *)photoFID {
    
    if([Reachability connected])
    {
        NSString * apiURLString = [NSString stringWithFormat:@"%@/rest/app/tdm_node",DAILYMEAL_SEVER_PROD];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        if (photoFID.length > 0) 
        {
            [dictionary setObject:photoFID forKey:@"field_res_review_upload_photo_fid"];
            [dictionary setObject:@"1" forKey:@"field_res_review_upload_photo_list"];
        }
        
        [dictionary setObject:@"signature_dish" forKey:@"type"];
        [dictionary setObject:vid forKey:@"field_restaurant_venue_nid_value"];
        [dictionary setObject:title forKey:@"title"];
        [dictionary setObject:body forKey:@"body"];
        [dictionary setObject:[NSNumber numberWithInt:1] forKey:@"field_res_review_terms_value"];
       
        NSString * requestString = [dictionary JSONRepresentation];
        
        [dictionary release];
       [self postRequest:apiURLString RequestBody:requestString];
    }
    else
    {
        if (self.addDishServicedelegate && [self.addDishServicedelegate respondsToSelector:
                                            @selector(networkErrorInAddingBusinessReview)]) 
        {
            [self.addDishServicedelegate networkErrorInAddingBusinessReview];
        }
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) 
    {
        if (self.addDishServicedelegate && [self.addDishServicedelegate respondsToSelector:
                                            @selector(signatureDishAddedSuccessFully)]) 
        {
            [self.addDishServicedelegate signatureDishAddedSuccessFully];
        }

       
    }
    else {
        if (self.addDishServicedelegate && [self.addDishServicedelegate respondsToSelector:
                                            @selector(failedToAddSignatureDish)]) 
        {
            [self.addDishServicedelegate failedToAddSignatureDish];
        }

       
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    NSString *message = [NSString stringWithFormat:@"Failed To Add Signature dish due to server Error %d",request.responseStatusCode];
     kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, message);
    [self.addDishServicedelegate failedToAddSignatureDish];
    
}
@end
