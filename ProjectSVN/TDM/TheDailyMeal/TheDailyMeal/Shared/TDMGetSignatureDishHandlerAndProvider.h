//
//  TDMGetSignatureDishHandlerAndProvider.h
//  TheDailyMeal
//
//  Created by Apple on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMBaseHttpHandler.h"

@protocol TDMGetSignatureDishHandlerAndProviderDelegate <NSObject>
@required
-(void)retrievedSignatureDishSuccessFully;
-(void)failedToGetSignatureDish;
@end

@interface TDMGetSignatureDishHandlerAndProvider : TDMBaseHttpHandler
{    
    id <TDMGetSignatureDishHandlerAndProviderDelegate> getSignatureDish;
}
@property (retain, nonatomic) id <TDMGetSignatureDishHandlerAndProviderDelegate> getSignatureDish;

@end
