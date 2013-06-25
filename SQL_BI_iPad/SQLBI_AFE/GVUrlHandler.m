//
//  GVUrlHandler.m
//  GreenVolts
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "GVUrlHandler.h"

@implementation GVUrlHandler


NSString * const kURLWebServerPROD = @"https://www.isisgreenvolts.com/GreenVolts-ISIS-BL-Web-Models-iPad-iPad_DS.svc/JSON";
NSString * const kURLWebServerDev = @"https://gvfredev04.greenvolts.com/isisclient/GreenVolts-ISIS-BL-Web-Models-iPad-iPad_DS.svc/JSON";
NSString * const kURLWebServerQA = @"https://gvfreqaap1.greenvolts.com/isisclient/GreenVolts-ISIS-BL-Web-Models-iPad-iPad_DS.svc/JSON";
NSString * const kURLWebServerSTG = @"https://gvfremfa01.greenvolts.com/isisclient/GreenVolts-ISIS-BL-Web-Models-iPad-iPad_DS.svc/JSON";
NSString * const kURLWebServerSAMPLER = @"https://demo.isisgreenvolts.com/GreenVolts-ISIS-BL-Web-Models-iPad-iPad_DS.svc/JSON";


+ (NSString*)GVWEBSERVERURL:(RVAPIRequestType)requestType
{
	NSString *result = nil;
#ifdef PROD_CONFIG 
    result = kURLWebServerPROD;
#endif
#ifdef QA_CONFIG
    result = kURLWebServerQA;
#endif
#ifdef DEV_CONFIG
    result = kURLWebServerDev;
#endif
#ifdef STG_CONFIG
    result = kURLWebServerSTG;
#endif
#ifdef SAMPLER_CONFIG
    result = kURLWebServerSAMPLER;
#endif
	return result;
}


@end
