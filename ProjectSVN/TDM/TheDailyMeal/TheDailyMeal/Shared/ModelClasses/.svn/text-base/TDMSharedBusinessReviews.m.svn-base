//
//  TDMSharedBusinessReviews.m
//  TheDailyMeal
//
//  Created by Apple on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMSharedBusinessReviews.h"

static TDMSharedBusinessReviews *sharedReview;

@implementation TDMSharedBusinessReviews
@synthesize reviewHeaders;

+(TDMSharedBusinessReviews *)sharedReviewDetails
{
    if(!sharedReview)
        sharedReview = [[TDMSharedBusinessReviews alloc]init];
    return sharedReview;
}
-(void)initializeReviewHeaders:(NSMutableArray *)incomingReviewHeaders
{
    if(!reviewHeaders)
        reviewHeaders = [[NSMutableArray alloc]init];
    [reviewHeaders addObjectsFromArray:incomingReviewHeaders];
}
@end
