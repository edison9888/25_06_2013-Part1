    //
//  VideoViewer.m
//  Torq361
//
//  Created by Nithin George on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoViewer.h"
#import "CustomScrollView.h"
#import "AppTmpData.h"
#import "UserCredentials.h"
//#import "Torq361AppDelegate.h"

@implementation VideoViewer

@synthesize videoPath;
@synthesize currentSelectedPath;
@synthesize videoCount;
@synthesize offset;
@synthesize thumbVideoImage;
@synthesize thumbVideoTime;


NSString *videoDuration;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	//self.view.backgroundColor = [UIColor redColor];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(OrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
	
	imageScrollView=[[CustomScrollView alloc]init];
	//[imageScrollView setBackgroundColor:[UIColor blueColor]];
	[self.view addSubview:imageScrollView];
 
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[self setPortraitView];
	}
	
	else {
		
		[self setLandscapeView];
	}
	
	
	//**********************
		
    imageScrollView.pagingEnabled = YES;
	//imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * videoCount, 0);
    imageScrollView.showsHorizontalScrollIndicator = YES;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.scrollsToTop = NO;
    imageScrollView.delegate = self;
	
	
	[self allocVideothumImage];
	[self playVideo:currentSelectedPath];
	
    [imageScrollView release];
    imageScrollView = nil;
}


#pragma mark -
#pragma mark For video Playing

- (void) allocVideothumImage {
	
	int x;
	int y;
	
	if (videoCount > 0) {
		
	    //thumbVideoImage = [[NSMutableArray alloc] initWithCapacity:videoCount];
		//thumbVideoTime  = [[NSMutableArray alloc] initWithCapacity:videoCount];
		
		//UIButton *button;

		
		for(int i=0; i<videoCount; i++) {
            
            UIImage *myImage;
            
            myImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"playButton" ofType:@"png"]];
			
			x = 14 + (i * 110); //x = 14 + (i * 70);
			
			//Sub class for creating the video frame
			videoFrameCreater = [[VideoFrameCreater alloc]init];
			
			videoFrameCreater.frame =CGRectMake(x , 0, 100, 100);
			
			
	/*		//For finding the correct image path for the selected image's content image path
			NSArray *objExtension = [[videoPath objectAtIndex:i] componentsSeparatedByString:@"/"];       //NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0];	
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/video",@"CompanyId",companyid]];		
			NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			
			NSURL* videoURL = [NSURL fileURLWithPath:strDownloadDestiantionPath];
			
			if(moviePlayer){
				
				[moviePlayer release];
				
				moviePlayer = nil;
			}
			
			moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
			
			//moviePlayer.shouldAutoplay = NO;
			
			
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(moviePlayerPlaybackDuration:)
														 name:MPMoviePlayerPlaybackStateDidChangeNotification
													   object:moviePlayer];
			
			
			NSTimeInterval time = 0.17;
			
			[thumbVideoImage addObject:[moviePlayer thumbnailImageAtTime:time
														 timeOption:MPMovieTimeOptionNearestKeyFrame]];
					
			[moviePlayer play];
		*/	
			//NSLog(@"duration======%@",[thumbVideoTime lastObject]);
			
			videoFrameCreater.xAxix  = 0;
			videoFrameCreater.yAxix  = 0;
			videoFrameCreater.wWidth = 100;
			videoFrameCreater.hHight = 100;
			videoFrameCreater.xLabel = 50;
			videoFrameCreater.yLabel = 40;
			
			videoFrameCreater.frameCheckVariable = 2;
			
			videoFrameCreater.tagValue      = i;
			
			videoFrameCreater.thumnailImage = [[thumbVideoImage objectAtIndex:i] imageFrame];
			
			if ([[thumbVideoImage objectAtIndex:i] downloadStatus] == 1) {
				
				videoFrameCreater.timeLabel     = [thumbVideoTime objectAtIndex:i]; 
				
			}
		
			videoFrameCreater.playImage     = myImage;

				
			videoFrameCreater.delegate = self;
			
			
			[imageScrollView addSubview:videoFrameCreater];
            [videoFrameCreater release];
            videoFrameCreater = nil;
			
            [myImage release];
            myImage = nil;
		/*	button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(x , 23, 73, 73);
			button.tag = i;
			[button setBackgroundImage:[thumbVideoImage objectAtIndex:i] forState:UIControlStateNormal];
			
			[button addTarget:self action:@selector(thumbnailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			[imageScrollView addSubview:button];
		*/
					
		}
		
	}

	//if (videoCount > 6) {
		imageScrollView.contentSize = CGSizeMake(110*videoCount , 0);
    //}
		
}



