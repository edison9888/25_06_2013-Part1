//
//  Twitter_iPad.h
//  Brighton MCommerce
//
//  Created by Surya on 13/09/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"
#import "AppDelegate_iPad.h"
#import "SyncProgress.h"
#import "AppTmpData.h"

//#import "UploadMedia.h"

@class OAuth, CustomLoginPopup;

@interface Twitter_iPad : UIViewController <TwitterLoginPopupDelegate, TwitterLoginUiFeedback> {
    IBOutlet UIButton *postButton, *latestTweetsButton, *uploadMediaButton;
    IBOutlet UITextView *statusText;
    IBOutlet UILabel *signedInAs;
    IBOutlet UITextView *tweets;
	IBOutlet UIButton *m_objBackButton;
	IBOutlet UIButton *m_objLoginBtn;
	IBOutlet UIButton *m_objLogoutBtn;
	IBOutlet UIImageView *m_objTweetBoxImage;
	IBOutlet UILabel *m_objCountLabel;
	IBOutlet UIImageView *m_objTwitterBackgroundImgView;
	
    CustomLoginPopup *loginPopup;	
	OAuth *oAuth;
	SyncProgress *m_objSyncProgress;
	
	UIViewController *presentController;
	
	NSString *strProductURL;
	
	//activity indicator for the login delay
	UIActivityIndicatorView *m_objActivity;	
}

@property(nonatomic,retain)  NSString *strProductURL;

-(IBAction)didPressPost:(id)sender;
-(IBAction)didPressLatestTweets:(id)sender;
-(IBAction)loginBtnClicked:(id)sender;
-(IBAction)logoutBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;


- (void)resetUi;
-(void)BackButtonClkd;
- (void)login;
-(void)setParentViewController:(UIViewController *)controller;

-(void)ShowSyncprogress:(BOOL)bFlag;
-(void)hideSyncProgress;
 
-(void)releaseAllocatedResources;		//added on 15/12/2010 for fixing the Twitter non tweeting issue.

@end
