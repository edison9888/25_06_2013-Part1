//
//  ProductDetailsView.h
//  Torq361
//
//  Created by Nithin George on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "PDFImageCreater.h"
#import "VideoFrameCreater.h"
#import "ImageStore.h"


@class ProductDetails;
@class ImageViewer;
@class PDFViewer;
@class VideoViewer;

@interface ProductDetailsView : UIViewController<UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate> {
	
	ProductDetails *productDetails;
	
	int productIndex;
	
	IBOutlet UIView *shareView;
	
	IBOutlet UITextView	*productDetailsTextView; //displaying the product description
	
	UIImageView *backgroundImage;
	UILabel		*productName;
	UIImageView *descriptionButtonImage;
	UITextView	*textView;
	UIView		*textBackgroundView;
	UIView		*selectionButtonView;
	
	UIImageView *thumbnailSelectionImage;			// image showing which thumbnail is selected
	
	UIScrollView *thumbnailScrollView;
	UIScrollView *contentScrollView;
	
	NSMutableArray *contentPaths;//full paths
	NSMutableArray * imagePathArray;
	NSMutableArray * pdfPathArray;
	NSMutableArray *videoPathArray;
	
	int x;
	int y;
	int videoPresent;
	int imagePresent;
	int pdfPresent;
	int videoNotPresentCount;
	int currentImagePositionsForMail;
	UIImage *image;
	NSMutableArray *videoFrameImage;
	NSMutableArray *tempVideoFrameImage;
	NSMutableArray *videoFrameTime;
	NSMutableArray *sharePaths;
	MPMoviePlayerController *moviePlayer;
	//PDFImageCreater *pdfImageCreater;
	ImageStore *imageStore;
	UIPopoverController *popOverControllerView;
	NSMutableArray *imageStoreArray;
	
	int contentCount, imageCount, pdfCount, videoCount;
	
	ImageViewer *imageViewer;
	//PDFViewer *pdfViewer;
	VideoViewer *videoViewer;
	
	VideoFrameCreater *videoFrameCreater; //today

}

@property (nonatomic)int productIndex;
@property (nonatomic, retain)IBOutlet UILabel *productName;
@property (nonatomic, retain)IBOutlet UIView *selectionButtonView;
@property (nonatomic, retain)IBOutlet UIImageView *descriptionButtonImage;
@property (nonatomic, retain)IBOutlet UITextView *textView;
@property (nonatomic, retain)IBOutlet UIView *textBackgroundView;
@property (nonatomic, retain)IBOutlet UIScrollView *thumbnailScrollView;
@property (nonatomic, retain)IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain)IBOutlet UIImageView *thumbnailSelectionImage;


- (void)initializeView;
- (void)setPortraitView;
- (void)setLandscapeView;

- (void)allocThumbnailScrollView;
- (void)loadImageArray;

- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)mailButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)descriptionButtonClicked:(id)sender;

- (void)addTouchGestureToScrollView;

- (void)addViewToContentScrollView;
- (void)addViewToThumScrollView:(id)index;
- (void)releaseMemory;
- (void)getSharePaths:(id)index;
- (void)seetingMailBodyComponents:(NSData *)data:(NSString *)mimeType:(NSString *)fileName;
- (void)dismissPopoverController;

@end
