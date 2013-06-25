//
//  CreditCardViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreditCardViewController.h"
#import "Constants.h"
#import "ModelContext.h"
#import "BaseDataCell.h"
#import "PlndrPurchaseSession.h"
#import "TitleAndTextFieldMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "TitleAndPickerViewMetaData.h"
#import "TitleAndPickerViewDataCell.h"
#import "Utility.h"
#import "GANTracker.h"
#import "PopupUtil.h"


@interface CreditCardViewController ()

- (void) createGetCreditCardOptionSubscription;
- (void) handleGetCreditCardOptionSubscriptionError;

@end

@implementation CreditCardViewController

@synthesize creditCardPickerValue = _creditCardPickerValue;
@synthesize creditCardName = _creditCardName;
@synthesize creditCardNumber = _creditCardNumber;
@synthesize creditCardExpiry = _creditCardExpiry;
@synthesize creditCardCVV = _creditCardCVV;
@synthesize getCreditCardOptionSubscription = _getCreditCardOptionSubscription;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"CREDIT CARD";
        self.creditCardPickerValue = nil;
        self.creditCardExpiry = nil;
        
    }
    return self;
}

- (void)dealloc {
    [self.getCreditCardOptionSubscription cancel];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self.getCreditCardOptionSubscription cancel];
    self.getCreditCardOptionSubscription = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageCreditCard withError:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createGetCreditCardOptionSubscription];
}

#pragma mark - private

- (CellMetaData*) getCellMetaDataForIndexPath:(NSIndexPath*)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    switch (indexPath.row) {
        case CCCellType: {
            cellMetaData = [self getDefaultTitleAndPickerFieldMetaDataAtIndexPath:indexPath];
            BOOL hasCreditCardTypeBeenSelected = self.creditCardPickerValue.count > 0;
            cellMetaData.isValid = self.isValidatingData ? hasCreditCardTypeBeenSelected : YES;
            
            ((TitleAndPickerViewMetaData*)cellMetaData).cellTitle = @"Card Type";
            ((TitleAndPickerViewMetaData*)cellMetaData).cellDetail = [[[ModelContext instance] plndrPurchaseSession] getCreditCardDisplayStringFromPickerIndexArray:self.creditCardPickerValue];
            ((TitleAndPickerViewMetaData*)cellMetaData).hasBeenSelected = hasCreditCardTypeBeenSelected;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerDataSources = [[[ModelContext instance] plndrPurchaseSession] getCreditCardOptions];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerValues = hasCreditCardTypeBeenSelected ? self.creditCardPickerValue : nil;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerColumnWidths = [NSArray arrayWithObjects:[NSNumber numberWithInt:230], nil];
            [(TitleAndPickerViewMetaData*)cellMetaData setWritePickerValuesBlock:^(NSArray * creditCardPickerValue) {
                self.creditCardPickerValue = creditCardPickerValue;
            }];
            
            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryNextDismiss;
            
            
            break;
        }
        case CCCellName: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            
            cellMetaData.isValid = self.isValidatingData ? self.creditCardName.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Name on Card";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.creditCardName;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.creditCardName = detail;
            }];
            break;
            
        }  
        case CCCellNumber: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];

            cellMetaData.isValid = self.isValidatingData ? [[[ModelContext instance] plndrPurchaseSession] isCreditCardNumberValid:self.creditCardNumber] : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Card Number";
            ((TitleAndTextFieldMetaData*)cellMetaData).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.creditCardNumber;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.creditCardNumber = detail;
            }];

            break;
            
        }
        case CCCellExpiry: {
            cellMetaData = [self getDefaultTitleAndPickerFieldMetaDataAtIndexPath:indexPath];
            BOOL hasCreditCardExpiryBeenSelected = self.creditCardExpiry.count > 0;
            cellMetaData.isValid = self.isValidatingData ? hasCreditCardExpiryBeenSelected : YES;
            
            ((TitleAndPickerViewMetaData*)cellMetaData).cellTitle = @"Expiry Date";
            ((TitleAndPickerViewMetaData*)cellMetaData).cellDetail = [[[ModelContext instance] plndrPurchaseSession] getExpiryStringFromMonthAndYearIndexesArray:self.creditCardExpiry];
            ((TitleAndPickerViewMetaData*)cellMetaData).hasBeenSelected =hasCreditCardExpiryBeenSelected;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerDataSources = [[[ModelContext instance] plndrPurchaseSession] getExpiryOptions];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerValues = hasCreditCardExpiryBeenSelected ? self.creditCardExpiry : nil;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerColumnWidths = [NSArray arrayWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:100], nil];
            [(TitleAndPickerViewMetaData*)cellMetaData setWritePickerValuesBlock:^(NSArray * monthAndYear) {
                self.creditCardExpiry = monthAndYear;
            }];

            break;
            
        }
        case CCCellCVV: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            
            cellMetaData.isValid = self.isValidatingData ? [[[ModelContext instance] plndrPurchaseSession] isCreditCardCVVValid:self.creditCardCVV] : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"CVV";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.creditCardCVV;
            ((TitleAndTextFieldMetaData*)cellMetaData).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.creditCardCVV = detail;
            }];

            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryPreviousDismiss;
            [((TitleAndTextFieldMetaData*)cellMetaData) setPerformNextAction:^(void) {
                [[Utility getFirstResponder] resignFirstResponder];
            }];            
            break;
        }
        default:
            NSLog(@"WARNING: %@ getCellMetaDataForIndexPath couldn't create metaData for indexPath %@", [self class], indexPath);
    }
    return cellMetaData;
}

- (void)createGetCreditCardOptionSubscription {
    [_getCreditCardOptionSubscription cancel]; //Cancel any previously set up subscription
    _getCreditCardOptionSubscription = [[GetCreditCardOptionSubscription alloc] initWithContext:[ModelContext instance]];
    _getCreditCardOptionSubscription.delegate = self;
    [self subscriptionUpdatedState:_getCreditCardOptionSubscription];
}

- (void)handleGetCreditCardOptionSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.getCreditCardOptionSubscription];
    [self displayAPIErrorWithTitle:kCreditCardErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}


#pragma mark - BaseModalView Overrides

- (void)saveModalData {
    [[[ModelContext instance] plndrPurchaseSession] setCreditCardIndexFromArray:self.creditCardPickerValue];
    [[[ModelContext instance] plndrPurchaseSession] setNameOnCard:self.creditCardName];
    [[[ModelContext instance] plndrPurchaseSession] setCreditCardNumber:self.creditCardNumber];
    [[[ModelContext instance] plndrPurchaseSession] setExpiryMonthAndYearIndexes:self.creditCardExpiry];
    [[[ModelContext instance] plndrPurchaseSession] setCreditCardCVV:self.creditCardCVV];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CCSectionNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CCSectionCell: {
            return CCCellNUM;
        }
        case CCSectionError:
            return 0;
            
        default:
            NSLog(@"WARNING: %@ - got unexpected section %d in numberOfRowsInSection", [self class], section);
            return 0;
            
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CCSectionError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case CCSectionCell:
        default:
            return 0;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CCSectionError:
            return self.errorHeader;
        case CCSectionCell:
        default:
            return nil;
    }
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self.dataTable reloadData];
    }else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    }
    else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleGetCreditCardOptionSubscriptionError];
    } else { //Pending
        [self showLoadingView];
    }
}


#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:sender];
    
}


@end
