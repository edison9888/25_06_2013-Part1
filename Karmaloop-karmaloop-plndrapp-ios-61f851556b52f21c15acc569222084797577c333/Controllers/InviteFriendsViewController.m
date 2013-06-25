//
//  InviteFriendsViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "Constants.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "PlndrAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PopupUtil.h"
#import "GANTracker.h"
#import "Utility.h"

@interface InviteFriendsViewController ()

@property InviteFriendButonTypes lastButtonPressed;
@property BOOL isPreparingToShare;

- (void) emailInviteButtonPressed:(id)sender;
- (void) facebookInviteButtonPressed:(id)sender;
- (void) twitterInviteButtonPressed:(id)sender;
- (void) smsInviteButtonPressed:(id)sender;
- (void) presentLoginModal;
- (void) performLastButtonPressedAction;
- (void) createAccountDetailsSubscription;
- (void) handleAccountDetailsSubscriptionError;

@end

@implementation InviteFriendsViewController

@synthesize 
scrollContainer = _scrollContainer,
lastButtonPressed = _lastButtonPressed,
accountDetailsSubscription = _accountDetailsSubscription,
isPreparingToShare = _isPreparingToShare;

- (id)init {
    self = [super init];
    if(self) {
        self.title = @"INVITE";
    }
    return self;
}

