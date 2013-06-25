//
//  AddressViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressViewController.h"
#import "Constants.h"
#import "ModelContext.h"
#import "BaseDataCell.h"
#import "PlndrPurchaseSession.h"
#import "TitleAndTextFieldMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "Address.h"
#import "SavedAddress.h"
#import "Utility.h"
#import "PopupNotificationViewController.h"
#import "PopupUtil.h"
#import "TitleAndPickerViewDataCell.h"
#import "TitleAndPickerViewMetaData.h"
#import "Country.h"
#import "State.h"
#import "Constants.h"
#import "GANTracker.h"
#import "PlndrAppDelegate.h"

@interface AddressViewController ()

- (void) deleteAddress;
- (void) deleteClicked:(id)sender;

// Address
- (NSString*) getCountryDisplayStringFromPickerIndexArray:(NSArray *)array;
- (NSArray*) getCountryOptions;
- (NSArray *)getCountryNames;

- (NSArray *)getStateNames:(Country *)country;
- (NSString*) getStateStringFromPickerIndexArray:(NSArray *)array display:(BOOL)display;
- (NSArray*) getStateOptionsForCountryIndex:(NSNumber *) countryIndex;
- (void) createCountrySubscription;
- (void) handleCountrySubscriptionError;
- (void) makeCreateSavedAddressSubscription;
- (void) handleCreateSavedAddressSubscriptionError;
- (void) createUpdateSavedAdddressSubscription;
- (void) handleUpdateSavedAddressSubscriptionError;
- (void) createDeleteSavedAdddressSubscription;
- (void) handleDeleteSavedAddressSubscriptionError;
- (BOOL) isAddressDeletable;

@end

@implementation AddressViewController

@synthesize savedAddress = _savedAddress;
@synthesize addressDelegate = _addressDelegate;
@synthesize countrySubscription = _countrySubscription;
@synthesize createSavedAddressSubscription = _createSavedAddressSubscription;
@synthesize updateSavedAddressSubscription = _updateSavedAddressSubscription;
@synthesize deleteSavedAddressSubscription = _deleteSavedAddressSubscription;
@synthesize createErrorPopup = _createErrorPopup;
@synthesize deleteConfirmationPopup = _deleteConfirmationPopup;
@synthesize updateErrorPopup = _updateErrorPopup;
@synthesize deleteErrorPopup = _deleteErrorPopup;


- (id)initWithAddressDelegate:(id<AddressViewControllerDelegate>)addressDelegate {
    self = [super init];
    if (self) {
        self.addressDelegate = addressDelegate;
        self.savedAddress = [[self.addressDelegate getSavedAddress] copy];
        self.title = @"EDIT ADDRESS";
    }
    return self;
}

- (void)dealloc {
    self.addressDelegate = nil;
    [self.countrySubscription cancel];
    [self.createSavedAddressSubscription cancel];
    [self.updateSavedAddressSubscription cancel];
    [self.deleteSavedAddressSubscription cancel];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageEditAddress withError:nil];
    
    [self createCountrySubscription];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [self.countrySubscription cancel];
    self.countrySubscription = nil;
}

