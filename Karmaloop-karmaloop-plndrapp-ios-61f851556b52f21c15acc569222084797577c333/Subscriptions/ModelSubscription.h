#import <Foundation/Foundation.h>

typedef enum {
	SubscriptionStateUnknown, // On subscription creation
	SubscriptionStatePending, // Data is loading (possibly for a refresh)
	SubscriptionStateAvailable, // Data is available and ready for use
	SubscriptionStateUnavailable, // Failed to fetch data - no server connectivity and no local cache
// PLNDR Use
    SubscriptionStateAuthenticationRequired, // AuthTokn has expired
    SubscriptionStateNoConnection
} SubscriptionState;

@protocol SubscriptionDelegate;
@class ModelContext;

// Abstract Base Class for "Subscriptions"
// Subscriptions are used by controllers to request specific model data
// and to be informed when the data becomes available

@interface ModelSubscription : NSObject {
	SubscriptionState _state;
	ModelContext *_context;
}

@property (nonatomic) SubscriptionState state;

@property (nonatomic, assign) id <SubscriptionDelegate> delegate;

@property (nonatomic, readonly) ModelContext *context;

@property (nonatomic, readonly) BOOL loadedFromCache; // If the state is SubscriptionStateAvailable, whether the data was loaded by a cache request

- (id) initWithContext:(ModelContext*)cont;

// Cancel _must_ be called when the controller that created the subscription is finished with it!
// This should likely be done in dealloc just before releasing the subscription

- (void) cancel;

// Call the method to ask the subscription to begin refreshing its data. This will set its state
// to SubscriptionStatePending (no callback will happen for this change), which will be followed
// by a callback once the state resolves to Available or Unavailable
// This method has no effect if the state before the call is Pending

- (void) refresh;

@end


@protocol SubscriptionDelegate
- (void) subscriptionUpdatedState:(ModelSubscription*)subscription;
@end