- (void) playVideo:(NSString *)path {
	
	//******its need becuse in contentpath array not containg the path like pdf/file.pdf, image/ and video/
	
	//For finding the correct image path for the selected image's content image path
	NSArray *objExtension = [path componentsSeparatedByString:@"/"];       //NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];	
	NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
	NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/video",@"CompanyId",companyid]];		
	NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
	

	NSURL* videoURL = [NSURL fileURLWithPath:strDownloadDestiantionPath];
	
	if(moviePlayer){
		//[moviePlayer stop];
		
		[moviePlayer release];
		moviePlayer = nil;
		[moviePlayer.view removeFromSuperview];
	}
	moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
	
	//[moviePlayer setContentURL:videoURL];
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
		moviePlayer.view.frame = CGRectMake(30, 175, 700, 600);
	}
	else {
		moviePlayer.view.frame=CGRectMake(170,80,700,500);
	}
	
	
	[moviePlayer play];
	

	
	[self.view addSubview:moviePlayer.view];

		
	[strIdViewed retain];
	
	
	strStartViewTime=[self createTime];
	[strStartViewTime retain];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerPlaybackModeChanged:)
												 name:MPMoviePlayerPlaybackStateDidChangeNotification
											   object:moviePlayer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerDidEnterFullScreenMode:)
												 name:MPMoviePlayerDidEnterFullscreenNotification
											   object:moviePlayer];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerDidExitFullScreenMode:)
												 name:MPMoviePlayerDidExitFullscreenNotification
											   object:moviePlayer];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayerPlaybackFinished:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:moviePlayer];
	
	
}



#pragma mark -
#pragma mark Button Clicked


-(void)closeButtonClicked:(id)sender {
	
	[moviePlayer stop];
    if(moviePlayer){
        
		[moviePlayer release];
		moviePlayer = nil;
    }
    
    NSLog(@"VIDEO VIEWER RETAIN COUNT %d", [self retainCount]);
	[self.view removeFromSuperview];	
    NSLog(@"VIDEO VIEWER RETAIN COUNT %d", [self retainCount]);
}
	
	
- (void)thumbnailButtonClicked:(id)arrayIndex {
	
	//[moviePlayer stop];
	
	//NSLog(@"Array Index IS========%d",arrayIndex);
	
	//downloded the video
	if ([[thumbVideoImage objectAtIndex:arrayIndex] downloadStatus] == 1) {
		
		
		NSString *selectedPath=[videoPath objectAtIndex:arrayIndex];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayer];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:moviePlayer];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
		
		[self playVideo:selectedPath];
		
	}
	
	else {
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry DownLoad Is Not Complete, So Please Wait" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}


	
}


	
//- (void)thumbnailButtonClicked:(id)sender {
	
/*	[moviePlayer stop];
	
	UIButton *button = (UIButton *)sender;
	
	int k = button.tag;
	
	NSString *selectedPath=[videoPath objectAtIndex:button.tag];
	
	[self playVideo:selectedPath];	
*/ 
//}



#pragma mark -
#pragma mark Methods for MoviePlayer

/*
-(void)moviePlayerPlaybackDuration:(NSNotification *)notification {


	NSLog(@"Movie Player moviePlayerPlaybackDuration Finished!!!....");
	NSTimeInterval durTime = moviePlayer.duration;
	int mode = durTime;
	
	int second = mode % 60;
	
	durTime = durTime/60;
	
	int minute = durTime;
	
	NSString *videoDuration = [NSString stringWithFormat:@"%d:%d",minute,second];
	
	[thumbVideoTime addObject:videoDuration];
	
	//NSLog(@"duration======%@",[thumbVideoTime lastObject]);

	if(moviePlayer){
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayer];
		[moviePlayer release];
		moviePlayer = nil;
	}
}


*/

- (void)moviePlayerPlaybackFinished:(NSNotification *)notification{
	//NSLog(@"Movie Player operation Finished!!!....");
	
}

