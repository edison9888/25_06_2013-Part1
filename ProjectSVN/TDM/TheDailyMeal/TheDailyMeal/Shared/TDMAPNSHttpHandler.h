//
//  TDMAPNSHttpHandler.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseHttpHandler.h"

@interface TDMAPNSHttpHandler : TDMBaseHttpHandler

- (NSString *)deviceTokenToHexString:(NSData *)data;
- (void)registerAPNSToken:(NSData *)data withUsername:(NSString *)username;
- (void)unregisterAPNSToken:(NSData *)data;

@end
