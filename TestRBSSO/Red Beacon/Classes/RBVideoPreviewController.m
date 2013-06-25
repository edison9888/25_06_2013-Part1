//
//  RBVideoPreviewController.m
//  Red Beacon
//
//  Created by Jayahari V on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBVideoPreviewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBVideoProcessor.h"
#import "RBSavedStateController.h"
#import "RBAlertMessageHandler.h"

@interface RBVideoPreviewController (Private)
- (void)onPlayMode;
- (void)onPauseMode;
- (void)initializeVariables;
- (void)removeMoviePlayer;
@end

@implementation RBVideoPreviewController

@synthesize playerContainer, currentVideo, parent, previewThumbnail;
@synthesize playButton, retakeButton, deleteButton;

NSString * const AS_CONFIRM_VIDEO_DELETE_TITLE = @"Discard Video?";
NSString * const AS_CONFIRM_VIDEO_DELETE_MESSAGE = @"Are you sure you want to delete this video?";

+ (NSString*)getnibName {    
    return @"RBVideoPreviewController";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.playerContainer = nil;
    self.previewThumbnail = nil;
    self.playButton = nil;
    self.retakeButton = nil;
    self.deleteButton = nil;
}

- (void)dealloc
{
    self.parent = nil;
    self.currentVideo = nil;
    self.playerContainer = nil;
    self.playButton = nil;
    self.retakeButton = nil;
    self.deleteButton = nil;
    self.previewThumbnail = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self removeMoviePlayer];
}

- (void)setupNavigationBar {
    
    [self.navigationItem setRBTitle:@"Video Preview"];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [button release];
    button=nil;
    [item release];
    item = nil;

    button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 60, 30);
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [button release];
    button=nil;
    [item release];
    item = nil;
}

- (void)showPreviewThumbnail {
    RBVideoProcessor * processor = [[RBVideoProcessor alloc] init];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:[processor thumbnailPath]];
    previewThumbnail.image = image;
    [image release];
    [processor release];
}

- (void)initializeVariables 
{
    isStopped = YES;
    isPlaying = NO;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeVariables];
    [self onTouchUpPlay:nil];
    
    [self setupNavigationBar];
    [self showPreviewThumbnail];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - helper
//returns the URL from input string
- (NSURL*)urlFromString:(NSString*)stringUrl{
    NSString* expandedPath = [stringUrl stringByExpandingTildeInPath];
    NSURL* url = [NSURL fileURLWithPath:expandedPath];
    return url;
}

- (void)removePlayer 
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if (moviePlayer) {
        NSLog(@"Removing Movie player...");
        [moviePlayer stop];
        [moviePlayer.view removeFromSuperview];    
        [moviePlayer release];
        moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];    
        //[self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
#endif 
}

- (void)removeMoviePlayer {
    [self performSelector:@selector(removePlayer) 
               withObject:nil 
               afterDelay:0.1];
}

#pragma mark - Video PLayer methods
- (void)videoPlayerDidExitFullscreen:(NSNotification*)notification {    
    [self removeMoviePlayer];
}

- (void)videoPlayerDidPlaybackFinish:(NSNotification*)notification {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    moviePlayer = [notification object];
    switch ([reason intValue]) {
            
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");         
            
            break;
        case MPMovieFinishReasonPlaybackError:
            
            NSLog(@"playbackFinished. Reason: Playback Error");
            break;
            
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");            
            break;
            
    }
    [moviePlayer setFullscreen:NO animated:YES];
#endif	
}

- (void)videoPlayerDidChangeState:(NSNotification*)notification {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000

    MPMoviePlayerController *mPlayer = notification.object;
    MPMoviePlaybackState playbackState = mPlayer.playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStatePlaying:
        {
            NSLog(@"playing");
            [self onPlayMode];
        }
            break;
        case MPMoviePlaybackStatePaused:
        {
            NSLog(@"paused");
            [self onPauseMode];
        }
            break;
            
        case MPMoviePlaybackStateInterrupted:
        {
            NSLog(@"interuppted");
        }
            break;
        case MPMoviePlaybackStateSeekingForward:
        {
            NSLog(@"seeking forward");
        }
            break;
        case MPMoviePlaybackStateSeekingBackward:
        {
            NSLog(@"seeking backward");
        }
            break;
        case MPMoviePlaybackStateStopped:
        {
            NSLog(@"stopped");
            isStopped = YES;
        }
            break;
    }
    //[moviePlayer setFullscreen:NO animated:YES];
#endif
}

//plays video in the videos folder with the videoName as in parameter.
- (void)playVideo:(RBMediaStatusTracker*)video {
   // self.currentVideo = video;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000    
    NSURL * videoUrl = [self urlFromString:video.mediaUrl];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];   
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(videoPlayerDidExitFullscreen:) 
                                                 name:MPMoviePlayerDidExitFullscreenNotification 
                                               object:moviePlayer];    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(videoPlayerDidPlaybackFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(videoPlayerDidChangeState:) 
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                               object:moviePlayer];    
    
    if ([moviePlayer respondsToSelector:@selector(view)]) {     
        
        moviePlayer.view.frame = CGRectMake(0, 0, 320, 365);
        moviePlayer.scalingMode = MPMovieScalingModeFill;
        [self.view addSubview:moviePlayer.view];        
        //[moviePlayer setFullscreen:YES animated:YES];        
    }
    [moviePlayer play];
    
#endif	
}

#pragma mark - Deletion
//deletes the videos and all its related references
- (void)deleteVideos {
    
    //delete all physical files
    RBVideoProcessor * processor = [[RBVideoProcessor alloc] init];
    [processor deleteAllVideos];
    [processor release];
    
    //delete the imageIds corresponding to it
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jRequest removeVideo];
}

#pragma mark - Button Actions
- (IBAction)onTouchUpPlay:(id)sender 
{
    if(isPlaying) 
    {
        [moviePlayer pause];
    }
    else if (isStopped) 
    {
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        [self playVideo:[jRequest getVideoTracker]];
    }
    else 
    {
        [moviePlayer play];
    }
        
}

- (IBAction)onTouchupRetake:(id)sender {
    [parent videoDidRetake];
    [self.navigationController popViewControllerAnimated:NO];
    [self removeMoviePlayer];
}

- (IBAction)onTouchUpDelete:(id)sender {
    [RBAlertMessageHandler showDiscardAlertWithTitle:AS_CONFIRM_VIDEO_DELETE_TITLE
                                             message:AS_CONFIRM_VIDEO_DELETE_MESSAGE
                                      delegateObject:self 
                                             viewTag:1];        
}

- (void)onPlayMode {
    isPlaying = YES;
    isStopped = NO;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.retakeButton setEnabled:NO];
    [self.deleteButton setEnabled:NO];
    [self.playButton setSelected:YES];
}

- (void)onPauseMode {
    isPlaying = NO;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.retakeButton setEnabled:YES];
    [self.deleteButton setEnabled:YES];
    [self.playButton setSelected:NO];
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self deleteVideos];
        [self.navigationController popViewControllerAnimated:NO];
        [self removeMoviePlayer];
    }
}
#pragma mark -
@end
