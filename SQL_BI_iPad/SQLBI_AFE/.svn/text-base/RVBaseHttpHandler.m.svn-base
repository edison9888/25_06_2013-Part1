//
//  RVBaseHttpHandler.m
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "RVBaseHttpHandler.h"
#import "Reachability.h"
#import "ConnectivityCheck.h"

@interface RVBaseHttpHandler (PVT) 

-(NSString*)getResposeString;

@end

static BOOL isConnected;
static double connectivityCurrentTimerToken;
//static BOOL connectivityCheckTimerStarted;

@implementation RVBaseHttpHandler
@synthesize delegate, requestinfo;

- (BOOL) connected 
{
    ConnectivityCheck *connectivityObj = [[ConnectivityCheck alloc] init];
    return [connectivityObj isHostReachable];
}


-(void) connectionCheckTimerMethod:(NSNumber*) token
{
    double tokenDoubleVal = [token doubleValue];
    
    while (1) {
        
        NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSASCIIStringEncoding error:nil];
        
        if(URLString)
            isConnected = YES;
        else
            isConnected = NO;
        
        [NSThread sleepForTimeInterval:2.0];
        
        if(tokenDoubleVal != connectivityCurrentTimerToken)
            break;

    }

}


-(id)init
{
    if( self = [super init])
    {

    }
    return self;
}


#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    if(!mResponseData)
        mResponseData=[NSMutableData data];
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
    
    ConnectivityCheck *connectivityObj = [[ConnectivityCheck alloc] init];
    if ([self respondsToSelector:@selector(serverConnectfailureReasonIsNoConnection)]&&[self respondsToSelector:@selector(serverConnectfailureReasonIsUnknown)]) {
        [connectivityObj testInternetConnectivity:self callbackForConnectionFailure:@selector(serverConnectfailureReasonIsNoConnection) callbackForConnectionSuccess:@selector(serverConnectfailureReasonIsUnknown)];        
    }
    
}

-(void) serverConnectfailureReasonIsNoConnection
{
    if(self.delegate)
        [self.delegate requestFailedWithError:RVAPIResponseStatusCodeNoConnectivityError message:@"Unable to reach server. Please check your internet connectivity." forRequestType:self.requestinfo];
}

-(void)serverConnectfailureReasonIsUnknown
{
   //This happens when internet connectivity is avaialable. But server is down.
    if(self.delegate)
        [self.delegate requestFailedWithError:RVAPIResponseStatusCodeServerUnReachableError message:@"Cannot reach server! Please contact Administrator." forRequestType:self.requestinfo];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
     if(mURLConnection) 
	{
		[mURLConnection cancel];
		mURLConnection=nil;
	}
    
    if(self.delegate)
    {
        [self.delegate requestCompletedSuccessfully:[self getResposeString] forRequest:self.requestinfo];
    }
    
}	
 

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //    if (... user allows connection despite bad certificate ...)
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    //[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark -

-(NSString*)getResposeString
{
    // parsing the first level    
    
    NSString *responseString=[[NSString alloc]initWithData:mResponseData encoding:NSUTF8StringEncoding];
    
    return responseString;
}


#pragma mark - Http Request processing methods

- (void)getRequest:(NSString*)apiName withRequestInfo:(RVAPIRequestInfo*) requestInfoObj
{
    NSString *requestToSend;
    
    requestToSend = [NSString stringWithFormat:@"%@%@", 
                     [RVUrlHandler GVWEBSERVERURL:requestInfoObj.requestType], 
                     apiName];

    NSLog(@"%@",requestToSend);
    currentRequestURL = [[NSURL alloc] initWithString:requestToSend];
    
    ConnectivityCheck *connectivityObj = [[ConnectivityCheck alloc] init];
    [connectivityObj testInternetConnectivity:self callbackForConnectionFailure:@selector(serverConnectfailureReasonIsNoConnection) callbackForConnectionSuccess:@selector(proceedToServerConnectWithGETRequest)];
    

}

-(void) proceedToServerConnectWithGETRequest
{
    mURLConnection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:currentRequestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0] delegate:self];
    
}

-(void) proceedToServerConnectWithPOSTRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:currentRequestURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSLog(@"%@",currentRequestURL);
    
    NSData *requestData = [NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];

    mURLConnection=[NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj
{
	NSMutableString *requestString = [[NSMutableString alloc] initWithString:strAPIName];
    [requestString appendString:@"?"];
    int counter=1;
	
	//build encoded string from params dictionary.
	for (NSString *key in [params keyEnumerator])
    {
		[requestString appendFormat:@"%@=%@", key,[params valueForKey:key]];
        
		if ([params count]>1 && ([params count]!=counter))//requestString.length > 1)
        {
            counter++;
			[requestString appendString:@"&"];
		}        
	}
    
    self->requestinfo = requestInfoObj;
    
	[self getRequest:requestString withRequestInfo:requestInfoObj];
}

- (void)getRequest:(NSString*)strAPIName withParamString:(NSString *)param  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj
{
	NSMutableString *requestString = [[NSMutableString alloc] initWithString:strAPIName];
    [requestString appendString:param];
    self->requestinfo = requestInfoObj;
    
	[self getRequest:requestString withRequestInfo:requestInfoObj];
}

- (void)postRequest:(NSString*)strAPIName withParamString:(NSString *)param  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj
{
	dataToPost = param;
    self->requestinfo = requestInfoObj;

     NSString *requestToSend;
    
    requestToSend = [NSString stringWithFormat:@"%@%@", 
                     [RVUrlHandler GVWEBSERVERURL:requestInfoObj.requestType], 
                     strAPIName];
    
    NSLog(@"GET - Sending URL: %@", requestToSend);
    currentRequestURL = [[NSURL alloc] initWithString:requestToSend];
    
    ConnectivityCheck *connectivityObj = [[ConnectivityCheck alloc] init];
    [connectivityObj testInternetConnectivity:self callbackForConnectionFailure:@selector(serverConnectfailureReasonIsNoConnection) callbackForConnectionSuccess:@selector(proceedToServerConnectWithPOSTRequest)];
    
}



-(void) cancelHttpRequest
{
    if(mURLConnection)
    {
        [mURLConnection cancel];
        mURLConnection = nil;
    }
    
    self->requestinfo.statusCode = RVAPIResponseStatusCodeRequestCanceled;
}
 
@end
