//
//  MultiLinePreviewDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLinePreviewDataCell.h"
#import "Constants.h"



@interface MultiLinePreviewDataCell ()

- (CGSize) getTitleLabelSize;
- (CGSize) getDetailLabelSize;
- (CGSize) getPlaceholderLabelSize;

+ (UIFont*) getTitleLabelFont;
+ (UIFont*) getDetailLabelFont;
+ (UIFont*) getPlaceholderLabelFont;

- (NSNumber*) getHeightForTitle:(NSArray*)titles details:(NSArray*)details placeholder:(NSArray*)placeholders;
- (int) getLabelHorizontalMargin;

@end

@implementation MultiLinePreviewDataCell

@synthesize labels = _labels;
@synthesize iconView = _iconView;

- (void)initSubviews {
    [super initSubviews];
}

- (void)update {
    [super update];
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }    
    
    NSArray *titles = [self.baseDataCellDelegate getTitleForMultiLinePreviewDataCell:self];
    NSArray *details = [self.baseDataCellDelegate getDetailForMultiLinePreviewDataCell:self];
    NSArray *placeholders = [self.baseDataCellDelegate getPlaceholderForMultiLinePreviewDataCell:self];
    
    if (titles.count + details.count == 0) {
        // show placeholder
        self.labels = [NSMutableArray arrayWithCapacity:placeholders.count];
        int labelY = kMultiLinePreviewVerticleCellMargin;
        CGSize placeholderLabelSize = [self getPlaceholderLabelSize];
        
        for (NSString *placeholder in placeholders) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([self getLabelHorizontalMargin], labelY, placeholderLabelSize.width, placeholderLabelSize.height)];
            label.text = placeholder;
            label.font = [MultiLinePreviewDataCell getPlaceholderLabelFont];
            label.textColor = kPlndrMediumGreyTextColor;
            label.backgroundColor = [UIColor clearColor];
            
            [self.labels addObject:label];
            [self.contentView addSubview:label];
            
            labelY += label.frame.size.height;
            if ([placeholders indexOfObject:placeholder] != placeholders.count - 1) {
                labelY += kMultiLinePreviewLabelLineMargin;
            }
        }
     } else {
        // show title and detail
        self.labels = [NSMutableArray arrayWithCapacity:titles.count + details.count];
        int labelY = kMultiLinePreviewVerticleCellMargin;
        CGSize titleLabelSize = [self getTitleLabelSize];

        for (NSString *title in titles) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([self getLabelHorizontalMargin], labelY, titleLabelSize.width, titleLabelSize.height)];
            label.text = title;
            label.font = [MultiLinePreviewDataCell getTitleLabelFont];
            label.textColor = kPlndrBlack;
            label.backgroundColor = [UIColor clearColor];

            [self.labels addObject:label];
            [self.contentView addSubview:label];

            labelY += label.frame.size.height;
            if ([titles indexOfObject:title] != titles.count - 1) {
            labelY += kMultiLinePreviewLabelLineMargin;
            }
        }

        if (titles.count > 0 && details.count > 0) {
            labelY += kMultiLinePreviewTitleAndDetailSpacer;
        }

        CGSize detailLabelSize = [self getDetailLabelSize];

        for (NSString *detail in details) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([self getLabelHorizontalMargin], labelY, detailLabelSize.width, detailLabelSize.height)];
            label.text = detail;
            label.font = [MultiLinePreviewDataCell getDetailLabelFont];
            label.textColor = kPlndrBlack;
            label.backgroundColor = [UIColor clearColor];

            [self.labels addObject:label];
            [self.contentView addSubview:label];

            labelY += label.frame.size.height;
            if ([details indexOfObject:detail] != details.count - 1) {
                labelY += kMultiLinePreviewLabelLineMargin;
            }
        }  
    }
    
    // Setup accessory view
    CustomAccessoryType accessoryType = [self.baseDataCellDelegate getCustomAccessoryTypeForMultiLinePreviewDataCell:self];
    
    switch (accessoryType) {
        case CustomAccessoryTypeNothing:
            self.accessoryView = nil;
            self.iconView = nil;
            break;
        case CustomAccessoryTypePencil: {
            UIImage *editIcnImg = [UIImage imageNamed:@"edit_icn.png"];
            int cellHeight = [[self getHeightForTitle:titles details:details placeholder:placeholders] intValue];
            int firstLabelCenter = ((UILabel*)[self.labels objectAtIndex:0]).frame.origin.y + (((UILabel*)[self.labels objectAtIndex:0]).frame.size.height)/2;
            UIView *accessoryContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editIcnImg.size.width + 10, cellHeight)];
            self.iconView = [[UIImageView alloc] initWithImage:editIcnImg];
            self.iconView.frame = CGRectMake(0,  firstLabelCenter - editIcnImg.size.height/2, editIcnImg.size.width, editIcnImg.size.height);
            [accessoryContainer addSubview:self.iconView];
            
            self.accessoryView = accessoryContainer;
        }
            break;
        case CustomAccessoryTypePlus:
            // Fallthrough to reuse the positioning code
        case CustomAccessoryTypeDisclosure:
        {
            UIImage *iconImage = accessoryType == CustomAccessoryTypePlus ? [UIImage imageNamed:@"add_icn.png"] : [UIImage imageNamed:@"chevron.png"];
            self.iconView = [[UIImageView alloc] initWithImage:iconImage];
            UIView *accessoryContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.iconView.frame.size.width, self.iconView.frame.size.height)];
            [accessoryContainer addSubview:self.iconView];
            self.accessoryView = accessoryContainer;
        }
            break;
            
        default:
            break;
    }
    
    
    
}


