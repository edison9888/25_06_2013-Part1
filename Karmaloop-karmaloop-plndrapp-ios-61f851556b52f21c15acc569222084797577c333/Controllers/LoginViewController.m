//
//  LoginViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "TextEntryMetaData.h"
#import "TextEntryDataCell.h"
#import "LoginSession.h"
#import "ModelContext.h"
#import "Constants.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "PopupUtil.h"
#import "PasswordRequestPopup.h"
#import "SignupViewController.h"
#import "Utility.h"
#import "PopupNotificationViewController.h"
#import "GANTracker.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIScrollView *scrollContainer;

- (void)cancelButtonPressed;
- (void)loginButtonPressed:(id)sender;
- (void)signupButtonPressed:(id)sender;
- (void)loginSucceeded;
- (void)createLoginSubscription;

@end

@implementation LoginViewController

@synthesize loginDelegate = _loginDelegate;
@synthesize loginSubscription = _loginSubscription;
@synthesize scrollContainer = _scrollContainer;
@synthesize hasSessionExpired = _hasSessionExpired;


- (id) initWithLoginDelegate:(id<LoginViewControllerDelegate>)loginDelegate hasSessionExpired:(BOOL)hasSessionExpired{
    self = [super init];
    if (self) {
        self.title = @"";
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        self.loginDelegate = loginDelegate;
        self.hasSessionExpired = hasSessionExpired;
        if (self.hasSessionExpired) {
            self.errorHeaderMessage = kAuthErrorMessage;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    self.loginDelegate = nil;
    [self.loginSubscription cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    self.scrollContainer = nil;
    self.errorHeader = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[GANTracker sharedTracker] trackPageview:kGANPageLogin withError:nil];
    
    self.view.backgroundColor = kPlndrBgGrey;
    
    self.scrollContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollContainer setDelaysContentTouches:NO];
    [self.view addSubview:self.scrollContainer];
    

    if (self.hasSessionExpired) {
        [self setErrorHeaderWithMessage:self.errorHeaderMessage];
    }
    int errorHeaderHeight = self.hasSessionExpired ? self.errorHeader.frame.size.height : 0.0f;
    self.dataTable.delegate = self;
    self.dataTable.frame = CGRectMake(0, 0, kDeviceWidth, 133 + errorHeaderHeight);
    self.dataTable.scrollEnabled = NO;
    [self.dataTable setBackgroundColor:[UIColor clearColor]];
    self.dataTable.sectionIndexMinimumDisplayRowCount = 0;
    [self.scrollContainer addSubview:self.dataTable];

    UIImage *signUpBG = [UIImage imageNamed:@"bg_signin.png"];
    UIImageView *signUPBGView = [[UIImageView alloc] initWithImage:signUpBG];
    signUPBGView.frame = CGRectMake(0, 0, signUpBG.size.width, signUpBG.size.height);
    [self.scrollContainer insertSubview:signUPBGView atIndex:0];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *loginButtonImage = [UIImage imageNamed:@"yellow_btn.png"];
    loginButton.frame = CGRectMake((kDeviceWidth - loginButtonImage.size.width)/2, self.dataTable.frame.origin.y + self.dataTable.frame.size.height + 10, loginButtonImage.size.width, loginButtonImage.size.height);
    [loginButton setTitle:kLoginSignIn forState:UIControlStateNormal];
    [loginButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    loginButton.titleLabel.font = kFontBoldCond17;
    [loginButton setBackgroundImage:loginButtonImage forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContainer addSubview:loginButton];
    
    NSString *forgotPasswordLinkText = kLoginForgotPasswordMessage;
    UIFont *forgotPasswordLinkFont = kFontMedium14;
    
    CGSize forgotPasswordLinkSize = [forgotPasswordLinkText sizeWithFont:forgotPasswordLinkFont constrainedToSize:CGSizeMake(320, 35) lineBreakMode:UILineBreakModeTailTruncation];
    
    OHAttributedLabel *forgotPasswordLink = [[OHAttributedLabel alloc] initWithFrame:CGRectMake((kDeviceWidth - forgotPasswordLinkSize.width)/2, loginButton.frame.origin.y + loginButton.frame.size.height + 30, forgotPasswordLinkSize.width, forgotPasswordLinkSize.height)];
    forgotPasswordLink.delegate = self;
    forgotPasswordLink.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString: forgotPasswordLinkText];
    [attrStr setFont:forgotPasswordLinkFont];
    forgotPasswordLink.attributedText = attrStr;
    [forgotPasswordLink addCustomLink:[[NSURL alloc] init] inRange:[attrStr.string rangeOfString:attrStr.string]];
    forgotPasswordLink.linkColor = kPlndrTextGold;
    [self.scrollContainer addSubview:forgotPasswordLink]; 
    
    NSString *signupLabelText = kLoginNotAMemberMessage;
    UIFont *signupLabelTextFont = kFontMediumCond14;
    
    CGSize signupLabelTextSize = [signupLabelText sizeWithFont:signupLabelTextFont constrainedToSize:CGSizeMake(320, 35) lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *signupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 315, kDeviceWidth, signupLabelTextSize.height)];
    signupLabel.text = signupLabelText;
    signupLabel.textAlignment = UITextAlignmentCenter;
    signupLabel.backgroundColor = [UIColor clearColor];
    signupLabel.font = signupLabelTextFont;
    [signupLabel setTextColor:kPlndrMediumGreyTextColor];
    [self.scrollContainer addSubview:signupLabel];
    
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *signupButtonImage = [UIImage imageNamed:@"black_btn.png"];
    signupButton.frame = CGRectMake(loginButton.frame.origin.x, signupLabel.frame.origin.y + signupLabelTextSize.height + 10, signupButtonImage.size.width, signupButtonImage.size.height);
    [signupButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signupButton setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    signupButton.titleLabel.font = kFontBoldCond17;
    [signupButton setBackgroundImage:signupButtonImage forState:UIControlStateNormal];
    [signupButton setBackgroundImage:[UIImage imageNamed:@"black_btn_hl.png"] forState:UIControlStateHighlighted];
    [signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContainer addSubview:signupButton];
    self.scrollContainer.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight - kNavBarFrame.size.height + errorHeaderHeight);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[ModelContext instance] loginSession].isLoggedIn) {
        [self loginSucceeded];
    }
}


