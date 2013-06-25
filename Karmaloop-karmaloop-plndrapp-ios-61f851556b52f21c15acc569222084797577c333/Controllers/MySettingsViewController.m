//
//  MySettingsViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MySettingsViewController.h"
#import "Constants.h"
#import "ModelContext.h"
#import "LoginSession.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "ChangePasswordViewController.h"
#import "DetailAndDisclosureDataCell.h"
#import "DetailAndDisclosureMetaData.h"
#import "ProfileViewController.h"
#import "MiniBrowserViewController.h"
#import "GANTracker.h"
#import "PopupUtil.h"
#import "EmailManager.h"
#import "Utility.h"

@interface MySettingsViewController ()

- (void) logoutButtonPressed;
- (void) reloadView;
- (void) pushLoginController;
- (void) pushSignUpController;
- (void) pushProfileController;
- (void) pushChangePasswordController;
- (void) setupNavBar;
- (void) callCustomerSupport;
- (void) createCustomerSupportEmail;
- (void) pushFAQWithLink:(NSURL*) link;

@end

@implementation MySettingsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"SETTINGS";
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    [self setupNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadView];
    if (self.isPresentingAuthenticationDueToInterruption) {
        [self presentAuthRequired];
    } else {
        [[GANTracker sharedTracker] trackPageview:kGANPageSettings withError:nil];
    }
}

- (void)dealloc {
    // None so far
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

#pragma mark - private

- (void)setupNavBar {
    if ([ModelContext instance].loginSession.isLoggedIn) {
        // Setup the right nav button
        UIButton *navBarButton = [PlndrBaseViewController createNavBarButtonWithText:@"LOGOUT"];
        
        [navBarButton addTarget:self action:@selector(logoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBarButton];   
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)logoutButtonPressed {
    [[ModelContext instance].loginSession logout];
    [self reloadView];
}

- (void) pushLoginController {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginDelegate:self hasSessionExpired:NO]; 
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentModalViewController:navController animated:YES];
}

- (void) pushSignUpController {
    SignupViewController *signupVC = [[SignupViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signupVC];
    
    [self presentModalViewController:navController animated:YES];
}

- (void) pushProfileController {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileViewController animated:YES];
}
- (void)pushChangePasswordController {
    ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (void) reloadView {
    [self setupNavBar];
    [[self dataTable] reloadData];
}

- (CellMetaData*) getCellMetaDataForIndexPath:(NSIndexPath*)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    switch (indexPath.section) {
        case MySettingsMyAccountSection: {
            if ([ModelContext instance].loginSession.isLoggedIn) {
                switch (indexPath.row) {
                    case MyAccountProfileCell: {
                        cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"PROFILE";
                        [cellMetaData setDidSelectBlock:^(void) {
                            [self pushProfileController];
                        }];
                        break;
                    }
                    case MyAccountChangePasswordCell: {
                        cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"CHANGE PASSWORD";
                        [cellMetaData setDidSelectBlock:^(void) {
                            [self pushChangePasswordController]; 
                        }];
                        break;
                    }
                        
                    default:
                        NSLog(@"WARNING: unknown MYACCOUNTLoggedInCell enum %d", indexPath.row);
                }
            } else {    
                switch (indexPath.row) {
                    case MyAccountLoginCell: {
                        cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"LOG IN";
                        [cellMetaData setDidSelectBlock:^(void) {
                            [self pushLoginController];
                        }];
                        break;
                    }
                    case MyAccountSignUpCell: {
                        cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"SIGN UP";
                        [cellMetaData setDidSelectBlock:^(void) {
                            [self pushSignUpController]; 
                        }];
                        break;
                    }
                    default:
                        NSLog(@"WARNING: unknown MYACCOUNTLoggedOutCell enum %d", indexPath.row);
                }
            }
        }
            break;        
        case MySettingsSocialManagerSection: {
            switch (indexPath.row) {
                case SocialManagerFacebookCell: {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    if ([[SocialManager instance] isFacebookLoggedIn]) {
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"LOGOUT FACEBOOK";
                        [cellMetaData setDidSelectBlock:^(void) {
                            // TO add Logout
                            [[SocialManager instance] facebookLogout];
                            [self.dataTable reloadData];
                        }];
                    } else {
                        ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"LOGIN FACEBOOK";
                        [cellMetaData setDidSelectBlock:^(void) {
                            [[SocialManager instance] setSocialManagerDelegate:self];
                            [[SocialManager instance] facebookLogin];

                        }];                            
                    }
                    
                    break;
                }    
                    
                default:
                    NSLog(@"WARNING: unknown MySettingsSocialManagerSection enum %d", indexPath.row);
            }
        }
            break;
        case MySettingsCustomerSupportSection: {
            switch (indexPath.row) {
                case MySettingsCustomerSupportPhoneCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = [NSString stringWithFormat:@"CALL (%@)", kPlndrCustomerSupportPrettyPhoneNumber];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self callCustomerSupport]; 
                    }];
                    break;
                }
                case MySettingsCustomerSupportEmailCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = [NSString stringWithFormat:@"EMAIL (%@)", kPlndrCustomerSupportEmail];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self createCustomerSupportEmail]; 
                    }];
                    break;
                }
                default:
                    NSLog(@"WARNING: unknown MySettingsCustomerSupportSection enum %d", indexPath.row);
            }
        }
            break;
        case MySettingsFAQSection: {
            switch (indexPath.row) {
                case MySettingsFAQOrdersCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"ORDERS FAQ";
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushFAQWithLink:[NSURL URLWithString:kPlndrOrdersFAQURL]];
                    }];
                    break;
                }
                case MySettingsFAQPaymentCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"PAYMENT FAQ";
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushFAQWithLink:[NSURL URLWithString:kPlndrPaymentFAQURL]];
                    }];
                    break;
                }
                case MySettingsFAQReturnsCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"RETURNS FAQ";
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushFAQWithLink:[NSURL URLWithString:kPlndrReturnsFAQURL]];
                    }];
                    break;
                }
                case MySettingsFAQPromotionAndGiftCell:
                {
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"PROMOTION/GIFT FAQ";
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushFAQWithLink:[NSURL URLWithString:kPlndrPromotionAndGiftURL]];
                    }];
                    break;
                }
                default:
                    NSLog(@"WARNING: unknown MySettingsFAQSection enum %d", indexPath.row);
            }
        }
            break;
        
        default:
            NSLog(@"WARNING: unknown MYSettingsMYAccountSection enum %d", indexPath.section);
            break;
    }
    
    return cellMetaData;
}

