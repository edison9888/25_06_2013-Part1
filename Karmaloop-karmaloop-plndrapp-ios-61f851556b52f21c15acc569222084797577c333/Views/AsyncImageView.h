//
//  AsyncImageView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoadingManager.h"

@protocol AsyncImageViewDelegate;

@interface AsyncImageView : UIImageView <ImageLoadingManagerDelegate> {
	NSString *_requestedUrl;
	ImageUrlConnection *_connection;
	
	UIColor *_overlayBackgroundColor;
	UIView *_overlayView;
}

@property (nonatomic, unsafe_unretained) id<AsyncImageViewDelegate> delegate;

@property (nonatomic) BOOL loaded;

@property (nonatomic, readonly) UIView *overlayView;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic) BOOL overlayBorder; // Whether to show a border around the placeholder overlay. Default is YES

- (void) loadImageFromUrl:(NSString*)url sizedForFrame:(BOOL)sizedForFrame;
- (void) clearImage; // Get rid of any image being shown and show the overlay instead

+ (NSString*) urlFromUrl:(NSString*)url withWidth:(float)width;

@end

@protocol AsyncImageViewDelegate <NSObject>

- (void) imageDidLoad:(AsyncImageView*)image;
- (void) imageFailedToLoad:(AsyncImageView*)image;

@optional
- (BOOL) imageShouldFadeIn:(AsyncImageView*)image;
@end