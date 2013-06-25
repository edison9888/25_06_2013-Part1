//
//  DiscountViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscountViewController.h"
#import "Constants.h"
#import "DiscountCode.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "TextEntryDataCell.h"
#import "TextEntryMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "TitleAndTextFieldMetaData.h"
#import "Utility.h"
#import "DiscountCode.h"
#import "AppliedDiscountCode.h"
#import "CheckoutError.h"
#import "CheckoutSummary.h"
#import "PopupUtil.h"
#import "GANTracker.h"
#import "NavigationControlManager.h"
#import "PlndrAppDelegate.h"

@interface DiscountViewController ()

- (void) createCheckoutSummarySubscription;
- (void) handleDiscountSubscriptionError;

@end

@implementation DiscountViewController

@synthesize promoCode = _promoCode;
@synthesize repCode = _repCode;
@synthesize giftCodes = _giftCodes;
@synthesize checkoutSummarySubscription = _checkoutSummarySubscription;
@synthesize mostImportantError = _mostImportantError;
@synthesize checkoutErrorPopup = _checkoutErrorPopup;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"DISCOUNTS";
        AppliedDiscountCode *appliedDiscount = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getPromoCode];
        if (appliedDiscount) {
            self.promoCode = [[DiscountCode alloc] initWithAppliedDiscountCode:appliedDiscount];
        } else {
            self.promoCode = [[DiscountCode alloc] initWithType:PromoCode];
        }
        
        appliedDiscount = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getRepCode];
        if (appliedDiscount){
            self.repCode = [[DiscountCode alloc] initWithAppliedDiscountCode:appliedDiscount];
        } else {
            self.repCode = [[DiscountCode alloc] initWithType:RepCode];
        }
        
        NSArray *appliedDiscountCodes = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getGiftCertificates];
        self.giftCodes = [[NSMutableArray alloc] init];
        for (int i = 0; i < appliedDiscountCodes.count; i++){
            DiscountCode *giftCode = [[DiscountCode alloc] initWithAppliedDiscountCode:[appliedDiscountCodes objectAtIndex:i]];
            [self.giftCodes addObject:giftCode];
        }
    }
    return self;
}

- (void)dealloc {
    [self.checkoutSummarySubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Nope. Nothing here
    
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[GANTracker sharedTracker] trackPageview:kGANPageDiscounts withError:nil];
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
        case DiscountSectionPromotions:
            switch (indexPath.row) {
                case DiscountPromotionPromoCell: {
                    cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
                    cellMetaData.isValid = self.isValidatingData ?
                    ![CheckoutError isThereFirstCheckoutErrorForAffectedAreaType:checkoutErrorPromoCodeArea inCheckoutErrors:[[ModelContext instance] plndrPurchaseSession].intermediateCheckoutErrors] : YES;
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Promo";
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.promoCode.name;
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
                    [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                        self.promoCode.name = detail;
                    }];
                                                                     
                    ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryDismiss;
                                                                     
                    break;
                }
                case DiscountPromotionRepCell: {
                    cellMetaData = [self getDefaultTitleAndTextFieldMetaDataAtIndexPath:indexPath];
                    cellMetaData.isValid = self.isValidatingData ? 
                    ![CheckoutError isThereFirstCheckoutErrorForAffectedAreaType:checkoutErrorRepCodeArea inCheckoutErrors:[[ModelContext instance] plndrPurchaseSession].intermediateCheckoutErrors] : YES;
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellTitle = @"Rep";
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellDetail = self.repCode.name;
                    ((TitleAndTextFieldMetaData*)cellMetaData).cellDetailGhost = kOptional;
                    [(TitleAndTextFieldMetaData*)cellMetaData setWriteDetailBlock: ^(NSString *detail) {
                        self.repCode.name = detail;
                    }];
                    
                    ((TitleAndTextFieldMetaData*)cellMetaData).inputAccessoryViewType = InputAccessoryDismiss;
                    
                    
                    break;
                }                                           
                default:
                NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
            
        case DiscountSectionGiftCertificates:{
            cellMetaData = [self getDefaultTextEntryMetaDataAtIndexPath:indexPath];
            int numOfRowsInSection = [self tableView:self.dataTable numberOfRowsInSection:indexPath.section];
            if (indexPath.row < numOfRowsInSection - 1){
                ((TextEntryMetaData*) cellMetaData).cellData = ((DiscountCode*)[self.giftCodes objectAtIndex:indexPath.row]).name;
            } else {
                [cellMetaData setDidBecomeFirstResponderBlock:^(void) {                    
                    [self.dataTable beginUpdates];
                    DiscountCode *giftCode = [[DiscountCode alloc] initWithType:GiftCode];
                    [self.giftCodes addObject:giftCode];
                    [self.dataTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.dataTable endUpdates];
                }];
            }
            [cellMetaData setPerformNextAction:^(void) {
                [[Utility getFirstResponder] resignFirstResponder];
            }]; 
            ((TextEntryMetaData*) cellMetaData).cellPlaceholder = @"Add More";
            [((TextEntryMetaData*) cellMetaData) setWriteDataBlock:^(NSString *data) {
                if (data.length > 0) {
                    ((DiscountCode*)[self.giftCodes objectAtIndex:indexPath.row]).name = data;
                } else {
                    // Delete the current cell
                    [self.dataTable beginUpdates];
                    [self.giftCodes removeObjectAtIndex:indexPath.row];
                    [self.dataTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.dataTable endUpdates];
                }
                
            }];
            
            cellMetaData.inputAccessoryViewType = InputAccessoryDismiss;
            
            break;
        }
        default:
            break;
    }
    return cellMetaData;
}


