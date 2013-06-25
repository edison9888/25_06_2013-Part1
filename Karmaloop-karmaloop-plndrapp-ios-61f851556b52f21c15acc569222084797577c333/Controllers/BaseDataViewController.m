//
//  BaseDataViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataViewController.h"
#import "BaseDataCell.h"
#import "CellMetaData.h"
#import "Constants.h"
#import "Utility.h"
#import "PopupUtil.h"
#import "TitleAndTextFieldMetaData.h"
#import "TitleAndTextFieldDataCell.h"
#import "DetailAndDisclosureDataCell.h"
#import "DetailAndDisclosureMetaData.h"
#import "TitleAndPickerViewDataCell.h"
#import "TitleAndPickerViewMetaData.h"
#import "TitleAndCheckboxDataCell.h"
#import "TitleAndCheckboxMetaData.h"
#import "MultiLinePreviewDataCell.h"
#import "MultiLinePreviewMetaData.h"
#import "MultiLinePreviewAndCheckboxDataCell.h"
#import "MultiLinePreviewAndCheckboxMetaData.h"
#import "MultiLineItemizedDataCell.h"
#import "MultiLineItemizedMetaData.h"
#import "TextEntryDataCell.h"
#import "TextEntryMetaData.h"
#import "Constants.h"

const static int kSectionAsTagOffset = 1000;

@interface BaseDataViewController ()


- (void) cleanupTableDelegates;

- (int) encodeTagForIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*) decodeIndexPathForTag:(int)tag;
- (void) setupDefaultTitleAndTextFieldMetaData:(TitleAndTextFieldMetaData **)cellMetaData atIndexPath:(NSIndexPath *)indexPath;
- (void) setupDefaultMultiLinePreviewMetaData:(MultiLinePreviewMetaData **)cellMetaData atIndexPath:(NSIndexPath *)indexPath;
- (void) cellAtIndexPathWasSelected:(NSIndexPath *)indexPath;
- (void) cellAtIndexPathBecameActive:(NSIndexPath*)indexPath;

@end

@implementation BaseDataViewController

@synthesize dataTable = _dataTable, keyboardHeight = _keyboardHeight;
@synthesize isValidatingData = _isValidatingData;
@synthesize errorHeader = _errorHeader;
@synthesize errorHeaderMessage = _errorHeaderMessage;


- (id)init {
    self = [super init];
    if (self) {
        self.errorHeaderMessage =kModalErrorMessage;
    }
    return self;
}

- (void) dealloc {
    [self cleanupTableDelegates];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)loadView {
    // Implementing controllers must implement the frame
}

- (void) viewDidUnload {
    [super viewDidUnload];

    [self cleanupTableDelegates];
    self.dataTable = nil;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    CGRect tableFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.dataTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.dataTable.delegate = self;
    self.dataTable.dataSource = self;
    [self.view addSubview:self.dataTable];
    self.dataTable.backgroundColor = kPlndrBgGrey;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (CellMetaData *)getCellMetaDataForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSIndexPath *)getIndexPathForCell:(UITableViewCell *)cell {
    // Use the table look up, because it is the most up-to date (tags can become out of sync if you implement cell deletion)
    // But on cell creation, table look-up doesn't work. But tag is up-to-date. So use that as fallback.
    
    NSIndexPath *indexPath = [self.dataTable indexPathForCell:cell];
    if (!indexPath) {
        indexPath = [self decodeIndexPathForTag:cell.tag];
    }
    return indexPath;
}

- (void) makeNextFieldActive:(NSIndexPath *)indexPath {
    int lastRowInCurrentSection = [self tableView:self.dataTable numberOfRowsInSection:indexPath.section];
    int sections = [self numberOfSectionsInTableView:self.dataTable];
    
    if (sections == indexPath.section && lastRowInCurrentSection == indexPath.row) {
        return;
    }
    
    NSIndexPath *nextIndexPath;
    if(indexPath.row == lastRowInCurrentSection){
        nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
    } else{
        nextIndexPath= [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    [((BaseDataCell*)[self.dataTable cellForRowAtIndexPath:nextIndexPath]) becomeFirstResponderIfCapable];
}

- (void)makePreviousFieldActive:(NSIndexPath *)indexPath {  
    int lastRowInPreviousSection = [self tableView:self.dataTable numberOfRowsInSection:indexPath.section - 1];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        return;
    }
    
    NSIndexPath *previousIndexPath;
    if(indexPath.row == 0){
        previousIndexPath = [NSIndexPath indexPathForRow:lastRowInPreviousSection inSection:indexPath.section - 1];
    } else{
        previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    }
    [((BaseDataCell*)[self.dataTable cellForRowAtIndexPath:previousIndexPath])becomeFirstResponderIfCapable];
}

- (void)setErrorHeader:(UIView *)errorHeader {
    [self.errorHeader removeFromSuperview];
    _errorHeader = errorHeader;
}

#pragma mark - private

- (int)encodeTagForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * kSectionAsTagOffset + indexPath.row;
}

