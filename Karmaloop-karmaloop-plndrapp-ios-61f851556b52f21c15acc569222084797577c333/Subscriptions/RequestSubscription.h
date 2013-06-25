#import <Foundation/Foundation.h>
#import "ModelSubscription.h"
#import "APIRequestController.h"

// Abstract Base Class for Subscriptions that function by making a server
// or disk dache request

// Subscriptions are used by controllers to request specific model data
// and to be informed when the data becomes available

@interface RequestSubscription : ModelSubscription <AsyncRequestDelegate> {
	BOOL _triedServerRequest; // Whether the subscription has tried loading data from the server and should next try the disk cache
}

@property (nonatomic, retain) AsyncRequestController *requestInProgress; // Reference to any active request for filling the data needed for the subscription
@property (nonatomic) BOOL loadedFromCache;
@property (nonatomic, retain) NSObject *errorResult;


// Optionally skip the step of making the server request, and go straight
// for the on-disk cache instead
- (id) initWithContext:(ModelContext*)context forceFetch:(BOOL)forceFetch;

//////////////////

// Callback methods for when requests come back
- (void) apiRequestSucceeded;
- (void) apiRequestFailedWithErrorResult:(NSObject*)errorResult;


///// Methods implemented by subclasses /////

- (BOOL) isDataAvailable; // Examine models to determine if the required information is already there
- (BOOL) subscriptionMatches:(ModelSubscription*)subscription; // Whether the given subscription is requesting the same data (or a superset of the data) as this one

- (APIRequestController*) apiRequest; // Start a server request for the data this subscription requires
@end
