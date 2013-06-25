//
//  MultiLinePreviewAndCheckboxDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLinePreviewAndCheckboxDataCell.h"
#import "Constants.h"

@interface MultiLinePreviewAndCheckboxDataCell()

+ (UIImage*) getCheckboxImage:(BOOL) isSelected;
- (void) checkboxClicked:(id)sender;

@end

@implementation MultiLinePreviewAndCheckboxDataCell

@synthesize checkboxButton = _checkboxButton;


- (void)initSubviews {
    [super initSubviews];
    UIImage *checkboxImage = [MultiLinePreviewAndCheckboxDataCell getCheckboxImage:NO];
    UIImage *checkboxImageHL = [MultiLinePreviewAndCheckboxDataCell getCheckboxImage:YES];
    self.checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkboxButton setImage:checkboxImage forState:UIControlStateNormal];
    [self.checkboxButton setImage:checkboxImageHL forState:UIControlStateSelected];
    [self.checkboxButton setImage:checkboxImageHL forState: UIControlStateSelected | UIControlStateHighlighted];
    [self.checkboxButton addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchDown];
    
    [self.contentView  addSubview:self.checkboxButton];
}

- (void)update {
    [super update];
    UIImage *checkboxImage = [MultiLinePreviewAndCheckboxDataCell getCheckboxImage:NO];
    self.checkboxButton.frame = CGRectMake(0, 0, checkboxImage.size.width + 2*kMultiLineHorizontalCellMargin, [self getHeight].intValue);
    if ([self.baseDataCellDelegate isMultiLinePreviewAndCheckboxDataCellChecked:self]) {
        self.checkboxButton.selected = YES;
    } else {
        self.checkboxButton.selected = NO;        
    }
    
}

+ (UIImage*) getCheckboxImage:(BOOL)isSelected {
    UIImage *checkbox;
    if (isSelected ){
        checkbox = [UIImage imageNamed:@"check_box_on.png"];
    } else {
        checkbox = [UIImage imageNamed:@"check_box.png"];
    }
    return checkbox;
}

- (int)getLabelHorizontalMargin {

    return 2 * kMultiLineHorizontalCellMargin + ((UIImage*)[MultiLinePreviewAndCheckboxDataCell getCheckboxImage:NO]).size.width;
}

- (void)checkboxClicked:(id)sender {
    [self.baseDataCellDelegate multiLinePreviewAndCheckboxDataCellCheckboxClicked:self];
}

- (void)setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    self.checkboxButton.alpha = [self alphaForCellContents:isEnabled];
}
@end
