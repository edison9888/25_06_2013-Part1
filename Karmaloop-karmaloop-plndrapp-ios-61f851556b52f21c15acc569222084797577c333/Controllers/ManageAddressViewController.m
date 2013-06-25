//
//  ManageAddressViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "MultiLinePreviewDataCell.h"
#import "MultiLinePreviewMetaData.h"
#import "MultiLinePreviewAndCheckboxDataCell.h"
#import "MultiLinePreviewAndCheckboxMetaData.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "SavedAddress.h"
#import "Address.h"
#import "LoginSession.h"
#import "Constants.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "GANTracker.h"
#import "Utility.h"

@interface ManageAddressViewController ()

- (void) pushAddressAtIndexPath:(NSIndexPath*)indexPath;
- (int) heightOfSameAsSection;
- (void) topAreaButtonClicked:(id)sender;
- (void) updateSameAsSectionViewState;
- (void) createGetSavedAddressesSubscription;
- (void) handleGetSavedAddressesSubscriptionErrors;
- (void) createUpdateSavedAdddressSubscription;
- (void) handleUpdateSavedAddressSubscriptionError;
- (void) matchSelectedIndexToNewAddressListRespectingSameAs:(BOOL)doesRespectSameAs;

@end

@implementation ManageAddressViewController

@synthesize currentSelectedAddressIndex = _currentSelectedAddressIndex;
@synthesize manageDelegate = _manageDelegate;
@synthesize currentEditingAddressIndex = _currentEditingAddressIndex;
@synthesize topAreaButton = _topAreaButton;
@synthesize getSavedAddressesSubscription = _getSavedAddressesSubscription;
@synthesize updateSavedAddressSubscription = _updateSavedAddressSubscription;
@synthesize updateErrorPopup = _updateErrorPopup;
@synthesize recentlyUpdatedSavedAddress = _recentlyUpdatedSavedAddress;

- (id)initWithManageDelegate:(id<ManageAddressViewControllerDelegate>)manageDelegate {
    self = [super init];
    if (self) {
        self.manageDelegate = manageDelegate;
        self.errorHeaderMessage = [self.manageDelegate getErrorHeaderMessage];
        self.title = [self.manageDelegate navTitle];
    }
    return self;
}

- (void)dealloc {
    self.manageDelegate = nil;
    [self.getSavedAddressesSubscription cancel];
    [self.updateSavedAddressSubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.topAreaButton = nil;
    
    [self.getSavedAddressesSubscription cancel];
    self.getSavedAddressesSubscription = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    if ([self.manageDelegate doesSupportSameAs]) {
        self.topAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.topAreaButton.frame = CGRectMake(0, 0, kDeviceWidth, [self heightOfSameAsSection]);
        [self.topAreaButton setTitle:@"Same as Shipping Address" forState:UIControlStateNormal];
        self.topAreaButton.titleLabel.font = kFontMediumCond17;
        [self.topAreaButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
        [self.topAreaButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [self.topAreaButton setImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        [self.topAreaButton setImage:[UIImage imageNamed:@"check_box_on.png"] forState:UIControlStateSelected];
        [self.topAreaButton setImage:[UIImage imageNamed:@"check_box_on.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [self.topAreaButton setImageEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 0)];
        [self.topAreaButton addTarget:self action:@selector(topAreaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        self.topAreaButton.selected = [self.manageDelegate isSameAsShippingAddress];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataTable reloadData];
    [self createGetSavedAddressesSubscription];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:kGANPageManageAddress withError:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    switch (indexPath.section) {
        case ManageAddressSectionCell: {
            switch (indexPath.row) {
                case ManageAddressAddMoreCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellTitle = [NSArray arrayWithObjects:@"Add New", nil];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushAddressAtIndexPath:indexPath]; 
                    }];
                    cellMetaData.inputAccessoryViewType = InputAccessoryNone;
                    ((MultiLinePreviewMetaData*)cellMetaData).customAccessoryType = CustomAccessoryTypePlus;
                }
                    break;
                    
                case ManageAddressAddressCell: 
                default:{
                    cellMetaData = [self getDefaultMultiLinePreviewAndCheckboxMetaDataAtIndexPath:indexPath];
                    SavedAddress *savedAddress = (SavedAddress*)[[[[ModelContext instance] loginSession] addresses] objectAtIndex:indexPath.row - 1];
                    ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).cellTitle = [savedAddress getNameSummary];
                    ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).cellDetail = [savedAddress.address getSummaryStrings];
                    ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushAddressAtIndexPath:indexPath];
                    }];
                    [(MultiLinePreviewAndCheckboxMetaData*)cellMetaData setClickedCheckbox:^(void) {
                        self.currentSelectedAddressIndex =indexPath.row - 1;
                        [self.dataTable reloadData];
                    }];
                    ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).isChecked = self.currentSelectedAddressIndex == indexPath.row - 1;
                    cellMetaData.inputAccessoryViewType = InputAccessoryNone;
                }
                    break;
            }
            
            cellMetaData.isRowEnabled = !self.topAreaButton.selected;
        }
            break;
            
        default:
            NSLog(@"Other Type of Cells");
            break;
    }
    return cellMetaData;
}

