//
//  MultiLinePreviewAndCheckboxDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLinePreviewDataCell.h"

@class MultiLinePreviewAndCheckboxDataCell;

@protocol MultiLinePreviewAndCheckboxDataCellDelegate

- (BOOL) isMultiLinePreviewAndCheckboxDataCellChecked:(MultiLinePreviewAndCheckboxDataCell*)sender;
- (void) multiLinePreviewAndCheckboxDataCellCheckboxClicked:(MultiLinePreviewAndCheckboxDataCell*)sender;

@end

@interface MultiLinePreviewAndCheckboxDataCell : MultiLinePreviewDataCell

@property (nonatomic, strong) UIButton *checkboxButton;

@end
