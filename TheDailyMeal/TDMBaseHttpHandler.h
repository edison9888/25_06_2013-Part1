//
//  TDMBaseHttpHandler.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMURLHandler.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#include "SBJson.h"
@protocol TDMBaseHttpHandlerDelegate <NSObject>
@required
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request;
- (void)requestCompletedWithErrors:(ASIHTTPRequest *)theRequest;
- (void)requestFailedWithAuthenticationError:(ASIHTTPRequest *)theRequest;
@optional
- (void)sessionValid:(BOOL)status;
@end


@interface TDMBaseHttpHandler : NSObject <ASIHTTPRequestDelegate>
{
    id <TDMBaseHttpHandlerDelegate> delegate;
    BOOL clearCurrentQueue;
    int typeRequest;

}
@property (nonatomic, assign) NSInteger typeRequest;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) BOOL clearCurrentQueue;

+ (void)setSessionCookie: (NSHTTPCookie *)cookie;
+ (NSHTTPCookie *)getSessionCookie;
+ (void)saveSession;
+ (void)clearSession;
+ (BOOL)isSessionInfoAvailable;
- (void)saveTheCookie:(ASIHTTPRequest*)request;
- (BOOL)extractSuccessKeyValue:(NSDictionary*)responseDictionary;
- (BOOL)connected;
//+ (TDMHTTPRequestType)getRequestType:(ASIHTTPRequest*)request;
- (void)trackRequestError:(ASIHTTPRequest*)request;

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params;
- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest;
- (void)getRequest:(NSString*)apiName;
- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params;
- (void)putRequest:(NSString *)apiName RequestBody:(NSString *)strRequest;
- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params;
@end
