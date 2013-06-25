//
//  ProfileViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "CellMetaData.h"
#import "MultiLinePreviewDataCell.h"
#import "MultiLinePreviewMetaData.h"
#import "Constants.h"
#import "ModelContext.h"
#import "AddressViewController.h"
#import "ManageAddressViewController.h"
#import "LoginSession.h"
#import "SavedAddress.h"
#import "GANTracker.h"

@interface ProfileViewController ()

- (void) pushAddress:(BOOL)isShipping;
- (void) createGetSavedAddressesSubscription;

@end

@implementation ProfileViewController

@synthesize isCurrentlyEditingShippingAddress = _isCurrentlyEditingShippingAddress;
@synthesize getSavedAddressesSubscription = _getSavedAddressesSubscription;
@synthesize addressErrorLabel = _addressErrorLabel;

- (id) init {
    self = [super init];
    if (self) {
        self.title = @"PROFILE";
    }
    return self;
}

- (void)dealloc {
    [self.getSavedAddressesSubscription cancel];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.addressErrorLabel = nil;
    [self.getSavedAddressesSubscription cancel];
    self.getSavedAddressesSubscription = nil;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    int errorLabelWidth = kDeviceWidth - 20;
    int errorLabelHeight = 60;
    self.addressErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - errorLabelWidth)/2, (self.view.bounds.size.height - errorLabelHeight)/2, errorLabelWidth, 60)];
    self.addressErrorLabel.text = kProfileAddressUnavailable;
    self.addressErrorLabel.font = kErrorFontForReplaceingTables;
    self.addressErrorLabel.backgroundColor = [UIColor clearColor];
    self.addressErrorLabel.textAlignment = UITextAlignmentCenter;
    self.addressErrorLabel.textColor = kPlndrMediumGreyTextColor;
    self.addressErrorLabel.numberOfLines = 0;
    self.addressErrorLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createGetSavedAddressesSubscription];
    [self.dataTable reloadData];
    [self.view insertSubview:self.addressErrorLabel aboveSubview:self.dataTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataTable.frame = self.view.frame;
    
    [[GANTracker sharedTracker] trackPageview:kGANPageProfile withError:nil];
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
        case ProfileSectionUser:
            switch (indexPath.row) {
                case ProfileUsernameCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    NSString* username = [[ModelContext instance].loginSession username] ? [[ModelContext instance].loginSession username] : @"";
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [NSArray arrayWithObject:username];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    ((MultiLinePreviewMetaData*)cellMetaData).customAccessoryType = CustomAccessoryTypeNothing;
                    break;
                }
                    
                default:
                    NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
            
        case ProfileSectionShipping:
            switch (indexPath.row) {
                case ProfileShippingAddressInfoCell: {   
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    SavedAddress *savedShippingAddress =[[ModelContext instance].loginSession getShippingSavedAddress];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellTitle = [savedShippingAddress getNameSummary];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [savedShippingAddress.address getSummaryStrings];
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
        case ProfileSectionBilling:
            switch (indexPath.row) {
                case ProfileBillingAddressInfoCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    SavedAddress *savedBillingAddress =[[ModelContext instance].loginSession getBillingSavedAddress];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellTitle = [savedBillingAddress getNameSummary];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellDetail = [savedBillingAddress.address getSummaryStrings];
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
        default:
            NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.section);
            break;
    }
    
    
    return cellMetaData;
}



- (void)pushAddress:(BOOL)isShipping {
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


- (void)createGetSavedAddressesSubscription {
    [_getSavedAddressesSubscription cancel]; //Cancel any previously set up subscription
    _getSavedAddressesSubscription = [[GetSavedAddressesSubscription alloc] initWithContext:[ModelContext instance]];
    _getSavedAddressesSubscription.delegate = self;
    [self subscriptionUpdatedState:_getSavedAddressesSubscription];
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    self.addressErrorLabel.hidden = YES;
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        self.addressErrorLabel.hidden = NO;
        [self handleConnectionError];
    } else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self.dataTable reloadData];
    } else if (subscription == self.getSavedAddressesSubscription && (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable)) {
        [self hideLoadingView];
        self.addressErrorLabel.hidden = NO;
    } else {
        [self showLoadingView];
    }
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.getSavedAddressesSubscription.state == SubscriptionStateAvailable) {
        return ProfileSectionNUM;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kPOTableHeaderHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
        case ProfileSectionUser:
            headerLabel.text = @"USER EMAIL";
            break;
        case ProfileSectionShipping:
            headerLabel.text = @"SHIPPING ADDRESS";
            break;
        case ProfileSectionBilling:
            headerLabel.text = @"BILLING ADDRESS";
            break;
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

#pragma mark - ManageAddressViewControllerDelegate

- (BOOL) doesSupportSameAs {
    return NO;
}

- (BOOL)isCheckout {
    return NO;
}

- (NSString *)navTitle {
    if (self.isCurrentlyEditingShippingAddress) {
        return @"SHIPPING ADDRESS";        
    } else {
        return @"BILLING ADDRESS";
    }
    
}

- (int)getSelectedAddressIndex {
    if (self.isCurrentlyEditingShippingAddress) {
        return [[ModelContext instance] loginSession].defaultShippingAddressIndex;
    } else {
        return [[ModelContext instance] loginSession].defaultBillingAddressIndex;
    }
}

- (int) getShippingAddressIndex {
    return  [[[ModelContext instance] loginSession] defaultShippingAddressIndex];
}

- (SavedAddressTypes)typeOfAddress {
    return [self getSavedAddressType];
}

#pragma mark - AddressViewControllerDelegate
// The following methods are only called when there are no exisiting addresses stored.

-(SavedAddress *)getSavedAddress {
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
        return kAddressDefaultShippingError;
    } else {
        return kAddressDefaultBillingError;
    }
}

- (void) addressDidChange:(SavedAddress*)newSavedAddress {
    // Do nothing - everything is looked after by the API
}

@end