- (NSIndexPath *)decodeIndexPathForTag:(int)tag {
    if (tag == kBaseDataCellInvalidIndexTag) {
        return nil;
    }
    int section = tag / kSectionAsTagOffset;
    int row = tag % kSectionAsTagOffset;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void) cleanupTableDelegates {
    
    self.dataTable.delegate = nil;
    self.dataTable.dataSource = nil;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    self.keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    // subtract the keyboard height that exists outside the table frame
    int tableBottomY = self.dataTable.frame.origin.y + self.dataTable.frame.size.height;
    int tableBottomYInWindowCoordinates = [self.view convertPoint:CGPointMake(0, tableBottomY) toView:[[UIApplication sharedApplication].windows objectAtIndex:0]].y;
    
    int heightOfKeyboardOutsideTableBounds = (kDeviceHeight + kStatusBarHeight - tableBottomYInWindowCoordinates); 
    self.keyboardHeight -= heightOfKeyboardOutsideTableBounds;
    
    [self shiftContentToBeVisibleWithCurrentKeyboard];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.dataTable.contentInset = contentInsets;
    self.dataTable.scrollIndicatorInsets = contentInsets;
    self.keyboardHeight = 0;
}

- (void) shiftContentToBeVisibleWithCurrentKeyboard {
    if (![PopupUtil isPopupShowing]) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, self.keyboardHeight, 0);
        self.dataTable.contentInset = contentInsets;
        self.dataTable.scrollIndicatorInsets = contentInsets;
        
        CGRect frameRect = self.dataTable.frame;
        frameRect.size.height -= self.keyboardHeight;
        
        UIView *activeView = [Utility getFirstResponder];
        CGPoint bottomOfField = CGPointMake(0, activeView.frame.origin.y + activeView.frame.size.height);
        CGPoint bottomOfFieldInTableCoords = [activeView.superview convertPoint:bottomOfField toView:self.dataTable];
        bottomOfFieldInTableCoords.y -= self.dataTable.contentOffset.y;
        
        CGPoint topOfField = CGPointMake(0, activeView.frame.origin.y);
        CGPoint topOfFieldInTableCoords = [activeView.superview convertPoint:topOfField toView:self.dataTable];
        
        int coveredBottomY = bottomOfFieldInTableCoords.y - frameRect.size.height;
        int coveredTopY = self.dataTable.contentOffset.y - topOfFieldInTableCoords.y;
        int keyboardPadding = 7;
        
        if (coveredBottomY > 0 ) {
            CGPoint offset = self.dataTable.contentOffset;
            offset.y += coveredBottomY + keyboardPadding;
            [self.dataTable setContentOffset:offset animated:YES];
        } else if (coveredTopY > 0) {
            CGPoint offset = self.dataTable.contentOffset;
            offset.y -= coveredTopY + keyboardPadding;
            [self.dataTable setContentOffset:offset animated:YES];
        }
    }
}

- (void) cellAtIndexPathWasSelected:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    if (cellMetaData.didSelectBlock) {
        cellMetaData.didSelectBlock();
    }
}

- (void) cellAtIndexPathBecameActive:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    if (cellMetaData.didBecomeFirstResponderBlock) {
        cellMetaData.didBecomeFirstResponderBlock();
    }
}

- (void)resetErrorHeader {
    self.errorHeader = nil;
    [self.dataTable reloadData];
}

- (void)showDataErrors {
    [self setErrorHeaderWithMessage:self.errorHeaderMessage];
    self.isValidatingData = YES;
    [self.dataTable reloadData];
}

