//
//  FeaturedListCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeaturedListCell.h"
#import "Constants.h"
#import "OHAttributedLabel.h"
#import "Utility.h"
#import "NSAttributedString+Attributes.h"
#import "Sale.h"
#import "AsyncImageView.h"

@interface FeaturedListCell ()
+ (UIColor *) getTopBorderColor;
- (void)initBorders;
- (void)initSubviews;
- (void)updateTimer;
@end

@implementation FeaturedListCell

@synthesize saleIcon = _saleIcon;
@synthesize disclosureView = _disclosureView;
@synthesize saleLabel = _saleLabel;
@synthesize timerLabel = _timerLabel;
@synthesize endDate = _endDate;
@synthesize topBorder = _topBorder;
@synthesize bottomBorder = _bottomBorder;

static UIFont *timerFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timerFont = kFontHomeViewTimer; // Don't change this anywhere else
        [self initBorders];
        [self initSubviews];
    }
    return self;
}

- (void)updateWithSale:(Sale *)sale tag:(int)tag {
    self.tag = tag;
    self.saleLabel.text = sale.name;
    self.endDate = sale.endDate;
    [self.saleIcon loadImageFromUrl:sale.tileImagePathMedium sizedForFrame:YES];
    [self updateTimer];
}

- (void)initBorders {
    self.topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHomeScreenListCellWidth, 1)];
    self.topBorder.backgroundColor = [FeaturedListCell getTopBorderColor];
    [self.contentView addSubview:self.topBorder];
    self.bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, kHomeScreenListCellHeight - 1, kHomeScreenListCellWidth, 1)];
    self.bottomBorder.backgroundColor = [FeaturedListCell separatorColor];
    [self.contentView addSubview:self.bottomBorder];
}

- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = kListHighlightColor;
    self.selectedBackgroundView = selectionView;
    
    self.saleIcon = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, (kHomeScreenListCellHeight - kHomeScreenListIconHeight)/2, kHomeScreenListIconWidth, kHomeScreenListIconHeight)];
    self.saleIcon.placeholderImage = [UIImage imageNamed:@"Placeholder_100x60.png"];
    [self addSubview:self.saleIcon];

    const int kLabelMargin = 2;
    
    UIFont *nameFont = kFontMedium15;
    
    int labelWidth = kHomeScreenListCellWidth - self.saleIcon.frame.size.width - self.disclosureView.frame.size.width - kHomeScreenListMargin*4;
    
    CGSize nameLabelSize = [@"SizeText!" sizeWithFont:nameFont
                            constrainedToSize:CGSizeMake(labelWidth, 35)
                                lineBreakMode:UILineBreakModeTailTruncation];
    CGSize timerLabelSize = [@"SizeText!" sizeWithFont:timerFont
                                    constrainedToSize:CGSizeMake(labelWidth, 35)
                                        lineBreakMode:UILineBreakModeTailTruncation];
    
    int nameOriginY = (kHomeScreenListCellHeight - (nameLabelSize.height + timerLabelSize.height + kLabelMargin))/2;
    self.saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.saleIcon.frame.origin.x + self.saleIcon.frame.size.width + kHomeScreenListMargin, nameOriginY, labelWidth, nameLabelSize.height)];
    self.saleLabel.backgroundColor = [UIColor clearColor];
    self.saleLabel.font = nameFont;
    self.saleLabel.textColor = kPlndrBlack;
    self.saleLabel.shadowColor = [UIColor whiteColor];
    self.saleLabel.shadowOffset = CGSizeMake(0,1);
    [self addSubview:self.saleLabel];
    
    self.timerLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(self.saleLabel.frame.origin.x, self.saleLabel.frame.origin.y + self.saleLabel.frame.size.height + kLabelMargin, labelWidth, timerLabelSize.height)];
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.automaticallyAddLinksForType = 0;
    self.timerLabel.centerVertically = YES;
    [self addSubview:self.timerLabel];
    [self updateTimer];
    
}

- (void)updateClock {
    [self updateTimer];
}

- (void) updateTimer {
    NSString *redTxt = @"";
    RemainingSaleTime unusedRST = RemainingSaleTimeLots;
    NSString *txt = [Utility stringForSaleEndDate:self.endDate textToMakeRed:&redTxt remainingSaleTime:&unusedRST];
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
    [attrStr setFont:timerFont];
    [attrStr setTextColor:kPlndrMediumGreyTextColor];
    
    // possibly make the timer red
    NSRange redRange = [txt rangeOfString:redTxt];
    [attrStr setFont:kFontBold13 range:redRange];
    [attrStr setTextColor:kPlndrTextRed range:redRange];
    
    self.timerLabel.attributedText = attrStr;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron_hl.png"]];
        self.topBorder.backgroundColor = [FeaturedListCell getTopBorderColor];
        self.bottomBorder.backgroundColor = [FeaturedListCell separatorColor];
    } else {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron.png"]];        
    }
}

+ (UIColor *)separatorColor {
    return kPlndrLightGreyTextColor;
}

+ (UIColor *)getTopBorderColor {
    return [UIColor whiteColor];
}

@end
