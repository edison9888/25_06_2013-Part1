#import "NSOperationQueue+FileQueue.h"


@implementation NSOperationQueue (FileQueue)

static NSOperationQueue *fileQueue;
+ (id) fileQueue {
	if (!fileQueue) {
		fileQueue = [[NSOperationQueue alloc] init];
		[fileQueue setMaxConcurrentOperationCount:1];
	}
	return fileQueue;
}

- (void) addInvocationOperationWithTarget:(id)target selector:(SEL)selector object:(id)arg {
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:target selector:selector object:arg];
	[self addOperation:op];
}

- (void) cancelInvocationOperationsWithTarget:(id)target {
	for (NSOperation *op in self.operations) {
		if ([op isKindOfClass:[NSInvocationOperation class]]) {
			NSInvocationOperation *inv = (NSInvocationOperation*)op;
			
			if ([[inv invocation] target] == target) {
				[inv cancel];
			}
		}
	}
}

@end
