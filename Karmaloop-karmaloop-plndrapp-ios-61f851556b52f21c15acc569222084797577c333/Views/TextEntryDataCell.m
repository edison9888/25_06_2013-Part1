//
//  TextEntryDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextEntryDataCell.h"
#import "TextFieldWithPlaceholderColor.h"
#import "Constants.h"

@implementation TextEntryDataCell

@synthesize textEntryField = _textEntryField;

- (void)initSubviews {
    [super initSubviews];
    self.textEntryField = [[TextFieldWithPlaceholderColor alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth - 40, kPOTableCellHeight)];
    self.textEntryField.backgroundColor = [UIColor clearColor];
    self.textEntryField.delegate = self;
    self.textEntryField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textEntryField.placeholderColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
    self.textEntryField.font = kFontRoman16;
    [self.contentView addSubview:self.textEntryField];
}

- (void)update {
    [super update];    
    self.textEntryField.text = [self.baseDataCellDelegate getDataForTextEntryDataCell:self];
    self.textEntryField.placeholder = [self.baseDataCellDelegate getPlaceholderStringForTextEntryDataCell:self];
    self.textEntryField.secureTextEntry = [self.baseDataCellDelegate isTextEntryDataCellSecure:self];
    UIKeyboardType keyboardType = [self.baseDataCellDelegate getCellKeyboardTypeForTextEntryDataCell:self];
    self.textEntryField.keyboardType = keyboardType;
    if (keyboardType == UIKeyboardTypeEmailAddress) {
        self.textEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    InputAccessoryViewType inputAccessoryViewType = [self.baseDataCellDelegate getKeyboardAccessoryTypeForBaseDataCell:self];
    self.textEntryField.inputAccessoryView = [self getInputAccessoryViewWithType:inputAccessoryViewType];
    self.textEntryField.returnKeyType = [self getReturnKeyTypeForInputAccessoryView:inputAccessoryViewType];
    [self setNeedsDisplay];
}

- (void) setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    
    self.textEntryField.enabled = isEnabled; 
    self.textEntryField.alpha = [self alphaForCellContents:isEnabled];
}

- (void)becomeFirstResponderIfCapable {
    [self.textEntryField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(TextFieldWithPlaceholderColor *)textField   {
    [self.baseDataCellDelegate textEntryDataCellDidBecomeActive:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.baseDataCellDelegate setDetailString:textField.text forTextEntryDataCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.baseDataCellDelegate executeNextBlockForBaseDataCell:self];
    return YES;
}

@end