- (void)setErrorHeaderWithMessage:(NSString *)errorMessage {
    CGSize errorMessageSize = [errorMessage sizeWithFont:kFontHeaderErrorMessage constrainedToSize:CGSizeMake(300, 15) lineBreakMode:UILineBreakModeTailTruncation];
    self.errorHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, fmax(kErrorHeaderHeight,(errorMessageSize.height +2*kErrorHeaderMargin)))];
    UIView *blackBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, errorMessageSize.height + 2*kErrorHeaderMargin)];
    blackBanner.backgroundColor = kPlndrDarkBgGrey;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(kErrorHeaderMargin, 0, kDeviceWidth - 2*kErrorHeaderMargin, blackBanner.frame.size.height)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = kPlndrWhite;
    headerLabel.font = kFontHeaderErrorMessage;
    headerLabel.lineBreakMode = UILineBreakModeTailTruncation;
    headerLabel.numberOfLines = 3;
    headerLabel.text = errorMessage;
    [blackBanner addSubview:headerLabel];
    [self.errorHeader addSubview:blackBanner];
}

- (BOOL) isDataViewValid {
    // TO BE OVERRIDDEN
    return YES;
}

- (void) revalidateDataCell:(BaseDataCell*)sender {
    if ([self isDataViewValid]) {
        [self resetErrorHeader];
    } else {
        if (self.errorHeader) {
            NSIndexPath *indexPath = [self getIndexPathForCell:sender];
            [self.dataTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            if(self.isValidatingData) {
                [self showDataErrors];
                [self.dataTable reloadData];
            }
        }
    }
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    NSString *reuseIdentifier = NSStringFromClass(cellMetaData.cellClass);

    BaseDataCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[cellMetaData.cellClass alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    cell.baseDataCellDelegate = self;
    cell.tag = [self encodeTagForIndexPath:indexPath];

    [cell update];    
    [cell setCellEnabled:cellMetaData.isRowEnabled];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPOTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self cellAtIndexPathWasSelected:indexPath];
    [self.dataTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4.0;
}

#pragma mark - MetaData convenience functions

- (void) setupDefaultTitleAndTextFieldMetaData:(TitleAndTextFieldMetaData **)cellMetaData atIndexPath:(NSIndexPath *)indexPath {
    (*cellMetaData).inputAccessoryViewType = InputAccessoryPreviousNextDismiss;
    [*cellMetaData setPerformNextAction:^(void) {
        [self makeNextFieldActive:indexPath];
    }];
    [*cellMetaData setPerformPreviousAction:^(void) {
        [self makePreviousFieldActive:indexPath];
    }];
    [*cellMetaData setDidSelectBlock:^(void) {
        [((BaseDataCell*)[self.dataTable cellForRowAtIndexPath:indexPath]) becomeFirstResponderIfCapable];
    }];
}

- (TitleAndTextFieldMetaData*) getDefaultTitleAndTextFieldMetaDataAtIndexPath:(NSIndexPath*)indexPath {
    TitleAndTextFieldMetaData *cellMetaData = [[TitleAndTextFieldMetaData alloc] init];
    [self setupDefaultTitleAndTextFieldMetaData:&cellMetaData atIndexPath:indexPath];
    cellMetaData.cellClass = [TitleAndTextFieldDataCell class];
    cellMetaData.cellDetailGhost = kRequired;
    return cellMetaData;
}

- (TitleAndPickerViewMetaData *)getDefaultTitleAndPickerFieldMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    TitleAndPickerViewMetaData *cellMetaData = [[TitleAndPickerViewMetaData alloc] init];
    [self setupDefaultTitleAndTextFieldMetaData:&cellMetaData atIndexPath:indexPath];
    cellMetaData.cellClass = [TitleAndPickerViewDataCell class];
    [cellMetaData setDidSelectBlock:^(void) {
        [((TitleAndPickerViewDataCell*)[self.dataTable cellForRowAtIndexPath:indexPath]).pickerView reloadAllComponents];
        [((BaseDataCell*)[self.dataTable cellForRowAtIndexPath:indexPath]) becomeFirstResponderIfCapable];
    }];
    return cellMetaData;
}

- (DetailAndDisclosureMetaData *)getDefaultDetailsAndDisclosureMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    DetailAndDisclosureMetaData *cellMetaData = [[DetailAndDisclosureMetaData alloc] init];
    cellMetaData.cellClass = [DetailAndDisclosureDataCell class];
    cellMetaData.cellDetail = @"";
    return cellMetaData;
}

- (TextEntryMetaData *)getDefaultTextEntryMetaDataAtIndexPath:(NSIndexPath *)indexPath{
    TextEntryMetaData *cellMetaData = [[TextEntryMetaData alloc] init];
    cellMetaData.cellClass = [TextEntryDataCell class];
    [cellMetaData setPerformPreviousAction :^(void) {
        [self makePreviousFieldActive:indexPath];
    }];
    [cellMetaData setPerformNextAction :^(void) {
        [self makeNextFieldActive:indexPath];
    }];
    cellMetaData.inputAccessoryViewType = InputAccessoryPreviousNextDismiss;
    [cellMetaData setDidSelectBlock:^(void) {
        [((BaseDataCell*)[self.dataTable cellForRowAtIndexPath:indexPath]) becomeFirstResponderIfCapable];
    }];
    return cellMetaData;
}