- (void)setupNavBar {
    // Setup the left nav button
    UIButton *leftBtn = [PlndrBaseViewController createNavBarButtonWithText:@"CLOSE"];
    [leftBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];   
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.loginDelegate loginModalDidDisappear]; 
}


#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    TextEntryMetaData *cellMetaData = [self getDefaultTextEntryMetaDataAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case LoginCellUsername: {
            cellMetaData.cellData = [[ModelContext instance] loginSession].username;
            cellMetaData.cellPlaceholder = @"Email";
            cellMetaData.cellKeyboardType = UIKeyboardTypeEmailAddress;
            [cellMetaData setWriteDataBlock:^(NSString *data) {
                [[[ModelContext instance] loginSession] setUsername:data];
            }];
            
            cellMetaData.inputAccessoryViewType = InputAccessoryNextDismiss;
            break;
        }
        case LoginCellPassword: {
            cellMetaData.cellData = [[ModelContext instance] loginSession].password;
            cellMetaData.cellPlaceholder = @"Password";
            cellMetaData.isSecure = YES;
            [cellMetaData setPerformNextAction:^(void) {
                [self loginButtonPressed:self];
            } ];
            
            [cellMetaData setWriteDataBlock:^(NSString *data) {
                [[[ModelContext instance] loginSession] setPassword:data]; 
            }];
            
            cellMetaData.inputAccessoryViewType = InputAccessoryPreviousDismissGo;
            
            break;
        }
        default: {
            NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
            break;
        }
    }
    
    return cellMetaData;
}

