//
//  TDMAPNSHttpHandler.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 22/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMAPNSHttpHandler.h"

@implementation TDMAPNSHttpHandler

NSString * const kAPNSRegisterApi = @"/m/apns/register";
NSString * const kAPNSUnregisterApi = @"/m/apns/unregister";

NSString * const kAPNSUsernameKey = @"username";
NSString * const kAPNSDeviceTokenKey = @"token";

#pragma mark - Helper methods

- (NSString *)deviceTokenToHexString:(NSData *)data {
    // Convert the NSData into a hex string (for easy portability).
    // From http://stackoverflow.com/questions/1305225/
    NSString *token = [[data description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token substringWithRange:NSMakeRange(1, [token length] - 2)];
    return token;
}

#pragma mark - Public API

- (void)registerAPNSToken:(NSData *)data withUsername:(NSString *)username {
    NSString *token = [self deviceTokenToHexString:data];
    NSLog(@"APNS registration: username=%@, token=%@", username, token);
    
    // Send an async POST request.
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:username forKey:kAPNSUsernameKey];
    [params setObject:token forKey:kAPNSDeviceTokenKey];
    [self postRequest:kAPNSRegisterApi withParams:params withRequestType:kAPNSRegister]; 
    
    [params release];
    params = nil;
}

- (void)unregisterAPNSToken:(NSData *)data {
    NSString *token = [self deviceTokenToHexString:data];
    NSLog(@"APNS unregistration: token=%@", token);
    
    // Send an async POST request.
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:kAPNSDeviceTokenKey];
    [self postRequest:kAPNSUnregisterApi withParams:params withRequestType:kAPNSUnregister];    
    
    [params release];
    params = nil;
}

@end
