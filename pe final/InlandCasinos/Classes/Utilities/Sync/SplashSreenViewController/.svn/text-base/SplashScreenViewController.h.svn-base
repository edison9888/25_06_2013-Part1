//
//  SplashScreenViewController.h
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GADBannerView.h"

@protocol SplashScreenViewControllerDelegate <NSObject>
-(void)splashMovieCompleted;
@end

@interface SplashScreenViewController : UIViewController {
    
    MPMoviePlayerController	*moviePlayer;
	NSURL *movieURL;
    id <SplashScreenViewControllerDelegate>delegate;
    GADBannerView *bannerView_;
    
    UIButton *skipButton;
    UIImageView    *backgroundImage;
}
@property(nonatomic,retain)id <SplashScreenViewControllerDelegate>delegate;
@property(nonatomic,retain) MPMoviePlayerController	*moviePlayer;
@property(nonatomic, retain)    IBOutlet UIButton *skipButton;
@property(nonatomic, retain)    IBOutlet UIImageView    *backgroundImage;

-(void)playMovie;
-(void)playAdmob;

- (IBAction)skipButtonClicked:(id)sender;

#pragma mark MoviePlayerController delegate
-(void)moviePlayBackDidFinish:(NSNotification*)notification;
-(void)moviePlaybackStateChanged :(NSNotification *)notification;

@end
