//
//  SocialManager.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialManager.h"
#import "Utility.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "AccountDetails.h"
#import "Constants.h"
#import "GANTracker.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "EmailManager.h"
#import "PlndrAppDelegate.h"

@interface SocialManager () {}

- (void)setupFacebook;
- (NSString*)getUsersInviteLink;
- (void)shareText:(NSString *)shareText actionType:(ShareActionSheetType)actionType viewController:(UIViewController *)viewController;
- (void)sendSMSWithBody:(NSString *)body viewController:(UIViewController *)viewController;
- (void)sendTwitterWithBody:(NSString *)body viewController:(UIViewController *)viewController;
- (void)sendFacebookWithBody:(NSString *)body urlLink:(NSString *)urlLink;

@end

@implementation SocialManager

@synthesize facebook = _facebook;
@synthesize permissions = _permissions;
@synthesize socialManagerDelegate = _socialManagerDelegate;

static SocialManager *instance = nil;

+ (SocialManager *)instance {
    if(!instance) {
        instance = [[SocialManager alloc] init];
    }
    return  instance;
}

- (id)init {
    self = [super init];
	if (self) {
        self.facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
        [self setupFacebook];
	}
	return self;
}

- (id)socialManagerDelegate {
    return _socialManagerDelegate;
} 

- (NSString *)getUsersInviteLink {
    NSNumber *refCode = [ModelContext instance].loginSession.accountDetails.customerId;
    return [NSString stringWithFormat:@"%@%d", kInviteUrl,refCode]; 
}

- (void)shareText:(NSString *)shareText actionType:(ShareActionSheetType)actionType viewController:(UIViewController *)viewController {
	switch (actionType) {
		case ShareActionSheetEmail:
			[[EmailManager instance] sendEmailWithSubject:kCaptionInviteMessage body:shareText viewController:viewController];
			break;
		case ShareActionSheetTwitter:
			[self sendTwitterWithBody:shareText viewController:viewController];
			break;
		case ShareActionSheetSMS:
			[self sendSMSWithBody:shareText viewController:viewController];
			break;
		default:
			break;
	}
}

- (void)shareProductViaShareActionType:(ShareActionSheetType)shareActionType itemName:(NSString *)itemName discountPercentage:(int)discountPercentage url:(NSString *)url viewController:(UIViewController *)viewController {
	NSString *shareText = [NSString stringWithFormat:kShareProuctText, itemName,discountPercentage, url];
	[self shareText:shareText actionType:shareActionType viewController:viewController];
}

- (void)shareSaleViaShareActionType:(ShareActionSheetType)shareActionType brandName:(NSString *)brandName url:(NSString *)url viewController:(UIViewController *)viewController {
	NSString *shareText = [NSString stringWithFormat:kShareSaleText, brandName, url];
	[self shareText:shareText actionType:shareActionType viewController:viewController];
}

#pragma  mark - Email
- (void)sendInviteFriendsEmailWithViewController:(UIViewController *)viewController {
    [[GANTracker sharedTracker] trackEvent:kGANEventInvite action:kGANActionInviteEmail label:nil value:-1 withError:nil];
	NSString *subjectString = [NSString stringWithFormat:@"%@", [Utility localizedStringForKey:kCaptionInviteMessage]];
	NSString *bodyString = [NSString stringWithFormat:@"%@\n\n%@", kLongInviteMessage, [self getUsersInviteLink]];
    [[EmailManager instance] sendEmailWithSubject:subjectString body:bodyString viewController:viewController];    
}

#pragma mark - Twitter

- (void)sendTwitterWithBody:(NSString *)body viewController:(UIViewController *)viewController {
	TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];    
	
    [twitter setInitialText:body];
    [viewController presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {        
        [viewController dismissModalViewControllerAnimated:YES];        
    };
}

- (void)sendInviteFriendsViaTwitterViewController:(UIViewController *)viewController {
    [[GANTracker sharedTracker] trackEvent:kGANEventInvite action:kGANActionInviteTwitter label:nil value:-1 withError:nil];
    NSString *twitterMessage = [NSString stringWithFormat:@"%@%@", kShortInviteMessage, [self getUsersInviteLink]];
    [self sendTwitterWithBody:twitterMessage viewController:viewController];    
}

#pragma mark - SMS

