//
//  MyCartTableCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCartTableCell.h"
#import "AsyncImageView.h"
#import "Constants.h"
#import "Product.h"
#import "CartItem.h"
#import "ProductSku.h"
#import "Utility.h"

@interface MyCartTableCell ()
- (void)initBorders;
- (void)initSubviews;

- (void) quantityChangeButtonPressed:(id)sender;
- (void) updateQuantityButtonEnabledStates;
- (void) updateErrorState:(CartItem *)cartItem;

@end

@implementation MyCartTableCell

@synthesize productImage = _productImage;
@synthesize brandNameLabel = _brandNameLabel;
@synthesize productNameLabel = _productNameLabel;
@synthesize sizeAndColorLabel = _sizeAndColorLabel;
@synthesize checkoutPriceLabel = _checkoutPriceLabel;
@synthesize quantityLabel = _quantityLabel;
@synthesize quantityMinusButton = _quantityMinusButton;
@synthesize quantityPlusButton = _quantityPlusButton;
@synthesize myCartDelegate = _myCartDelegate;
@synthesize errorLabel = _errorLabel;
@synthesize bottomBorder = _bottomBorder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initBorders];
        [self initSubviews];
    }
    return self;
}

- (void)initBorders {
    UIView *whiteBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
    whiteBorder.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBorder];
    
    self.bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, kMyCartTableCellHeight - 1, kDeviceWidth, 1)];
    self.bottomBorder.backgroundColor = kPlndrMediumGreyTextColor;
    [self addSubview:self.bottomBorder];
}

- (void)initSubviews {
    self.contentView.backgroundColor = kPlndrBgGrey;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = kListHighlightColor;
    
    self.productImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(kMyCartTableCellImageMargin, (kMyCartTableCellHeight - kMyCartTableCellImageHeight)/2, kMyCartTableCellImageWidth, kMyCartTableCellImageHeight)];
    self.productImage.placeholderImage = [UIImage imageNamed:@"Placeholder_58x89.png"];
    [self.contentView addSubview:self.productImage];
    
    UIFont *labelFont = kFontMedium15;
    int labelWidth = kDeviceWidth - self.productImage.frame.size.width - 2*kMyCartTableCellInternalMargin;
    CGSize labelSize = [@"SizeTexty!" sizeWithFont:labelFont
                                    constrainedToSize:CGSizeMake(labelWidth, 40)
                                        lineBreakMode:UILineBreakModeTailTruncation];
    
    int labelInternalMargin = (kMyCartTableCellHeight - 4*labelSize.height)/5;
    
    self.brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.productImage.frame.origin.x + self.productImage.frame.size.width + kMyCartTableCellInternalMargin, labelInternalMargin, labelWidth, labelSize.height)];
    self.brandNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.brandNameLabel.font = labelFont;
    [self.brandNameLabel setTextColor:kPlndrBlack];
    self.brandNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.brandNameLabel];
    
    self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.brandNameLabel.frame.origin.x, self.brandNameLabel.frame.origin.y + labelSize.height + labelInternalMargin, labelWidth, labelSize.height)];
    self.productNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.productNameLabel.backgroundColor = [UIColor clearColor];
    self.productNameLabel.font = labelFont;
    self.productNameLabel.textColor = kPlndrMediumGreyTextColor;
    [self.contentView addSubview:self.productNameLabel];
    
    self.sizeAndColorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y + labelSize.height + labelInternalMargin, labelWidth, labelSize.height)];
    self.sizeAndColorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.sizeAndColorLabel.backgroundColor = [UIColor clearColor];
    self.sizeAndColorLabel.font = labelFont;
    self.sizeAndColorLabel.textColor = kPlndrMediumGreyTextColor;
    [self.contentView addSubview:self.sizeAndColorLabel];
    
    self.checkoutPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sizeAndColorLabel.frame.origin.x, self.sizeAndColorLabel.frame.origin.y + labelSize.height + labelInternalMargin, labelWidth*(3.f/4.f), labelSize.height)];
    self.checkoutPriceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.checkoutPriceLabel.backgroundColor = [UIColor clearColor];
    self.checkoutPriceLabel.font = labelFont;
    self.checkoutPriceLabel.textColor = kPlndrMediumGreyTextColor;
    [self.contentView addSubview:self.checkoutPriceLabel];
    
    int fudgePadding = 8;
    
    UIImage *plusButtonImage = [UIImage imageNamed:@"plus.png"];
    self.quantityPlusButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quantityPlusButton.backgroundColor = [UIColor clearColor];
    [self.quantityPlusButton setImage:plusButtonImage forState:UIControlStateNormal];
    [self.quantityPlusButton setImage:[UIImage imageNamed:@"plus_hl.png"] forState:UIControlStateHighlighted];
    self.quantityPlusButton.frame = CGRectMake(self.contentView.frame.size.width - kMagicButtonHeight, self.checkoutPriceLabel.frame.origin.y - (kMagicButtonHeight - self.checkoutPriceLabel.frame.size.height)/2 - 6, kMagicButtonHeight, kMagicButtonHeight);
    self.quantityPlusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -14, 0);
    [self.quantityPlusButton addTarget:self action:@selector(quantityChangeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.quantityPlusButton];    
    
    int quantityLabelWidth = labelWidth*(1.f/4.5f);
    self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.quantityPlusButton.frame.origin.x - quantityLabelWidth + 1.3*fudgePadding, self.checkoutPriceLabel.frame.origin.y, quantityLabelWidth, labelSize.height)];
    self.quantityLabel.backgroundColor = [UIColor clearColor];
    self.quantityLabel.font = labelFont;    
    self.quantityLabel.textColor = kPlndrBlack;
    [self addSubview:self.quantityLabel];
    
    UIImage *minusButton = [UIImage imageNamed:@"minus.png"];
    self.quantityMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quantityMinusButton.backgroundColor = [UIColor clearColor];
    [self.quantityMinusButton setImage:minusButton forState:UIControlStateNormal];
    [self.quantityMinusButton setImage:[UIImage imageNamed:@"minus_hl.png"] forState:UIControlStateHighlighted];
    self.quantityMinusButton.frame = CGRectMake(self.quantityLabel.frame.origin.x - kMagicButtonHeight + fudgePadding, self.quantityPlusButton.frame.origin.y, kMagicButtonHeight, kMagicButtonHeight);
    self.quantityMinusButton.imageEdgeInsets = self.quantityPlusButton.imageEdgeInsets;
    [self.quantityMinusButton addTarget:self action:@selector(quantityChangeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.quantityMinusButton];
    
    UIButton *clickAbsorbButton = [[UIButton alloc] initWithFrame:CGRectMake(self.quantityMinusButton.frame.origin.x, self.quantityMinusButton.frame.origin.y, self.quantityPlusButton.frame.origin.x - self.quantityMinusButton.frame.origin.x + self.quantityPlusButton.frame.size.width, self.quantityMinusButton.frame.size.height)];
    [self insertSubview:clickAbsorbButton belowSubview:self.quantityPlusButton];
}

