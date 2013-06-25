//
//  PurchaseReceiptViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PurchaseReceiptViewController.h"
#import "Constants.h"
#import "DetailAndDisclosureMetaData.h"
#import "MultiLinePreviewMetaData.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "Address.h"
#import "MultiLineItemizedMetaData.h"
#import "MultiLineItemizedDataCell.h"
#import "CartItem.h"
#import "Product.h"
#import "Utility.h"
#import "AppliedDiscountCode.h"
#import "PlndrAppDelegate.h"
#import "CheckoutSummary.h"
#import "CheckoutCompleteResponse.h"
#import "GANTracker.h"

@interface PurchaseReceiptViewController ()

- (void) bottomButtonPressed:(id)sender;

- (void) dismissModalAndSwitchToTabIndex:(int)index;

+ (UIFont*) wideFont;
+ (UIFont*) boldWideFont;
+ (UIFont*) boldCondensedFont;

@end

@implementation PurchaseReceiptViewController

- (id) init {
    self = [super init];
    if (self) {
        self.title =@"PURCHASE RECEIPT";
    }
    return self;
}

- (void)dealloc {
    //Nothing to do
}

- (void)viewDidUnload {
    [super viewDidUnload];
    //Nothing
}


- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[GANTracker sharedTracker] trackEvent:kGANEventCheckout action:kGANActionCheckoutComplete label:nil value:-1 withError:nil];
    
    [[GANTracker sharedTracker] trackPageview:kGANPagePurchaseReceipt withError:nil];
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
    
    CellMetaData *cellMetaData = [self getDefaultDetailsAndDisclosureMetaDataAtIndexPath:indexPath];
    switch (indexPath.section) {

        case PurchaseConfirmationInformationSection: {
            switch (indexPath.row) {
                    
                case PurchaseConfirmationOrderNumberCell: {
                    cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                    
                    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:@"Order Number" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldCondensedFont], kAttributedStringFont, kPlndrBlack, kAttributedStringColor, nil]];
                    NSString *orderNumberStr = [NSString stringWithFormat:@"%010d", [[[ModelContext instance] plndrPurchaseSession] checkoutComplete].orderNumber.intValue];
                    NSMutableAttributedString *item1 = [[NSMutableAttributedString alloc] initWithString:orderNumberStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    
                    ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = [NSArray arrayWithObjects:title1, item1, nil];
                    ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];
                    break;  
                }
                case PurchaseConfirmationShippingCell: {
                    cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                    
                    NSMutableAttributedString *header = [[NSMutableAttributedString alloc] initWithString:@"Ship To:" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldCondensedFont], kAttributedStringFont, kPlndrBlack, kAttributedStringColor, nil]];
                    NSMutableAttributedString *emptyString = [[NSMutableAttributedString alloc] initWithString:@""];
                    
                    NSMutableArray * addressItems = [NSMutableArray arrayWithObjects:header, emptyString, nil];
                    NSArray *addressStrings = [[[ModelContext instance].plndrPurchaseSession getPurchaseShippingAddress] getSummaryStrings];
                    for (int i = 0; i < addressStrings.count; i++) {
                        NSString *addressString = [addressStrings objectAtIndex:i];
                        NSMutableAttributedString *addressAttrString = [[NSMutableAttributedString alloc] initWithString:addressString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, [NSNumber numberWithBool:YES], kAttributedStringSuppressBottomPadding, nil]];
                        [addressItems addObject:addressAttrString];
                        [addressItems addObject:emptyString];
                    }                    
                    
                    ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = addressItems;
                    ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];
                    break; 
                }
                    
                default:
                    NSLog(@"WARNING: %@ getCellMetaDataForIndexPath couldn't create metaData for indexPath %@", [self class], indexPath);
            }
        }
        break;
            
        case PurchaseConfirmationMoneySection: {
            if (indexPath.row == 0) {
                cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                
                NSMutableArray *items = [NSMutableArray array];
                NSArray *cartItems = [ModelContext instance].plndrPurchaseSession.checkoutSummary.adjustedItems;
                for (int i = 0; i < cartItems.count; i++) {
                    AdjustedCartItem *cartItem = [cartItems objectAtIndex:i];
                    
                    NSString *cartString = [NSString stringWithFormat:@"%d %@", cartItem.quantity.intValue, cartItem.productName];
                    NSMutableAttributedString *attributedCartString = [[NSMutableAttributedString alloc] initWithString:cartString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedCartString];
                    
                    NSString *priceString = [Utility currencyStringForFloat:[cartItem.originalPricePerUnit floatValue] * cartItem.quantity.intValue];
                    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedPriceString];
                } 
                
                NSMutableAttributedString *attributedShippingStr = [[NSMutableAttributedString alloc] initWithString:@"Shipping" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedShippingStr];
                
                NSString *priceString = [Utility currencyStringForFloat:[[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] shippingSubtotal] floatValue]];
                NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedPriceString];
                
                NSMutableAttributedString *attributedCartString = [[NSMutableAttributedString alloc] initWithString:@"Handling" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedCartString];
                
                priceString = [Utility currencyStringForFloat:[[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] handling] floatValue]];
                attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedPriceString];
                
                ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = items;
                ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];
            } else if (indexPath.row == 1 && [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] hasDiscount]) {                    
                cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                
                NSMutableArray *items = [NSMutableArray array];
                
                NSMutableAttributedString *attributedLabelStr = [[NSMutableAttributedString alloc] initWithString:@"Subtotal:" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldWideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedLabelStr];
                
                NSString *priceString = [Utility currencyStringForFloat:[[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] subtotal] floatValue]];
                NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldWideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedPriceString];
                
                ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = items;
                ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];
                break;

            } else if (indexPath.row == 2) {
                cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                
                NSMutableArray *items = [NSMutableArray array];
                
                AppliedDiscountCode *promoCode = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getPromoCode];
                if (promoCode) {
                    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:@"Promo Code" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:labelString];
                    
                    NSString *priceString = [Utility currencyStringForFloat:[promoCode.totalDiscount floatValue]];
                    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedPriceString];
                }
                
                AppliedDiscountCode *repCode = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getRepCode];
                if (repCode) {
                    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:@"Rep Code" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:labelString];
                    
                    NSString *priceString = [Utility currencyStringForFloat:[repCode.totalDiscount floatValue]];
                    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedPriceString];
                }
                
                NSArray *giftCodes = [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] getGiftCertificates];
                for (AppliedDiscountCode *giftCode in giftCodes) {
                    
                    NSMutableAttributedString *attributedLabelString = [[NSMutableAttributedString alloc] initWithString:giftCode.name attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedLabelString];
                    
                    NSString *priceString = [Utility currencyStringForFloat:[giftCode.totalDiscount floatValue]];
                    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController wideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                    [items addObject:attributedPriceString];

                }
                
                ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = items;
                ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];

            } else if (indexPath.row == 3 || indexPath.row == 1) {
                cellMetaData = [self getDefaultMultiLineItemizedMetaDataAtIndexPath:indexPath];
                
                NSMutableArray *items = [NSMutableArray array];
                
                NSMutableAttributedString *attributedLabelStr = [[NSMutableAttributedString alloc] initWithString:@"Order Total:" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldWideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedLabelStr];
                
                NSString *priceString = [Utility currencyStringForFloat:[[[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] total] floatValue]];
                NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString attributes:[NSDictionary dictionaryWithObjectsAndKeys:[PurchaseReceiptViewController boldWideFont], kAttributedStringFont, kPlndrDarkGreyTextColor, kAttributedStringColor, nil]];
                [items addObject:attributedPriceString];
                
                ((MultiLineItemizedMetaData*)cellMetaData).attributedStringLineItems = items;
                ((MultiLineItemizedMetaData*)cellMetaData).cellHeight = [MultiLineItemizedDataCell getHeightWithMetadata:(MultiLineItemizedMetaData*)cellMetaData];
            }
        }
        break;
        default:
            NSLog(@"WARNING: %@ getCellMetaDataForIndexPath couldn't create metaData for indexPath %@", [self class], indexPath);

    }
    return cellMetaData;
}

