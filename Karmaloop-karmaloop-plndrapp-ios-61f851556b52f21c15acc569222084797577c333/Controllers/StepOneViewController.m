//
//  StepOneViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StepOneViewController.h"
#import "CellMetaData.h"
#import "MultiLinePreviewDataCell.h"
#import "MultiLinePreviewMetaData.h"
#import "Constants.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "CreditCardViewController.h"
#import "AddressViewController.h"
#import "ManageAddressViewController.h"
#import "LoginSession.h"
#import "SavedAddress.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "GANTracker.h"
#import "Utility.h"
#import "ConnectionErrorViewController.h"
#import "MyCartViewController.h"

@interface StepOneViewController ()

- (void) createGetSavedAddressesSubscription;
- (void) handleGetSavedAddressesSubscriptionErrors;
@end

@implementation StepOneViewController

@synthesize isCurrentlyEditingShippingAddress = _isCurrentlyEditingShippingAddress;
@synthesize getSavedAddressesSubscription = _getSavedAddressesSubscription;

- (void)dealloc {
    [self.getSavedAddressesSubscription cancel];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.getSavedAddressesSubscription cancel];
    self.getSavedAddressesSubscription = nil;
}

- (void) loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kNavBarFrame.size.height - kTabBarHeight - kCheckoutStepButtonHeight)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createGetSavedAddressesSubscription];
    if([self stepIsComplete]) {
        [self resetErrorHeader];
    }
    [self.dataTable reloadData];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageCheckoutStep1 withError:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataTable.frame = self.view.frame;
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
        case CheckoutStepOneSectionsError: {
            return nil;
            break;
        }
        case CheckoutStepOneSectionCreditCard:
            switch (indexPath.row) {
                case CheckoutCreditCardInfoCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    cellMetaData.isValid = self.isValidatingData ? [[[ModelContext instance] plndrPurchaseSession] isPaymentOptionsComplete] : YES;
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [[ModelContext instance].plndrPurchaseSession getCreditCardSummaryStrings];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushCreditCard]; 
                    }];
                    break;
                }
                    
                default:
                    NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
            
        case CheckoutStepOneSectionBilling:
            switch (indexPath.row) {
                case CheckoutBillingAddressInfoCell: {   
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    cellMetaData.isValid = self.isValidatingData ? [[[ModelContext instance] plndrPurchaseSession] getPurchaseBillingAddress] != nil : YES;
                    ((MultiLinePreviewMetaData*)cellMetaData).cellTitle = [[ModelContext instance].plndrPurchaseSession isBillingAddressSameAsShippingAddress] ? [NSArray arrayWithObject:@"Same as Shipping Address"] : nil;
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [[[ModelContext instance].plndrPurchaseSession getPurchaseBillingAddress] getSummaryStrings];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushAddress:NO]; 
                    }];
                    break;
                }
                    
                default:                    
                    NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
        case CheckoutStepOneSectionShipping:
            switch (indexPath.row) {
                case CheckoutShippingAddressInfoCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    cellMetaData.isValid = self.isValidatingData ? [[[ModelContext instance] plndrPurchaseSession] getPurchaseShippingAddress] != nil : YES;
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [[[ModelContext instance].plndrPurchaseSession getPurchaseShippingAddress] getSummaryStrings];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushAddress:YES]; 
                    }];
                    break;
                }
                    
                default:
                    NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
        default:
            NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.section);
            break;
    }
    
    
    return cellMetaData;
}

- (void)pushCreditCard {
    CreditCardViewController *creditCardViewController = [[CreditCardViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:creditCardViewController];
    [self presentModalViewController:navController animated:YES];
}

- (void) pushAddress:(BOOL) isShipping {
    self.isCurrentlyEditingShippingAddress = isShipping;
    UIViewController *addressViewController;
    if ([[[[ModelContext instance] loginSession] addresses] count] > 0) {
        addressViewController = [[ManageAddressViewController alloc] initWithManageDelegate:self];
    } else {
        addressViewController = [[AddressViewController alloc] initWithAddressDelegate:self];
    }

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addressViewController];
    [self presentModalViewController:navController animated:YES];
}

- (void) createGetSavedAddressesSubscription {
    [_getSavedAddressesSubscription cancel]; //Cancel any previously set up subscription
    _getSavedAddressesSubscription = [[GetSavedAddressesSubscription alloc] initWithContext:[ModelContext instance]];
    _getSavedAddressesSubscription.delegate = self;
    [self subscriptionUpdatedState:_getSavedAddressesSubscription];
}

- (void)handleGetSavedAddressesSubscriptionErrors {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.getSavedAddressesSubscription];
    [self displayAPIErrorWithTitle:kCheckoutErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (void)handleConnectionError {
    self.isPresentingConnectionErrorPopup = YES;
    MyCartViewController *myCartVC = ((MyCartViewController*)[self.navigationController.viewControllers objectAtIndex:0]);
    if (self.hasViewAppeared) {
        [myCartVC handleConnectionError:self];
    }
}

- (BOOL)isDataViewValid {
    return [self stepIsComplete];
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:sender];
}