- (void)sendSMSWithBody:(NSString *)body viewController:(UIViewController *)viewController {
	if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *smsComposer =[[MFMessageComposeViewController alloc] init];
        
        // Reset nav bar to default appearance.   
        [(PlndrAppDelegate *)[[UIApplication sharedApplication] delegate] updateNavBarAppearanceToDefault:YES];
        
        [smsComposer.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [smsComposer.navigationBar setTitleTextAttributes:nil];
        
        smsComposer.body = body;
        
        smsComposer.messageComposeDelegate = self;
        
        [viewController presentModalViewController:smsComposer animated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Utility localizedStringForKey:kErrorTitleError]
															message:[Utility localizedStringForKey:kSocialManagerSMSNotConfiguredMessage]
														   delegate:nil
												  cancelButtonTitle:[Utility localizedStringForKey:@"OK"]
												  otherButtonTitles:nil];
        [alertView show];    
	}
}

- (void)sendInviteFriendsViaSMSWithViewController:(UIViewController *)viewController {
    [[GANTracker sharedTracker] trackEvent:kGANEventInvite action:kGANActionInviteSMS label:nil value:-1 withError:nil];
	NSString *smsMessage = [NSString stringWithFormat:@"%@%@", kShortInviteMessage, [self getUsersInviteLink]];
	[self sendSMSWithBody:smsMessage viewController:viewController];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result{
    
    /* You can use the MessageComposeResult to determine what happened to the 
     message. I believe it tells you about sent, stored for sending later, failed 
     or cancelled. */
    
    // Customize nav bar appearance
    [(PlndrAppDelegate *)[[UIApplication sharedApplication] delegate] updateNavBarAppearanceToDefault:NO];
    
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Facebook
- (void)loginFacebookAndPopDialog {
    
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:permissions];
        NSLog(@"Authorizing Permission");
    }
    else {
        [self.socialManagerDelegate onFacebookLoginSuccess];
    }
}


- (void)sendFacebookWithBody:(NSString *)body urlLink:(NSString *)urlLink {
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kFacebookAppID, @"app_id",
                                   urlLink, @"link",
                                   kFacebookImageUrl, @"picture",
                                   kAppName, @"name",
                                   kCaptionInviteMessage, @"caption",
                                   body, @"description",
                                   nil];
    [[[SocialManager instance] facebook] dialog:@"feed" andParams:params andDelegate: [SocialManager instance]];

}

- (void)sendInviteFriendsViaFacebookDialog {
    [[GANTracker sharedTracker] trackEvent:kGANEventInvite action:kGANActionInviteFacebook label:nil value:-1 withError:nil];
	[self sendFacebookWithBody:kLongInviteMessage urlLink:[self getUsersInviteLink]];
}

- (void)facebookShareSaleWithBrandName:(NSString *)brandName url:(NSString *)url {
	NSString *shareText = [NSString stringWithFormat:kShareSaleText, brandName, @""];
	[self sendFacebookWithBody:shareText urlLink:url];
}

- (void)facebookShareProductWithitemName:(NSString *)itemName discountPercentage:(int)discountPercentage url:(NSString *)url {
	NSString *shareText = [NSString stringWithFormat:kShareProuctText, itemName,discountPercentage, @""];
	[self sendFacebookWithBody:shareText urlLink:url];
}

#pragma mark - FBConnect

- (void)setupFacebook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.facebook.sessionDelegate = self;
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}



- (void)facebookButtonPressed {
    if (self.facebook.accessToken) {
        [self fbDidLogin];
    } else {
        [self setupFacebook];
        if (![self.facebook isSessionValid]) {
            [self.facebook authorize: permissions];
        } else {
            [self fbDidLogin];
        }
    }
}


- (BOOL)isFacebookLoggedIn {
	return [self.facebook isSessionValid];
}

-(void) facebookLogout{
    [self.facebook logout:self];
}

-(void)facebookLogin {
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize:permissions];
        NSLog(@"Authorizing Permission");
    }
}

#pragma mark - FB Delegate Methods

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:kFACEBOOK_ACCESS_TOKEN];
    [defaults setObject:[self.facebook expirationDate] forKey:kFACEBOOK_EXPIRATION_DATE];
    [defaults synchronize];

    [self.socialManagerDelegate onFacebookLoginSuccess];
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:kFACEBOOK_ACCESS_TOKEN];
    [defaults setObject:nil forKey:kFACEBOOK_EXPIRATION_DATE];
    [defaults synchronize];

}

- (void)fbDidNotLogin:(BOOL)cancelled {
    // To be implemented
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    // To be implemented    
}


- (void)fbSessionInvalidated {
    // To be implemented
}



@end
