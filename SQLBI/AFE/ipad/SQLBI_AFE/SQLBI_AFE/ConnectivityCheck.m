//
//  ConnectivityCheck.m
//  Brighton
//
//  Created by Bittu Davis on 03/07/10.
//  Copyright 2012 RVS. All rights reserved.
//

#import "ConnectivityCheck.h"


@implementation ConnectivityCheck

//This method will not give accurate values always as this is a Synchronous method.
//Use the testInternetConnectivity method instead. 
- (BOOL)isHostReachable{
	
	BOOL isWifiAvaialable = NO;
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
		NSLog(@"Error. Could not recover network reachability flags");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	BOOL isCarrierNetwork = flags & kSCNetworkReachabilityFlagsIsWWAN;			
	
	isWifiAvaialable = isReachable && !needsConnection;		
	
	if(nonWiFi)
	{
		NSLog(@"Nonwifi Network");
		
		NSURL *testURL = [NSURL URLWithString:@"http://www.google.com"];
		int iLoop= 0;
		
		do
		{
			NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
			NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
			returnValue = ((isReachable && !needsConnection) || isCarrierNetwork) ? (testConnection ? YES : NO) : NO;

			iLoop++;
		}
		while(!returnValue && iLoop < 10);				
		return returnValue;
        
	}
	else
	{
        if(isWifiAvaialable)
        {   
            NSURL *testURL = [NSURL URLWithString:@"http://www.google.com"];
            
            NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
            NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
            returnValue = ((isReachable && !needsConnection) || isCarrierNetwork) ? (testConnection ? YES : NO) : NO;
              				
            return returnValue;
            
        }
        else
            return isWifiAvaialable;
	}
	
}


-(void) testInternetConnectivity:(id) callbackDelegate callbackForConnectionFailure:(SEL) failureCallback callbackForConnectionSuccess:(SEL) successCallback
{
    delegate = callbackDelegate;
    failureCallbackMethod = failureCallback;
    successCallbackMethod = successCallback;
    
    isCalledBack = NO;
    
    BOOL isWifiAvaialable = NO;
	//BOOL returnValue = NO;
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
		NSLog(@"Error. Could not recover network reachability flags");
        
        if(delegate)
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if([delegate respondsToSelector:failureCallbackMethod])
                    [delegate performSelector:failureCallbackMethod withObject:nil];
            #pragma clang diagnostic pop
        }
		return;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	BOOL isCarrierNetwork = flags & kSCNetworkReachabilityFlagsIsWWAN;			
	
	isWifiAvaialable = isReachable && !needsConnection;		
	
	if(nonWiFi)
	{
		NSLog(@"Nonwifi Network");
		
		NSURL *testURL = [NSURL URLWithString:@"http://www.google.com"];
		//int iLoop= 0;
		
		//do
		//{
			NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        mURLConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
        if(!((isReachable && !needsConnection) || isCarrierNetwork))
        {
            if(delegate)
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    if([delegate respondsToSelector:failureCallbackMethod])
                    {
                        [delegate performSelector:failureCallbackMethod withObject:nil];
                        
                    }
                #pragma clang diagnostic pop
            }
        }
            
			//iLoop++;
		//}
		//while(!returnValue && iLoop < 10);				
		//return returnValue;
        
	}
	else
	{
        if(isWifiAvaialable)
        {   
            NSURL *testURL = [NSURL URLWithString:@"http://www.google.com"];
            
            NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            mURLConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
            if(!((isReachable && !needsConnection) || isCarrierNetwork))
            {
                if(delegate)
                {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        if([delegate respondsToSelector:failureCallbackMethod])
                        {
                            [delegate performSelector:failureCallbackMethod withObject:nil];
                            
                        }
                    #pragma clang diagnostic pop
                }
            }
            
        }
        else
            if(delegate)
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    if([delegate respondsToSelector:failureCallbackMethod])
                    {
                        isCalledBack = YES;
                        [delegate performSelector:failureCallbackMethod withObject:nil];
                        
                    }
                #pragma clang diagnostic pop                
            }

	}

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    if(!mResponseData)
        mResponseData=[NSMutableData data];
    
    if(delegate && !isCalledBack)
    {
        if([delegate respondsToSelector:successCallbackMethod])
        {
            isCalledBack = YES;
            
            if(mURLConnection) 
            {
                [mURLConnection cancel];
                mURLConnection=nil;
            }
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [delegate performSelector:successCallbackMethod withObject:nil];
            #pragma clang diagnostic pop            
            
        }
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    
    if(mURLConnection) 
	{
		[mURLConnection cancel];
		mURLConnection=nil;
	}
	if(mResponseData)
	{
		mResponseData=nil;
	}
    
    if(delegate  && !isCalledBack)
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if([delegate respondsToSelector:failureCallbackMethod])
            {
                         isCalledBack = YES;
                [delegate performSelector:failureCallbackMethod withObject:nil];
            }
        #pragma clang diagnostic pop
    }
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(mURLConnection) 
	{
		[mURLConnection cancel];
		mURLConnection=nil;
	}
    
      
}	


@end
