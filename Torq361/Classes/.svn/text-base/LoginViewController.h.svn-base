//
//  LoginViewController.h
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonParser.h"


@interface LoginViewController : UIViewController<JsonParserDelegate> {
	
	IBOutlet UITextField *txtUsername;
	IBOutlet UITextField *txtPassword;
	
	IBOutlet UILabel *m_ErrMessage;
	IBOutlet UILabel *obj_status;
	
	IBOutlet UIImageView *backgroundImageView;
	IBOutlet UIImageView *usernameFieldImage;
	IBOutlet UIImageView *passwordFieldImage;
	IBOutlet UIImageView *loginButtonImage;
	
	IBOutlet UIButton *m_TroubleLoginBtn;
	IBOutlet UIButton *m_LoginBtn;
	
	
	IBOutlet UIActivityIndicatorView *m_actindicator;
	
	
	IBOutlet UIScrollView *loginScrollView;
	int icontentsize;
	BOOL bcontentflag;
	
	
	
	
}

-(IBAction)loginBtnClicked:(id)Sender;

-(IBAction)ForgotPasswordBtnClicked:(id)Sender;

-(void)startAnimateScrollview:(int)iVal;

-(void)RestoreScrollview;

-(void)adjustScrollView;

-(void)setUserCredential:(NSDictionary *)Dict;

-(void)checkPreviousUserIdAndCompanyId;

@end