- (void) createCheckoutSummarySubscription {
    
    [_checkoutSummarySubscription cancel]; //Cancel any previously set up subscription
    
    NSMutableArray *discounts = [NSMutableArray array];
    if (self.promoCode.name.length > 0) { 
        [discounts addObject:self.promoCode];
    }
    if (self.repCode.name.length > 0) {
        [discounts addObject:self.repCode];
    }
    
    for (DiscountCode *giftCode in self.giftCodes ) {
        if (giftCode.name.length > 0) {
            [discounts addObject:giftCode];
        }
    }
    
    _checkoutSummarySubscription = [[CheckoutSummarySubscription alloc] initWithDiscounts:discounts
                                                                          shippingDetails:nil  
                                                                 isIntermediateValidation:YES 
                                                                              withContext:[ModelContext instance]];
    _checkoutSummarySubscription.delegate = self;
    [self subscriptionUpdatedState:_checkoutSummarySubscription];
}

- (void) handleDiscountSubscriptionError {
    NSString *errorTitle = kDiscountErrorTitle;
    BOOL areThereCheckoutErrors = [[ModelContext instance].plndrPurchaseSession.checkoutErrors count] > 0;
    if (areThereCheckoutErrors) {
        [self setFlagForCartItemForViewController:self];
    }
    // Look for any discount errors first, then just take the fist error
    NSArray *intermediaCheckoutErrors = [[ModelContext instance] plndrPurchaseSession].intermediateCheckoutErrors;
    if (intermediaCheckoutErrors.count == 0) {
        self.mostImportantError = nil;
    } else {
        self.mostImportantError = [CheckoutError getFirstCheckoutErrorForAffectedAreaType:checkoutErrorPromoCodeArea inCheckoutErrors:intermediaCheckoutErrors];
        
        if (!self.mostImportantError) {
            self.mostImportantError = [CheckoutError getFirstCheckoutErrorForAffectedAreaType:checkoutErrorRepCodeArea inCheckoutErrors:intermediaCheckoutErrors];
        }
        if (!self.mostImportantError) {
            self.mostImportantError = [CheckoutError getFirstCheckoutErrorForAffectedAreaType:checkoutErrorGiftCodeArea inCheckoutErrors:intermediaCheckoutErrors];
        }
        if (!self.mostImportantError) {
            self.mostImportantError = [intermediaCheckoutErrors objectAtIndex:0];
            errorTitle = kCheckoutErrorTitle;
        }
    }
    
    PopupViewController *popup;
    NSString *errorStr;
    NSString *popupButtonTitle = nil;
    if (self.mostImportantError) {
        errorStr = self.mostImportantError.generalMessage;
        
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

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    }else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    }  else if (subscription.state == SubscriptionStateAvailable) {
        [subscription cancel];
        [self hideLoadingView];
        [self saveModalData];
        [self dismissModalViewControllerAnimated:YES];

    } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [self hideLoadingView];
        [self handleDiscountSubscriptionError];
        
    } else { // Pending
        [self showLoadingView];
    }
}


#pragma mark - BaseModalView Overrides

- (void)doneButtonPressed {
    [[Utility getFirstResponder] resignFirstResponder];
    
    [self showLoadingView];
    [self createCheckoutSummarySubscription];
}
- (void)saveModalData {    
    [[ModelContext instance] plndrPurchaseSession].checkoutSummary = [[ModelContext instance] plndrPurchaseSession].intermediateCheckoutSummary;
}

- (BOOL)canBeVerifiedLocally {
    return NO;
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
    [self dismissPopup:popupViewController];
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

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return DiscountSectionNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DiscountSectionError:
            return 0;
        case DiscountSectionPromotions:
            return DiscountPromotionsNUM;
            
        case DiscountSectionGiftCertificates:
        {
            int count = self.giftCodes.count + 1; // One extra for the empty row
            return count;
        }
            
        default:
            NSLog(@"WARNING: %@ - got unexpected section %d in numberOfRowsInSection", [self class], section);
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case DiscountSectionError:
            return self.errorHeader ? self.errorHeader.frame.size.height : 0.1f;
        case DiscountSectionPromotions:
        case DiscountSectionGiftCertificates:
        default:
            return kPOTableHeaderHeight;
    }

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
        case DiscountSectionError:
            return self.errorHeader;
        case DiscountSectionPromotions:
            headerLabel.text = @"Promotions";
            break;
        case DiscountSectionGiftCertificates:
            headerLabel.text = @"Gift Certificates";
            break;
    }
    [headerView addSubview:headerLabel];
    return headerView;
}




@end
