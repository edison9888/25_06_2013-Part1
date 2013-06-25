//
//  UserSetting.h
//  Torq361
//
//  Created by Nithin George on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"

@interface UserSetting : UIViewController {
	
	IBOutlet UIImageView *backgroundImageView;
	
	//IBOutlet UIView *subViewController;

	//IBOutlet UIButton *closeButton;
	
	IBOutlet UIButton *changePasswordButton;
	
	//IBOutlet UIButton *changeProfileButton;
	
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
}


- (IBAction)closeButtonClicked:(id)sender;

- (IBAction)changePasswordButtonClicked:(id)sender;
//- (IBAction)changeProfileButtonClicked:(id)sender;
- (IBAction)resetContentButtonClicked:(id)sender;
-(IBAction)logoutFromFacebookButtonClicked:(id)sender;
-(IBAction)logoutFromTwitterButtonClicked:(id)sender;

-(void)checkSocialNetworkLoginStatus;

@end