#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    switch (indexPath.row) {
        case AddressCellNickname: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.name.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Nickname";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.name;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.name = detail;
            }];
            
            
            ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryNextDismiss;            
            break;
        }
        case AddressCellFirstName: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.firstName.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"First Name";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.firstName;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.firstName = detail;
            }];
            
            break;
        }
        case AddressCellLastName: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.lastName.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Last Name";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.lastName;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.lastName = detail;
            }];
            
            break;
        }
        case AddressCellAttention: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Attention/Company";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.attention;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.attention = detail;
            }];
            
            
            break;
        }
        case AddressCellFirstAddress: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.address1.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Address 1";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.address1;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.address1 =detail;
            }];
            
            break;
        }
        case AddressCellSecondAddress: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Address 2";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.address2;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.address2 = detail;
            }];
            
            break;
        }
        case AddressCellThirdAddress: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Address 3";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.address3;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.address3 = detail;
            }];
            
            break;
        }
        case AddressCellCity: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.city.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"City";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.city;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.city = detail;
            }];
            
            break;
        }
        case AddressCellState: {
            
            cellMetaData = [self getDefaultTitleAndPickerFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.stateIndex != nil : YES;
            
            ((TitleAndPickerViewMetaData*)cellMetaData).cellTitle = @"State";
            ((TitleAndPickerViewMetaData*)cellMetaData).cellDetail = [self getStateStringFromPickerIndexArray:[self.savedAddress.address getCountryAndStateIndexArray] display:YES];
            ((TitleAndPickerViewMetaData*)cellMetaData).hasBeenSelected = self.savedAddress.address.stateIndex != nil;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerDataSources = [self getStateOptionsForCountryIndex:self.savedAddress.address.countryIndex];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerValues = [self.savedAddress.address getStateIndexArray];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerColumnWidths = [NSArray arrayWithObjects:[NSNumber numberWithInt:230], nil];
            
            [(TitleAndPickerViewMetaData*)cellMetaData setWritePickerValuesBlock:^(NSArray * statePickerValue) {
                if (self.savedAddress.address.countryIndex) {
                    self.savedAddress.address.stateIndex = [statePickerValue objectAtIndex:0];
                    self.savedAddress.address.state =[self getStateStringFromPickerIndexArray:[self.savedAddress.address getCountryAndStateIndexArray] display:NO];
                }
            }];
            
            break;
        }
        case AddressCellZipCode: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.postalCode.length > 0 : YES;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Zip Code";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail =self.savedAddress.address.postalCode;
            ((TitleAndTextFieldMetaData*)cellMetaData).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.postalCode = detail;
            }];
            
            break;
        }
        case AddressCellCountry: {
            
            
            cellMetaData = [self getDefaultTitleAndPickerFieldMetaDataAtIndexPath:indexPath];
            cellMetaData.isValid = self.isValidatingData ? self.savedAddress.address.countryIndex != nil : YES;
            
            ((TitleAndPickerViewMetaData*)cellMetaData).cellTitle = @"Country";
            ((TitleAndPickerViewMetaData*)cellMetaData).cellDetail = [self getCountryDisplayStringFromPickerIndexArray: [self.savedAddress.address getCountryIndexArray]];
            ((TitleAndPickerViewMetaData*)cellMetaData).hasBeenSelected = self.savedAddress.address.countryIndex != nil;
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerDataSources = [self getCountryOptions];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerValues = [self.savedAddress.address getCountryIndexArray];
            ((TitleAndPickerViewMetaData*)cellMetaData).pickerColumnWidths = [NSArray arrayWithObjects:[NSNumber numberWithInt:230], nil];
            [(TitleAndPickerViewMetaData*)cellMetaData setWritePickerValuesBlock:^(NSArray * countryPickerValue) {
                if (!self.savedAddress.address.countryIndex || [[countryPickerValue objectAtIndex:0] intValue] != self.savedAddress.address.countryIndex.intValue) {
                    self.savedAddress.address.countryIndex = [countryPickerValue objectAtIndex:0];
                    self.savedAddress.address.stateIndex = [NSNumber numberWithInt:0];
                    self.savedAddress.address.country = [self getCountryDisplayStringFromPickerIndexArray:countryPickerValue];
                    self.savedAddress.address.state =[self getStateStringFromPickerIndexArray:[NSArray arrayWithObjects:self.savedAddress.address.countryIndex, self.savedAddress.address.stateIndex, nil] display:NO];

                    // Reload State to Select One.
                    NSIndexPath *stateIndexPath = [NSIndexPath indexPathForRow:AddressCellState inSection:indexPath.section];
                    [self.dataTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:stateIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];

            break;
        }
        case AddressCellDaytimePhone: {
            cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
            ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Daytime Phone";
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.savedAddress.address.phone;
            ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
            ((TitleAndTextFieldMetaData*)cellMetaData).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                self.savedAddress.address.phone = detail;
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

- (void)deleteAddress {
    [[Utility getFirstResponder] resignFirstResponder];
    [self createDeleteSavedAdddressSubscription];
}

- (void)deleteClicked:(id)sender {
    PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:@"Delete Address" message:@"Delete this address?" buttonOneTitle:@"DELETE" buttonTwoTitle:@"CANCEL"];
    self.deleteConfirmationPopup = popup;
    [PopupUtil presentPopup:popup withDelegate:self];
}

- (void) createCountrySubscription {
    [_countrySubscription cancel]; //Cancel any previously set up subscription
    _countrySubscription = [[CountrySubscription alloc] initWithContext:[ModelContext instance]];
    _countrySubscription.delegate = self;
    [self subscriptionUpdatedState:_countrySubscription];
}

- (void)handleCountrySubscriptionError {    
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.countrySubscription];
    [self displayAPIErrorWithTitle:kAddressErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (void)makeCreateSavedAddressSubscription {
    [_createSavedAddressSubscription cancel]; //Cancel any previously set up subscription
    

    _createSavedAddressSubscription = [[CreateSavedAddressSubscription alloc] initWithAddress:self.savedAddress.address 
                                                                                     withName:self.savedAddress.name 
                                                                                    isPrimary:[self.addressDelegate isPrimaryAddress] 
                                                                                     WithType:[self.addressDelegate getSavedAddressType] withContext:[ModelContext instance]];
    _createSavedAddressSubscription.delegate = self;
    [self subscriptionUpdatedState:_createSavedAddressSubscription];
}

- (void)handleCreateSavedAddressSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.createSavedAddressSubscription];
    [self displayAPIErrorWithTitle:kAddressCreateErrorTitle message:errorStr usingPopup:&popup];
    self.createErrorPopup = popup;
}

- (void)createUpdateSavedAdddressSubscription {
    [_updateSavedAddressSubscription cancel]; //Cancel any previously set up subscription
    
    _updateSavedAddressSubscription = [[UpdateSavedAddressSubscription alloc] initWithSavedAddress:self.savedAddress WithContext:[ModelContext instance]];
    _updateSavedAddressSubscription.delegate = self;
    [self subscriptionUpdatedState:_updateSavedAddressSubscription];
}

- (void)handleUpdateSavedAddressSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.updateSavedAddressSubscription];
    [self displayAPIErrorWithTitle:kAddressUpdateErrorTitle message:errorStr usingPopup:&popup];
    self.updateErrorPopup = popup;
}

