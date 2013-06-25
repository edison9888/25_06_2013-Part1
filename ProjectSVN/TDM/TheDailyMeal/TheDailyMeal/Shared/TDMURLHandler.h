//
//  TDMURLHandler.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TDMURLHandler : NSObject 
{
    
}

+ (NSString*)RBWEBSERVERURL:(TDMHTTPRequestType)requestType;
+ (BOOL)useHttpsService:(TDMHTTPRequestType)requestType;

@end
