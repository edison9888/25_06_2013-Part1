//
//  Twitter.h
//  ElDiario
//
//  Created by NaveenShan on 10/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark Twitter
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterLoginPopup.h"
#import "ASIFormDataRequest.h"
#import "ShareView.h"
#import "NetworkCheck.h"
@interface Twitter : UIViewController <TwitterLoginPopupDelegate> {

	int m_itextCount;
	IBOutlet UIButton *m_btnStatus;
	IBOutlet UILabel  *m_lblScreenName;
	IBOutlet UITextView *m_objTextView;
	IBOutlet UILabel *m_lblCount;
	UIActionSheet *m_objActionSheet;
	
	OAuth *oAuth;
	TwitterLoginPopup *loginPopup;	
	
	NSString *strTweetContent;
	id parentView;
}

@property (nonatomic, retain) NSString *strTweetContent;
@property (nonatomic, retain) id parentView;

- (void)login;
- (void)logout;
-(void)resetUi;
- (void)loadTwitterPage:(id)sender;
-(IBAction)onStatusButtonClick:(id)sender;
-(IBAction)postTweet:(id)sender;

-(void)showAlert:(NSString *)strAlertMessage delegateObject:(id)Delegate;

@end