- (void)updateWithCartItem:(CartItem *)cartItem {
    [self.productImage loadImageFromUrl:cartItem.product.browseImageUrl sizedForFrame:YES];
    self.brandNameLabel.text = cartItem.product.vendorName;
    self.productNameLabel.text = cartItem.product.name;
    self.sizeAndColorLabel.text = [NSString stringWithFormat:@"%@ / %@", cartItem.size.size, cartItem.size.color];
    self.checkoutPriceLabel.text = [Utility currencyStringForFloat:cartItem.product.checkoutPrice.floatValue];
    self.quantityLabel.text = [NSString stringWithFormat:@"Qty: %d", cartItem.quantity];
    [self.quantityLabel sizeToFit];
    
    self.quantityLabel.frame = CGRectMake(self.quantityPlusButton.frame.origin.x - self.quantityLabel.frame.size.width, self.checkoutPriceLabel.frame.origin.y, self.quantityLabel.frame.size.width, self.quantityLabel.frame.size.height);
    self.quantityMinusButton.frame = CGRectMake(self.quantityLabel.frame.origin.x - kMagicButtonHeight, self.quantityPlusButton.frame.origin.y, kMagicButtonHeight, kMagicButtonHeight);
    
    [self updateQuantityButtonEnabledStates];
    [self updateErrorState:(CartItem *)cartItem];
    
    int bottomBorderY = self.errorLabel ? self.errorLabel.frame.origin.y + self.errorLabel.frame.size.height - 1 : kMyCartTableCellHeight - 1;
    self.bottomBorder.frame = CGRectMake(self.bottomBorder.frame.origin.x, bottomBorderY, self.bottomBorder.frame.size.width, self.bottomBorder.frame.size.height);
}

#pragma mark - private

- (void) quantityChangeButtonPressed:(id)sender {
    if (sender == self.quantityPlusButton) {
        [self.myCartDelegate addQuantity:self];
    } else {
        [self.myCartDelegate subtractQuantity:self];
    }
    [self updateQuantityButtonEnabledStates];
}

- (void) updateQuantityButtonEnabledStates {
    self.quantityMinusButton.enabled = [self.myCartDelegate minusButtonEnabled:self];
    self.quantityPlusButton.enabled = [self.myCartDelegate plusButtonEnabled:self];
}

- (void)updateErrorState:(CartItem *)cartItem {
    [self.errorLabel removeFromSuperview];
    if ([cartItem containsError]) {
        UIFont *errorFont = kFontMedium15;
        NSString *errorMessage; 
        if (cartItem.isUnavailableDueToError) {
            errorMessage = kSkuInconsistencyError;
        } else {
            errorMessage = [cartItem.size.stock intValue] > 0 ? [NSString stringWithFormat:kMyCartInsufficientStockMessage, cartItem.size.stock.intValue] : kMyCartSoldOutMessage;
        }
            
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMyCartTableCellHeight, self.frame.size.width, kMyCartTableCellErrorFooterHeight)];
        self.errorLabel.text = errorMessage;
        self.errorLabel.textColor = kPlndrTextRed;
        self.errorLabel.font = errorFont;
        self.errorLabel.textAlignment = UITextAlignmentCenter;
        self.errorLabel.backgroundColor = kPlndrWhite;
        [self insertSubview:self.errorLabel belowSubview:self.bottomBorder];
    } else {
        self.errorLabel = nil;
    }
}

@end
