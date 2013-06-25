//
//  StepTwoViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StepTwoViewController.h"
#import "CellMetaData.h"
#import "MultiLinePreviewDataCell.h"
#import "MultilinePreviewMetaData.h"
#import "Constants.h"
#import "ShippingOptionsViewController.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "DetailAndDisclosureDataCell.h"
#import "DetailAndDisclosureMetaData.h"
#import "HorizontalTableView.h"
#import "CheckoutSummaryHorizontalTableViewCell.h"
#import "DiscountViewController.h"
#import "AppliedDiscountCode.h"
#import "Utility.h"
#import "CheckoutSummary.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "GANTracker.h"
#import "NavigationControlManager.h"
#import "CheckoutViewController.h"
#import "ConnectionErrorViewController.h"

@interface StepTwoViewController ()


- (void) buyButtonPressed:(id)sender;
- (void) relayoutSummaryView;
- (UILabel*) getDefaultSummaryLabelWithText:(NSString*) text withTextAlignment:(UITextAlignment) alignment;
- (NSArray*) addDefaultSummaryLabelPairWithLeftText:(NSString*) leftText withRightText:(NSString*) rightText withY:(int)y;
- (int) addDiscountSummaryLabelWithLeftTitle:(NSString*) leftText withRightAmount:(NSString*) rightAmount withY:(int)y;
- (void) createShippingMethodsSubscription;
- (void) createCheckoutSummarySubscription;
- (void) handleSubscriptionError:(RequestSubscription*)subscription;
- (PopupViewController *)displayErrorFromSubscription:(RequestSubscription *)subscription errorString:(NSString *)errorString buttonTitle:(NSString *)buttonTitle;
- (NSString *)getErrorStringForFirstCheckoutError;
- (NSString *)getPopupButtonTitleForFirstCheckoutError;

@end

@implementation StepTwoViewController

@synthesize checkoutDelegate = _checkoutDelegate;
@synthesize scrollContainer = _scrollContainer;
@synthesize summaryViewContainer = _summaryViewContainer;
@synthesize summaryBackgroundView = _summaryBackgroundView;
@synthesize numberOfItemsLabel = _numberOfItemsLabel;
@synthesize summaryDynamicViews = _summaryDynamicViews;
@synthesize subtotalAmountLabel = _subtotalAmountLabel;
@synthesize shippingAmountLabel = _shippingAmountLabel;
@synthesize handlingAmountLabel = _handlingAmountLabel;
@synthesize summarySecondRule = _discountInitialLabelOffset;
@synthesize summaryHorizontalTableView = _summaryHorizontalTableView;
@synthesize shippingMethodsSubscription = _shippingMethodsSubscription;
@synthesize checkoutSummarySubscription = _checkoutSummarySubscription;
@synthesize checkoutErrorPopup = _checkoutErrorPopup;
@synthesize checkoutOptionsErrorPopup = _checkoutOptionsErrorPopup;
@synthesize footerButton = _footerButton;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.summaryDynamicViews = [[NSMutableArray alloc] init];
        self.errorHeaderMessage = kStepTwoErrorHeader;
    }
    return self;
}

- (void)dealloc {
    self.checkoutDelegate = nil;
    self.summaryHorizontalTableView.delegate = nil;
    self.summaryHorizontalTableView.dataSource = nil;
    [self.shippingMethodsSubscription cancel];
    [self.checkoutSummarySubscription cancel];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.checkoutDelegate = nil;
    self.scrollContainer = nil;
    self.summaryViewContainer = nil;
    self.summaryBackgroundView = nil;
    self.numberOfItemsLabel = nil;
    self.summaryHorizontalTableView.delegate = nil;
    self.summaryHorizontalTableView.dataSource = nil;
    self.summaryHorizontalTableView = nil;
    self.subtotalAmountLabel = nil;
    self.shippingAmountLabel = nil;
    self.handlingAmountLabel = nil;
    self.summarySecondRule = nil;
    self.summaryDynamicViews = nil;
    self.footerButton = nil;

    [self.shippingMethodsSubscription cancel];
    self.shippingMethodsSubscription = nil;
    [self.checkoutSummarySubscription cancel];
    self.checkoutSummarySubscription = nil;
}

