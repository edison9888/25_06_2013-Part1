//
//  TitleAndTextFieldDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"
#import "TextFieldWithPlaceholderColor.h"

@class TitleAndTextFieldDataCell;

@protocol TitleAndTextFieldDataCellDelegate

- (NSString*) getTitleStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (NSString*) getDetailStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (NSString*) getDetailGhostStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (BOOL) shouldDetailStringBeSet:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (void) setDetailString:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (void) titleAndTextFieldDataCellDidBecomeActive:(TitleAndTextFieldDataCell*)sender;
- (UIKeyboardType) getKeyboardTypeForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;
- (BOOL) shouldTextFieldBeSecureForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender;

@end

@interface TitleAndTextFieldDataCell : BaseDataCell <UITextFieldDelegate>

@property (nonatomic, strong) TextFieldWithPlaceholderColor *customDetailField;

@end
