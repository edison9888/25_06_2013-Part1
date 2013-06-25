//
//  TDMFaceBookHandler.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TDMAPNSHttpHandler.h"
#import "TDMURLHandler.h"
#import "ASIHTTPRequest.h"

@interface TDMFaceBookHandler : TDMAPNSHttpHandler
{
    
}
- (void)sendFacebookLoginWithCookie:(NSString *)accessToken;
@end
