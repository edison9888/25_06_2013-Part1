#import <Foundation/Foundation.h>
#import "APIRequestManager.h"
#import "AsyncRequestController.h"

@interface APIRequestController : AsyncRequestController 

#if kUseStaginUrls 
// SSL Bypass Code. Should only be in the build if you are pointing to staging servers.
<NSURLConnectionDelegate>
#endif

{
	
	APIRequestManager *owner;
	
	RequestType requestType;
	NSMutableData *webData;
	
	NSURLConnection *__unsafe_unretained connection;
}

@property (nonatomic, unsafe_unretained) NSURLConnection *connection;
@property (nonatomic, strong) APIRequestManager *owner;
@property (nonatomic, unsafe_unretained) RequestType requestType;
@property int statusCode;

- (id) initWithOwner:(APIRequestManager*)owner;

+ (NSDate*)getLastDownloadTime;

@end