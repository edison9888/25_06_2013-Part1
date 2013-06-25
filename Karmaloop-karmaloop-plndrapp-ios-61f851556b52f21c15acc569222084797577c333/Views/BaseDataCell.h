//
//  DataEntryCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellMetaData.h"

@protocol BaseDataCellDelegate

@optional
- (void) executeNextBlockForBaseDataCell:(BaseDataCell*)sender;
- (void) executePreviousBlockForBaseDataCell:(BaseDataCell*)sender;
- (InputAccessoryViewType) getKeyboardAccessoryTypeForBaseDataCell:(BaseDataCell*)sender;
- (BOOL) isBaseDataCellValid:(BaseDataCell*)sender;

@end

@interface BaseDataCell : UITableViewCell

@property (nonatomic, weak) id baseDataCellDelegate;

// Protected
- (void) initSubviews;
- (void) setCellEnabled:(BOOL)isEnabled;
- (void) update;
- (UIView*) getInputAccessoryViewWithType:(InputAccessoryViewType)type;
- (UIReturnKeyType) getReturnKeyTypeForInputAccessoryView:(InputAccessoryViewType) accessoryType;
- (void) becomeFirstResponderIfCapable;
- (float) alphaForCellContents:(BOOL)isCellEnabled;
@end
