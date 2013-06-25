#import "SubscriptionManager.h"
#import "ModelSubscription.h"
#import "RequestSubscription.h"
#import "APIRequestController.h"


static NSMutableArray *_subscriptions;

@implementation SubscriptionManager

+ (NSMutableArray*)subscriptions {
	if (!_subscriptions) {
		_subscriptions = [[NSMutableArray alloc] init];	
	}
	return _subscriptions;
}

#pragma mark -
#pragma mark Subscription Methods

+ (void) registerSubscription:(ModelSubscription*)subscription {
	[[self subscriptions] addObject:subscription];
}

+ (void) cancelSubscription:(ModelSubscription*)subscription {
	[[self subscriptions] removeObject:subscription];
}

+ (AsyncRequestController*) requestThatMatchesSubscription:(ModelSubscription*)subscription {
	for (ModelSubscription *sub in [self subscriptions]) {
		if ([sub isKindOfClass:[RequestSubscription class]]) {
			RequestSubscription *rsub = (RequestSubscription*)sub;
			if (rsub.requestInProgress && rsub.context == subscription.context && [rsub subscriptionMatches:subscription]) {
				return rsub.requestInProgress;
			}
		}
	}
	return nil;
}

+ (NSSet*) subscriptionsMatchingSubscription:(ModelSubscription*)subscription {
	NSMutableSet *matchingSubs = [NSMutableSet set];
	
	for (ModelSubscription *sub in [self subscriptions]) {
		if ([sub isKindOfClass:[RequestSubscription class]]) {
			RequestSubscription *rsub = (RequestSubscription*)sub;
			if (rsub != subscription && rsub.context == subscription.context && [rsub subscriptionMatches:subscription]) {
				[matchingSubs addObject:rsub];
			}
		}
	}
	
	return matchingSubs;
}


#pragma mark -
#pragma mark API Request Delegate Methods

+ (void) informSubscriptionsOfFailure:(AsyncRequestController*)request result:(NSObject *)result{
	// If the request has any subscriptions associated with it, inform them of failure
	if (request.userInfo) {
		NSArray *subscriptions = [NSArray arrayWithArray:[request.userInfo objectForKey:@"subscriptions"]];
		if (subscriptions) {
			for (ModelSubscription *sub in subscriptions) {
				if ([sub isKindOfClass:[RequestSubscription class]]) {
                    
					[((RequestSubscription*)sub) apiRequestFailedWithErrorResult:result];
				}
			}
		}
	}
}

+ (void) informSubscriptionsOfSuccess:(AsyncRequestController*)request {
	// If the request has any subscriptions associated with it, inform them of success
	if (request.userInfo) {
		NSArray *subscriptions = [NSArray arrayWithArray:[request.userInfo objectForKey:@"subscriptions"]];
		if (subscriptions) {
			for (ModelSubscription *sub in subscriptions) {
				if ([sub isKindOfClass:[RequestSubscription class]]) {
					[((RequestSubscription*)sub) apiRequestSucceeded];
				}
			}
		}
	}
}



@end