- (void)moviePlayerPlaybackModeChanged:(NSNotification *)notification{

	
	if(moviePlayer.playbackState == MPMoviePlaybackStatePaused)
	{
		NSLog(@"Movie Player Paused!!!....");
		//NSLog(@"Current Time : %0.0f",objMoviePlayer.currentPlaybackTime);
	}
	else if(moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
	{
		NSLog(@"Movie Player Playing!!!....");
	}
	
	else if(moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
	{
		NSLog(@"Movie Player Seeks Backward!!!....");
	}
	
	else if(moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward)
	{
		NSLog(@"Movie Player Seeks Forward!!!....");
	}
	
	else if(moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
	{
		NSLog(@"Movie Player Interrupted!!!....");
	}
	else if(moviePlayer.playbackState == MPMoviePlaybackStateStopped)
	{
		
		MPMoviePlayerController *theMovie = [notification object];
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerPlaybackDidFinishNotification
													  object:theMovie];
		
		
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerPlaybackStateDidChangeNotification
													  object:theMovie];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerDidEnterFullscreenNotification
													  object:theMovie];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMoviePlayerDidExitFullscreenNotification
													  object:theMovie];		
		
		if(moviePlayer==theMovie){
			[theMovie pause];
			theMovie.initialPlaybackTime = -1;
			[theMovie stop];
			[theMovie.view removeFromSuperview];
			[theMovie release];
			theMovie=nil;
		}
		
		

		//moviePlayer.initialPlaybackTime = -1;
		 
		 //[moviePlayer stop];
		 //[moviePlayer release]; 
		   moviePlayer = nil;
				NSLog(@"Movie Player Stopped!!!....");
	}
	else
	{
		//NSLog(@"Unknown Operation on Movie Player!!!....");
	}
	
}

- (void)moviePlayerDidEnterFullScreenMode:(NSNotification *)notification{
	bFullscreen=YES;
	//NSLog(@"Movie Player now in Full Screen Mode !!!....");
}

- (void)moviePlayerDidExitFullScreenMode:(NSNotification *)notification{
	bFullscreen=NO;
	//NSLog(@"Movie Player exited from Full Screen Mode !!!....");
}


#pragma mark -


-(NSString*)createTime{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	
	
	
	NSString *theDate = [dateFormat stringFromDate:[NSDate date]];
	NSString *theTime = [timeFormat stringFromDate:[NSDate date]];
	
	
	theDate=[theDate stringByAppendingString:@" "];
	theDate=[theDate stringByAppendingString:theTime];
	
	[dateFormat release];
	[timeFormat release];
	
	
	return theDate;
	//return @"";
}



#pragma mark -
#pragma mark Orientation methods

-(void)OrientationDidChange:(UIDeviceOrientation)orientation{
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
		[self setPortraitView];
		 
		if (moviePlayer) {
			
			moviePlayer.view.frame = CGRectMake(30, 175, 700, 600);
			
		}
	}

	else {
	
		[self setLandscapeView];
		//self.view.frame=CGRectMake(0, 0, 1024,768);
		
		if (moviePlayer) {
			
			moviePlayer.view.frame=CGRectMake(170,80,700,500);
			
		}
		
	}
	
}


- (void)setPortraitView {
	
	
	//Torq361AppDelegate *appDelegate1 = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	//[appDelegate1.home setBackGroundWhenLandScapeToPortrate];
	
	imageScrollView.frame = CGRectMake(200, 800, 425, 100);//width 452
	self.view.frame=CGRectMake(0, 0, 768, 1024);
	
}

- (void)setLandscapeView {
	
	//Torq361AppDelegate *appDelegate1 = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	//[appDelegate1.home setBackGroundWhenPortrateToLandScape];
	
	imageScrollView.frame = CGRectMake(270,600, 425, 100);
	self.view.frame=CGRectMake(0, 0, 1024,768);         
	//videoViewerView.frame=CGRectMake(0, 0,1024,768);
}

#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if(moviePlayer){
		[moviePlayer release];
		
		moviePlayer = nil;
	}
    [super dealloc];
	  
    [closeButton release];
     closeButton = nil;
    
    [videoPath release];
    videoPath = nil;
    
    [thumbVideoImage release];
    thumbVideoImage = nil;
    
    [thumbVideoTime release];
    thumbVideoTime = nil;
}


@end
