//
//  TDMLoginViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMSignupHandlerAndProvider.h"
#import "TDMLoginHandler.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import "Facebook.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "TDMSignupHandlerAndProvider.h"
#import "TDMFBLoginViewController.h"
#import "TDMFaceBookHandler.h"
#import "Twitter.h"
#import "ShareView.h"
#import "TDMLogoutHandler.h"

@interface TDMLoginViewController : TDMBaseViewController<UITextFieldDelegate,TDMLoginHandlerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TDMSignupHandlerAndProviderDelegate,TDMFacebookLoginDialogDelegate,TDMLogoutHandlerDelegate,UITabBarControllerDelegate,UITabBarDelegate>{
    NSString *nameUser;
    NSString *email;
    NSString *userPassword;
    NSString *confirmPassword;
    NSString *imageName;
    BOOL isChange;
    BOOL isLogin;
   // Facebook *facebook;
    TDMFaceBookHandler *facebookHandler;
    Twitter *objTwitter;
    ShareView *dialog;
   
}

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain,nonatomic) IBOutlet UIView *loginView;
@property (retain,nonatomic) IBOutlet UIView *signupView;
@property (retain,nonatomic) IBOutlet UITableView *signUpTableView;
@property (retain,nonatomic) IBOutlet UISegmentedControl *segment;
@property (retain,nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (retain,nonatomic) IBOutlet UIScrollView *signUpScrollView;
@property (retain, nonatomic) IBOutlet UITextField *userNames;
@property (retain, nonatomic) IBOutlet UITextField *eMailId;
@property (retain, nonatomic) IBOutlet UITextField *passwords;
@property (retain, nonatomic) IBOutlet UITextField *confirmPasswords;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *forgotPassword;
@property (retain, nonatomic) IBOutlet UIButton *FBLoginButton;
@property (retain, nonatomic) IBOutlet UIButton *twitterLoginButton;

- (NSString *)getDirectoryPath;
- (IBAction)segmentClick:(id)sender;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)signupAddImageButtonClick:(id)sender;
- (UIImage *)compressImage:(UIImage *)imageToCompress;
- (IBAction)fbLoginAction:(id)sender;
- (void)FacebookLoginWithAceessTocken;
- (IBAction)twitterLoginAction:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *userName;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIButton *userImageAddButton;
@property (retain, nonatomic) NSString *nameUser;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *userPassword;
@property (retain, nonatomic) NSString *confirmPassword;
//@property (nonatomic, retain) Facebook *facebook;
@end
