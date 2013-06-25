//
//  TextEntryDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"
#import "TextFieldWithPlaceholderColor.h"
#import "CellMetaData.h"

@class TextEntryDataCell;

@protocol TextEntryDataCellDelegate

- (NSString*)getDataForTextEntryDataCell:(TextEntryDataCell*)sender;
- (NSString*)getPlaceholderStringForTextEntryDataCell:(TextEntryDataCell*)sender;
- (UIKeyboardType) getCellKeyboardTypeForTextEntryDataCell:(TextEntryDataCell*)sender;
- (void)textEntryDataCellDidBecomeActive:(TextEntryDataCell*)sender;
- (void)setDetailString:(NSString*)dataString forTextEntryDataCell:(TextEntryDataCell*)sender;
- (BOOL)isTextEntryDataCellSecure:(TextEntryDataCell*)sender;

@end

@interface TextEntryDataCell : BaseDataCell <UITextFieldDelegate>

@property (nonatomic, strong) TextFieldWithPlaceholderColor *textEntryField;

@end
