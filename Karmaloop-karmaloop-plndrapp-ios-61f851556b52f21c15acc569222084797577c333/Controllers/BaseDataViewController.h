//
//  BaseDataViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlndrBaseViewController.h"
#import "DetailAndDisclosureDataCell.h"
#import "TitleAndTextFieldDataCell.h"
#import "TitleAndPickerViewDataCell.h"
#import "TitleAndCheckboxDataCell.h"
#import "MultiLinePreviewDataCell.h"
#import "MultiLinePreviewAndCheckboxDataCell.h"
#import "MultiLineItemizedDataCell.h"
#import "TextEntryDataCell.h"
#import "BaseDataCell.h"

@class TitleAndTextFieldMetaData, TitleAndPickerViewMetaData, DetailAndDisclosureMetaData, TextEntryMetaData, MultiLinePreviewMetaData, TitleAndCheckboxMetaData, MultiLinePreviewAndCheckboxMetaData, MultiLineItemizedMetaData;

@interface BaseDataViewController : PlndrBaseViewController <UITableViewDelegate, UITableViewDataSource, BaseDataCellDelegate, TitleAndTextFieldDataCellDelegate, DetailAndDisclosureDataCellDelegate, TitleAndPickerViewDataCellDelegate, TitleAndCheckboxDataCellDelegate, TextEntryDataCellDelegate, MultiLinePreviewDataCellDelegate, MultiLinePreviewAndCheckboxDataCellDelegate, MultiLineItemizedDataCellDelegate>


@property (nonatomic, strong) UITableView *dataTable;
@property int keyboardHeight;
@property BOOL isValidatingData;
@property (nonatomic, strong) UIView *errorHeader;
@property (nonatomic, strong) NSString *errorHeaderMessage;

// Base implementations for data driven controllers

- (CellMetaData*)getCellMetaDataForIndexPath:(NSIndexPath*)indexPath;
- (void) shiftContentToBeVisibleWithCurrentKeyboard;

- (NSIndexPath*) getIndexPathForCell:(UITableViewCell*)cell;

- (void) makeNextFieldActive:(NSIndexPath *)indexPath;
- (void) makePreviousFieldActive:(NSIndexPath *)indexPath;  

- (void) showDataErrors;
- (void) setErrorHeaderWithMessage:(NSString*) errorMessage;
- (void) resetErrorHeader;
- (BOOL) isDataViewValid;
- (void) revalidateDataCell:(BaseDataCell*)sender;

- (TitleAndTextFieldMetaData*) getDefaultTitleAndTextFieldMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (TitleAndPickerViewMetaData*) getDefaultTitleAndPickerFieldMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (DetailAndDisclosureMetaData *)getDefaultDetailsAndDisclosureMetaDataAtIndexPath:(NSIndexPath *)indexPath;
- (TextEntryMetaData *)getDefaultTextEntryMetaDataAtIndexPath:(NSIndexPath *)indexPath;
- (MultiLinePreviewMetaData*) getDefaultMultiLinePreviewMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (MultiLinePreviewAndCheckboxMetaData*) getDefaultMultiLinePreviewAndCheckboxMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (MultiLineItemizedMetaData*) getDefaultMultiLineItemizedMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (TitleAndCheckboxMetaData*) getDefaultTitleAndCheckboxMetaDataAtIndexPath:(NSIndexPath*)indexPath;
- (void) keyboardDidShow:(NSNotification*)notification;
- (void) keyboardDidHide:(NSNotification*)notification;

@end
