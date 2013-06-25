#import <Foundation/Foundation.h>

@protocol ImageLoadingManagerDelegate;
@class ImageUrlConnection;

@interface ImageLoadingManager : NSObject {
	NSMutableArray *_connections;		// In-progress connections
	NSMutableArray *_queuedConnections;	// Waiting connections
    NSMutableArray *_lowPriorityQueuedConnections;  //Low priority waiting connections (for prefetching images and download for offline reading)
}

+ (ImageLoadingManager*) sharedInstance;

- (void) reset;
- (ImageUrlConnection*) loadImage:(NSString*)url delegate:(id<ImageLoadingManagerDelegate>) del;
- (ImageUrlConnection*) loadImage:(NSString*)url delegate:(id<ImageLoadingManagerDelegate>)del lowPriority:(BOOL)lowPriority;
- (void) cancelLoadingImageConnection:(ImageUrlConnection*)connection;
- (BOOL) hasOutstandingRequests;

@end



@protocol ImageLoadingManagerDelegate

- (void) finishedLoadingImage: (UIImage*)image fromUrl:(NSString*)url connection:(ImageUrlConnection*)conn;
- (void) failedLoadingImageFromUrl:(NSString*)url connection:(ImageUrlConnection*)conn;

@end