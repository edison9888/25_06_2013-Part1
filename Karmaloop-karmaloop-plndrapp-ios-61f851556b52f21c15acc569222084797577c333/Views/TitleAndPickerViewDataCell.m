//
//  TitleAndPickerViewDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleAndPickerViewDataCell.h"
#import "Constants.h"
#import "Utility.h"

@interface TitleAndPickerViewDataCell ()

- (void) writePickerValues;

@end

@implementation TitleAndPickerViewDataCell

@synthesize pickerView = _pickerView;

- (void)initSubviews {
    [super initSubviews];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.customDetailField.inputView = self.pickerView;
    self.customDetailField.alpha = 0.0f;
    self.customDetailField.userInteractionEnabled = YES;
}

- (void)update {
    [super update];
    self.textLabel.text = [self.baseDataCellDelegate getTitleStringForTitleAndPickerDataCell:self];
    BOOL hasBeenSelected = [self.baseDataCellDelegate getHasBeenSelectedState:self];
    self.detailTextLabel.text = hasBeenSelected ? [self.baseDataCellDelegate getDetailStringForTitleAndPickerDataCell:self] : kRequired;

    
    // Reload the picker, so it starts with a clean state in this instance of the cell reuse.
    [self.pickerView reloadAllComponents];
    
    // pickerValues contains the index for every row.
    // So for every entry in pickerValues, set that row
    NSArray *pickerValues = [self.baseDataCellDelegate getPickerValuesForTitleAndPickerDataCell:self];
    for (int i = 0; i < pickerValues.count; i++) {
        [self.pickerView selectRow:[[pickerValues objectAtIndex:i] intValue] inComponent:i  animated:NO];
    }
}

- (void)setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    self.customDetailField.alpha = 0.0f;
    self.detailTextLabel.textColor = [self.baseDataCellDelegate getHasBeenSelectedState:self] ? kPlndrBlack : kPlndrLightGreyTextColor;
}

#pragma mark - private

- (void) writePickerValues {
    int numberOfColumns = [self numberOfComponentsInPickerView:self.pickerView];
    NSMutableArray *pickerValues = [NSMutableArray arrayWithCapacity:numberOfColumns];
    for (int i = 0; i < numberOfColumns; i++) {
        NSNumber *value = [NSNumber numberWithInt:[self.pickerView selectedRowInComponent:i]];
        [pickerValues addObject:value];
    }
    
    [self.baseDataCellDelegate setPickerValues:pickerValues forTitleAndPickerDataCell:self];
    if([self.baseDataCellDelegate getHasBeenSelectedState:self]) {
        self.detailTextLabel.text = [self.baseDataCellDelegate getDetailStringForTitleAndPickerDataCell:self];
        self.detailTextLabel.textColor = kPlndrBlack;    
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.pickerView reloadAllComponents];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self writePickerValues];
    if([Utility getFirstResponder] != textField) {
        [self.baseDataCellDelegate validatePickerCell:self];
    }
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSArray *data = [self.baseDataCellDelegate getDataSourcesForTitleAndPickerDataCell:self];
    return [data count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self writePickerValues];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *data = [self.baseDataCellDelegate getDataSourcesForTitleAndPickerDataCell:self];
    int rows = [[data objectAtIndex:component] count];
    return rows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *data = [self.baseDataCellDelegate getDataSourcesForTitleAndPickerDataCell:self];

    NSObject *titleObject = [[data objectAtIndex:component] objectAtIndex:row];
    if ([titleObject respondsToSelector:@selector(stringValue)]) {
        titleObject = [titleObject performSelector:@selector(stringValue) ];
    }
    return (NSString*)titleObject;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    NSArray *widths = [self.baseDataCellDelegate getColumnWidthsForTitleAndPickerDataCell:self];
    return [[widths objectAtIndex:component] intValue];
}

@end
