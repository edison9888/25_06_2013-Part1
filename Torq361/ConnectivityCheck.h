//
//  ConnectivityCheck.h
//  Brighton
//
//  Created by Timmi on 03/07/10.
//  Copyright 2010 RVS. All rights reserved.
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

}
- (BOOL)isHostReachable;
@end