- (void)pushAddressAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.currentEditingAddressIndex = -1;
    } else {
        self.currentEditingAddressIndex = indexPath.row - 1;
    }
    AddressViewController *newAddressViewController = [[AddressViewController alloc] initWithAddressDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newAddressViewController];
    [self presentModalViewController:navController animated:YES];
}

- (int)heightOfSameAsSection {
    return [self.manageDelegate doesSupportSameAs] ? 50 : 0.1f;
}

- (void) updateSameAsSectionViewState {
    if (self.topAreaButton.selected) {
        // Need to grab the Shipping Index incase the current index has changed.
        [self matchSelectedIndexToNewAddressListRespectingSameAs:YES];
    }
    [self.dataTable reloadData];
}

- (void)matchSelectedIndexToNewAddressListRespectingSameAs:(BOOL)shouldRespectSameAs {
    if (!shouldRespectSameAs && self.recentlyUpdatedSavedAddress && [self.manageDelegate isCheckout]) {
        
        NSArray *addresses = [[[ModelContext instance] loginSession] addresses];
        for (SavedAddress *savedAddress in addresses) {
            if ([savedAddress.address isEqual:self.recentlyUpdatedSavedAddress.address]) {
                self.currentSelectedAddressIndex = [addresses indexOfObject:savedAddress];
                break;
            }
        }
    } else {
        SEL indexSelector = shouldRespectSameAs ? @selector(getShippingAddressIndex) : @selector(getSelectedAddressIndex);
        
        if ([self.manageDelegate respondsToSelector:indexSelector]) {
            if (shouldRespectSameAs) {
                self.currentSelectedAddressIndex = [self.manageDelegate getShippingAddressIndex];
            } else {
                self.currentSelectedAddressIndex = [self.manageDelegate getSelectedAddressIndex];
            }
        } else {
            int selectedAddressIndex = -1;
            Address *selectedAddress;
            if (shouldRespectSameAs) {
                selectedAddress = [self.manageDelegate getShippingAddress];
            } else {
                selectedAddress = [self.manageDelegate getSelectedAddress];
            }
            NSArray *addresses = [[[ModelContext instance] loginSession] addresses];
            for (int i = 0; i < addresses.count; i++) {
                SavedAddress* savedAddress = [addresses objectAtIndex:i];
                if ([savedAddress.address isEqual:selectedAddress]) {
                    selectedAddressIndex = i;
                    break;
                }
            }
            self.currentSelectedAddressIndex = selectedAddressIndex;
        }
    }
}

- (void)topAreaButtonClicked:(id)sender {
    self.topAreaButton.selected = !self.topAreaButton.selected;
    [self updateSameAsSectionViewState];

}

- (void)createGetSavedAddressesSubscription {
    [_getSavedAddressesSubscription cancel]; //Cancel any previously set up subscription
    _getSavedAddressesSubscription = [[GetSavedAddressesSubscription alloc] initWithContext:[ModelContext instance]];
    _getSavedAddressesSubscription.delegate = self;
    [self subscriptionUpdatedState:_getSavedAddressesSubscription];
}

