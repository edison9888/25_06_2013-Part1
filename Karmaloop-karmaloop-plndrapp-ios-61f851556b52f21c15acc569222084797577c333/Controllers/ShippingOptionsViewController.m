//
//  ShippingOptionsViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShippingOptionsViewController.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "CellMetaData.h"
#import "TitleAndCheckboxMetaData.h"
#import "TitleAndCheckboxDataCell.h"
#import "ShippingMethod.h"
#import "ShippingOption.h"
#import "Constants.h"
#import "Utility.h"
#import "ShippingDetails.h"
#import "ShippingMethod.h"
#import "CheckoutError.h"
#import "CheckoutSummary.h"
#import "PopupUtil.h"
#import "GANTracker.h"
#import "NavigationControlManager.h"
#import "PlndrAppDelegate.h"

@interface ShippingOptionsViewController ()

- (void) createCheckoutSummarySubscription;
- (void) handleCheckoutSummarySubscriptionError;
- (BOOL) isShippingMethodsIndexValid;

@end

@implementation ShippingOptionsViewController

@synthesize shippingMethods = _shippingMethods;
@synthesize currentShippingMethodIndex = _currentShippingMethodIndex;
@synthesize checkoutSummarySubscription = _checkoutSummarySubscription;
@synthesize checkoutErrorPopup = _checkoutErrorPopup;
@synthesize mostImportantError = _mostImportantError;
@synthesize emptyErrorLabel = _emptyErrorLabel;

- (id)init {
    self = [super init];
    if (self) {
        _shippingMethods = [[NSArray alloc] initWithArray:[[ModelContext instance] plndrPurchaseSession].shippingMethods copyItems:YES];
        _currentShippingMethodIndex = [[[ModelContext instance] plndrPurchaseSession] shippingMethodsSelectedIndex];
        self.title = @"SHIPPING OPTIONS";
    }
    return self;
}

- (void)dealloc {
    [self.checkoutSummarySubscription cancel];
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.emptyErrorLabel = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int emptyLabelHeight = 60;
    self.emptyErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, emptyLabelHeight)];
    self.emptyErrorLabel.text = kShippingOptionsEmptyMessage;
    self.emptyErrorLabel.backgroundColor = [UIColor clearColor];
    self.emptyErrorLabel.textColor = kPlndrMediumGreyTextColor;
    self.emptyErrorLabel.font = kErrorFontForReplaceingTables;
    self.emptyErrorLabel.textAlignment = UITextAlignmentCenter;
    self.emptyErrorLabel.numberOfLines = 0;
    [self.view addSubview:self.emptyErrorLabel];
    self.emptyErrorLabel.hidden = YES;
    
    [[GANTracker sharedTracker] trackPageview:kGANPageShippingOptions withError:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.dataTable numberOfRowsInSection:0] == 0) {
        self.emptyErrorLabel.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.emptyErrorLabel.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    TitleAndCheckboxMetaData *cellMetaData = [self getDefaultTitleAndCheckboxMetaDataAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case ShippingOptionsSectionMethod: {
            ShippingMethod *shippingMethod = [self.shippingMethods objectAtIndex:indexPath.row];
            
            cellMetaData.cellTitle = [NSString stringWithFormat:@"%@: ($%0.02f)", shippingMethod.name, [shippingMethod.cost floatValue]];
            cellMetaData.isChecked = self.currentShippingMethodIndex == indexPath.row;
            [cellMetaData setDidSelectBlock:^(void) {
                self.currentShippingMethodIndex = indexPath.row;
                [self.dataTable reloadData];
            }];
        }
        break;
        case ShippingOptionsSectionOption: {
            ShippingOption *shippingOption = [((ShippingMethod*)[self.shippingMethods objectAtIndex:self.currentShippingMethodIndex]).shippingOptions objectAtIndex:indexPath.row];
            
            cellMetaData.cellTitle = [NSString stringWithFormat:@"%@: (+$%0.02f)", shippingOption.name, [shippingOption.cost floatValue]];
            cellMetaData.isChecked = [shippingOption.isSelected boolValue];
            [cellMetaData setDidSelectBlock:^(void) {
                shippingOption.isSelected = [NSNumber numberWithBool:![shippingOption.isSelected boolValue]];
                [self.dataTable reloadData];
            }];
        }
        break;
            
            
        default:
            break;
    }
    
        
    return cellMetaData;
}

- (void) createCheckoutSummarySubscription {
    [_checkoutSummarySubscription cancel]; //Cancel any previously set up subscription
    ShippingDetails *shippingDetails = [[[ModelContext instance] plndrPurchaseSession] getShippingDetails];
    ShippingMethod *shippingMethod = [self.shippingMethods objectAtIndex:self.currentShippingMethodIndex];
    shippingDetails.method = shippingMethod.shippingMethodValue;
    shippingDetails.options = [shippingMethod getSelectedOptions];
    _checkoutSummarySubscription = [[CheckoutSummarySubscription alloc] initWithDiscounts:nil
                                                                          shippingDetails:shippingDetails  
                                                                 isIntermediateValidation:YES 
                                                                              withContext:[ModelContext instance]];
    _checkoutSummarySubscription.delegate = self;
    [self subscriptionUpdatedState:_checkoutSummarySubscription];
}

- (void) handleCheckoutSummarySubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = nil;
    NSString *errorTitle = kCheckoutErrorTitle;
    NSString *popupButtonTitle = nil;
    BOOL areThereCheckoutErrors = [[ModelContext instance].plndrPurchaseSession.checkoutErrors count] > 0;
    if (areThereCheckoutErrors) {
        [self setFlagForCartItemForViewController:self];
    }
    NSArray *intermediaCheckoutErrors = [[ModelContext instance] plndrPurchaseSession].intermediateCheckoutErrors;
    self.mostImportantError = [CheckoutError getFirstCheckoutErrorForAffectedAreaType:checkoutErrorShippingArea inCheckoutErrors:intermediaCheckoutErrors];
    
    if (!self.mostImportantError) {
        self.mostImportantError = [intermediaCheckoutErrors objectAtIndex:0];
    }
    
    if(self.mostImportantError) {
        errorStr =  self.mostImportantError.generalMessage;
        XLCheckoutErrorResolution checkoutErrorResolution = [self.mostImportantError getCheckoutErrorResolution];
        if ([NavigationControlManager shouldErrorResolution:checkoutErrorResolution resultInNavigationFromController:self]) {
            popupButtonTitle = kCheckoutErrorButtonGoThere;
        }
        [self displayAPIErrorWithTitle:errorTitle message:errorStr buttonTitle:popupButtonTitle usingPopup:&popup];
        self.checkoutErrorPopup = popup;
    } else {
        errorStr = [Utility getDefaultErrorStringFromSubscription:self.checkoutSummarySubscription];
        [self displayAPIErrorWithTitle:errorTitle message:errorStr usingPopup:&popup];
        self.defaultErrorPopup = popup;
    }
}

- (BOOL)isShippingMethodsIndexValid {
    return self.shippingMethods.count > 0 && !(self.currentShippingMethodIndex < 0 || self.currentShippingMethodIndex >= self.shippingMethods.count);
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
        [self saveModalData];
        [self dismissModalViewControllerAnimated:YES];
    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleCheckoutSummarySubscriptionError];
    } else { // Pending
        [self showLoadingView];
    }
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    // pop to my cart if this error was fatal
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else {
        // otherwise do nothing 
        self.checkoutErrorPopup = nil;
        self.mostImportantError = nil;
    } 
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [PopupUtil dismissPopup];
    // pop to cart if this error was fatal
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else {
        // Otherwise, let the NavigationControlManager handle it
        XLCheckoutErrorResolution checkoutErrorResolution = [self.mostImportantError getCheckoutErrorResolution];
        [[NavigationControlManager instance] setErrorType:checkoutErrorResolution forViewController:self];
        self.checkoutErrorPopup = nil;
        self.mostImportantError = nil;
    } 
}
#pragma mark - BaseModalView Overrides

- (void)doneButtonPressed {
    [[Utility getFirstResponder] resignFirstResponder];
    
    if (![self isModalDataValid]) {
        [self showDataErrors];
        [self.dataTable reloadData];
        return;
    }
    [self showLoadingView];
    [self createCheckoutSummarySubscription];
}

- (void)saveModalData {
    
    [[ModelContext instance] plndrPurchaseSession].checkoutSummary = [[ModelContext instance] plndrPurchaseSession].intermediateCheckoutSummary;
    [[[ModelContext instance] plndrPurchaseSession] setShippingMethods:self.shippingMethods]; // Required to save the selected shipping options
    [[[ModelContext instance] plndrPurchaseSession] setShippingMethodsSelectedIndex:self.currentShippingMethodIndex];
}

- (BOOL)canBeVerifiedLocally {
    return NO;
}

#pragma mark - UITableViewDataSource/Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ShippingOptionsSectionMethod:
        {
            return self.shippingMethods.count;
        }
        case ShippingOptionsSectionOption:
            if ([self isShippingMethodsIndexValid]) {
                return ((ShippingMethod*)[self.shippingMethods objectAtIndex:self.currentShippingMethodIndex]).shippingOptions.count;
            }
        default:
            NSLog(@"WARNING: ShippingOptionsViewController got unexpect section %d", section);
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kPOTableHeaderHeight;
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
        case ShippingOptionsSectionMethod:
            if (self.shippingMethods.count > 0) {
                headerLabel.text = @"SHIPPING METHODS";
            }
            break;
        case ShippingOptionsSectionOption:
            if ([self isShippingMethodsIndexValid] && ((ShippingMethod*)[self.shippingMethods objectAtIndex:self.currentShippingMethodIndex]).shippingOptions.count > 0) {
                headerLabel.text = @"EXTRAS";
            }
            else {
                return nil;
            }
            break;
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

@end
