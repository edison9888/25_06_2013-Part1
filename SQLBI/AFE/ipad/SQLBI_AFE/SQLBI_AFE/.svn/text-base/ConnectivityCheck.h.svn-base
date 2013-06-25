//
//  ConnectivityCheck.h
//  Brighton
//
//  Created by Bittu Davis on 03/07/10.
//  Copyright 2012 RVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import "Reachability.h"

@interface ConnectivityCheck : NSObject {

    NSMutableData *mResponseData;
    NSURLConnection *mURLConnection;
    
    SEL failureCallbackMethod;
    SEL successCallbackMethod;
    id delegate;
    
    BOOL isCalledBack;

}
- (BOOL)isHostReachable;

-(void) testInternetConnectivity:(id) callbackDelegate callbackForConnectionFailure:(SEL) failureCallback callbackForConnectionSuccess:(SEL) successCallback;

@end