- (void)handleGetSavedAddressesSubscriptionErrors {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.getSavedAddressesSubscription];
    [self displayAPIErrorWithTitle:kAddressErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (void)createUpdateSavedAdddressSubscription {
    [_updateSavedAddressSubscription cancel]; //Cancel any previously set up subscription
    
    NSArray *savedAddresses = [[[ModelContext instance] loginSession] addresses];
    SavedAddress *newPrimary = [[savedAddresses objectAtIndex:self.currentSelectedAddressIndex] copy];
    newPrimary.isPrimary = [NSNumber numberWithBool:YES];
    NSString *type = [SavedAddress getSavedAddressTypeString:[self.manageDelegate typeOfAddress]];
    newPrimary.typeOfPrimary = type;
     
    _updateSavedAddressSubscription = [[UpdateSavedAddressSubscription alloc] initWithSavedAddress:newPrimary WithContext:[ModelContext instance]];
    _updateSavedAddressSubscription.delegate = self;
    [self subscriptionUpdatedState:_updateSavedAddressSubscription];
}

- (void)handleUpdateSavedAddressSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.updateSavedAddressSubscription];
    [self displayAPIErrorWithTitle:kAddressUpdateErrorTitle message:errorStr usingPopup:&popup];
    self.updateErrorPopup = popup;
}

#pragma mark - BaseModalView Overrides

- (BOOL)isModalDataValid {
    return self.currentSelectedAddressIndex >= 0;
}

- (BOOL)canBeVerifiedLocally {
    return NO;
}

- (void)saveModalData {
    if ([self.manageDelegate isCheckout]) {      
        NSArray *addresses = [[[ModelContext instance] loginSession] addresses];
        SavedAddress *selectedAddress = [addresses objectAtIndex:self.currentSelectedAddressIndex];
        [self.manageDelegate saveSelectedAddress:selectedAddress];
        
        if ([self.manageDelegate doesSupportSameAs]) {
            [self.manageDelegate saveSameAsShippingAddress:self.topAreaButton.selected];
        }
        
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self createUpdateSavedAdddressSubscription];
    }
    
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ManageAddressSectionNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ManageAddressSectionError:
            return 0;
        case ManageAddressSectionSameAs:
            return 0;
        case ManageAddressSectionCell: {
            NSArray *addresses = [[[ModelContext instance] loginSession] addresses];
            return addresses.count + 1; // One extra for the Add row cell            
        }
        default:
            return 0;
    }

}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    if ([cellMetaData respondsToSelector:@selector(cellHeight)]) {
        return [((NSNumber*)[cellMetaData performSelector:@selector(cellHeight)]) intValue];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case ManageAddressSectionError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case ManageAddressSectionSameAs:
            return [self heightOfSameAsSection];
        case ManageAddressSectionCell: {
            return 0.5f;
        }
        default:
            return 0.1f;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case ManageAddressSectionError:
            return self.errorHeader;
        case ManageAddressSectionSameAs:
            return self.topAreaButton;
        case ManageAddressSectionCell:
        default:
            return nil;
    }
}

#pragma mark - AddressViewControllerDelegate

-(SavedAddress *)getSavedAddress {
    if (self.currentEditingAddressIndex >= 0) {
        return [[[[ModelContext instance] loginSession] addresses] objectAtIndex:self.currentEditingAddressIndex];
    } else {
        return [[SavedAddress alloc] init];
    }
}

- (BOOL) isNewAddress {
    return self.currentEditingAddressIndex < 0;
}

- (NSNumber *)isPrimaryAddress {
    if ([self isNewAddress]) {
        return [NSNumber numberWithBool:NO];
    }
    
    SavedAddress *editingAddress = [[[ModelContext instance] loginSession].addresses objectAtIndex:self.currentEditingAddressIndex];
    return editingAddress.isPrimary;
}

- (SavedAddressTypes)getSavedAddressType {
    return [self.manageDelegate typeOfAddress];
}

- (void) addressDidChange:(SavedAddress*)newSavedAddress {
    self.recentlyUpdatedSavedAddress = newSavedAddress;
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    }  else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    }  else if (subscription == self.getSavedAddressesSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self hideLoadingView];
            
            [self matchSelectedIndexToNewAddressListRespectingSameAs:NO];
            [self updateSameAsSectionViewState];
            
            [self.dataTable reloadData];
            
            // If we have successfully made an update, then we need to
            // record the new primary, and dismiss
            if (self.updateSavedAddressSubscription.state == SubscriptionStateAvailable) {
                [self dismissModalViewControllerAnimated:YES];
            }
            
        } else if (subscription == self.getSavedAddressesSubscription && (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable)) {
            [self hideLoadingView];
            [self handleGetSavedAddressesSubscriptionErrors];
        } else {
            [self showLoadingView];
        }
    } else {
        if (subscription.state == SubscriptionStateAvailable) {
            [self hideLoadingView];
            [self createGetSavedAddressesSubscription];
            
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            [self handleUpdateSavedAddressSubscriptionError];
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
    } else {
        self.updateErrorPopup = nil;
    }
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:sender];
}



@end
