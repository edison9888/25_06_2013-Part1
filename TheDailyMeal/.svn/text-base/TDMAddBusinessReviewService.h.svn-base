//
//  TDMAddBusinessReviewService.h
//  TheDailyMeal
//
//  Created by Apple on 17/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMAddBusinessReviewServiceDelegate <NSObject>
@required
-(void) businessReviewAddedSuccessfully;
-(void) networkErrorInAddinBusinessReview;
-(void) businessReviewFailed;
@end

@interface TDMAddBusinessReviewService : TDMBaseHttpHandler
{
    id <TDMAddBusinessReviewServiceDelegate> businessReviewServicedelegate;
}

@property (nonatomic, retain) id <TDMAddBusinessReviewServiceDelegate> businessReviewServicedelegate;

-(void)addBusinessReviewWithBody:(NSString *)body andTitle:(NSString *)title  forVenue:(NSString *) vid;
//- (void)uploadPhotoToTheReviewWithUID:(NSString *)uid withData:(NSData *)data withFileName:(NSString *)fileName;

@end
