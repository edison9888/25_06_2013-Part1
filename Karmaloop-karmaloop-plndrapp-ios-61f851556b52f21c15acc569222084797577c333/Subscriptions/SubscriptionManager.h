#import <Foundation/Foundation.h>
#import "AsyncRequestController.h"

@class ModelSubscription;

@interface SubscriptionManager : NSObject {
	
}

+ (NSMutableArray*)subscriptions;

// inform subscriptions of response
+ (void) informSubscriptionsOfFailure:(AsyncRequestController*)request result:(NSObject*)result;
+ (void) informSubscriptionsOfSuccess:(AsyncRequestController*)request;

// Adds a new subscription to the registry
+ (void) registerSubscription:(ModelSubscription*)subscription;
+ (void) cancelSubscription:(ModelSubscription*)subscription;

// Look for a subscription with an in-progress API request that matches the given subscription. See subscriptionMathces in ModelSubscription
+ (AsyncRequestController*) requestThatMatchesSubscription:(ModelSubscription*)subscription;

// Look for all subscriptions that should be informed when the given subscription begins refreshing
+ (NSSet*) subscriptionsMatchingSubscription:(ModelSubscription*)subscription;

@end