- (void) loadView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kNavBarFrame.size.height - kTabBarHeight - kCheckoutStepButtonHeight)];
    
    self.scrollContainer = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollContainer];
    
    int summaryViewContainerWidth = 305;
    self.summaryViewContainer = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth - summaryViewContainerWidth)/2, 0, summaryViewContainerWidth, 0)];
    
    UIImage *resizableWhiteImage = [[UIImage imageNamed:@"white_panel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kSummaryBackgroundImageCap, kSummaryBackgroundImageCap, kSummaryBackgroundImageCap, kSummaryBackgroundImageCap)];
    self.summaryBackgroundView = [[UIImageView alloc] initWithImage:resizableWhiteImage];
    [self.summaryViewContainer addSubview:self.summaryBackgroundView];
    [self.scrollContainer addSubview:self.summaryViewContainer];
    
    NSString* summaryTitle = @"ORDER SUMMARY";
    UIFont *summaryTitleFont = kFontBoldCond16;
    CGSize summaryTitleSize = [summaryTitle sizeWithFont:summaryTitleFont constrainedToSize:kSummaryItemSizeConstraint lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *summaryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSummaryHorizontalLabelMargin, kSummaryVerticalMargin, summaryTitleSize.width, summaryTitleSize.height)];
    summaryTitleLabel.text = summaryTitle;
    summaryTitleLabel.textColor = kPlndrBlack;
    summaryTitleLabel.font = summaryTitleFont;
    summaryTitleLabel.backgroundColor = [UIColor clearColor];
    [self.summaryViewContainer addSubview:summaryTitleLabel];
    
    int numberOfItems = [[ModelContext instance] getNumberOfItemsInCart];
    NSString *numberOfItemsString = [NSString stringWithFormat:@"%d Item%@", numberOfItems, numberOfItems == 1 ? @"" : @"s"];
    UIFont *numberOfItemsFont = kFontMedium15;
    CGSize numberOfItemsSize = [numberOfItemsString sizeWithFont:numberOfItemsFont constrainedToSize:kSummaryItemSizeConstraint lineBreakMode:UILineBreakModeTailTruncation];
    
    int numberOfItemsLabelX = summaryTitleLabel.frame.origin.x + summaryTitleLabel.frame.size.width + kSummaryHorizontalLabelMargin;
    self.numberOfItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberOfItemsLabelX, summaryTitleLabel.frame.origin.y, self.summaryViewContainer.frame.size.width - numberOfItemsLabelX - kSummaryHorizontalLabelMargin, numberOfItemsSize.height)];
    self.numberOfItemsLabel.textAlignment = UITextAlignmentRight;
    self.numberOfItemsLabel.textColor = kPlndrBlack;
    self.numberOfItemsLabel.font = numberOfItemsFont;
    self.numberOfItemsLabel.text = numberOfItemsString;
    self.numberOfItemsLabel.backgroundColor = [UIColor clearColor];
    [self.summaryViewContainer addSubview:self.numberOfItemsLabel];
    
    
    self.summaryHorizontalTableView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(kSummaryHorizontalMargin, summaryTitleLabel.frame.origin.y + summaryTitleLabel.frame.size.height + kSummaryVerticalMargin/2, self.summaryViewContainer.frame.size.width - 2*kSummaryHorizontalMargin, kSummaryHorizontalCellHeight) style:UITableViewStylePlain];
    self.summaryHorizontalTableView.backgroundColor = [UIColor clearColor];
    self.summaryHorizontalTableView.delegate = self;
    self.summaryHorizontalTableView.dataSource = self;
    self.summaryHorizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.summaryViewContainer addSubview:self.summaryHorizontalTableView];
    
    
    UIView *ruleView = [[UIView alloc] initWithFrame:CGRectMake(kSummaryHorizontalMargin, self.summaryHorizontalTableView.frame.origin.y + self.summaryHorizontalTableView.frame.size.height, self.summaryViewContainer.frame.size.width - 2*kSummaryHorizontalMargin, 1)];
    ruleView.backgroundColor = kPurchaseSummarySeparatorGrey;
    [self.summaryViewContainer addSubview:ruleView];
    
    NSString *subtotalTitle = @"Items Subtotal";
    NSString *subtotalAmount = @"-"; // Something non-empty. Will never be displayed.
    NSArray *subtotalSummaryLabelPair = [self addDefaultSummaryLabelPairWithLeftText:subtotalTitle withRightText:subtotalAmount withY:(ruleView.frame.origin.y + ruleView.frame.size.height) + kSummaryVerticalMargin];
    self.subtotalAmountLabel = [subtotalSummaryLabelPair objectAtIndex:1];
        
    NSString *shippingTitle = @"Shipping";
    NSString *shippingAmount = @"-";
    NSArray *shippingSummaryLabelPair = [self addDefaultSummaryLabelPairWithLeftText:shippingTitle withRightText:shippingAmount withY:(self.subtotalAmountLabel.frame.origin.y + self.subtotalAmountLabel.frame.size.height + kSummaryVerticalMargin)];
    self.shippingAmountLabel = [shippingSummaryLabelPair objectAtIndex:1];

    NSString *handlingTitle = @"Handling";
    NSString *handlingAmount = @"-";
    NSArray *handlingSummaryLabelPair = [self addDefaultSummaryLabelPairWithLeftText:handlingTitle withRightText:handlingAmount withY: (self.shippingAmountLabel.frame.origin.y + self.shippingAmountLabel.frame.size.height + kSummaryVerticalMargin)];
    self.handlingAmountLabel = [handlingSummaryLabelPair objectAtIndex:1];
    
    self.summarySecondRule = [[UIView alloc] initWithFrame:CGRectMake(kSummaryHorizontalMargin, self.handlingAmountLabel.frame.origin.y + self.handlingAmountLabel.frame.size.height + kSummaryVerticalMargin, self.summaryViewContainer.frame.size.width - 2*kSummaryHorizontalMargin, 1)];
    self.summarySecondRule.backgroundColor = kPurchaseSummarySeparatorGrey;
    [self.summaryViewContainer addSubview:self.summarySecondRule];  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataTable.frame = self.view.frame;
    [self.dataTable removeFromSuperview];
    [self.scrollContainer addSubview:self.dataTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.dataTable reloadData];
    [self relayoutSummaryView];

    [[GANTracker sharedTracker] trackPageview:kGANPageCheckoutStep2 withError:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    BOOL isInTransitionState = [[NavigationControlManager instance] isInTransitionState];
    
    [super viewDidAppear:animated];
    
    if(!isInTransitionState) {
        // Don't worry about fetching options multiple times - the subscription will prevent that.
        [self createShippingMethodsSubscription];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showDataErrors {
    [super showDataErrors];
//    self.errorHeader.hidden = NO;
    [self.scrollContainer addSubview:self.errorHeader];
    self.summaryViewContainer.frame  = CGRectMake(self.summaryViewContainer.frame.origin.x, self.errorHeader.frame.origin.y + self.errorHeader.frame.size.height, self.summaryViewContainer.frame.size.width, self.summaryViewContainer.frame.size.height);
    [self relayoutSummaryView];
    
}

- (void)resetErrorHeader {
    [self.errorHeader removeFromSuperview];
    [super resetErrorHeader];
    self.summaryViewContainer.frame = CGRectMake(self.summaryViewContainer.frame.origin.x, self.errorHeader.frame.origin.y, self.summaryViewContainer.frame.size.width, self.summaryViewContainer.frame.size.height);
    [self relayoutSummaryView];
}

#pragma mark - private

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    CellMetaData *cellMetaData;
    switch (indexPath.section) {
        case CheckoutStepTwoSectionShippingOption:
            switch (indexPath.row) {
                case CheckoutShippingOptionsCell: {
                    cellMetaData = [self getDefaultMultiLinePreviewMetaDataAtIndexPath:indexPath];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellTitle =[[[ModelContext instance] plndrPurchaseSession] getShippingMethodsSummaryStrings];
                    ((MultiLinePreviewMetaData*)cellMetaData).cellHeight = [MultiLinePreviewDataCell getHeightWithMetadata:(MultiLinePreviewMetaData*)cellMetaData];
                    [cellMetaData setDidSelectBlock:^(void) {
                        [self pushShippingOptions]; 
                    }];
                    break;
                }
                    
                default:
                    NSLog(@"WARNING: %@ - got unexpected indexPath %d in getCellMetaDataForIndexPath", [self class], indexPath.row);
                    break;
            }
            break;
            
        case CheckoutStepTwoSectionDiscounts:
            switch (indexPath.row) {
                case CheckoutDiscountCell: {   
                    cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
                    ((DetailAndDisclosureMetaData*)cellMetaData).cellTitle = @"Promo, Rep and Gift Codes";
                    [cellMetaData setDidSelectBlock: ^(void) {
                        [self pushDiscounts];
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

- (void)pushShippingOptions {
    ShippingOptionsViewController *shippingOptionsViewController = [[ShippingOptionsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shippingOptionsViewController];
    [self presentModalViewController:navController animated:YES];
}

- (void) pushDiscounts {
    DiscountViewController *discountViewController = [[DiscountViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:discountViewController];
    [self presentModalViewController:navController animated:YES];
}

- (void)buyButtonPressed:(id)sender {
    [self.checkoutDelegate doPurchase];
}

- (void) relayoutSummaryView {
    // Update Values but positions stay the same
    NSString *subtotalAmount = [Utility currencyStringForFloat:[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary].cartSubtotal floatValue]];
    self.subtotalAmountLabel.text = subtotalAmount;
    
    NSString *shippingAmount = [Utility currencyStringForFloat:[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary].shippingSubtotal floatValue]];
    self.shippingAmountLabel.text = shippingAmount;
    
    NSString *handlingAmount = [Utility currencyStringForFloat:[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary].handling floatValue]];
    self.handlingAmountLabel.text = handlingAmount;
    
    
    // Remove the dynamic part of the summary - it will be repopulated
    for (UIView *view in self.summaryDynamicViews) {
        [view removeFromSuperview];
    }
    self.summaryDynamicViews = [NSMutableArray array];
    
    int labelPositionY = self.summarySecondRule.frame.origin.y + self.summarySecondRule.frame.size.height + kSummaryVerticalMargin;
    
    //If Promo Code Exist
    AppliedDiscountCode *promoCode = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getPromoCode];
    if(promoCode.name.length > 0) {
        NSString *promoTitle = @"Promo Code";
        NSString *promoAmount = [Utility currencyStringForFloat:[promoCode.totalDiscount floatValue]];
        labelPositionY = [self addDiscountSummaryLabelWithLeftTitle:promoTitle withRightAmount:promoAmount withY:labelPositionY] + kSummaryVerticalMargin;
    }
    
    //If Rep Code Exists
    AppliedDiscountCode *repCode =[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getRepCode];
    if(repCode.name.length > 0) {
        NSString *repTitle = @"Rep Code";
        NSString *repAmount = [Utility currencyStringForFloat:[repCode.totalDiscount floatValue]];
        labelPositionY = [self addDiscountSummaryLabelWithLeftTitle:repTitle withRightAmount:repAmount withY:labelPositionY] + kSummaryVerticalMargin;
    }
    
    NSArray *giftCerts = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getGiftCertificates];
    for (AppliedDiscountCode *giftCertificate in giftCerts) {
        NSString *giftTitle = giftCertificate.name;
        NSString *giftAmount = [Utility currencyStringForFloat:[giftCertificate.totalDiscount floatValue]];
        labelPositionY = [self addDiscountSummaryLabelWithLeftTitle:giftTitle withRightAmount:giftAmount withY:labelPositionY] + kSummaryVerticalMargin;
    }
    
    if (self.summaryDynamicViews.count > 0){
        UIView *ruleView = [[UIView alloc] initWithFrame:CGRectMake(kSummaryHorizontalMargin, labelPositionY, self.summaryViewContainer.frame.size.width - 2*kSummaryHorizontalMargin, 1)];
        ruleView.backgroundColor = kPurchaseSummarySeparatorGrey;
        [self.summaryViewContainer addSubview:ruleView];
        [self.summaryDynamicViews addObject:ruleView];
        labelPositionY = ruleView.frame.origin.y + ruleView.frame.size.height + kSummaryVerticalMargin;
    }

    NSString *totalSummary = [NSString stringWithFormat:@"Order Total: %@", 
                              [Utility currencyStringForFloat:[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary].total floatValue]]];
    UIFont *totalSummaryFont = kFontBold16;
    CGSize totalSummarySize = [totalSummary sizeWithFont:totalSummaryFont constrainedToSize:kSummaryItemSizeConstraint lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *totalSummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.summaryViewContainer.frame.size.width - totalSummarySize.width - kSummaryHorizontalLabelMargin, labelPositionY, totalSummarySize.width, totalSummarySize.height)];
    totalSummaryLabel.text = totalSummary;
    totalSummaryLabel.textColor = kPlndrBlack;
    totalSummaryLabel.textAlignment = UITextAlignmentRight;
    totalSummaryLabel.font = totalSummaryFont;
    totalSummaryLabel.backgroundColor = [UIColor clearColor];
    [self.summaryViewContainer addSubview:totalSummaryLabel];
    [self.summaryDynamicViews addObject:totalSummaryLabel];
   
    self.summaryViewContainer.frame = CGRectMake(self.summaryViewContainer.frame.origin.x, self.summaryViewContainer.frame.origin.y, self.summaryViewContainer.frame.size.width, totalSummaryLabel.frame.origin.y + totalSummaryLabel.frame.size.height + kSummaryVerticalMargin);
    self.summaryBackgroundView.frame = CGRectMake(-1*kSummaryBackgroundImageCap, 0, self.summaryViewContainer.frame.size.width + kSummaryBackgroundImageCap*2, self.summaryViewContainer.frame.size.height + kSummaryBackgroundImageCap);
    
    CGSize dataTableSize = self.dataTable.contentSize;
    self.dataTable.frame = CGRectMake(0, self.summaryViewContainer.frame.origin.y+self.summaryViewContainer.frame.size.height + 10, dataTableSize.width, dataTableSize.height);
    self.scrollContainer.contentSize = CGSizeMake(kDeviceWidth, self.dataTable.frame.size.height + self.dataTable.frame.origin.y);
}

- (UILabel *)getDefaultSummaryLabelWithText:(NSString *)text withTextAlignment:(UITextAlignment)alignment {
    UILabel * label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = kPlndrBlack;
    label.textAlignment = alignment;
    label.font = kSummaryItemFont;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (NSArray *)addDefaultSummaryLabelPairWithLeftText:(NSString *)leftText withRightText:(NSString *)rightText withY:(int)y {
    CGSize leftTitleSize = [leftText sizeWithFont:kSummaryItemFont constrainedToSize:kSummaryItemSizeConstraint lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *leftTitleLabel = [self getDefaultSummaryLabelWithText:leftText withTextAlignment:UITextAlignmentLeft];
    int leftTitleWidth = MIN(leftTitleSize.width, kSummaryTableMaxLeftLabelMaxSpace - kSummaryHorizontalLabelMargin);
    leftTitleLabel.frame =  CGRectMake(kSummaryHorizontalLabelMargin, y, leftTitleWidth, leftTitleSize.height);
    [self.summaryViewContainer addSubview:leftTitleLabel];
    
    CGSize rightAmountSize = [rightText sizeWithFont:kSummaryItemFont constrainedToSize:kSummaryItemSizeConstraint lineBreakMode:UILineBreakModeTailTruncation];
    UILabel *rightAmountLabel = [self getDefaultSummaryLabelWithText:rightText withTextAlignment:UITextAlignmentRight];
    int rightAmountLabelX = leftTitleLabel.frame.origin.x + leftTitleLabel.frame.size.width + kSummaryHorizontalLabelMargin;
    rightAmountLabel.frame = CGRectMake(rightAmountLabelX, leftTitleLabel.frame.origin.y, self.summaryViewContainer.frame.size.width - rightAmountLabelX - kSummaryHorizontalLabelMargin, rightAmountSize.height);
    [self.summaryViewContainer addSubview:rightAmountLabel];
    
    return [NSArray arrayWithObjects:leftTitleLabel, rightAmountLabel, nil];
    
}

// Returns the y position of the bottom of the labels.
- (int)addDiscountSummaryLabelWithLeftTitle:(NSString *)leftText withRightAmount:(NSString *)rightAmount withY:(int)y {
    NSArray *summaryLabelPair = [self addDefaultSummaryLabelPairWithLeftText:leftText withRightText:rightAmount withY:y];
    UILabel *titleLabel = [summaryLabelPair objectAtIndex:0];
    [self.summaryDynamicViews addObject:titleLabel];
    [self.summaryDynamicViews addObject:[summaryLabelPair objectAtIndex:1]];
    return titleLabel.frame.origin.y + titleLabel.frame.size.height;
}

- (void) createShippingMethodsSubscription {
    [_shippingMethodsSubscription cancel]; //Cancel any previously set up subscription
    _shippingMethodsSubscription = [[ShippingMethodsSubscription alloc] initWithAddress:[[[ModelContext instance] plndrPurchaseSession] getPurchaseShippingAddress] cartItems:[[ModelContext instance] cartItems] context:[ModelContext instance]];
    _shippingMethodsSubscription.delegate = self;
    [self subscriptionUpdatedState:_shippingMethodsSubscription];
}

- (void) handleSubscriptionError:(RequestSubscription*)subscription {
    [self showDataErrors];
    BOOL areThereCheckoutErrors = [[ModelContext instance].plndrPurchaseSession.checkoutErrors count] > 0;
    if (areThereCheckoutErrors) {
        [self setFlagForCartItemForViewController:self];
    }
    //Handling Checkout Option Error - As 0 Shipping Methods mean Checkout Option Error
    if ([[ModelContext instance] plndrPurchaseSession].shippingMethods.count == 0) {        
        if(areThereCheckoutErrors) {
            NSString *errorStr = [self getErrorStringForFirstCheckoutError];
            NSString *popupButtonTitle = [self getPopupButtonTitleForFirstCheckoutError];
            self.checkoutOptionsErrorPopup = [self displayErrorFromSubscription:subscription errorString:errorStr buttonTitle:popupButtonTitle];
        } else {
            NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:subscription];
            self.defaultErrorPopup = [self displayErrorFromSubscription:subscription errorString:errorStr buttonTitle:@"OK"];
        }
        return;
    }
    
    [self.dataTable reloadData];
    NSString *errorStr; 
    NSString *popupButtonTitle = nil;
    if (areThereCheckoutErrors) {
        errorStr = [self getErrorStringForFirstCheckoutError];
        popupButtonTitle = [self getPopupButtonTitleForFirstCheckoutError];
        self.checkoutErrorPopup = [self displayErrorFromSubscription:subscription errorString:errorStr buttonTitle:popupButtonTitle];
        [[ModelContext instance] plndrPurchaseSession].lastDisplayedCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0]; 
    } else {
        errorStr = [Utility getDefaultErrorStringFromSubscription:subscription];
        self.defaultErrorPopup = [self displayErrorFromSubscription:subscription errorString:errorStr buttonTitle:@"OK"];
    }
}

- (PopupViewController *)displayErrorFromSubscription:(RequestSubscription *)subscription errorString:(NSString *)errorString buttonTitle:(NSString *)buttonTitle {
    PopupViewController *popup;
    [self displayAPIErrorWithTitle:kCheckoutErrorTitle message:errorString buttonTitle:buttonTitle usingPopup:&popup];
    return popup;        
}

- (NSString *)getErrorStringForFirstCheckoutError {
    CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
    return firstCheckoutError.generalMessage;
}

- (NSString *)getPopupButtonTitleForFirstCheckoutError {
    CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
    XLCheckoutErrorResolution checkoutErrorResolution = [firstCheckoutError getCheckoutErrorResolution];
    if ([NavigationControlManager shouldErrorResolution:checkoutErrorResolution resultInNavigationFromController:self]) {
        return kCheckoutErrorButtonGoThere;
    } else {
        return @"OK";
    }
}

- (void) createCheckoutSummarySubscription {
    [_checkoutSummarySubscription cancel]; //Cancel any previously set up subscription
    _checkoutSummarySubscription = [[CheckoutSummarySubscription alloc] initWithDiscounts:nil
                                                                          shippingDetails:nil  
                                                                 isIntermediateValidation:NO 
                                                                              withContext:[ModelContext instance]];
    _checkoutSummarySubscription.delegate = self;
    [self subscriptionUpdatedState:_checkoutSummarySubscription];
}

- (void)handleConnectionError {
    ConnectionErrorViewController *connectionErrorVC = [[ConnectionErrorViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:connectionErrorVC];
    CheckoutViewController *parentController = (CheckoutViewController *)self.parentViewController;
    [(CheckoutViewController *)(self.parentViewController) changeToStep:CheckoutViewControllerStepOne];
    [parentController presentModalViewController:navController animated:YES];
}
#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    [self.checkoutDelegate updateContainerView];
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription == self.shippingMethodsSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self createCheckoutSummarySubscription];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            [self handleSubscriptionError:(RequestSubscription*)subscription];
        } else { // Pending
            [self showLoadingView];
        }
    } else if (subscription == self.checkoutSummarySubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self hideLoadingView];
            [self resetErrorHeader];
            [self.dataTable reloadData];
            [self relayoutSummaryView];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            // TODO handle error appropriately
            [self hideLoadingView];
            [self handleSubscriptionError:(RequestSubscription*)subscription];
        } else { // Pending
            [self showLoadingView];
        }
    }
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    // pop to my cart if this error was fatal
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else if (self.checkoutOptionsErrorPopup) {
        [(CheckoutViewController *)self.parentViewController changeToStep:CheckoutViewControllerStepOne];
        self.checkoutOptionsErrorPopup = nil;
    } else {
        // otherwise do nothing 
        self.checkoutErrorPopup = nil;
    } 
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [PopupUtil dismissPopup];
    // pop to cart if this error was fatal
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else if(self.checkoutOptionsErrorPopup) {
        CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
        XLCheckoutErrorResolution checkoutErrorResolution = [firstCheckoutError getCheckoutErrorResolution];
        [[NavigationControlManager instance] setErrorType:checkoutErrorResolution forViewController:self];
        self.checkoutOptionsErrorPopup = nil;
    } else {
        // Otherwise, let the NavigationControlManager handle it
        CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
        XLCheckoutErrorResolution checkoutErrorResolution = [firstCheckoutError getCheckoutErrorResolution];
        [[NavigationControlManager instance] setErrorType:checkoutErrorResolution forViewController:self];
        self.checkoutErrorPopup = nil;
    }
}

