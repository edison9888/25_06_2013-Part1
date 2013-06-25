//
//  TDMAddBusinessReviewService.m
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMAddBusinessReviewService.h"
#import "Reachability.h"
#import "NSDataAdditions.h"

@implementation TDMAddBusinessReviewService
@synthesize businessReviewServicedelegate;

-(void)addBusinessReviewWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid {
    if([Reachability connected])
    {
          NSString *fid = [[NSUserDefaults standardUserDefaults]objectForKey:@"fid"];
              NSString * apiURLString = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_node"];
        
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
        if (fid.length > 0) 
        {
            [dictionary setObject:fid forKey:@"field_res_review_upload_photo_fid"];
            [dictionary setObject:@"1" forKey:@"field_res_review_upload_photo_list"];
        }
        
        [dictionary setObject:@"restaurant_review" forKey:@"type"];
        [dictionary setObject:vid forKey:@"field_restaurant_venue_nid_value"];
        [dictionary setObject:body forKey:@"field_res_review_review_text_value"];
        [dictionary setObject:@"on" forKey:@"field_res_review_terms_value"];
        [dictionary setObject:title forKey:@"field_res_review_review_headline_value"];
        NSString * requestString = [dictionary JSONRepresentation];
        [dictionary release];
        
        [self postRequest:apiURLString RequestBody:requestString];
    }
    else
    {
        if (self.businessReviewServicedelegate && [self.businessReviewServicedelegate  respondsToSelector:@selector(networkErrorInAddinBusinessReview)]) 
        {
            [self.businessReviewServicedelegate networkErrorInAddinBusinessReview];
        }
    }
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.responseStatusCode == 200) {
        if (self.businessReviewServicedelegate && [self.businessReviewServicedelegate  respondsToSelector:@selector(businessReviewAddedSuccessfully)]) 
        {
            [self.businessReviewServicedelegate businessReviewAddedSuccessfully];
            NSLog(@"response:%@",request.responseString);
        }
    }
    else 
    {
        if (self.businessReviewServicedelegate && [self.businessReviewServicedelegate  respondsToSelector:@selector(businessReviewFailed)]) 
        {
            [self.businessReviewServicedelegate businessReviewFailed];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request { 
    
    [super requestFailed:request];
    [self.businessReviewServicedelegate businessReviewFailed];

}

@end
