//
//  TDMSharedBusinessReviews.h
//  TheDailyMeal
//
//  Created by Apple on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TDMSharedBusinessReviews : NSObject
{
    NSMutableArray *reviewHeaders;
}
@property (retain, nonatomic) NSMutableArray *reviewHeaders;
+(TDMSharedBusinessReviews *)sharedReviewDetails;
-(void)initializeReviewHeaders:(NSMutableArray *)incomingReviewHeaders;
@end
