//
//  RVUrlHandler.m
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "RVUrlHandler.h"

@implementation RVUrlHandler

NSString * const kURL_DEV = @"http://hsc-srv-sqld02:8087/AFERest2/AFEWebSvc.svc";
NSString * const kURL_UAT = @"http://hsc-srv-sqlua02:8087/AFERest2/AFEWebSvc.svc";
NSString * const kURL_PROD = @"http://50.57.145.54:8087/AFERest2Prod/AFEWebSvc.svc";
//NSString * const kURL_SBIDEV = @"http://50.57.145.54:8087/AFERest2/AFEWebSvc.svc";

NSString * const kURL_SBIDEV = @"http://50.57.145.54:8087/AFERest2/AFEWebSvc.svc";


+ (NSString*)GVWEBSERVERURL:(RVAPIRequestType)requestType
{
	NSString *result = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebServiceBaseURL"]; 
    
    //result = nil;
    
    if(!result || [[result stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        result = kURL_SBIDEV;
    }
    
	return result;
}


@end