#pragma mark - CheckoutViewControllerDelegate

- (BOOL) stepIsComplete {
    NSArray *creditCardSummary = [[[ModelContext instance] plndrPurchaseSession] getCreditCardSummaryStrings];
    NSArray *shippingAddressSummary = [[[[ModelContext instance] plndrPurchaseSession] getPurchaseShippingAddress] getSummaryStrings];
    NSArray *billingAddressSummary = [[[[ModelContext instance] plndrPurchaseSession] getPurchaseBillingAddress] getSummaryStrings];
    return ((creditCardSummary.count > 0) && (shippingAddressSummary.count > 0) && (billingAddressSummary.count > 0));
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CheckoutStepOneSectionNUM;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CheckoutStepOneSectionsError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case AddressSectionCell:
        default:
            return kPOTableHeaderHeight;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CheckoutStepOneSectionsError:
            return 0;
        case CheckoutStepOneSectionCreditCard:
        case CheckoutStepOneSectionShipping:
        case CheckoutStepOneSectionBilling:
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    if ([cellMetaData respondsToSelector:@selector(cellHeight)]) {
        return [((NSNumber*)[cellMetaData performSelector:@selector(cellHeight)]) intValue];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kPOTableHeaderHeight)];
    
    int headerViewVerticalOffset = 10;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, headerViewVerticalOffset, kDeviceWidth, kPOTableHeaderHeight - headerViewVerticalOffset)];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = kPlndrMediumGreyTextColor;
    headerLabel.font = kFontMediumCond17;
    switch (section) {
        case AddressSectionError:
            return self.errorHeader;
        case CheckoutStepOneSectionCreditCard:
            headerLabel.text = @"CREDIT CARD";
            break;
        case CheckoutStepOneSectionBilling:
            headerLabel.text = @"BILLING ADDRESS";
            break;
        case CheckoutStepOneSectionShipping:
            headerLabel.text = @"SHIPPING ADDRESS";
            break;
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

#pragma mark - ManageAddressViewControllerDelegate

- (BOOL)doesSupportSameAs {
    return !self.isCurrentlyEditingShippingAddress;
}

- (BOOL)isCheckout {
    return YES;
}

- (NSString *)navTitle {
    if (self.isCurrentlyEditingShippingAddress) {
        return @"SHIPPING ADDRESS";        
    } else {
        return @"BILLING ADDRESS";
    }

}

- (void)saveSelectedAddress:(SavedAddress*)address {
    if (self.isCurrentlyEditingShippingAddress) {
        [[[ModelContext instance] plndrPurchaseSession] resetShippingMethods];
        [[ModelContext instance] plndrPurchaseSession].purchaseShippingAddress = address.address;
    } else {
        [[ModelContext instance] plndrPurchaseSession].purchaseBillingAddress = address.address;
    }
}

- (Address*)getSelectedAddress {
    if (self.isCurrentlyEditingShippingAddress || [self isSameAsShippingAddress]) {
        return [[ModelContext instance] plndrPurchaseSession].purchaseShippingAddress;
    } else {
        return [[ModelContext instance] plndrPurchaseSession].purchaseBillingAddress;
    }
}

- (Address*) getShippingAddress {
    return  [[[ModelContext instance] plndrPurchaseSession] purchaseShippingAddress];
}

- (BOOL)isSameAsShippingAddress {
    return [[[ModelContext instance] plndrPurchaseSession] isBillingAddressSameAsShippingAddress];
}


- (void)saveSameAsShippingAddress:(BOOL)isSame {
    [[[ModelContext instance] plndrPurchaseSession] setIsBillingAddressSameAsShippingAddress:isSame];
}

- (SavedAddressTypes)typeOfAddress {
    return [self getSavedAddressType];
}

#pragma mark - AddressViewControllerDelegate
// The following methods are only called when there are no exisiting addresses stored.

- (SavedAddress *)getSavedAddress {
    return [[SavedAddress alloc] init];
}

- (BOOL) isNewAddress {
    return YES;
}

- (NSNumber *)isPrimaryAddress {
    return [NSNumber numberWithBool:YES];
}

- (SavedAddressTypes)getSavedAddressType {
    if (self.isCurrentlyEditingShippingAddress) {
        return SavedAddressShipping;
    } else {
        return SavedAddressBilling;
    }
}


- (NSString *)getErrorHeaderMessage {
    if (self.isCurrentlyEditingShippingAddress) {
        return kAddressPurchaseShippingError;
    } else {
        return kAddressPurchaseBillingError;
    }
}

- (void) addressDidChange:(SavedAddress*)newSavedAddress {
    // Do nothing - everything is looked after by the API
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self.dataTable reloadData];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleGetSavedAddressesSubscriptionErrors];
    } else { // Pending
        [self showLoadingView];
    }
}


@end
