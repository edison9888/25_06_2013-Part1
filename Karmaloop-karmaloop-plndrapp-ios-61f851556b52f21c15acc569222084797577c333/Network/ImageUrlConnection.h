#import <Foundation/Foundation.h>
#import "ImageLoadingManager.h"


@interface ImageUrlConnection : NSURLConnection {

}

@property (nonatomic, unsafe_unretained) id<ImageLoadingManagerDelegate> requesterDelegate;
@property (nonatomic, strong) NSString *sourceUrl;
@property (nonatomic, strong) NSMutableData *receivedData;

@end
