#import <Foundation/Foundation.h>

@protocol AsyncRequestDelegate;

// Superclass for both API (server) requests, and disk-cache lookup requests
@interface AsyncRequestController : NSObject {
	id <AsyncRequestDelegate> __unsafe_unretained _delegate;
	BOOL _cancel;
	NSMutableDictionary *_userInfo;
}

@property (nonatomic) BOOL cancel;
@property (nonatomic, unsafe_unretained) id<AsyncRequestDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;

@end


@protocol AsyncRequestDelegate <NSObject>

- (void)asyncRequest:(AsyncRequestController*)request didLoad:(id)result;
- (void)asyncRequest:(AsyncRequestController*)request didFailWithError:(NSError*)error result:(NSObject*)result;

@end