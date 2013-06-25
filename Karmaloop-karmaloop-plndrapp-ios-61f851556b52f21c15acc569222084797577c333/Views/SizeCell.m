//
//  SizeCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SizeCell.h"
#import "Constants.h"
#import "ProductSku.h"

@interface SizeCell () 

- (void) initSubviews;
- (void) initBorders;
- (UIColor*) getDefaultSizeTextColor;
- (UIColor*) getDisabledSizeTextColor;
- (UIColor*) getSelectedSizeTextColor;
- (UIColor*) getSelectedBackgroundColor;
- (void) hideBorders;
- (void) showBorders;

@end

@implementation SizeCell

@synthesize sizeLabel = _sizeLabel;
@synthesize topBorder = _topBorder;
@synthesize bottomBorder = _bottomBorder;
@synthesize isSelected = _isSelected;
@synthesize isDisabled = _isDisabled;

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
    self.topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kProductDetailSizeTableWidth, 1)];
    self.topBorder.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topBorder];
    
    self.bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, kProductDetailSizeTableCellHeight - 1, kDeviceWidth, 1)];
    self.bottomBorder.backgroundColor = [SizeCell separatorColor];
    [self addSubview:self.bottomBorder];
}

- (void)initSubviews {
    self.contentView.backgroundColor = kPlndrBgGrey;
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = [self getSelectedBackgroundColor];
    
    self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProductDetailSizeTableCellLabelMargin, 0, kProductDetailSizeTableWidth - kProductDetailSizeTableCellLabelMargin, kProductDetailSizeTableCellHeight)];
    self.sizeLabel.backgroundColor = [UIColor clearColor];
    self.sizeLabel.textColor = [self getDefaultSizeTextColor];
    self.sizeLabel.font = [SizeCell cellFont];
    [self.contentView addSubview:self.sizeLabel];
}

- (void)updateWithSku:(ProductSku*)sku isSelected:(BOOL)isSelected {
    self.sizeLabel.text = sku.size;
    self.isSelected = isSelected;
    if (isSelected) {
        self.sizeLabel.textColor = [self getSelectedSizeTextColor];
        self.contentView.backgroundColor = [self getSelectedBackgroundColor];
        self.userInteractionEnabled = YES;
        self.isDisabled = NO;
        [self hideBorders];
    } else if ([sku.stock intValue] > 0) {
        self.sizeLabel.textColor = [self getDefaultSizeTextColor];
        self.contentView.backgroundColor = kPlndrBgGrey;
        self.userInteractionEnabled = YES;
        self.isDisabled = NO;
        [self showBorders];
    } else {
        self.sizeLabel.textColor = [self getDisabledSizeTextColor];
        self.contentView.backgroundColor = kPlndrBgGrey;
        self.userInteractionEnabled = NO;
        self.isDisabled = YES;
        [self showBorders];
    }
}

- (UIColor*) getDefaultSizeTextColor {
    return kPlndrDarkGreyTextColor;
}

- (UIColor*) getDisabledSizeTextColor {
    return [UIColor colorWithWhite:178.0f/255.0f alpha:1.0f];
}

- (UIColor*) getSelectedSizeTextColor {
    return kPlndrTextGold;
}

- (UIColor*) getSelectedBackgroundColor {
    return [UIColor colorWithWhite:51.0f/255.0f alpha:1.0f];
}

- (void) showBorders {
    self.topBorder.hidden = NO;
    self.bottomBorder.hidden = NO;
}

- (void) hideBorders {
    self.topBorder.hidden = YES;
    self.bottomBorder.hidden = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted || self.isSelected) {
        self.sizeLabel.textColor = [self getSelectedSizeTextColor];
    } else if (!self.isDisabled) {
        self.sizeLabel.textColor = [self getDefaultSizeTextColor];
    } else {
        self.sizeLabel.textColor = [self getDisabledSizeTextColor];
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected || self.isSelected) {
        self.sizeLabel.textColor = [self getSelectedSizeTextColor];
    } else if (!self.isDisabled) {
        self.sizeLabel.textColor = [self getDefaultSizeTextColor];
    } else {
        self.sizeLabel.textColor = [self getDisabledSizeTextColor];
    }
}

+ (UIColor *)separatorColor {
    return kPlndrMediumGreyTextColor;
}

+ (UIFont *)cellFont {
    return kFontBoldCond16; 
}

+ (UIView*) borderSeparator {
    int topSeparatorHeight = 2;
    int bottomSeparatorHeight = 1;
    
    UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,0, kProductDetailSizeTableWidth, topSeparatorHeight)];
    topSeparator.backgroundColor = [SizeCell separatorColor];
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,topSeparatorHeight,kProductDetailSizeTableWidth, bottomSeparatorHeight)];
    bottomSeparator.backgroundColor = [UIColor whiteColor];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kProductDetailSizeTableWidth, topSeparatorHeight + bottomSeparatorHeight)];
    [separator addSubview:topSeparator];
    [separator addSubview:bottomSeparator];
    return separator;
}
@end
