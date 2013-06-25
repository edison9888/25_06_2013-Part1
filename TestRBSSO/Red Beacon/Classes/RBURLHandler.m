//
//  RBURLHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBURLHandler.h"


@implementation RBURLHandler

NSString * const kURLWebServerPROD = @"https://www.redbeacon.com";
NSString * const kURLWebServerQA = @"http://redbeacon-inc.com:80";


+ (NSString*)RBWEBSERVERURL
{
	NSString *result = nil;
#ifdef PROD_CONFIG
	result = kURLWebServerPROD;
#else
	result = kURLWebServerQA;
#endif
	NSLog(@"RBURLHandler returned RBWEBSERVERURL: %@", result);
	return result;
}

@end
