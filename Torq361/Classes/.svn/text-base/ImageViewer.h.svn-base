//
//  ImageViewer.h
//  Torq361
//
//  Created by Nithin George on 20/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomScrollView.h"
#import "ZoomImageThumbFrame.h"

@interface ImageViewer : UIViewController {
	
	NSMutableArray *imageArray;   // Array of images, pdf, video actualy we need only the images 
	
	int imageCount;
	
	int offset;
	
	float zoomScale;
	
	BOOL bZoomedFlag;
	
	BOOL bButtonClicked;
	
	IBOutlet UILabel *pagelabel;
	
	NSOperationQueue *OperationQueue;
	
	NSMutableArray *viewControllers;
	
	IBOutlet UIPageControl *pageControl;
	
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *forWordButton;
	IBOutlet UIButton *backWordButton;
	IBOutlet UIImageView *zoomThumbImage;
	
	int page;
	
	UIImage *img;
	
	CustomScrollView *imageScrollView;
	CustomScrollView *zoomImageScrollView;
	
	ZoomImageThumbFrame *zoomImageThumbFrame;
	
	

	
	UIImageView *imageView1;
	
	NSMutableArray *imageViews;   //Array of imageviews

}

@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic)int imageCount;
@property (nonatomic)int offset;
@property (nonatomic)float zoomScale;
@property (nonatomic, retain)IBOutlet UIScrollView *imageScrollView;

- (void)setPortraitView;
- (void)setLandscapeView;
- (void)adjustPortrate;
- (void)adjustLandscape;

- (void)allocImageViews;

-(void)performTransition;

- (void) Perform_Pinch:(UIPinchGestureRecognizer*)Sender;	//For image pinch effect

-(void)setNewScrollViewForZooming;

- (void)backButtonClicked:(id)sender;	//for closing the zooming image
- (void)forWordButtonClicked:(id)sender;
- (void)backWordButtonClicked:(id)sender;




-(void)initializeView;

-(void)populateImages;

-(void)OrientationDidChange:(UIDeviceOrientation)orientation;


@end
