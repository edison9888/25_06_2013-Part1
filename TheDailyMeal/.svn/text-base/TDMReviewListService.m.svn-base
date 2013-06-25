//
//  TDMReviewListService.m
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMReviewListService.h"
#import "Reachability.h"
#import "BusinessReviewModel.h"
#import "TDMBusinessDetails.h"
#import "TDMBusinessViewController.h"

@implementation TDMReviewListService

@synthesize reviewListserviceDelegate;

- (id)initWithDelegate:(id)_delegate {
    
    self = [super init];
    if(self){
        self.delegate = _delegate;
    }
    
    return self;
}

-(void) getReviewListServiceForVenueID:(int)venueID
{

    NSString *url = [NSString stringWithFormat:@"%@%@%d%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_node/",venueID,@"/restaurant_review"];
    if([Reachability connected])
        [self getRequest:url];
    else
    {
        [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders removeAllObjects];
        if(self.reviewListserviceDelegate && [self.reviewListserviceDelegate respondsToSelector:@selector(networkErrorInFindingReview)])
        {
            [self.reviewListserviceDelegate networkErrorInFindingReview];
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
        }
        
    }
}

-(void)clearDelegate{
    bCheck=YES;
    self.reviewListserviceDelegate=nil;
}
    
    
- (void)requestFinished:(ASIHTTPRequest *)request 
{        
    [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders removeAllObjects];
    if(bCheck){
        self.reviewListserviceDelegate=nil;
    }
    if(request.responseStatusCode == 200)
    {
        NSMutableArray *finalDictionaryArray = [[NSMutableArray alloc]init];
        NSString *responseString = [request responseString];
        if([[request.responseString JSONValue] isKindOfClass:NSClassFromString(@"NSMutableArray")]) {
            NSMutableArray *responseArray = [responseString JSONValue];
            for (NSDictionary *responseDictionary in responseArray) {
                BusinessReviewModel *tempReviewListModel = [[BusinessReviewModel alloc]init];
                if([[responseDictionary objectForKey:@"title"] isKindOfClass:NSClassFromString(@"NSString")]) {
                    tempReviewListModel.reviewTitle = [responseDictionary objectForKey:@"title"];
                }
                if([[responseDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")]) {
                    tempReviewListModel.userName = [responseDictionary objectForKey:@"name"];
                }
                if([[responseDictionary objectForKey:@"body"] isKindOfClass:NSClassFromString(@"NSString")]) 
                {
                            tempReviewListModel.reviewText = [responseDictionary objectForKey:@"body"];
                }
                if([[responseDictionary objectForKey:@"field_res_review_upload_photo"]isKindOfClass:NSClassFromString(@"NSArray")])
                {
                    NSArray *imageArray =[responseDictionary objectForKey:@"field_res_review_upload_photo"];
                    if([imageArray count]>0)
                    {
                        if([[imageArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSDictionary")])
                        {
                            NSDictionary *imageDictionary = [imageArray objectAtIndex:0];
                            if([[imageDictionary objectForKey:@"filepath"] isKindOfClass:NSClassFromString(@"NSString")])
                                tempReviewListModel.businessImage  =[imageDictionary objectForKey:@"filepath"];
                        }
                    }
                }
                if([[responseDictionary objectForKey:@"field_res_review_review_text"] isKindOfClass:[NSArray class]])
                {
                    NSArray *reviewArray= [responseDictionary objectForKey:@"field_res_review_review_text"];
                    if([reviewArray count]>0)
                    {
                        if([[reviewArray objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                        {
                            NSDictionary *reviewDictionary =[reviewArray objectAtIndex:0];
                            if([[reviewDictionary objectForKey:@"value"] isKindOfClass:[NSString class]])
                            {
                                tempReviewListModel.reviewText = [reviewDictionary objectForKey:@"value"];
                            }
                        }
                    }
                }

                [finalDictionaryArray addObject:tempReviewListModel];
                [tempReviewListModel release];
                tempReviewListModel = nil;
            }
            [[TDMBusinessDetails sharedBusinessDetails] initializeReviewListHeaders:finalDictionaryArray];
            if (self.reviewListserviceDelegate && [self.reviewListserviceDelegate  respondsToSelector:@selector(reviewListserviceResponse:)]) {
                    [self.reviewListserviceDelegate reviewListserviceResponse:finalDictionaryArray];
            }
        }
    }

    else
    {
        if (self.reviewListserviceDelegate && [self.reviewListserviceDelegate  respondsToSelector:@selector(reviewListFetchFailed)]){
        [self.reviewListserviceDelegate reviewListFetchFailed];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];
    [[TDMBusinessDetails sharedBusinessDetails].reviewListHeaders removeAllObjects];
    NSLog(@"Review fetch failed %d",request.responseStatusCode);
    if (self.reviewListserviceDelegate && [self.reviewListserviceDelegate  respondsToSelector:@selector(reviewListFetchFailed)]){
    [self.reviewListserviceDelegate reviewListFetchFailed];
    }
}

- (void)dealloc {
    
    self.reviewListserviceDelegate = nil;
    [super dealloc];
}

@end
