#import <Foundation/Foundation.h>


@interface NSOperationQueue (FileQueue)

// Returns a serializing queue (one operation at a time) intended to run operations that deal with
// files, for cases when such file system access should be serialized to help prevent race conditions
+ (id) fileQueue;

// Shortcut for creating an NSInvocationOperation object and adding it to the queue
- (void) addInvocationOperationWithTarget:(id)target selector:(SEL)selector object:(id)arg;
- (void) cancelInvocationOperationsWithTarget:(id)target;	// Call cancel on all NSInvocationOperations in the queue with the given target
@end