- (void)loginModalDidDisappear {
    // Do nothing. Updating UI is handled by viewDidAppear
}

- (void)callCustomerSupport {    
    NSString *customerSupportNumber = [NSString stringWithFormat:@"telprompt://%@", kPlndrCustomerSupportPhoneNumber];
    NSURL *customerSupportUrl = [NSURL URLWithString:customerSupportNumber];
    if ([[UIApplication sharedApplication] canOpenURL:customerSupportUrl]) {
        [[UIApplication sharedApplication] openURL:customerSupportUrl];
    } else {
        self.defaultErrorPopup = [[PopupNotificationViewController alloc] initWithTitle:kErrorTitleError message:[NSString stringWithFormat:kPlndrCustomerSupportCallErrorText, kPlndrCustomerSupportPrettyPhoneText,kPlndrCustomerSupportPrettyPhoneNumber]];
        [PopupUtil presentPopup:self.defaultErrorPopup withDelegate:self];
    }
}

- (void)createCustomerSupportEmail {
    
    NSString *systemInfo = @"System Info";
    NSString *deviceName = [NSString stringWithFormat:@"%@: %@", @"Device Name", [UIDevice currentDevice].model];
    NSString *iosVersion = [NSString stringWithFormat:@"%@: %@", @"iOS Version", [UIDevice currentDevice].systemVersion];
    NSString *appVersion = [NSString stringWithFormat:@"%@: %@", @"App Version", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    NSString *languageCode = [NSString stringWithFormat:@"%@: %@", @"Language Code", [[NSLocale preferredLanguages] objectAtIndex:0]];
    NSString *currentNetwork = [NSString stringWithFormat:@"%@: %@", @"Current Network", [Utility networkStatus]];
    NSString *currentTime = [NSString stringWithFormat:@"%@: %@", @"Current Time", [[EmailManager dateFormatterForSupportEmail] stringFromDate:[NSDate date]]];
    
    NSString *messageBody = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n%@\n%@\n", systemInfo, deviceName, iosVersion, appVersion, languageCode, currentNetwork, currentTime];		
    NSArray *recipients = [NSArray arrayWithObject:kPlndrCustomerSupportEmail];

    [[EmailManager instance] sendEmailWithSubject:@"PLNDR Support" body:messageBody recipients:recipients viewController:self];
}

- (void)pushFAQWithLink:(NSURL *)link {
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:link];
    MiniBrowserViewController *browserVC = [[MiniBrowserViewController alloc] initWithUrl:urlRequest];
    browserVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browserVC animated:YES];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MySettingsSectionsNUM;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case MySettingsSocialManagerSection:
            if (![ModelContext instance].loginSession.isLoggedIn) {
                return 0;
            } else {
                return kPOTableHeaderHeight;
            }
        case MySettingsMyAccountSection:
            if ([ModelContext instance].loginSession.isLoggedIn) {
                return kPOTableHeaderHeight + 2*kMySettingsAccountHeaderVerticalPadding;
            }
        case MySettingsCustomerSupportSection:
        case MySettingsFAQSection:
            return kPOTableHeaderHeight;
        default:
            return 1.0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, kDeviceWidth, kPOTableHeaderHeight)];
    headerView.textAlignment = UITextAlignmentCenter;
    headerView.backgroundColor = [UIColor clearColor];
    headerView.textColor = kPlndrMediumGreyTextColor;
    headerView.font = kFontBoldCond17;
    switch (section) {
        case MySettingsMyAccountSection: {
            NSString *username = @"";
            headerView.text = [NSString stringWithFormat:@"MY ACCOUNT"];
            if ([ModelContext instance].loginSession.isLoggedIn) {
                headerView.text = [NSString stringWithFormat:@"MY ACCOUNT:"];
                headerView.frame =  CGRectMake(0, kMySettingsAccountHeaderVerticalPadding, headerView.frame.size.width, headerView.frame.size.height/2);
                username = [NSString stringWithFormat:@"%@", [ModelContext instance].loginSession.username];
                UILabel *accountName = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height + kMySettingsAccountHeaderVerticalPadding, kDeviceWidth, headerView.frame.size.height)];
                accountName.text = [NSString stringWithFormat:@"%@", username];
                accountName.textAlignment = UITextAlignmentCenter;
                accountName.backgroundColor = [UIColor clearColor];
                accountName.textColor = kPlndrMediumGreyTextColor;
                accountName.font = kFontMediumCond17;
                UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kPOTableHeaderHeight + 2*kMySettingsAccountHeaderVerticalPadding)];
                [header addSubview:headerView];
                [header addSubview:accountName];
                return header;
            } else {
                return headerView;
            }
        }
            break;
        case MySettingsCustomerSupportSection: {
            headerView.text = @"CUSTOMER SUPPORT";
        }
            break;
        case MySettingsSocialManagerSection: {
            if ([ModelContext instance].loginSession.isLoggedIn) {
                headerView.text = @"FACEBOOK";                
            } else {
                return nil;
            }

        }
            break;
        case MySettingsFAQSection: {
            headerView.text = @"FREQUENTLY ASKED QUESTIONS";
            break;
        }
        default:
            headerView = nil;
            NSLog(@"WARNING: unknown viewForHeaderInSection enum %d", section);
            break;
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case MySettingsMyAccountSection:
            if ([ModelContext instance].loginSession.isLoggedIn) {
                return MyAccountLoggedInCellNUM;
            } else {
                return MyAccountLoggedOutCellNUM;
            }
        case MySettingsCustomerSupportSection:
            return MySettingsCustomerSupportSectionCellNUM;
        case MySettingsSocialManagerSection:
            if ([ModelContext instance].loginSession.isLoggedIn) {
                return SocialManagerNUM;                
            } else {
                return 0;
            }
        case MySettingsFAQSection: {
            return MySettingsFAQNUM;
        }

        default:
            NSLog(@"WARNING: unknown numberOfRowsInSection enum %d", section);
            return 0;
    }
}

- (void)handleAbortForAuthentication {
    [[[ModelContext instance] loginSession] logout];
    self.isPresentingAuthenticationDueToInterruption = YES;
    if (self.modalViewController) {
       [self.navigationController popToRootViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark - socialManagerDelegate

-(void) onFacebookLoginSuccess {
    [self.dataTable reloadData];
    
}

@end