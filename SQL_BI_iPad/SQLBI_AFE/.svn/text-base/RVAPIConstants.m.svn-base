//
//  GVConstants.m
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "RVAPIConstants.h"

@implementation RVAPIConstants

+ (NSString *)urlEncodedParamStringFromString:(NSString *)original
{
	NSString *param = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                          (__bridge CFStringRef)original, 
                                                                          NULL, 
                                                                          (CFStringRef)@";/?:@&=+$-_.~*'()", 
                                                                          kCFStringEncodingUTF8);
	
	//NSLog(@"original: '%@' - encoded: '%@'", original, param);
	return param;
    //return  param;
}

@end
