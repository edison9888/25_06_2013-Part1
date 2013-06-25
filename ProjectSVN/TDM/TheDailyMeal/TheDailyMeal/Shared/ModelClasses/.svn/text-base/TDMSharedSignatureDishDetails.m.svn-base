//
//  TDMSharedSignatureDishDetails.m
//  TheDailyMeal
//
//  Created by Apple on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMSharedSignatureDishDetails.h"

static TDMSharedSignatureDishDetails *sharedSignatureDish;

@implementation TDMSharedSignatureDishDetails
@synthesize signatureDishHeaders;
+(TDMSharedSignatureDishDetails *)sharedSignatureDishDetails
{
    if(!sharedSignatureDish)
        sharedSignatureDish = [[TDMSharedSignatureDishDetails alloc]init]; 
    return sharedSignatureDish;
}
-(void)initializeSignatureDishHeaders:(NSMutableArray *)incomingSignatureDishHeaders
{
    if(!self.signatureDishHeaders)
        self.signatureDishHeaders = [[NSMutableArray alloc]init];
    [self.signatureDishHeaders addObjectsFromArray:(NSMutableArray *)incomingSignatureDishHeaders];
}
@end
