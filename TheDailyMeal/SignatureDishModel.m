//
//  SignatureDishModel.m
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignatureDishModel.h"

@implementation SignatureDishModel

@synthesize signatureDishImage;
@synthesize signatureDishTitle;
@synthesize userName;
@synthesize reviewText;
@synthesize userImage;

-(id) init
{
    if (self = [super init]) 
    {
        self.userName = @"";
        self.signatureDishImage =@"";
        self.signatureDishTitle =@"";
        self.reviewText= @"";
        self.userImage = @"";
    }
    return self;

    
}
- (void)dealloc {

    [super dealloc];
}

@end
