//
//  SignupViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignupViewController.h"
#import "CellMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "TitleAndTextFieldMetaData.h"
#import "TitleAndPickerViewMetaData.h"
#import "TitleAndPickerViewDataCell.h"
#import "Constants.h"
#import "ModelContext.h"
#import "SignupSession.h"
#import "Utility.h"
#import "SignupSubscription.h"
#import "PopupNotificationViewController.h"
#import "PopupUtil.h"
#import "GANTracker.h"

@interface SignupViewController ()

- (void)signupButtonPressed:(id)sender;
- (void)createSignUpSubscription;
- (void)signupSucceeded;
- (void)handleSignupSubscriptionError;
- (void)initValues;

@end

@implementation SignupViewController

@synthesize signupSubscription = _signupSubscription;
@synthesize signupDelegate = _signupDelegate;
@synthesize genderPickerValue = _genderPickerValue;

- (id)initWithSignupDelegate:(id<SignupViewControllerDelegate>)signupDelegate {
    self = [super init];
    if (self) {
        self.title = @"SIGNUP";
        self.signupDelegate = signupDelegate;
        [self initValues];
    }
    return self;

}

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"SIGNUP";
        [self initValues];
    }
    return self;
}

- (void)dealloc {
    self.signupDelegate = nil;
    [self.signupSubscription cancel];
}

- (void) loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageSignup withError:nil];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    //Nothing to do
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.signupDelegate signupModalDidDisappear];
    
}

- (void)setupNavBar {
    // Setup the left nav button
    UIButton *leftBtn = [PlndrBaseViewController createNavBarButtonWithText:@"CANCEL"];
    [leftBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];   
}

- (void)initValues {
    self.genderPickerValue = nil;
}

#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    SignupSession *signupSession = [[ModelContext instance] signupSession];
    CellMetaData *cellMetaData;

    switch (indexPath.row) {
        case SignupCellFirstName: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? signupSession.firstName.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"First Name";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = signupSession.firstName;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                [[[ModelContext instance] signupSession] setFirstName:detail];
            }];
            
           ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryNextDismiss;
            break;
        }
        case SignupCellLastName: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? signupSession.lastName.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Last Name";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = signupSession.lastName;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                [[[ModelContext instance] signupSession] setLastName:detail];
            }];
            
            
            break;
        }
        case SignupCellGender: {
            cellMetaData = [self getDefaultTitleAndPickerFieldMetaDataAtIndexPath:indexPath];
            BOOL hasGenderBeenSelected = self.genderPickerValue.count > 0;
            cellMetaData.isValid = self.isValidatingData ? hasGenderBeenSelected : YES;
            ((TitleAndPickerViewMetaData*)cellMetaData).cellTitle = @"Gender";
            ((TitleAndPickerViewMetaData*)cellMetaData).cellDetail = [[[ModelContext instance] signupSession] getGenderDisplayString];
            ((TitleAndPickerViewMetaData*)cellMetaData).hasBeenSelected = hasGenderBeenSelected;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerDataSources = [[[ModelContext instance] signupSession] getGenderOptions];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerValues = hasGenderBeenSelected ? [[[ModelContext instance] signupSession] getGenderIndexArray] : nil;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerColumnWidths = [NSArray arrayWithObjects:[NSNumber numberWithInt:230], nil];
            
            [(TitleAndPickerViewMetaData*)cellMetaData setWritePickerValuesBlock:^(NSArray * genderPickerValue) {
                self.genderPickerValue = genderPickerValue;
                [[[ModelContext instance] signupSession] setGenderIndexFromArray:genderPickerValue];
            }];
     
            break;
        }
        case SignupCellEmail: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? signupSession.email.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Email";
            ((TitleAndTextFieldMetaData*)cellMetaData).keyboardType = UIKeyboardTypeEmailAddress;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = signupSession.email;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                [[[ModelContext instance] signupSession] setEmail:detail];
            }];
            

            break;
        }
        case SignupCellPassword: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? signupSession.password.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Password";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = signupSession.password;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                [[[ModelContext instance] signupSession] setPassword:detail];
            }];
            
            ((TitleAndTextFieldMetaData*)cellMetaData).isSecure = YES;
            break;
        }
        case SignupCellConfirmPassword: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? signupSession.confirmPassword.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Confirm Password";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = signupSession.confirmPassword;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                [[[ModelContext instance] signupSession] setConfirmPassword:detail];
            }];

            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryPreviousDismiss;
            [((TitleAndTextFieldMetaData*)cellMetaData) setPerformNextAction:^(void) {
                [self signupButtonPressed:self];
            }];
            ((TitleAndTextFieldMetaData*)cellMetaData).isSecure = YES;
            
            break;
        }
            
        default:
            NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
            break;
    }
    return cellMetaData;
}

- (void)cancelButtonPressed {
	[ModelContext instance].signupSession = nil;
	[super cancelButtonPressed];
}

- (void)signupButtonPressed:(id)sender {
    [[Utility getFirstResponder] resignFirstResponder];
	if (![self isModalDataValid]) {
        [self showDataErrors];
        [self.dataTable reloadData];
        return;
    }
    else {
        [self resetErrorHeader];
		[self createSignUpSubscription];
    }
}


- (void)signupSucceeded {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createSignUpSubscription {
    [_signupSubscription cancel]; //Cancel any previously setup subscription
    SignupSession *signupSession = [[ModelContext instance] signupSession];
    _signupSubscription = [[SignUpSubscription alloc] initWithEmail:signupSession.email
                                                       withPassword:signupSession.password
                                                withConfirmPassword:signupSession.confirmPassword
                                                      withFirstName:signupSession.firstName
                                                       withLastName:signupSession.lastName
                                                        withContext:[ModelContext instance]];
    _signupSubscription.delegate = self;
    [self subscriptionUpdatedState:_signupSubscription];
}

- (void)handleSignupSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.signupSubscription];
    [self displayAPIErrorWithTitle:kSignUpErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (BOOL)isDataViewValid {
	SignupSession *signupSession = [[ModelContext instance] signupSession];
	return  [signupSession isSignupSessionComplete] && self.genderPickerValue.count > 0;
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self signupSucceeded];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleSignupSubscriptionError];
    } else  { //Pending
        [self showLoadingView];
    }
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SignupSectionNUM;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SignupSectionCell:
			return SignupCellNUM;
		case SignupSectionError:
		default:
			return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SignupSectionError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case SignupSectionCell:
        default:
            return 0;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SignupSectionError:
            return self.errorHeader;
        case SignupSectionCell:
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case SignupSectionCell:
			return kButtonFooterHeight;
		case SignupSectionError:
		default:
			return 0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	switch (section) {
		case SignupSectionCell: {
			UIView *footerView = [[UIView alloc] init];
			
			UIImage *signupImage = [UIImage imageNamed:@"yellow_btn.png"];
			UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
			signupButton.frame = CGRectMake((kDeviceWidth - signupImage.size.width)/2, 20, signupImage.size.width, signupImage.size.height);
			[signupButton setBackgroundImage:signupImage forState:UIControlStateNormal];
			[signupButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
			[signupButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
			[signupButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
			signupButton.titleLabel.font = kFontBoldCond17;
			[signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			[footerView addSubview:signupButton];
			
			return footerView;
		}
		case SignupSectionError:
		default:
			return nil;
	}
    
}

@end
