//
//  TDMAddSignatureDishHandlerAndProvider.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"

@protocol TDMAddSignatureDishHandlerAndProviderDelegate <NSObject>
@required
-(void)signatureDishAddedSuccessFully;
-(void)failedToAddSignatureDish;
@end

@interface TDMAddSignatureDishHandlerAndProvider : TDMBaseHttpHandler
{
    id <TDMAddSignatureDishHandlerAndProviderDelegate> signatureDishDelegate;
}

@property (nonatomic, retain) id <TDMAddSignatureDishHandlerAndProviderDelegate> signatureDishDelegate;
@end