+ (NSNumber*) getHeightWithMetadata:(MultiLinePreviewMetaData *)metaData {
    MultiLinePreviewDataCell *instance = [[metaData.cellClass alloc] init];
    return [instance getHeightForTitle:metaData.cellTitle details:metaData.cellDetail placeholder:metaData.cellPlaceholder];
};

- (NSNumber*) getHeight {
    NSArray *titles = [self.baseDataCellDelegate getTitleForMultiLinePreviewDataCell:self];
    NSArray *details = [self.baseDataCellDelegate getDetailForMultiLinePreviewDataCell:self];
    NSArray *placeholders = [self.baseDataCellDelegate getPlaceholderForMultiLinePreviewDataCell:self];

    return [self getHeightForTitle:titles details:details placeholder:placeholders];
}

- (NSNumber*)getHeightForTitle:(NSArray *)titles details:(NSArray *)details placeholder:(NSArray *)placeholders {
    int height = kMultiLinePreviewVerticleCellMargin*2;
    
    if (titles.count + details.count > 0) {
        if (titles.count > 0) {
            height += titles.count * [self getTitleLabelSize].height;
            height += (titles.count - 1) * kMultiLinePreviewLabelLineMargin;
        }
        if (details.count > 0) {
            height += details.count * [self getDetailLabelSize].height;
            height += (details.count - 1) * kMultiLinePreviewLabelLineMargin;
        }
        if (titles.count > 0 && details.count > 0) {
            height += kMultiLinePreviewTitleAndDetailSpacer;
        }
    } else {
        if (placeholders.count > 0) {
            height += placeholders.count * [self getPlaceholderLabelSize].height;
            height += (placeholders.count - 1) * kMultiLinePreviewLabelLineMargin;
        }
    }
    
    return [NSNumber numberWithInt:height];
}

- (void) setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    
    for (UILabel *label in self.labels) {
        label.enabled = isEnabled;
        label.alpha = [self alphaForCellContents:isEnabled];
    }

    self.iconView.alpha = [self alphaForCellContents:isEnabled];
}

#pragma mark - private

+ (UIFont *)getTitleLabelFont {
    return kFontBoldCond16;
}

+ (UIFont *) getDetailLabelFont {
    return kFontRoman16;
}

+ (UIFont *) getPlaceholderLabelFont {
    return kFontRoman16;
}

- (CGSize) getTitleLabelSize {
    CGSize sizeWithHeight = [@"SizeString!yp" sizeWithFont:[MultiLinePreviewDataCell getTitleLabelFont] constrainedToSize:CGSizeMake(kMultiLinePreviewMaxLabelWidth - ([self getLabelHorizontalMargin] - kMultiLineHorizontalCellMargin), 20) lineBreakMode:UILineBreakModeTailTruncation];
    return CGSizeMake(kMultiLinePreviewMaxLabelWidth, sizeWithHeight.height);
}

- (CGSize)getDetailLabelSize {
    CGSize sizeWithHeight =  [@"SizeString!yp" sizeWithFont:[MultiLinePreviewDataCell getDetailLabelFont] constrainedToSize:CGSizeMake(kMultiLinePreviewMaxLabelWidth - ([self getLabelHorizontalMargin] - kMultiLineHorizontalCellMargin), 20) lineBreakMode:UILineBreakModeTailTruncation];
    return CGSizeMake(kMultiLinePreviewMaxLabelWidth - ([self getLabelHorizontalMargin] - kMultiLineHorizontalCellMargin), sizeWithHeight.height);
}

- (CGSize)getPlaceholderLabelSize {
    CGSize sizeWithHeight =  [@"SizeString!yp" sizeWithFont:[MultiLinePreviewDataCell getPlaceholderLabelFont] constrainedToSize:CGSizeMake(kMultiLinePreviewMaxLabelWidth - ([self getLabelHorizontalMargin] - kMultiLineHorizontalCellMargin), 20) lineBreakMode:UILineBreakModeTailTruncation];
    return CGSizeMake(kMultiLinePreviewMaxLabelWidth - ([self getLabelHorizontalMargin] - kMultiLineHorizontalCellMargin), sizeWithHeight.height);
}

- (int)getLabelHorizontalMargin {
    return kMultiLineHorizontalCellMargin;
}

@end
