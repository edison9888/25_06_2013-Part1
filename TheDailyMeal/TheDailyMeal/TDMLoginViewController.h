//
//  TDMLoginViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMHTTPLoginService.h"
#import "TDMLogoutService.h"
#import "TDMSignUpService.h"
#import "TDMOverlayView.h"
#import "TDMPhotoUploadService.h"
#import "Facebook.h"
#import "TDMMFBHelper.h"
#import "FBConnect.h"
//#import "TDMLoginHandler.h"
//#import "TDMSignupHandlerAndProvider.h"
//#import "TDMLogoutHandler.h"

@interface TDMLoginViewController : TDMBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UIScrollViewDelegate,TDMLoginHandlerDelegate,TDMSignupHandlerAndProviderDelegate,TDMLogoutHandlerDelegate,TDMPhotoUploadServiceDelegate,FBSessionDelegate>
{
    NSString *nameUser;
    NSString *newImagePath;
    NSString *email;
    NSString *userPassword;
    NSString *confirmPassword;
    NSString *imageName;
    BOOL isChange;
    BOOL isLogin;
    TDMLogoutService *logoutHandler;
    TDMOverlayView *overlayView;
    Facebook *facebook;

//    TDMMFBHelper *fbHelper;
}

@property (retain, nonatomic) Facebook *facebook;
@property (retain, nonatomic) IBOutlet UITableView *loginTable;
@property (retain, nonatomic)  NSString *imageName;
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
@property (retain, nonatomic) IBOutlet UITextField *userName;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UIButton *userImageAddButton;
@property (retain, nonatomic) NSString *nameUser;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *userPassword;
@property (retain, nonatomic) NSString *confirmPassword;
@property (retain, nonatomic) IBOutlet UIImageView *signUpImageView;
@property (retain, nonatomic) IBOutlet UILabel *navigationLabel;
@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *usrNameImageView;
@property (retain, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (retain, nonatomic) IBOutlet UIButton *signUpButton;
@property (assign, nonatomic)BOOL isfromSettings;
@property (retain, nonatomic) IBOutlet UIButton *termsButton;
@property (retain, nonatomic) IBOutlet UILabel *termsLabel;

- (IBAction)signUpButtonClicked:(id)sender;

- (IBAction)segmentClick:(id)sender;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signupAddImageButtonClick:(id)sender;
- (IBAction)fbLoginAction:(id)sender;
- (IBAction)twitterLoginAction:(id)sender;
- (BOOL)isNonEmptyString:(NSString*)string;
- (UIImage *)compressImage:(UIImage *)imageToCompress;
- (NSString *)getDirectoryPath;

- (void)FacebookLoginWithAceessTocken;
- (void)sentLoginRequest;
- (void)sentLogoutRequest;
- (void)addSegmentedControl;
-(void) changeUISegmentFont:(UIView*) myView ;
- (IBAction)fbLoginButtonClicked:(id)sender;
- (IBAction)termsButtonClicked:(id)sender;

@end