- (void) setupDefaultMultiLinePreviewMetaData:(MultiLinePreviewMetaData **)cellMetaData atIndexPath:(NSIndexPath *)indexPath {
    (*cellMetaData).cellPlaceholder = [NSArray arrayWithObjects:@"Please enter info", nil];
    (*cellMetaData).customAccessoryType = CustomAccessoryTypePencil;
}

- (MultiLinePreviewMetaData *)getDefaultMultiLinePreviewMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    MultiLinePreviewMetaData *cellMetaData = [[MultiLinePreviewMetaData alloc] init];
    [self setupDefaultMultiLinePreviewMetaData:&cellMetaData atIndexPath:indexPath];
    cellMetaData.cellClass = [MultiLinePreviewDataCell class];
    return cellMetaData;
}

- (MultiLineItemizedMetaData *)getDefaultMultiLineItemizedMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    MultiLineItemizedMetaData *cellMetaData = [[MultiLineItemizedMetaData alloc] init];
    cellMetaData.cellClass = [MultiLineItemizedDataCell class];
    return cellMetaData;
}

- (TitleAndCheckboxMetaData *)getDefaultTitleAndCheckboxMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    TitleAndCheckboxMetaData *cellMetaData = [[TitleAndCheckboxMetaData alloc] init];
    cellMetaData.cellClass = [TitleAndCheckboxDataCell class];
    return cellMetaData;
}

- (MultiLinePreviewAndCheckboxMetaData *)getDefaultMultiLinePreviewAndCheckboxMetaDataAtIndexPath:(NSIndexPath *)indexPath {
    MultiLinePreviewAndCheckboxMetaData *cellMetaData = [[MultiLinePreviewAndCheckboxMetaData alloc] init];
    [self setupDefaultMultiLinePreviewMetaData:&cellMetaData atIndexPath:indexPath];
    cellMetaData.cellClass = [MultiLinePreviewAndCheckboxDataCell class];
    return cellMetaData;
}

#pragma mark - BaseDataCellDelegate

- (BOOL)isBaseDataCellValid:(BaseDataCell *)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.isValid;
}

- (void) executeNextBlockForBaseDataCell:(BaseDataCell *)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    if (cellMetaData.performNextAction) {
        cellMetaData.performNextAction(); 
    }
}

- (void) executePreviousBlockForBaseDataCell:(BaseDataCell *)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    if (cellMetaData.performPreviousAction) {
        cellMetaData.performPreviousAction(); 
    }
}

- (InputAccessoryViewType)getKeyboardAccessoryTypeForBaseDataCell:(BaseDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.inputAccessoryViewType;
}

#pragma mark - TitleAndTextFieldDataCellDelegate

- (NSString*) getTitleStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellTitle;
}

- (NSString*) getDetailStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellDetail;
}

- (NSString*) getDetailGhostStringForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellDetailGhost;
}

- (BOOL) shouldDetailStringBeSet:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.isDetailValidBlock(detailString);
}

- (void) setDetailString:(NSString*)detailString forTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell*)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    cellMetaData.writeDetailBlock(detailString);
}

- (UIKeyboardType)getKeyboardTypeForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell *)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.keyboardType;
}

- (void) titleAndTextFieldDataCellDidBecomeActive:(TitleAndTextFieldDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    [self cellAtIndexPathBecameActive:indexPath];
    [self shiftContentToBeVisibleWithCurrentKeyboard];
}

