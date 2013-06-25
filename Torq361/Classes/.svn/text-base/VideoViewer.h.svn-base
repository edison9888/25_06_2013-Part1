//
//  VideoViewer.h
//  Torq361
//
//  Created by Nithin George on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomScrollView.h"
#import "VideoFrameCreater.h"


@interface VideoViewer : UIViewController {
	
	NSMutableArray *videoPath;
	
	NSString *currentSelectedPath;
	
	int videoCount;

	int offset;
	
	NSMutableArray *thumbVideoImage;	//Storing the corresponding video frame
	
	NSMutableArray *thumbVideoTime;		//Storing the corresponding video duration
	
	
	MPMoviePlayerController *moviePlayer;
	BOOL bFullscreen;
	NSString *strStartViewTime;
	NSString *strStopViewTime;
	NSString *strIdViewed;
	NSString *strUserNameViewed;

	
	BOOL bZoomedFlag;
	

	
	//IBOutlet UIPageControl *pageControl;

	IBOutlet UIButton *closeButton;
	
	CustomScrollView *imageScrollView;
	
	VideoFrameCreater *videoFrameCreater;
	
	
}

@property (nonatomic,retain)NSMutableArray *videoPath;
@property (nonatomic,retain)NSString *currentSelectedPath;
@property (nonatomic)int videoCount;
@property (nonatomic)int offset;
@property (nonatomic,retain)NSMutableArray *thumbVideoImage;
@property (nonatomic,retain)NSMutableArray *thumbVideoTime;


-(NSString*)createTime;

- (void) allocVideothumImage;	//For Showing all the video thumb image on the scroll view
- (void) playVideo:(NSString *)path;

- (void)closeButtonClicked:(id)sender;
//- (void)thumbnailButtonClicked:(id)sender;


-(void)setPortraitView;
-(void)setLandscapeView;



-(void)OrientationDidChange:(UIDeviceOrientation)orientation;

@end
