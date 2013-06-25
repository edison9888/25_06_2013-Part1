#import "ModelSubscription.h"
#import "SubscriptionManager.h"

@implementation ModelSubscription
@synthesize state =_state, delegate, context = _context, loadedFromCache;

- (id) init {
	NSAssert(NO, @"Initialized Subscription without context!");
	return nil;
}

- (id) initWithContext:(ModelContext*)cont {
	if ((self = [super init])) {
		_context = cont;
	}
	return self;
}
- (void) setState:(SubscriptionState)s {
	_state = s;
	[delegate subscriptionUpdatedState:self];
}

- (void) cancel {
	self.delegate = nil;
}

- (void) refresh {}

- (BOOL) loadedFromCache {
	return NO;
}


@end
