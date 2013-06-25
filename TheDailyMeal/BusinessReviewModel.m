//
//  BusinessReviewModel.m
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessReviewModel.h"

@implementation BusinessReviewModel

@synthesize userName;
@synthesize businessImage;
@synthesize reviewTitle;
@synthesize reviewText;
@synthesize userImage;

-(id) init
{
    if (self = [super init]) 
    {
        self.userName = @"";
        self.businessImage =@"";
        self.reviewText =@"";
        self.reviewTitle = @"";
    }
    return self;
}



@end