- (void)createDeleteSavedAdddressSubscription {
    [_deleteSavedAddressSubscription cancel]; //Cancel any previously set up subscription
    
    _deleteSavedAddressSubscription = [[DeleteSavedAddressSubscription alloc] initWithSavedAddressId:self.savedAddress.addressId withContext:[ModelContext instance]];
    _deleteSavedAddressSubscription.delegate = self;
    [self subscriptionUpdatedState:_deleteSavedAddressSubscription];
}

- (void)handleDeleteSavedAddressSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.deleteSavedAddressSubscription];
    [self displayAPIErrorWithTitle:kAddressDeleteErrorTitle message:errorStr usingPopup:&popup];
    self.deleteErrorPopup = popup;
}

- (BOOL)isAddressDeletable {
    return !(self.savedAddress.isPrimary.boolValue || [self.addressDelegate isNewAddress]);
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if ([self.countrySubscription isEqual:subscription]) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self.savedAddress.address rectifyIndexAndStringStates];
            [self hideLoadingView];
            [self.dataTable reloadData];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            [self handleCountrySubscriptionError];
        } else {
            [self showLoadingView];
        }
    } else if ([self.createSavedAddressSubscription isEqual:subscription] || [self.updateSavedAddressSubscription isEqual:subscription] || [self.deleteSavedAddressSubscription isEqual:subscription]) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self hideLoadingView];
            [self.addressDelegate addressDidChange:self.savedAddress];
            [self dismissModalViewControllerAnimated:YES];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            if ([self.createSavedAddressSubscription isEqual:subscription]) {
                [self handleCreateSavedAddressSubscriptionError];
            } else if ([self.updateSavedAddressSubscription isEqual:subscription]) {
                [self handleUpdateSavedAddressSubscriptionError];
            } else {
                [self handleDeleteSavedAddressSubscriptionError];
            }
            
        } else {
            [self showLoadingView];
        }
    }
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    if (sender == self.defaultErrorPopup) {
        [self dismissModalViewControllerAnimated:YES];
        self.defaultErrorPopup = nil;
    } else if (sender == self.createErrorPopup) {
        self.createErrorPopup = nil;
    } else if (sender == self.updateErrorPopup) {
        self.updateErrorPopup = nil;
    } else if (sender == self.deleteErrorPopup) {
        self.deleteErrorPopup = nil;
    } else {
        self.deleteConfirmationPopup = nil;
    }
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [PopupUtil dismissPopup];
    if (popupViewController == self.defaultErrorPopup || popupViewController == self.createErrorPopup || popupViewController == self.updateErrorPopup || popupViewController == self.deleteErrorPopup) {
        [self dismissPopup:popupViewController];
    } else {
        // Delete
        self.deleteConfirmationPopup = nil;
        [self deleteAddress];
        
    }

}