- (void)dealloc {
    [self.accountDetailsSubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollContainer = nil;
    [self.accountDetailsSubscription cancel];
    self.accountDetailsSubscription = nil;
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    self.view.backgroundColor = kPlndrBgGrey;
    
    int verticalPadding = 12;
    int leftEdgeInsectPadding = 60;
    
    
    self.scrollContainer = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollContainer];
    
    NSString *titleText = kInviteFriendsTitle;
    UIFont *titleFont = kFontBoldCond20;
    CGSize titleFontSize = [titleText sizeWithFont:titleFont constrainedToSize:CGSizeMake(kDeviceWidth, 35) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - titleFontSize.width)/2, verticalPadding, titleFontSize.width, titleFontSize.height)];
    titleTextLabel.text = titleText;
    titleTextLabel.font = titleFont;
    titleTextLabel.textColor = kPlndrTextGold;
    titleTextLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:titleTextLabel];
    
    
    NSString *subtitleText = kInviteFriendsSubtitle;
    UIFont *subtitleFont = kFontBoldCond15;
    CGSize subtitleSize = [subtitleText sizeWithFont:subtitleFont constrainedToSize:CGSizeMake(kDeviceWidth, 30) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *subtitleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - subtitleSize.width)/2, titleTextLabel.frame.origin.y + titleTextLabel.frame.size.height + verticalPadding, subtitleSize.width, subtitleSize.height)];
    subtitleTextLabel.text = subtitleText;
    subtitleTextLabel.font = subtitleFont;
    subtitleTextLabel.textColor = kPlndrBlack;
    subtitleTextLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:subtitleTextLabel];
    
    UIImage *emailBanner = [UIImage imageNamed:@"email.png"];
    UIButton *inviteByEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteByEmail.frame = CGRectMake((kDeviceWidth - emailBanner.size.width)/2, subtitleTextLabel.frame.origin.y + subtitleTextLabel.frame.size.height + verticalPadding, emailBanner.size.width, emailBanner.size.height);
    [inviteByEmail setTitle:kInviteFriendsEmailTitle forState:UIControlStateNormal];
    [inviteByEmail setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    [inviteByEmail.titleLabel setFont:kFontUnivers16];
    [inviteByEmail setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inviteByEmail setTitleEdgeInsets: UIEdgeInsetsMake(0, leftEdgeInsectPadding, 0, 0)];
    [inviteByEmail setBackgroundImage:emailBanner forState:UIControlStateNormal];
    [inviteByEmail setBackgroundImage:[UIImage imageNamed:@"email_hl.png"] forState:UIControlStateHighlighted];
    [inviteByEmail setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f] forState:UIControlStateNormal];
    [inviteByEmail.titleLabel setShadowOffset:CGSizeMake(-1.0, 1.0)];
    
    [inviteByEmail addTarget:self action:@selector(emailInviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContainer addSubview:inviteByEmail];
    
    UIImage *facebookBanner = [UIImage imageNamed:@"facebook.png"];
    UIButton *inviteByFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteByFacebook.frame = CGRectMake((kDeviceWidth - facebookBanner.size.width)/2, inviteByEmail.frame.origin.y + inviteByEmail.frame.size.height + verticalPadding, facebookBanner.size.width, facebookBanner.size.height);
    [inviteByFacebook setTitle:kInviteFriendsFacebookTitle forState:UIControlStateNormal];
    [inviteByFacebook setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    [inviteByFacebook.titleLabel setFont:kFontUnivers16];
    [inviteByFacebook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inviteByFacebook setTitleEdgeInsets:UIEdgeInsetsMake(0, leftEdgeInsectPadding, 0, 0)];
    [inviteByFacebook setBackgroundImage:facebookBanner forState:UIControlStateNormal];
    [inviteByFacebook setBackgroundImage:[UIImage imageNamed:@"facebook_hl.png"] forState:UIControlStateHighlighted];
    [inviteByFacebook addTarget:self action:@selector(facebookInviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inviteByFacebook setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f] forState:UIControlStateNormal];
    [inviteByFacebook.titleLabel setShadowOffset:CGSizeMake(-1.0, 1.0)];
    
    [self.scrollContainer addSubview:inviteByFacebook];
    
    
    UIImage *twitterBanner = [UIImage imageNamed:@"twitter.png"];
    UIButton *inviteByTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteByTwitter.frame = CGRectMake((kDeviceWidth - twitterBanner.size.width)/2, inviteByFacebook.frame.origin.y + inviteByFacebook.frame.size.height + verticalPadding, twitterBanner.size.width, twitterBanner.size.height);
    [inviteByTwitter setTitle:kInviteFriendsTwitterTitle forState:UIControlStateNormal];
    [inviteByTwitter setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    [inviteByTwitter.titleLabel setFont:kFontUnivers16];
    [inviteByTwitter setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inviteByTwitter setTitleEdgeInsets:UIEdgeInsetsMake(0, leftEdgeInsectPadding, 0, 0)];
    [inviteByTwitter setBackgroundImage:twitterBanner forState:UIControlStateNormal];
    [inviteByTwitter setBackgroundImage:[UIImage imageNamed:@"twitter_hl.png"] forState:UIControlStateHighlighted];
    [inviteByTwitter addTarget:self action:@selector(twitterInviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inviteByTwitter setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f] forState:UIControlStateNormal];
    [inviteByTwitter.titleLabel setShadowOffset:CGSizeMake(-1.0, 1.0)];
    
    [self.scrollContainer addSubview:inviteByTwitter];

    UIImage *smsBanner = [UIImage imageNamed:@"sms.png"];
    UIButton *inviteBySMS = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteBySMS.frame = CGRectMake((kDeviceWidth - smsBanner.size.width)/2, inviteByTwitter.frame.origin.y + inviteByTwitter.frame.size.height + verticalPadding, smsBanner.size.width, smsBanner.size.height);
    [inviteBySMS setTitle:kInviteFriendsSMSTitle forState:UIControlStateNormal];
    [inviteBySMS setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    [inviteBySMS.titleLabel setFont:kFontUnivers16];
    [inviteBySMS setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inviteBySMS setTitleEdgeInsets:UIEdgeInsetsMake(0, leftEdgeInsectPadding, 0, 0)];
    [inviteBySMS setBackgroundImage:smsBanner forState:UIControlStateNormal];
    [inviteBySMS setBackgroundImage:[UIImage imageNamed:@"sms_hl.png"] forState:UIControlStateHighlighted];
    [inviteBySMS addTarget:self action:@selector(smsInviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inviteBySMS setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f] forState:UIControlStateNormal];
    [inviteBySMS.titleLabel setShadowOffset:CGSizeMake(-1.0, 1.0)];
    [self.scrollContainer addSubview:inviteBySMS];
    
    NSString *endText1 = @"*Any new member you send an invite to, and makes a purchase earns you $10.";
    UIFont *endFont = kFontRoman12;
    CGSize endSize1 = [endText1 sizeWithFont:endFont constrainedToSize:CGSizeMake(inviteBySMS.frame.size.width, 100) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *endTextLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - endSize1.width)/2, inviteBySMS.frame.origin.y + inviteBySMS.frame.size.height + verticalPadding, endSize1.width, endSize1.height)];
    endTextLabel1.text = endText1;
    endTextLabel1.font = endFont;
    endTextLabel1.textColor = kPlndrMediumGreyTextColor;
    endTextLabel1.backgroundColor = [UIColor clearColor];
    endTextLabel1.numberOfLines = 5;
    endTextLabel1.textAlignment = UITextAlignmentLeft;
    [self.scrollContainer addSubview:endTextLabel1];    
    
    NSString *endText2 = @"*All referral credit expire on Dec 31, 2012.";
    CGSize endSize2 = [endText2 sizeWithFont:endFont constrainedToSize:CGSizeMake(inviteBySMS.frame.size.width, 100) lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *endTextLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - endSize1.width)/2, endTextLabel1.frame.origin.y + endTextLabel1.frame.size.height + verticalPadding, endSize1.width, endSize2.height)];
    endTextLabel2.text = endText2;
    endTextLabel2.font = endFont;
    endTextLabel2.textColor = kPlndrMediumGreyTextColor;
    endTextLabel2.backgroundColor = [UIColor clearColor];
    endTextLabel2.numberOfLines = 5;
    endTextLabel2.textAlignment = UITextAlignmentLeft;
    [self.scrollContainer addSubview:endTextLabel2];
    
    self.scrollContainer.contentSize = CGSizeMake(kDeviceWidth, endTextLabel2.frame.origin.y + endTextLabel2.frame.size.height + verticalPadding); // todo calculate height
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad]; 
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[ModelContext instance] loginSession] isLoggedIn]) {
        [self createAccountDetailsSubscription];
    }
    
    [[GANTracker sharedTracker] trackPageview:kGANPageInvite withError:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Pressed
- (void) emailInviteButtonPressed:(id)sender {
   
    self.lastButtonPressed = InviteFriendEmailButton;
    if([[ModelContext instance] loginSession].isLoggedIn) {
        if (self.accountDetailsSubscription.state == SubscriptionStateAvailable) {
            [[SocialManager instance] sendInviteFriendsEmailWithViewController:self];
        } else {
            self.isPreparingToShare = YES;
            [self createAccountDetailsSubscription];
        }
    }
    else {
        [self presentLoginModal];
    }
}
- (void) facebookInviteButtonPressed:(id)sender {
    self.lastButtonPressed = InviteFriendFacebookButton;
    if([[ModelContext instance] loginSession].isLoggedIn) {
        if (self.accountDetailsSubscription.state == SubscriptionStateAvailable) {
            [[SocialManager instance] setSocialManagerDelegate:self];
            [[SocialManager instance] loginFacebookAndPopDialog]; 
        } else {
            self.isPreparingToShare = YES;
            [self createAccountDetailsSubscription];
        }
    }
    else {
        [self presentLoginModal];
    }

    
}
- (void) twitterInviteButtonPressed:(id)sender {
   self.lastButtonPressed = InviteFriendTwitterButton;
    if([[ModelContext instance] loginSession].isLoggedIn) {
        if (self.accountDetailsSubscription.state == SubscriptionStateAvailable) {
            [[SocialManager instance] sendInviteFriendsViaTwitterViewController:self];
        } else {
            self.isPreparingToShare = YES;
            [self createAccountDetailsSubscription];
        }
    }
    else {
        [self presentLoginModal];
    }
}
- (void) smsInviteButtonPressed:(id)sender {
    self.lastButtonPressed = InviteFriendSMSButton;
    if([[ModelContext instance] loginSession].isLoggedIn) { 
        if (self.accountDetailsSubscription.state == SubscriptionStateAvailable) {
            [[SocialManager instance] sendInviteFriendsViaSMSWithViewController:self];
        } else {
            self.isPreparingToShare = YES;
            [self createAccountDetailsSubscription];
        }
    }
    else {
        [self presentLoginModal];
    }
}

- (void)presentLoginModal {
    self.isPreparingToShare = YES;
    LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginDelegate:self hasSessionExpired:NO];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentModalViewController:navController animated:YES];
}

