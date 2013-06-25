#import <QuartzCore/QuartzCore.h>
#import "APIRequestController.h"
#import "JSON.h"
#import "Utility.h"
#import "Constants.h"
#import "PlndrStrings.h"

static const int kGeneralErrorCode = 10000;

@interface APIRequestController ()

+ (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData;
+ (id)parseJsonResponse:(NSData*)data error:(NSError**)error;
+ (id)parseJsonResponseString:(NSString*)responseString error:(NSError**)error;

@end


@implementation APIRequestController

@synthesize owner, connection, requestType, statusCode = _statusCode;


- (id) initWithOwner:(APIRequestManager*)own {
	if ((self = [super init])) {
		self.owner = own;
		webData = [[NSMutableData alloc] init];
		connection = nil;
	}
	
	return self;
}

- (void) setCancel:(BOOL)c {
	[super setCancel:c];
	
	if ( connection != nil ) {
		[connection cancel];
		connection = nil;
		[owner removeRequest:self];
	}
}

#pragma mark -
#pragma mark JSON Methods

+ (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
	return [self parseJsonResponseString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:error];
}

+ (id)parseJsonResponseString:(NSString*)responseString error:(NSError**)error {
	SBJSON *jsonParser = [SBJSON new];
	if ([responseString isEqualToString:@"true"]) {
		return [NSDictionary dictionaryWithObject:@"true" forKey:@"result"];
	} else if ([responseString isEqualToString:@"false"]) {
		if (error) {
			*error = [self formError:kGeneralErrorCode 
							userInfo:[NSDictionary 
									  dictionaryWithObject: OPERATION_CANNOT_BE_COMPLETED
									  forKey:@"error_msg"]];
		}
		return nil;
	}
	
    if ([responseString isEqualToString:@"[]"]) {
        //Empty array
        NSLog(@"Got empty array as response, setting response result as nil");
        return nil;
    }
	
	id result = [jsonParser objectWithString:responseString];
	
	if (![result isKindOfClass:[NSArray class]]) {
		if ([result objectForKey:@"error"] != nil) {
			if (error) {
				*error = [self formError:kGeneralErrorCode
								userInfo:result];
			}
			return nil;
		}
		
		if ([result objectForKey:@"error_code"] != nil) {
			if (error) {
				*error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
			}
			return nil;
		}
		
		if ([result objectForKey:@"error_msg"] != nil) {
			if (error) {
				*error = [self formError:kGeneralErrorCode userInfo:result];
			}
		}
		
		if ([result objectForKey:@"error_reason"] != nil) {
			if (error) {
				*error = [self formError:kGeneralErrorCode userInfo:result];
			}
		}
	}
	
	return result;
	
}

+ (id) formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
	return [NSError errorWithDomain:@"APIRequestDomain" code:code userInfo:errorData];
}

#pragma mark -
#pragma mark Connection Methods

-(void)connection:(NSURLConnection *)con didReceiveResponse:(NSURLResponse *)response
{
	connection = con;
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = [httpResponse statusCode];
    
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)con
{
	connection = nil;
	[self performSelectorInBackground:@selector(parseData:) withObject:webData];
}


-(void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error
{
	connection = nil;
	
	@synchronized(self.delegate) {
		[self.delegate asyncRequest:self didFailWithError:error result:nil];
	}
	
	[owner removeRequest:self];
	
	requestType = Nothing;
	self.delegate = nil;
}


#pragma mark - Private

+ (NSDate*) getLastDownloadTime {
    NSDate *lastOnlineTime;
    @synchronized([NSUserDefaults standardUserDefaults]) {
        lastOnlineTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastConnectionTimeKey];
    }    
    return lastOnlineTime;
}

- (void) parseData:(NSData*)data {
	// Called on background thread
	
	@autoreleasepool {
	
		NSError* error = nil;
		id result = [APIRequestController parseJsonResponse:data error:&error];
		
		[self performSelectorOnMainThread:@selector(parsingFinished:) withObject:error ? error : result waitUntilDone:YES];
	
	}
}

- (void) parsingFinished:(id)result {
	// Called on main thread
	
	if (self.cancel) {
		return;
	}
	
	if ([result isKindOfClass:[NSError class]] || self.statusCode >= kHTTP_400) {
		[self.delegate asyncRequest:self didFailWithError:result result:result];
	}
	else {
		[self.delegate asyncRequest:self didLoad:result];
	}
	
	requestType = Nothing;
	self.delegate = nil;
	[owner removeRequest:self];
	
	[APIRequestManager updateLastConnectionTime];
}

#if kUseStaginUrls
// SSL Bypass Code. Should only be in the build if you are pointing to staging servers.

#pragma mark - NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}
#endif

@end
