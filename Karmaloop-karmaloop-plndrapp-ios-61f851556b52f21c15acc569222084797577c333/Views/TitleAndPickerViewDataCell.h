//
//  TitleAndPickerViewDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleAndTextFieldDataCell.h"

@class TitleAndPickerViewDataCell;

@protocol TitleAndPickerViewDataCellDelegate

- (NSString*) getTitleStringForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (NSString*) getDetailStringForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (NSArray*) getDataSourcesForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (NSArray*) getColumnWidthsForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (NSArray*) getPickerValuesForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (void) setPickerValues:(NSArray*)values forTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender;
- (BOOL) getHasBeenSelectedState:(TitleAndPickerViewDataCell*)sender;
- (void) validatePickerCell:(TitleAndPickerViewDataCell*)sender;

@end

@interface TitleAndPickerViewDataCell : TitleAndTextFieldDataCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@end