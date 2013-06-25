//
//  SocialManager.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"

typedef enum {
	ShareActionSheetEmail,
	ShareActionSheetFacebook,
	ShareActionSheetTwitter,
	ShareActionSheetSMS,
	ShareActionSheetNUM
}ShareActionSheetType;

@protocol SocialManagerDelegate <NSObject>

- (void) onFacebookLoginSuccess;

@optional
- (NSMutableDictionary *) getFacebookDialogParam;

@end

@interface SocialManager : NSObject <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, FBSessionDelegate, FBDialogDelegate>{
    
    //FBConnect
//	Facebook *facebook;
    NSArray *permissions;
}

+(SocialManager*) instance;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, weak) id<SocialManagerDelegate> socialManagerDelegate;

- (void)shareProductViaShareActionType:(ShareActionSheetType)shareActionType itemName:(NSString *)itemName discountPercentage:(int)discountPercentage url:(NSString *)url viewController:(UIViewController *)viewController;
- (void)shareSaleViaShareActionType:(ShareActionSheetType)shareActionType brandName:(NSString *)brandName url:(NSString *)url viewController:(UIViewController *)viewController;

// Email
- (void)sendInviteFriendsEmailWithViewController:(UIViewController *)viewController;

// SMS

- (void)sendInviteFriendsViaSMSWithViewController:(UIViewController *)viewController;

// Twitter

- (void)sendInviteFriendsViaTwitterViewController:(UIViewController *)viewController;

// Facebook
- (void)facebookLogin;
- (void)facebookLogout;
- (BOOL)isFacebookLoggedIn;
- (void)loginFacebookAndPopDialog;
- (id)socialManagerDelegate;

- (void)sendInviteFriendsViaFacebookDialog;
- (void)facebookShareSaleWithBrandName:(NSString *)brandName url:(NSString *)url;
- (void)facebookShareProductWithitemName:(NSString *)itemName discountPercentage:(int)discountPercentage url:(NSString *)url;

@end