- (void) popupButtonTwoClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    // Cancel
    [PopupUtil dismissPopup];
}

#pragma mark - BaseModalView Overrides


- (void)saveModalData {
    // Updating an address. Cause a refresh on shipping methods
    [[[ModelContext instance] plndrPurchaseSession] resetShippingMethods];
    
    if ([self.addressDelegate isNewAddress]) {
        [self makeCreateSavedAddressSubscription];
    } else {
        [self createUpdateSavedAdddressSubscription];
    }
}

- (BOOL)canBeVerifiedLocally {
    return NO;
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AddressSectionNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case AddressSectionCell: {
            if (self.countrySubscription.state == SubscriptionStateAvailable) {
                return AddressCellNUM;
            } else {
                return 0;
            }
        }
        case AddressSectionError:
            return 0;
            
        default:
            NSLog(@"WARNING: %@ - got unexpected section %d in numberOfRowsInSection", [self class], section);
            return 0;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case AddressSectionError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case AddressSectionCell:
        default:
            return 0;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case AddressSectionError:
            return self.errorHeader;
        case AddressSectionCell:
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case AddressSectionCell:
            if ([self isAddressDeletable]) {
                return kButtonFooterHeight;
            } 
            // Fallthrough
        default:
            return 0.1f;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case AddressSectionCell: {
            if ([self isAddressDeletable]) {
                UIView *footerView = [[UIView alloc] init];
                
                UIImage *deleteImage = [UIImage imageNamed:@"red_btn.png"];
                UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteButton.frame = CGRectMake((kDeviceWidth - deleteImage.size.width)/2, 20, deleteImage.size.width, deleteImage.size.height);
                [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
                [deleteButton setBackgroundImage:[UIImage imageNamed:@"red_btn_hl.png"] forState:UIControlStateHighlighted];
                [deleteButton setTitle:@"DELETE ADDRESS" forState:UIControlStateNormal];
                [deleteButton setTitleColor:kPlndrWhite forState:UIControlStateNormal];
                deleteButton.titleLabel.font = kFontBoldCond17;
                [deleteButton addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [footerView addSubview:deleteButton];
                
                return footerView;
            }
            // Fallthrough
        }
        default:
            return nil;
    }
    
}

#pragma mark - Picker related

- (NSString*) getCountryDisplayStringFromPickerIndexArray:(NSArray *)array {
    if (array.count == 0) {
        return @"";
    }
    return [[[[[ModelContext instance] plndrPurchaseSession] countries] objectAtIndex:[[array objectAtIndex:0] intValue]] name];
}

- (NSArray*) getCountryOptions {
    return [NSArray arrayWithObject:[self getCountryNames]];
}


- (NSArray *)getCountryNames {
    NSMutableArray *listOfCountries = [NSMutableArray array];
    for (Country *country in [[[ModelContext instance] plndrPurchaseSession] countries]) {
        [listOfCountries addObject:country.name];
    }
    return listOfCountries;
}

- (NSString*) getStateStringFromPickerIndexArray:(NSArray *)array display:(BOOL)display {
    if (array.count == 0) {
        return @"";
    }
    
    int countryIndex = [[array objectAtIndex:0] intValue];
    int stateIndex = [[array objectAtIndex:1] intValue];
    
    Country *country = [[[[ModelContext instance] plndrPurchaseSession] countries] objectAtIndex:countryIndex];
    
    if (display) {
        return [[country.states objectAtIndex:stateIndex] name];  
    } else {
        return [[country.states objectAtIndex:stateIndex] shortName];
    }
    
}

- (NSArray*) getStateOptionsForCountryIndex:(NSNumber *) countryIndex {
    if (!countryIndex) {
        return [NSArray arrayWithObject:[NSArray array]];
    }
    Country *country = [[[[ModelContext instance] plndrPurchaseSession] countries] objectAtIndex: [countryIndex intValue]];
    return [NSArray arrayWithObject:[self getStateNames:country]];
}


- (NSArray *)getStateNames:(Country *)country {
    
    NSMutableArray *listOfStates = [NSMutableArray array];
    for (State *state in country.states) {
        [listOfStates addObject:state.name];
    }
    return listOfStates;
}



@end
