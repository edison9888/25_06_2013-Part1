//
//  VideoViewerView.m
//  Torq361
//
//  Created by Rajeev KR on 24/08/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "VideoViewerView.h"



@implementation VideoViewerView
@synthesize videoPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.videoPath=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(playVideo) withObject:nil afterDelay:0 ];
}

-(void)playVideo{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 

    NSURL *url = [NSURL fileURLWithPath:videoPath];  
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];  
    
    // Register to receive a notification when the movie has finished playing.  
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(moviePlayBackDidFinish:)  
                                                 name:MPMoviePlayerPlaybackDidFinishNotification  
                                               object:moviePlayer]; 
    
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {  
        // Use the new 3.2 style API  
        moviePlayer.controlStyle = MPMovieControlStyleFullscreen;  
        moviePlayer.shouldAutoplay = YES; 
        [self.view addSubview:moviePlayer.view];  
        [moviePlayer setFullscreen:YES animated:YES];
    } 
    [moviePlayer play]; 
    
    [pool drain], pool = nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {  
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    MPMoviePlayerController *moviePlayer1 = [notification object];  
    [[NSNotificationCenter defaultCenter] removeObserver:self  
                                                    name:MPMoviePlayerPlaybackDidFinishNotification  
                                                  object:moviePlayer1]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    [moviePlayer1 setFullscreen:NO animated:NO];
    moviePlayer1.initialPlaybackTime = -1;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    [moviePlayer1 pause]; 
#endif

    [ moviePlayer1 stop];
    
    // If the moviePlayer.view was added to the view, it needs to be removed  
    if ([moviePlayer1 respondsToSelector:@selector(setFullscreen:animated:)]) {  
        [moviePlayer1.view removeFromSuperview];  
    }  
    
    [moviePlayer1 release];  
    moviePlayer1=nil;
    
    
    [pool drain], pool = nil;
    
    [self performSelector:@selector(dismisVideoPlayerView) withObject:nil afterDelay:0];
    
}  

-(void)dismisVideoPlayerView{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