- (void)performLastButtonPressedAction {
    if (![ModelContext instance].loginSession.isLoggedIn || ([ModelContext instance].loginSession.accountDetails == nil)) { return; }
    switch (self.lastButtonPressed) {
        case InviteFriendEmailButton: {
            [[SocialManager instance] sendInviteFriendsEmailWithViewController:self];
            break;
        }
        case InviteFriendFacebookButton: {
            [[SocialManager instance] setSocialManagerDelegate:self];
            [[SocialManager instance] loginFacebookAndPopDialog];
            break;
        }
        case InviteFriendSMSButton: {
            [[SocialManager instance] sendInviteFriendsViaSMSWithViewController:self];
            break;
        }
        case InviteFriendTwitterButton: {
            [[SocialManager instance] sendInviteFriendsViaTwitterViewController:self];
            break;
        }
        default: {
            NSLog(@"Error, no button was last pressed!");
        }
    }
    self.isPreparingToShare = NO;
}

- (void)createAccountDetailsSubscription {
    [_accountDetailsSubscription cancel]; //Cancel any previously set up subscription
    _accountDetailsSubscription = [[AccountDetailsSubscription alloc] initWithContext:[ModelContext instance]];
    _accountDetailsSubscription.delegate = self;
    [self subscriptionUpdatedState:_accountDetailsSubscription];
}

- (void)handleAccountDetailsSubscriptionError {    
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.accountDetailsSubscription];
    [self displayAPIErrorWithTitle:kInviteErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

#pragma mark - SocialManagerDelegate Methods

- (void) onFacebookLoginSuccess {
	[[SocialManager instance] setSocialManagerDelegate:nil];
    [[SocialManager instance] sendInviteFriendsViaFacebookDialog];
}


#pragma mark - LoginViewControllerDelegate

- (void) loginModalDidDisappear {
    [self performLastButtonPressedAction];
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self presentAuthRequired];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } 
    else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        if ([((PlndrAppDelegate*)[[UIApplication sharedApplication] delegate]) currentTabBarIndex] == kInviteFriendsTabIndex) {
            if (self.isPreparingToShare) {
                [self performLastButtonPressedAction];
            }
        } else {
            self.isPreparingToShare = NO;
        }
        
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleAccountDetailsSubscriptionError];
    } else { // Pending
        [self showLoadingView];
    }
}

@end