- (void) cancelButtonPressed {
    if ([self.loginDelegate respondsToSelector:@selector(loginFailed)]) {
        [self.loginDelegate performSelector:@selector(loginFailed)];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginButtonPressed:(id)sender {
    [[Utility getFirstResponder] resignFirstResponder];
    
    [self createLoginSubscription];
}

- (void)signupButtonPressed:(id)sender {
    SignupViewController *signupVC = [[SignupViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signupVC];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)loginSucceeded {
    if ([self.loginDelegate respondsToSelector:@selector(loginSucceeded)]) {
        [self.loginDelegate loginSucceeded];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) createLoginSubscription {
    [_loginSubscription cancel]; //Cancel any previously set up subscription
    _loginSubscription = [[LoginSubscription alloc] initWithUsername:[[ModelContext instance] loginSession].username password:[[ModelContext instance] loginSession].password context:[ModelContext instance]];
    _loginSubscription.delegate = self;
    [self subscriptionUpdatedState:_loginSubscription];
}



#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self loginSucceeded];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];     
        PopupViewController *popup;
        NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.loginSubscription];
        [self displayAPIErrorWithTitle:kLoginErrorTitle message:errorStr usingPopup:&popup];
        self.defaultErrorPopup = popup;
        
    } else  { //Pending
        [self showLoadingView];
    }

}

#pragma mark - UITableViewDataSource/Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int errorHeaderHeight = self.hasSessionExpired ? self.errorHeader.frame.size.height : 0.0f;
    return kLoginHeaderHeight + errorHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int errorHeaderHeight = 0;
    UIView *headerView = [[UIView alloc] init];
    if (self.hasSessionExpired) {
        errorHeaderHeight = self.errorHeader.frame.size.height;
    } else {
        self.errorHeader = nil;
    }
    headerView.frame = CGRectMake(0, 0, kDeviceWidth, kLoginHeaderHeight + errorHeaderHeight);
    [headerView addSubview:self.errorHeader];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, errorHeaderHeight, kDeviceWidth, kLoginHeaderHeight)];
    headerLabel.text = @"MEMBER SIGN IN";
    headerLabel.textAlignment = UITextAlignmentCenter;
    [headerLabel setTextColor:kPlndrDarkGreyTextColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = kFontBoldCond20;
    
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

#pragma mark - OHAttributedLabelDelegate

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo {
    PasswordRequestPopup *passwordVC = [[PasswordRequestPopup alloc] init];
    [PopupUtil presentPopup:passwordVC withDelegate:self];
    return NO;
}

#pragma mark - PopupViewControllerDelegate

- (void)dismissPopup:(id)sender {
    [[Utility getFirstResponder] resignFirstResponder];
    [PopupUtil dismissPopup];
    self.defaultErrorPopup = nil;
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:popupViewController];
}

#pragma mark - PlndrBaseViewController Override

- (CGRect)loadingViewFrame {
    return CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - self.navigationController.navigationBar.frame.size.height);
}

- (UIColor*) loadingViewBackgroundColor {
    return kPlndrTransparencyColor;
}


#pragma mark - TextEntryDataCellDelegate Methods

- (void)textEntryDataCellDidBecomeActive:(TextEntryDataCell*)sender {
    [super textEntryDataCellDidBecomeActive:sender];
    int verticalPadding = 5;
    int headerHeight = kLoginHeaderHeight;
    if (self.hasSessionExpired) {
        headerHeight += self.errorHeader.frame.size.height;
    }
    [self.scrollContainer setScrollEnabled:NO];
    [self.scrollContainer setContentOffset:CGPointMake(0, headerHeight - verticalPadding) animated:YES];
}


#pragma mark - KeyboardListener

-(void) keyboardDidHide {
    [self.scrollContainer setScrollEnabled:YES];
    [self.scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    return;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    return;
}



@end