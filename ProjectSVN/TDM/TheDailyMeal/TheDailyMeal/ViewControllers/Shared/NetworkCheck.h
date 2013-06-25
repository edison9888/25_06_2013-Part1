//
//  NetworkCheck.h
//
//  Copyright 2010 RapidValue. All rights reserved.
//


#import <Foundation/Foundation.h>

#include <SystemConfiguration/SCNetworkReachability.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>


@interface NetworkCheck : NSObject {
	
}

+(BOOL)isServerAvailable;
@end
