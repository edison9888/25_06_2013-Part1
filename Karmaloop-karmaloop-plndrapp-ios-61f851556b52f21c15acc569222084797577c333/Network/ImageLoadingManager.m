#import "ImageLoadingManager.h"
#import "ImageUrlConnection.h"
#import "Utility.h"
//#import "UIApplication+NetworkActivityIndicatorAddition.h"

#define MAX_PARALLEL_IMAGE_CONNECTIONS 5

@implementation ImageLoadingManager

static ImageLoadingManager *manager = nil;

+ (ImageLoadingManager*) sharedInstance {
	@synchronized (manager) {
		if (manager == nil) {
			manager = [[ImageLoadingManager alloc] init];			
		}
	}
	return manager;
}

- (id) init {
	if ((self = [super init])) {
		_connections = [[NSMutableArray alloc] init];
		_queuedConnections = [[NSMutableArray alloc] init];
        _lowPriorityQueuedConnections = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) reset {
	for (ImageUrlConnection *conn in _connections) {
		[conn cancel];
	}
	[_connections removeAllObjects];
	[_queuedConnections removeAllObjects];
    [_lowPriorityQueuedConnections removeAllObjects];
}

- (void) startQueuedConnections {
	while ([_connections count] < MAX_PARALLEL_IMAGE_CONNECTIONS && 
           _queuedConnections.count + _lowPriorityQueuedConnections.count > 0) {
		
        BOOL fromLowPriorityQueue = _queuedConnections.count <= 0;
        ImageUrlConnection *conn = fromLowPriorityQueue ? [_lowPriorityQueuedConnections objectAtIndex:0] : [_queuedConnections objectAtIndex:0];
		
		[_connections addObject:conn];
        if (fromLowPriorityQueue) {
            [_lowPriorityQueuedConnections removeObjectAtIndex:0];
        } else {
            [_queuedConnections removeObjectAtIndex:0];
        }
//        NSLog(@"ImageLoadingManager: currQ = %d, normalQ = %d, lowPriorityQ = %d", _connections.count, _queuedConnections.count, _lowPriorityQueuedConnections.count);

		// Start the connection
		[conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes/*NSDefaultRunLoopMode*/];
		[conn start];		
	}
	
    //TODO fix this
//	[[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

- (ImageUrlConnection*) loadImage:(NSString*)url delegate:(id<ImageLoadingManagerDelegate>)del {
    return [self loadImage:url delegate:del lowPriority:NO];
}

- (ImageUrlConnection*) loadImage:(NSString*)url delegate:(id<ImageLoadingManagerDelegate>)del lowPriority:(BOOL)lowPriority {
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    //Change to return cache data first if not found then load from internet
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];	
	
    [request setValue:[Utility userAgentString] forHTTPHeaderField:@"User-Agent"];
    
    ImageUrlConnection *connection = [[ImageUrlConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	connection.requesterDelegate = del;
	connection.sourceUrl = url;
	

	if (lowPriority) {
        [_lowPriorityQueuedConnections addObject:connection];
    }
    else {
        [_queuedConnections addObject:connection];	
    }

	[self startQueuedConnections];
	return connection;
}

- (void) cancelLoadingImageConnection:(ImageUrlConnection*)connection {
	[connection cancel];
	[_connections removeObject:connection];
	[_queuedConnections removeObject:connection];
    [_lowPriorityQueuedConnections removeObject:connection];
	[self startQueuedConnections];
}

#pragma mark -
#pragma mark Connection Delegate Methods


-(void)connection:(NSURLConnection *)con didReceiveResponse:(NSURLResponse *)response
{
	ImageUrlConnection *connection = (ImageUrlConnection*)con;
	connection.receivedData = [[NSMutableData alloc] initWithLength:0];
}


-(void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data
{
	ImageUrlConnection *connection = (ImageUrlConnection*)con;
	[connection.receivedData appendData:data];
}


-(void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error
{
	ImageUrlConnection *connection = (ImageUrlConnection*)con;
	
    @synchronized(connection.requesterDelegate) {
        if (connection.requesterDelegate) {
            [connection.requesterDelegate failedLoadingImageFromUrl:connection.sourceUrl connection:connection];
        }
    }
	
	[_connections removeObject:connection];
	[self startQueuedConnections];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)con
{
	ImageUrlConnection *connection = (ImageUrlConnection*)con;
	
	UIImage *image = [UIImage imageWithData:connection.receivedData];
	
	if (image) {
		@synchronized(connection.requesterDelegate) {
			if (connection.requesterDelegate) {
				[connection.requesterDelegate finishedLoadingImage:image fromUrl:connection.sourceUrl connection:connection];
			}
		}
	}
	else {
		@synchronized(connection.requesterDelegate) {
			if (connection.requesterDelegate) {
				[connection.requesterDelegate failedLoadingImageFromUrl:connection.sourceUrl connection:connection];
			}
		}
	}
	
	[_connections removeObject:connection];
	[self startQueuedConnections];
}


- (BOOL) hasOutstandingRequests {
	return [_connections count] > 0 || [_queuedConnections count] > 0 || [_lowPriorityQueuedConnections count] > 0;
}

#pragma mark -


@end