- (void)bottomButtonPressed:(id)sender {
    [self dismissModalAndSwitchToTabIndex:kInviteFriendsTabIndex];
}

+ (UIFont*) wideFont {
    return kFontMedium15;
}

+ (UIFont*) boldWideFont {
    return kFontBold15;
}

+ (UIFont*) boldCondensedFont {
    return kFontBoldCond15;
}

- (void) dismissModalAndSwitchToTabIndex:(int)index {
    [[ModelContext instance].plndrPurchaseSession resetPurchaseSession:YES];
    
    PlndrAppDelegate *appDelegate = (PlndrAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate switchToTabIndex:index];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - BaseModalViewController Overrides

- (void)setupNavBar {
    UIButton *rightBtn = [PlndrBaseViewController createNavBarButtonWithText:@"DONE" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
    [rightBtn addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)doneButtonPressed {
    [self dismissModalAndSwitchToTabIndex:kMyCartTabIndex];  
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    if ([cellMetaData respondsToSelector:@selector(cellHeight)]) {
        return [((NSNumber*)[cellMetaData performSelector:@selector(cellHeight)]) intValue];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case PurchaseConfirmationInformationSection:
            return 2;
        case PurchaseConfirmationMoneySection:
            if ([[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] hasDiscount]) {
                return 4;
            } else {
                return 2;
            }
        default:
            NSLog(@"WARNING: %@ numberofRowsInSection for section %@", [self class], section);
            return 0;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kPurchaseConfirmationHeaderHeight;
    } else {
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kPurchaseConfirmationHeaderHeight)];
        UIView *blackBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kPurchaseConfirmationHeaderHeight - kPurchaseConfirmationHeaderMargin)];
        blackBanner.backgroundColor = kPlndrDarkBgGrey;
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(kPurchaseConfirmationHeaderMargin, 0, kDeviceWidth - 2*kPurchaseConfirmationHeaderMargin, blackBanner.frame.size.height)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = kPlndrWhite;
        headerLabel.font = kFontMediumCond14;
        headerLabel.lineBreakMode = UILineBreakModeTailTruncation;
        headerLabel.numberOfLines = 3;
        headerLabel.text = @"Thank you for your order. Please review your final details below. A receipt will also be emailed to you.";
        [blackBanner addSubview:headerLabel];
        [headerView addSubview:blackBanner];
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return kButtonFooterHeight;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        
        UIImage *bottomImage = [UIImage imageNamed:@"yellow_btn.png"];
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.frame = CGRectMake((kDeviceWidth - bottomImage.size.width)/2, 20, bottomImage.size.width, bottomImage.size.height);
        [bottomButton setBackgroundImage:bottomImage forState:UIControlStateNormal];
        [bottomButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
        [bottomButton setTitle:@"INVITE A PAL AND GET CREDITS" forState:UIControlStateNormal];
        [bottomButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
        bottomButton.titleLabel.font = kFontBoldCond17;
        [bottomButton addTarget:self action:@selector(bottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:bottomButton];
        
        return footerView;
    } else {
        return nil;
    }
}



@end
