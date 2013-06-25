//
//  ChangePassword.h
//  Torq361
//
//  Created by Nithin George on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonParser.h"


@interface ChangePassword : UIViewController <UIAlertViewDelegate> {
	
	IBOutlet UIImageView *backgroundImageView; 
	
	IBOutlet UIScrollView *scrollView;
	
	//IBOutlet UIImageView *userNameImageView;
	IBOutlet UIImageView *oldPasswordImageView;
	IBOutlet UIImageView *newPasswordImageView;
	IBOutlet UIImageView *conformPasswordImageView;
	
	
	//IBOutlet UITextField *txtUserName;
	IBOutlet UITextField *txtOldPassword;
	IBOutlet UITextField *txtNewPassword;
	IBOutlet UITextField *txtConformPassword;
	
	
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *connectingLabel;
	IBOutlet UILabel *statusLalel;

}


- (IBAction)submitButtonClicked:(id)sender;

- (IBAction)closeButtonClicked:(id)sender;

- (void)clearValue;//For clearing all the values

@end
