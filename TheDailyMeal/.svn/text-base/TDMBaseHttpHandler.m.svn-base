//
//  RBBaseAsyncHttpHandler.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"
#import "Reachability.h"

 
@implementation TDMBaseHttpHandler

@synthesize delegate;
@synthesize clearCurrentQueue;

@synthesize typeRequest;
// cookie code begin
//  cookie 
static NSHTTPCookie *rbCookie;
static NSRecursiveLock *sessionLock;

NSString * const kSuccessKeyValue = @"success";

#pragma mark - Object lifecycle

- (void)dealloc
{
    [delegate release];
    [super dealloc];
}

#pragma mark - Session management

+ (void)saveSessionCookies:(NSArray *)cookies
{
    NSDictionary* savedCookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"TDMCookies"];
    NSMutableDictionary * cookieDictionary=  nil;
    if (savedCookieDictionary) {
        cookieDictionary = [[NSMutableDictionary alloc] initWithDictionary:savedCookieDictionary];
    }
    else {
        cookieDictionary = [[NSMutableDictionary alloc] init];
    }
    
    for (NSHTTPCookie * cookie in cookies) {
        [cookieDictionary setValue:cookie.properties forKey:cookie.name];
    }

	[[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:@"TDMCookies"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	[cookieDictionary release];
}
+ (NSHTTPCookie *)getSessionCookie {
    return nil;
}

+ (NSArray *)getSessionCookies
{
    NSDictionary* savedCookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"TDMCookies"];
    NSArray * allKeys = [savedCookieDictionary allKeys];
    NSMutableArray * cookies = [[NSMutableArray alloc] init];
    for (NSString * key in allKeys) {
        NSDictionary * properties = [savedCookieDictionary valueForKey:key];
        NSHTTPCookie * cookie = [NSHTTPCookie cookieWithProperties:properties];
        [cookies addObject:cookie];
    }
    return [cookies autorelease];
}

+ (void) saveSession
{
	NSLog(@"Saving session to disk");
	[sessionLock lock];
	NSHTTPCookie *cookie = rbCookie;
	NSMutableDictionary* cookieDictionary = [[NSMutableDictionary alloc] init];
	[cookieDictionary setValue:cookie.properties forKey:@"sessionid"];
	[[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:@"MCDSKEY"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	[cookieDictionary release];
	rbCookie = nil;
	[sessionLock unlock];
}

+ (void) clearSession
{
	NSLog(@"Clearing session");
	[sessionLock lock];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MCDSKEY"];
	[[NSUserDefaults standardUserDefaults]synchronize];	
	rbCookie = nil;
	[sessionLock unlock];
}

+ (BOOL) isSessionInfoAvailable
{
	if ([TDMBaseHttpHandler getSessionCookie] == nil)
	{
		return NO;
	}
	return YES;
}
// cookie code end

// cookie code begin
- (void)saveTheCookie:(ASIHTTPRequest*)request {
    // Save the MCDS cookie 
	NSArray *newCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[request responseHeaders] 
                                                                 forURL:[request url]];
    [TDMBaseHttpHandler saveSessionCookies:newCookies];
}

- (void)addCookies:(ASIHTTPRequest*)request {
    NSArray * cookies = [TDMBaseHttpHandler getSessionCookies];
    [request setRequestCookies:[NSMutableArray arrayWithArray:cookies]];
}

// cookie code end
- (BOOL)extractSuccessKeyValue:(NSDictionary*)responseDictionary
{
    BOOL isSuccess = [[responseDictionary objectForKey:kSuccessKeyValue] boolValue];
    //  BOOL isSuccess = ([successString isEqualToString:@"true"] ? YES : NO);
    
    return isSuccess;
}

#pragma mark - Public API

- (BOOL)connected 
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}

- (void)putRequest:(NSString *)apiName RequestBody:(NSString *)strRequest
{
    NSString *requestToSend = [NSString stringWithFormat:@"%@",apiName];
    
    NSLog(@"PUT - Sending URL: %@ with body: %@",requestToSend,strRequest);
    
    NSURL * url = [[NSURL alloc] initWithString:requestToSend];
    
    if (!sessionLock) {
        sessionLock = [[NSRecursiveLock alloc] init];
    }
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];
    [request appendPostData:[strRequest dataUsingEncoding:NSUTF8StringEncoding]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request setRequestMethod:@"PUT"];
    [request setShouldRedirect:NO];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@",request.requestHeaders);
    // cookie code begin
    [request setUseCookiePersistence:YES];
    
        // Add the session cookie if it exists
        NSHTTPCookie *cookie = [TDMBaseHttpHandler getSessionCookie];
        if (cookie != nil)
        {
            [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
        }
        // cookie code end
    
    if ([self connected]) {
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        
        [delegate requestCompletedWithErrors:nil];
    }
}

- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest
{
	NSString *requestToSend=[NSString stringWithFormat:@"%@",apiName];
    
    NSLog(@"POST - Sending URL: %@ with body: %@", requestToSend, strRequest);
    NSURL * url = [[NSURL alloc] initWithString:requestToSend];
    
    // cookie code begin
    if (!sessionLock) 
	{
		sessionLock = [[NSRecursiveLock alloc] init];
	}
    // cookie code end
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];
    [request appendPostData:[strRequest dataUsingEncoding:NSUTF8StringEncoding]];
 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setShouldRedirect:NO];
    [request setTimeOutSeconds:60];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    [self addCookies:request];

    if ([self connected]) {
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        
        [delegate requestCompletedWithErrors:nil];
    }
    
}

- (void)getRequest:(NSString*)apiName 
{

    NSLog(@"GET - Sending URL: %@", apiName);
    NSURL * url = [[NSURL alloc] initWithString:apiName];
    
    // cookie code begin
    if (!sessionLock) 
	{
		sessionLock = [[NSRecursiveLock alloc] init];
	}
    // cookie code end
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];

    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setShouldRedirect:NO];
    [ASIHTTPRequest setDefaultTimeOutSeconds:20];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    [self addCookies:request];
    // cookie code end
       
    if ([self connected]) {
        
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];

        
        
        alert.delegate = self;
        [alert show];
        [alert release];
        
        [delegate requestCompletedWithErrors:nil];
    }

}

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params
{
	NSMutableString *requestString = [[NSMutableString alloc] init];
	
	//build encoded string from params dictionary.
	for (NSString *key in [params keyEnumerator])
    {
		if (requestString.length > 0)
        {
			[requestString appendString:@"&"];
		}
        
		[requestString appendFormat:@"%@=%@", key,[params valueForKey:key]];
	}
    
	[self postRequest:strAPIName RequestBody:requestString];
    NSLog(@"request String %@",requestString);
	[requestString release];
}

- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params 
{
	NSMutableString *requestString = [[NSMutableString alloc] initWithString:strAPIName];
    NSLog(@"strAPIName before appending %@",strAPIName);
	
	//build encoded string from params dictionary.
	for (NSString *key in [params keyEnumerator])
    {
		[requestString appendFormat:@"%@=%@", key,[params valueForKey:key]];
        
		if ([params count]>1)//requestString.length > 1)
        {
			[requestString appendString:@"&"];
		}        
	}
    NSLog(@"request String %@",requestString);
	[self getRequest:requestString];
    
	[requestString release];    
    
}

- (void)trackRequestError:(ASIHTTPRequest*)request
{

}



#pragma mark - response delegate 
- (void)requestFinished:(ASIHTTPRequest *)request {

    NSLog(@"Successfull");
    //overridden in the subclasses
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"Request Failed due to server error: %@ %d",request.responseString,request.responseStatusCode);
    
    if(request.responseStatusCode > 0){
        
        //NSString *serverError = [NSString stringWithFormat:@"Request Failed due to server Error %d",request.responseStatusCode];
        if(request.responseStatusCode == 401){
            
            if (self.delegate && [self.delegate  respondsToSelector:@selector(requestFailedWithAuthenticationError:)]) 
            {
                //commented this because it is not used anywhere
               // serverError = UNAUTHORISED_MESSSAGE;
                [TDMDataStore sharedStore].isLoggedIn = NO;
                [TDMUtilities clearCookies];
                [self.delegate requestFailedWithAuthenticationError:request];
            }
        }   
        //TODO
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ALERT_TITLE
//                                                       message:serverError 
//                                                      delegate:nil 
//                                             cancelButtonTitle:@"OK" 
//                                             otherButtonTitles:nil];
//        [alert show];
//        [alert release];
    }
}

+ (void)setSessionCookie: (NSHTTPCookie *)cookie
{
    
}
@end
