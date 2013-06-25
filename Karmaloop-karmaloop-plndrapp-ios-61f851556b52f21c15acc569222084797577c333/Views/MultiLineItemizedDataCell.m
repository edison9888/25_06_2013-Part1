//
//  MultiLineItemizedDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLineItemizedDataCell.h"
#import "Constants.h"
#import "MultiLineItemizedMetaData.h"

@interface MultiLineItemizedDataCell ()

- (NSNumber*) getHeightForItems:(NSArray*)items;

@end

@implementation MultiLineItemizedDataCell

@synthesize labels = _labels;

- (void)initSubviews {
    [super initSubviews];
}

- (void)update {
    [super update];
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    self.labels = [NSMutableArray array];
    
    // Items are pairs of attributed strings: a left and right string.
    // The right string gets priority: we will display the whole thing, on one line.
    // The left string lays itself out in the remaining space, taking multiple lines if necessary.
    NSArray *items = [self.baseDataCellDelegate getAttributedStringLineItemsMultiLineItemizedDataCell:self];
    
    int yOffset = kMultiLineItemizedVerticleCellMargin;
    for (int i = 0; i < items.count; i = i + 2) {
        NSAttributedString *leftString = [items objectAtIndex:i];
        NSAttributedString *rightString = [items objectAtIndex:i+1];
        NSRange tinyRange = NSMakeRange(0, 0);
        NSDictionary *leftAttributes = leftString.length > 0 ? [leftString attributesAtIndex:0 effectiveRange:&tinyRange] : nil;
        NSDictionary *rightAttributes = rightString.length > 0 ? [rightString attributesAtIndex:0 effectiveRange:&tinyRange] : nil;
        
        UIFont *leftFont = [leftAttributes objectForKey:kAttributedStringFont];
        UIFont *rightFont = [rightAttributes objectForKey:kAttributedStringFont];
        UIColor *leftColor = [leftAttributes objectForKey:kAttributedStringColor];
        UIColor *rightColor = [rightAttributes objectForKey:kAttributedStringColor];
        leftColor = leftColor ? leftColor : kPlndrBlack;
        rightColor = rightColor ? rightColor :kPlndrBlack;
        BOOL suppressBottomPadding = [[leftAttributes objectForKey:kAttributedStringSuppressBottomPadding] boolValue];
        
        // right
        CGSize maxRightSize = CGSizeMake(kMultiLineItemizedMaxLineWidth, 40);
        CGSize rightTextSize = [rightString.string sizeWithFont:rightFont constrainedToSize:maxRightSize lineBreakMode:UILineBreakModeTailTruncation];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMultiLineItemizedHorizontalCellMargin + kMultiLineItemizedMaxLineWidth - rightTextSize.width, yOffset, rightTextSize.width, rightTextSize.height)];
        rightLabel.text = rightString.string;
        rightLabel.font = rightFont;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = rightColor;
        [self addSubview:rightLabel];
        
        // left
        CGSize maxLeftSize = CGSizeMake(kMultiLineItemizedMaxLineWidth - rightTextSize.width - kMultiLineItemizedItemSpacer, 300);
        CGSize leftTextSize = [leftString.string sizeWithFont:leftFont constrainedToSize:maxLeftSize lineBreakMode:UILineBreakModeTailTruncation];
        
        CGSize leftOneLineHeight = [leftString.string sizeWithFont:leftFont constrainedToSize:CGSizeMake(1000, 40) lineBreakMode:UILineBreakModeTailTruncation];
        rightLabel.frame = CGRectMake(rightLabel.frame.origin.x, rightLabel.frame.origin.y, rightLabel.frame.size.width, MAX(rightLabel.frame.size.height, leftOneLineHeight.height));
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMultiLineItemizedHorizontalCellMargin, rightLabel.frame.origin.y, leftTextSize.width, leftTextSize.height)];
        leftLabel.text = leftString.string;
        leftLabel.font = leftFont;
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.textColor = leftColor;
        leftLabel.numberOfLines = 0;
        [self addSubview:leftLabel];
        
        [self.labels addObject:leftLabel];
        [self.labels addObject:rightLabel];
        
        yOffset +=  MAX(leftTextSize.height, rightTextSize.height);
        
        if (!suppressBottomPadding) {
            yOffset += kMultiLineItemizedItemLineMargin;
        }
    }
}


+ (NSNumber*) getHeightWithMetadata:(MultiLineItemizedMetaData *)metaData {
    MultiLineItemizedDataCell *instance = [[metaData.cellClass alloc] init];
    return [instance getHeightForItems:metaData.attributedStringLineItems];
};

- (NSNumber*) getHeight {
    NSArray *items = [self.baseDataCellDelegate getAttributedStringLineItemsMultiLineItemizedDataCell:self];
    
    return [self getHeightForItems:items];
}

- (NSNumber*)getHeightForItems:(NSArray *)items {
    
    // Items are pairs of attributed strings: a left and right string.
    // The right string gets priority: we will display the whole thing, on one line.
    // The left string lays itself out in the remaining space, taking multiple lines if necessary.
    
    int yOffset = kMultiLineItemizedVerticleCellMargin;
    for (int i = 0; i < items.count; i = i + 2) {
        NSAttributedString *leftString = [items objectAtIndex:i];
        NSAttributedString *rightString = [items objectAtIndex:i+1];
        NSRange tinyRange = NSMakeRange(0, 0);
        NSDictionary *leftAttributes = leftString.length > 0 ? [leftString attributesAtIndex:0 effectiveRange:&tinyRange] : nil;
        UIFont *leftFont = [leftAttributes objectForKey:kAttributedStringFont];
        UIFont *rightFont = rightString.length > 0 ? [[rightString attributesAtIndex:0 effectiveRange:&tinyRange] objectForKey:kAttributedStringFont] : nil;
        BOOL suppressBottomPadding = [[leftAttributes objectForKey:kAttributedStringSuppressBottomPadding] boolValue];

        // right
        CGSize maxRightSize = CGSizeMake(kMultiLineItemizedMaxLineWidth, 40);
        CGSize rightTextSize = [rightString.string sizeWithFont:rightFont constrainedToSize:maxRightSize lineBreakMode:UILineBreakModeTailTruncation];
        
        // left
        CGSize maxLeftSize = CGSizeMake(kMultiLineItemizedMaxLineWidth - rightTextSize.width - kMultiLineItemizedItemSpacer, 300);
        CGSize leftTextSize = [leftString.string sizeWithFont:leftFont constrainedToSize:maxLeftSize lineBreakMode:UILineBreakModeTailTruncation];
        
        yOffset += MAX(leftTextSize.height, rightTextSize.height);
        if (i < items.count - 2 && !suppressBottomPadding) {
            yOffset += kMultiLineItemizedItemLineMargin;
        }
    }
    
    return [NSNumber numberWithInt:yOffset + kMultiLineItemizedVerticleCellMargin];
}

- (void) setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    
    for (UILabel *label in self.labels) {
        label.enabled = isEnabled;
        label.alpha = [self alphaForCellContents:isEnabled];
    }
}

@end