#pragma mark - CheckoutViewControllerDelegate Methods

- (BOOL) stepIsComplete {
    return [[[ModelContext instance] plndrPurchaseSession] checkoutSummary] != nil;
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.dataTable) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.dataTable) {
       return kPOTableHeaderHeight; 
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.dataTable) {
        if (section == CheckoutStepTwoSectionDiscounts) {
            return kButtonFooterHeight;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.dataTable) {
        switch (section) {
            case CheckoutStepTwoSectionShippingOption:
                return 1;
            case CheckoutStepTwoSectionDiscounts:
                return 1;
            default:
                NSLog(@"WARNING: %@ - got unexpected section %d in numberOfRowsInSection", [self class], section);
                return 0;
        }
    } else {
        return [[ModelContext instance] cartItems].count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.dataTable) {
        CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
        if ([cellMetaData respondsToSelector:@selector(cellHeight)]) {
            return [((NSNumber*)[cellMetaData performSelector:@selector(cellHeight)]) intValue];
        }
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return 64;
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.dataTable) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kPOTableHeaderHeight)];
        
        int headerViewVerticalOffset = 10;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, headerViewVerticalOffset, kDeviceWidth, kPOTableHeaderHeight - headerViewVerticalOffset)];
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = kPlndrMediumGreyTextColor;
        headerLabel.font = kFontMediumCond17;
        switch (section) {
            case CheckoutStepTwoSectionShippingOption:
                headerLabel.text = @"SHIPPING OPTIONS";
                break;
            case CheckoutStepTwoSectionDiscounts:
                headerLabel.text = @"DISCOUNTS";
                break;
        }
        [headerView addSubview:headerLabel];
        return headerView;
    } else {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.dataTable) {
         UIView *footerView = [[UIView alloc] init];
        if (section == CheckoutStepTwoSectionDiscounts) {
            
            UIImage *footerImage = [UIImage imageNamed:@"yellow_btn.png"];
            self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.footerButton.frame = CGRectMake((kDeviceWidth - footerImage.size.width)/2, 20, footerImage.size.width, footerImage.size.height);
            [self.footerButton setBackgroundImage:footerImage forState:UIControlStateNormal];
            [self.footerButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
            [self.footerButton setTitle:@"BUY!" forState:UIControlStateNormal];
            [self.footerButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
            [self.footerButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
            self.footerButton.titleLabel.font = kFontBoldCond17;
            [self.footerButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:self.footerButton];
        }    
        return footerView;

    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.dataTable) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSString *reuseIdentifier = @"horizontalTableViewCell";
        
        CheckoutSummaryHorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[CheckoutSummaryHorizontalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        [cell updateCheckoutSummaryCellWithCartItem:[[[ModelContext instance] cartItems] objectAtIndex:indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.dataTable) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        // do nothing
    }
}

@end
