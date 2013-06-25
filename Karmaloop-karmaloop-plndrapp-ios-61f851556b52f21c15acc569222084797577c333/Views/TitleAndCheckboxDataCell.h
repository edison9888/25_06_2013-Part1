//
//  TitleAndCheckboxDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"

@class TitleAndCheckboxDataCell;

@protocol TitleAndCheckboxDataCellDelegate

- (NSString*) getTitleStringForTitleAndCheckboxDataCell:(TitleAndCheckboxDataCell*)sender;
- (BOOL) isTitleAndCheckboxDataCellChecked:(TitleAndCheckboxDataCell*)sender;

@end

@interface TitleAndCheckboxDataCell : BaseDataCell

@end
