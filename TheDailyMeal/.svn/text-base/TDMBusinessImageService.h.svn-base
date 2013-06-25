//
//  TDMBusinessImageService.h
//  TheDailyMeal
//
//  Created by Apple on 22/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"
#import "BussinessModel.h"

@protocol TDMBusinessImageServiceDelegate <NSObject>
@required
-(void) thumbnailReceivedForBusiness:(BussinessModel *)businessModel;
-(void) failedToFecthPhoto;
-(void) networkError;
@end

@interface TDMBusinessImageService : TDMBaseHttpHandler {
    
    id <TDMBusinessImageServiceDelegate> businessImageDelegate;
    BussinessModel *tempBusinessModel;
}

@property (nonatomic, retain) id <TDMBusinessImageServiceDelegate> businessImageDelegate;
@property (retain, nonatomic) BussinessModel *tempBusinessModel;

- (NSString *) getCurrentDateFormat;
-(void) getCategoryImagesForBusiness:(BussinessModel *)businessModel;

@end
