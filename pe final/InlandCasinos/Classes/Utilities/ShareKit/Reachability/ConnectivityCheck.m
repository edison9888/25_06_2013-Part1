//
//  ConnectivityCheck.m
//  Brighton
//
//  Created by Timmi on 03/07/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import "ConnectivityCheck.h"


@implementation ConnectivityCheck

- (BOOL)isHostReachable{
	
	BOOL isDataAvailable = NO;
	BOOL returnValue = NO;
	BOOL didRetrieveFlags = NO;
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		DebugLog(@"Error. Could not recover network reachability flags");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	BOOL isCarrierNetwork = flags & kSCNetworkReachabilityFlagsIsWWAN;			
	
	isDataAvailable = isReachable && !needsConnection;		
	
	if(nonWiFi)
	{
		DebugLog(@"Nonwifi Network");
		
		NSURL *testURL = [NSURL URLWithString:@"http://www.google.com"];
		int iLoop= 0;
		
		do
		{
			NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
			NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
			returnValue = ((isReachable && !needsConnection) || isCarrierNetwork) ? (testConnection ? YES : NO) : NO;
			[testConnection release];	
			iLoop++;
		}
		while(!returnValue && iLoop < 10);				
		return returnValue;
	}
	else
	{
		return isDataAvailable;
	}
	
}

@end
