#import "RequestSubscription.h"
#import "SubscriptionManager.h"
#import "Constants.h"
#import "Utility.h"

@implementation RequestSubscription
@synthesize requestInProgress, loadedFromCache;
@synthesize errorResult = _errorResult;

- (AsyncRequestController*) dataRequest {
    return [self apiRequest];
		// Only attempt a cache request if it has been within a certain amount of time
		// since we have completed a server request. If we have been offline for longer
		// than this period, we don't touch the cache.
    
//		if ([APIRequestManager isCacheStillValid]) {
//			return [self cacheRequest];
//		}
}

// Private method for starting a new API request or attaching ourselves to an in-progress one
// Returns whether or not a new request was started

- (void) initiateRequest {
	// Check for any current requests matching for this article
	// If none exist, start a new one
	AsyncRequestController *request = [SubscriptionManager requestThatMatchesSubscription:self];
    self.errorResult = nil;
	if (request) {
		self.requestInProgress = request;
		
		// Add ourselves to the request's userInfo
		[[requestInProgress.userInfo objectForKey:@"subscriptions"] addObject:self];
	}
	else {
		self.requestInProgress = [self dataRequest];
		
		if (!self.requestInProgress) {
			self.state = SubscriptionStateUnavailable;
			return;
		}
		
		[requestInProgress.userInfo setObject:[NSMutableArray array] forKey:@"subscriptions"];
				
		// Add ourselves to the request's userInfo
		[[requestInProgress.userInfo objectForKey:@"subscriptions"] addObject:self];
		
		// Look for any other subscriptions that may also care about this refresh, and inform them
		NSSet *matchingSubs = [SubscriptionManager subscriptionsMatchingSubscription:self];
		for (RequestSubscription *sub in matchingSubs) {
            if (sub != self) {
                [sub initiateRequest];
            }
		}
	}
	
	self.state = SubscriptionStatePending;
}

- (id) initWithContext:(ModelContext*)cont {
	return [self initWithContext:cont forceFetch:NO];
}

- (id) initWithContext:(ModelContext*)cont forceFetch:(BOOL)forceFetch {
	if ((self = [super initWithContext:cont])) {
        
        // Add ourselves to the manager's list of subscriptions
		[SubscriptionManager registerSubscription:self];
        
		if (!forceFetch && [self isDataAvailable]) {
			self.state = SubscriptionStateAvailable;
		} else {
			[self initiateRequest];
		}
	}
	return self;
}


- (void) cancel {
	[SubscriptionManager cancelSubscription:self];
	self.delegate = nil;
	
	// If we are waiting for a request to come back, remove ourselves from the list of subscriptions
	// to be informed when it completes. If there are no more subscriptions waiting for it, then cancel
	// the request
	if (self.requestInProgress) {
		NSMutableArray *listeningSubscriptions = [requestInProgress.userInfo objectForKey:@"subscriptions"];
		[listeningSubscriptions removeObject:self];
		
		if ([listeningSubscriptions count] == 0) {
			requestInProgress.cancel = YES;
		}
		else {
			// If there is another object watching this request, however the request's delegate is
			// self (i.e. this object "owns" the request, then transfer ownership to the next subscription
			if (requestInProgress.delegate == self) {
				requestInProgress.delegate = [listeningSubscriptions objectAtIndex:0];
			}
		}
	}
}

- (void) refresh {
	if (self.state != SubscriptionStatePending) {
		_triedServerRequest = NO; // TODO: Is it right to reset this here?
		
		[self initiateRequest];
	}
}


- (void) apiRequestSucceeded {
	self.loadedFromCache = NO;
	self.requestInProgress = nil;
	self.state = SubscriptionStateAvailable;
}

- (void) apiRequestFailedWithErrorResult:(NSObject*)errorResult {
	// If the API request failed, next see about cached data. If there is none,
	// set to Unavailable right away, otherwise wait for a cache callback
    SubscriptionState state = SubscriptionStateUnavailable;
	if ([errorResult isKindOfClass:[NSError class]] && ((((NSError*) errorResult).code == kHTTP_401_ERROR_AuthTokn))) {
        state = SubscriptionStateAuthenticationRequired;
    } else if ([errorResult isKindOfClass:[NSError class]] && (((NSError*) errorResult).code == kHTTP_ERROR_NoConnection)) {
        state = SubscriptionStateNoConnection;
    }
    
    self.errorResult = errorResult;
    if ([self.requestInProgress isKindOfClass:[APIRequestController class]]) {
        self.requestInProgress = nil;
        self.state = state;
    } else {
        NSLog(@"API request failed with unexpected request type %@", self.requestInProgress);
    }
}

// These methods are implemented by subclasses!

- (BOOL) isDataAvailable {
	return NO;
}
- (BOOL) subscriptionMatches:(ModelSubscription*)subscription {
	return NO;
}
- (APIRequestController*) apiRequest {
	return nil;
}

#pragma mark -
#pragma mark AsyncRequestDelegate Methods

// Callbacks from a cache request

- (void)asyncRequest:(AsyncRequestController*)request didLoad:(id)result {
    
}

- (void)asyncRequest:(AsyncRequestController*)request didFailWithError:(NSError*)error result:(NSObject*)result{
	
}

- (NSString *)description {
    NSString *state = @"";
    if (self.state == SubscriptionStatePending) {
        state = @"SubscriptionStatePending";
    } else if (self.state == SubscriptionStateAvailable) {
        state = @"SubscriptionStateAvailable";
    } else if (self.state == SubscriptionStateUnavailable) {
        state = @"SubscriptionStateUnavailable";
    } else {
        state = @"SubscriptionStateUnknown";
    }
    return [NSString stringWithFormat:@"%@ (%p) - %@%@", self.class, self, state, (self.requestInProgress!=nil) ? @" (request in progress)" : @""];
}

#pragma mark -

- (void) dealloc {
	[[self.requestInProgress.userInfo objectForKey:@"subscriptions"] removeObject:self];
	self.requestInProgress = nil;
}


@end
