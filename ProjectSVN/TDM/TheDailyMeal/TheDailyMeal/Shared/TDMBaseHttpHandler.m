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
@synthesize requestType;

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

+ (void)setSessionCookie: (NSHTTPCookie *)cookie
{
	[sessionLock lock];
	rbCookie = [cookie retain];
	[sessionLock unlock];
}

+ (NSHTTPCookie *)getSessionCookie
{
	NSHTTPCookie *cookie;
	[sessionLock lock];
	cookie = rbCookie;
	[sessionLock unlock];
	if (cookie == nil)
	{
		// If it is not in memory get it from storage
		NSDictionary* cookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MCDSKEY"];
		NSDictionary* cookieProperties = [cookieDictionary valueForKey:@"sessionid"];
		if (cookieProperties != nil) {
			cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
			rbCookie = [cookie retain];
		}
	}
	return rbCookie;
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
- (void)saveTheCookie:(ASIHTTPRequest*)request
{
    // Save the MCDS cookie 
	NSArray *newCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[request responseHeaders] forURL:[request url]];
	NSHTTPCookie *cookie;
	for (cookie in newCookies)
    {
        NSLog(@"Cookie Name: %@", cookie.name);
		//if ([cookie.name isEqualToString:@"MCDS"]) 
        if ([cookie.name isEqualToString:@"sessionid"])
		{ 
			[TDMBaseHttpHandler setSessionCookie:cookie];
            [TDMBaseHttpHandler saveSession];
		}
	}
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

- (void)putRequest:(NSString *)apiName RequestBody:(NSString *)strRequest withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType {
    NSString *requestToSend = [NSString stringWithFormat:@"%@%@",[TDMURLHandler RBWEBSERVERURL:TDMHTTPrequestType],apiName];
    
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
    
    if (requestType == kCurrentLocationBusinessDetails ) 
    {
        [TDMBaseHttpHandler clearSession];
    }
    else
    {
        // Add the session cookie if it exists
        NSHTTPCookie *cookie = [TDMBaseHttpHandler getSessionCookie];
        if (cookie != nil)
        {
            [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
        }
        // cookie code end
    }
    
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

- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType
{
	NSString *requestToSend=[NSString stringWithFormat:@"%@%@", 
                             [TDMURLHandler RBWEBSERVERURL:TDMHTTPrequestType], 
                             apiName];
    
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
    if (requestType == kCurrentLocationBusinessDetails) {
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    }
    if (!(requestType == kCurrentLocationBusinessDetails)) {
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
    }
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setShouldRedirect:NO];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@",request.requestHeaders);
    // cookie code begin
    [request setUseCookiePersistence:YES];
    
    if (requestType == kCurrentLocationBusinessDetails)
    {
        [TDMBaseHttpHandler clearSession];
    }
//    else if (requestType == kTDMAddSignatureDish)
//    {
//        [request setUsername:@"vivek"];
//        [request setPassword:@"vivek"];
//    }
    else
    {
        // Add the session cookie if it exists
        NSHTTPCookie *cookie = [TDMBaseHttpHandler getSessionCookie];
        if (cookie != nil)
        {
            [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
        }
        // cookie code end
        NSLog(@"cookie %@",cookie);
    }
    

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

- (void)getRequest:(NSString*)apiName withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType
{
    NSString *requestToSend=[NSString stringWithFormat:@"%@%@", 
                             [TDMURLHandler RBWEBSERVERURL:TDMHTTPrequestType], 
                             apiName];
    
    NSLog(@"GET - Sending URL: %@", requestToSend);
    NSURL * url = [[NSURL alloc] initWithString:requestToSend];
    
    // cookie code begin
    if (!sessionLock) 
	{
		sessionLock = [[NSRecursiveLock alloc] init];
	}
    // cookie code end
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];
    if (requestType == kCurrentLocationBusinessDetails) {
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    }
    if (!(requestType == kCurrentLocationBusinessDetails)) {
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
    }
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setShouldRedirect:NO];
    [ASIHTTPRequest setDefaultTimeOutSeconds:20];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    // cookie code begin
    [request setUseCookiePersistence:NO];
    
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

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType
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
    
	[self postRequest:strAPIName RequestBody:requestString withRequestType:TDMHTTPrequestType];
    NSLog(@"request String %@",requestString);
	[requestString release];
}

- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType
{
	NSMutableString *requestString = [[NSMutableString alloc] initWithString:strAPIName];
    NSLog(@"strAPIName before appending %@",strAPIName);
    //[requestString appendString:@"?"];
	
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
	[self getRequest:requestString withRequestType:TDMHTTPrequestType];
    
	[requestString release];    
    
}

+ (TDMHTTPRequestType)getRequestType:(ASIHTTPRequest*)request
{
    TDMHTTPRequestType reqType = kUnknownType;
    if (request.userInfo)
    {

    }
    
    return reqType;
}

- (void)trackRequestError:(ASIHTTPRequest*)request
{

}

#pragma mark - To Override
//TDMBusinessDetailsProviderAndHandler
- (void)getCurretLocationBusinessdetailsForQuery:(NSString *)query 
                                     forLatitude:(double)latitude 
                                    andLongitude:(double)longitude
{
    
}

//TDMLogoutHandler
- (void)logoutCurrentUser {
    
}

//TDMLoginHandler
- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password {
    
}

//TDMForgotPasswordHandlerAndProvider
-(void)sendForgotPasswordEmail:(NSString *)emailAddress {
    
}

//TDMSignupHandlerAndProvider
-(void)signUpUserWithUserName:(NSString *)userName 
               havingPassword:(NSString *)password 
                     andEmail:(NSString *)email 
                  withComment:(NSString *)comment 
         andLegalAcceptOption:(int)legalAccept {
    
}

//TDMBusinessHomeHandlerAndProvider
-(void)getBusinessHomeDetailsForVenueID:(int)venueNID 
{
}

//TDMCityGuideListOfCitiesHandler
-(void)getListOfCitiesForVenueID:(int)vid andParent:(int)parent {
    
}

//TDMCityGuideListOfRestaurantsHandler
-(void)getListOfRestaurantsForCity:(NSString *)cityName:(NSString *)guideType:(int) count:(int)offset{
    
}
//TDMCityGuideListOfBarsHandler
-(void)getListOfBarsForCity:(NSString *)cityName : (NSString *)guideType:(int) count:(int)offset{
    
}

//TDMBusinessSignatureDishesListHandler
-(void)getSignatureDishesListForVenue:(int)venueID {
    
}


//TDMBusinessReviewListHandlerAndProvider
-(void)getReviewListForVenueID:(int)venueID {
    
}


//TDMUserProfileHandlerAndProvider
-(void)getUserProfileForUserID:(NSString *)userID {
    
}

//TDMUploadPhotoHelper
-(void)uploadPhotoFromPath:(NSString *) filePath withFileName:(NSString *)fileName andUploadType:(int)fileType {
    
}

//TDMAddSignatureDishHandlerAndProvider
-(void)addSignatureDishWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid withPhotoFID:(NSString *)photoFID {
    
}

//TDMFilePUTHelper
-(void)putFileWithFID:(NSString *) fid {
    
}

//TDMFoursquareBrowse
-(void)makeFourSquareBrowseRequestWithQuery:(NSString *)query forLatitude:(float) latitude andLongitude:(float) longitude {
    
}

//TDMFoursquareName
-(void)makeFourSquareNameRequestWithQuery:(NSString *)query forLatitude:(float) latitude andLongitude:(float) longitude {
    
}

- (void)getBusinessReviewsForVenue
{
    
}

// TDMUserThumbnailHandlerAndProvider
- (void)signUpWithProfileImage:(NSString *)imagePath userId:(NSString *)userId
{
    
}
@end