- (BOOL)shouldTextFieldBeSecureForTitleAndTextFieldDataCell:(TitleAndTextFieldDataCell *)sender {
    TitleAndTextFieldMetaData *cellMetaData = (TitleAndTextFieldMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.isSecure;
}

#pragma mark - TextEntryDataCellDelegate Methods

- (NSString*)getDataForTextEntryDataCell:(TextEntryDataCell*)sender {
    TextEntryMetaData *cellMetaData = (TextEntryMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellData;
}

- (NSString*)getPlaceholderStringForTextEntryDataCell:(TextEntryDataCell*)sender {
    TextEntryMetaData *cellMetaData = (TextEntryMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellPlaceholder;
}

- (UIKeyboardType)getCellKeyboardTypeForTextEntryDataCell:(TextEntryDataCell *)sender {
    TextEntryMetaData *cellMetaData = (TextEntryMetaData*) [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.cellKeyboardType;
}

- (void)textEntryDataCellDidBecomeActive:(TextEntryDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    [self cellAtIndexPathBecameActive:indexPath];
    [self shiftContentToBeVisibleWithCurrentKeyboard];
}

- (void)setDetailString:(NSString*)dataString forTextEntryDataCell:(TextEntryDataCell*)sender {
    TextEntryMetaData *cellMetaData = (TextEntryMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    cellMetaData.writeDataBlock(dataString);
}

- (BOOL)isTextEntryDataCellSecure:(TextEntryDataCell*)sender {
    TextEntryMetaData *cellMetaData = (TextEntryMetaData*)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return cellMetaData.isSecure;
}

#pragma mark - TitleAndPickerViewDataCellDelegate

- (NSString*) getTitleStringForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.cellTitle;
}

- (NSString*) getDetailStringForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.cellDetail;
}

- (NSArray*) getDataSourcesForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.pickerDataSources;
}

- (NSArray*) getColumnWidthsForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.pickerColumnWidths;
}

- (NSArray*) getPickerValuesForTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.pickerValues;
}

- (void) setPickerValues:(NSArray*)values forTitleAndPickerDataCell:(TitleAndPickerViewDataCell*)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    cellMetaData.writePickerValuesBlock(values);
}

- (BOOL)getHasBeenSelectedState:(TitleAndPickerViewDataCell *)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    TitleAndPickerViewMetaData *cellMetaData = (TitleAndPickerViewMetaData*)[self getCellMetaDataForIndexPath:indexPath];
    return cellMetaData.hasBeenSelected;
}

- (void)validatePickerCell:(TitleAndPickerViewDataCell *)sender {
// Overriden in Base Modal View    
}

#pragma mark - DetailAndDisclosureDataCellDelegate 

- (NSString *)getTitleStringForDetailAndDisclosureDataCell:(DetailAndDisclosureDataCell *)sender {
    DetailAndDisclosureMetaData *metaData = ((DetailAndDisclosureMetaData *)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]]);
    return metaData.cellTitle;
}

- (NSString *)getDetailStringForDetailAndDisclosureDataCell:(DetailAndDisclosureDataCell *)sender {
    DetailAndDisclosureMetaData *metaData = ((DetailAndDisclosureMetaData *)[self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]]);
    return metaData.cellDetail;
}

#pragma mark - TitleAndCheckboxDataCellDelegate Methods

- (NSString *)getTitleStringForTitleAndCheckboxDataCell:(TitleAndCheckboxDataCell *)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((TitleAndCheckboxMetaData*)cellMetaData).cellTitle;
}

- (BOOL) isTitleAndCheckboxDataCellChecked:(TitleAndCheckboxDataCell *)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((TitleAndCheckboxMetaData*)cellMetaData).isChecked;
}

#pragma mark - MultiLinePreviewDataCellDelegate Methods

- (NSArray*) getTitleForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLinePreviewMetaData *)cellMetaData).cellTitle;
}
- (NSArray*) getDetailForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLinePreviewMetaData *)cellMetaData).cellDetail;
}
- (NSArray*) getPlaceholderForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender{
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLinePreviewMetaData *)cellMetaData).cellPlaceholder;
}

- (CustomAccessoryType) getCustomAccessoryTypeForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLinePreviewMetaData *)cellMetaData).customAccessoryType;
}

#pragma mark - MultiLineItemizedDataCellDelegate Methods

- (NSArray*) getAttributedStringLineItemsMultiLineItemizedDataCell:(MultiLineItemizedDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLineItemizedMetaData *)cellMetaData).attributedStringLineItems;
}

#pragma mark - MultiLinePreviewAndCheckboxDataCellDelegate Methods

- (BOOL)isMultiLinePreviewAndCheckboxDataCellChecked:(MultiLinePreviewAndCheckboxDataCell *)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    return ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).isChecked;
}

- (void) multiLinePreviewAndCheckboxDataCellCheckboxClicked:(MultiLinePreviewAndCheckboxDataCell*)sender {
    CellMetaData *cellMetaData = [self getCellMetaDataForIndexPath:[self getIndexPathForCell:sender]];
    if (((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).clickedCheckbox) {
        ((MultiLinePreviewAndCheckboxMetaData*)cellMetaData).clickedCheckbox(); 
    }
}

@end
