#import "AsyncRequestController.h"


@implementation AsyncRequestController
@synthesize cancel=_cancel, delegate=_delegate, userInfo=_userInfo;

- (id) init {
	if ((self = [super init])) {
		_userInfo = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) setCancel:(BOOL)cancel {
	_cancel = cancel;
	_delegate = nil;
}


@end
