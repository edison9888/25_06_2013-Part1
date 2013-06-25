//
//  ChangePasswordViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CellMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "TitleAndTextFieldMetaData.h"
#import "Constants.h"
#import "ModelContext.h"
#import "SignupSession.h"
#import "PopupUtil.h"
#import "PopupNotificationViewController.h"
#import "Utility.h"
#import "GANTracker.h"
#import "Constants.h"

@interface ChangePasswordViewController ()

- (void)submitButtonPressed:(id)sender;
- (void)updateSubmitButtonEnabledState;
- (void)changePasswordWasSuccessful;
- (void)showError:(NSString *)errorMessage;
- (void) createChangePasswordSubscription;
- (void) handleChangePasswordSubscriptionError;
@end

@implementation ChangePasswordViewController

@synthesize confirmPassword = _confirmPassword;
@synthesize oldPassword = _oldPassword;
@synthesize neuePassword = _neuePassword;
@synthesize submitButton = _submitButton;
@synthesize successPopup = _successPopup;

@synthesize changePasswordSubscription = _changePasswordSubscription;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"CHANGE PASSWORD";
    }
    return self;
}

- (void) dealloc {
    [self.changePasswordSubscription cancel];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageChangePassword withError:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self.changePasswordSubscription cancel];
    self.changePasswordSubscription = nil;
}


#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    
    switch (indexPath.row) {
        case ChangePasswordCellOldPassword: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Old Password";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.oldPassword;
            ((TitleAndTextFieldMetaData*)cellMetaData).isSecure = YES;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.oldPassword = detail;
            }];

            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryNextDismiss;
            
            break;
        }
        case ChangePasswordCellNewPassword: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"New Password";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.neuePassword;
            ((TitleAndTextFieldMetaData*)cellMetaData).isSecure = YES;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.neuePassword = detail;
            }];
            
            break;
        }
        case ChangePasswordCellConfirmPassword: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Confirm Password";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.confirmPassword;
            ((TitleAndTextFieldMetaData*)cellMetaData).isSecure = YES;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.confirmPassword = detail;
            }];

            
            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryPreviousDismiss;
            [((TitleAndTextFieldMetaData*)cellMetaData) setPerformNextAction:^(void) {
                [self submitButtonPressed:self];
            }];

            break;
        }
            
        default:
            NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
            break;
    }
    return cellMetaData;
}

- (void)submitButtonPressed:(id)sender {
    [[Utility getFirstResponder] resignFirstResponder];
    
    
    if (!(self.oldPassword.length > 0 && self.neuePassword.length > 0 && self.confirmPassword.length > 0)) {
        [self showError:@"Please fill out all the fields."];
    } else if ([self.neuePassword isEqualToString:self.confirmPassword]) {
        [self showLoadingView];
        [self createChangePasswordSubscription];
    } else {
        [self showError:@"Confirm Password must match the New Password."];
    } 
}

- (void) changePasswordWasSuccessful {
    [self hideLoadingView];
    self.successPopup = [[PopupNotificationViewController alloc] initWithTitle:kChangePasswordSuccessTitle message:kChangePasswordSuccessMessage];
    [PopupUtil presentPopup:self.successPopup withDelegate:self];
}

- (void)handleChangePasswordSubscriptionError {
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.changePasswordSubscription];
    [self showError:errorStr];
}

- (void) showError:(NSString *)errorMessage{
    [self hideLoadingView];
    
    PopupViewController *popup;
    [self displayAPIErrorWithTitle:kChangePasswordErrorTitle message:errorMessage usingPopup:&popup];
    popup = self.defaultErrorPopup;
}

- (void) updateSubmitButtonEnabledState {
    self.submitButton.enabled = (self.oldPassword.length > 0) && (self.neuePassword.length > 0) && (self.confirmPassword.length > 0);
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kButtonFooterHeight;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    
    UIImage *submitImage = [UIImage imageNamed:@"yellow_btn.png"];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake((kDeviceWidth - submitImage.size.width)/2, 20, submitImage.size.width, submitImage.size.height);
    [self.submitButton setBackgroundImage:submitImage forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
    [self.submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    [self.submitButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
    self.submitButton.titleLabel.font = kFontBoldCond17;
    [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self updateSubmitButtonEnabledState];
    
    [footerView addSubview:self.submitButton];
    
    return footerView;
}

#pragma mark - PopupViewControllerDelegate

- (void)dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    
    if (sender == self.successPopup) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - PlndrBaseViewController Override

- (CGRect)loadingViewFrame {
    return CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - self.navigationController.navigationBar.frame.size.height);
}

- (UIColor*) loadingViewBackgroundColor {
    return kPlndrTransparencyColor;
}

- (void) createChangePasswordSubscription {
    [_changePasswordSubscription cancel]; //Cancel any previously set up subscription
    _changePasswordSubscription = [[PasswordChangeSubscription alloc] initWithOldPassword:self.oldPassword neuePassword:self.neuePassword confirmPassword:self.confirmPassword context:[ModelContext instance]];
    _changePasswordSubscription.delegate = self;
    [self subscriptionUpdatedState:_changePasswordSubscription];
}

#pragma mark - TitleAndTextFieldDataCellDelegate (Overrides)

- (void) setDetailString:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    [super setDetailString:detailString forTitleAndTextFieldDataCell:sender];
    [self updateSubmitButtonEnabledState];
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    }else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } 
    else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self changePasswordWasSuccessful];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleChangePasswordSubscriptionError];
    } else  { //Pending
        [self showLoadingView];
    }
    
}

@end
