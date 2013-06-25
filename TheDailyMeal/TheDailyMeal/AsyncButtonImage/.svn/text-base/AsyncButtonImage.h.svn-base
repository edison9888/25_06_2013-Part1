//
//  AsyncButtonImage.h
//
//  Created by NibinV on 08/03/2012.
//

#import <UIKit/UIKit.h>

//Delegate
@protocol AsyncButtonImageDelegate <NSObject>

- (void)didLoadImage:(UIImage *)image forIndex:(int)indexForRow;
- (void)didFailedLoadingImageForIndex:(int)indexForRow;

@end

@interface AsyncButtonImage : UIButton 
{
	NSURLConnection *urlConnection; 
	NSMutableData *responseData;
	UIActivityIndicatorView *loadingActivityIndicator;

    id<AsyncButtonImageDelegate> delegate;
}

@property (assign, nonatomic) id delegate;

//We need to call this method, passing the image url as argument. 
- (void)loadImageFromURL:(NSURL*)url;

@end
