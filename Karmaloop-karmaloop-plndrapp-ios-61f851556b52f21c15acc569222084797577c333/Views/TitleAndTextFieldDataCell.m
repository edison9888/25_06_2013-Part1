//
//  TitleAndTextFieldDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleAndTextFieldDataCell.h"
#import "Constants.h"

@implementation TitleAndTextFieldDataCell

@synthesize customDetailField = _customDetailField;

- (void)initSubviews {
    [super initSubviews];
    self.customDetailField = [[TextFieldWithPlaceholderColor alloc] initWithFrame:CGRectMake(kDeviceWidth/2 - kTitleAndTextPadding, 0, kDeviceWidth/2 - 2*kTitleAndTextPadding, kPOTableCellHeight)];
    self.customDetailField.backgroundColor = [UIColor clearColor];
    self.customDetailField.delegate = self;
    self.customDetailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.customDetailField.textAlignment = UITextAlignmentRight;
    self.customDetailField.placeholderColor = kPlndrLightGreyTextColor;
    self.customDetailField.font = kFontRoman16;
    [self.contentView addSubview:self.customDetailField];
}

- (void)update {
    [super update];
    self.textLabel.text = [self.baseDataCellDelegate getTitleStringForTitleAndTextFieldDataCell:self];
    [self.textLabel sizeToFit];
    NSString* detailString = [self.baseDataCellDelegate getDetailStringForTitleAndTextFieldDataCell:self];
    if (detailString.length > 0) {
        self.customDetailField.text = detailString;
    } else {
        self.customDetailField.text = nil;
    }
    int customDetailXOrigin = 2*kTitleAndTextPadding + self.textLabel.frame.origin.x + self.textLabel.frame.size.width;
    self.customDetailField.frame = CGRectMake(customDetailXOrigin, 0.0f,kDeviceWidth - customDetailXOrigin - 3*kTitleAndTextPadding, self.customDetailField.frame.size.height);
    
    self.customDetailField.placeholder = [self.baseDataCellDelegate getDetailGhostStringForTitleAndTextFieldDataCell:self];
    UIKeyboardType keyboardType = [self.baseDataCellDelegate getKeyboardTypeForTitleAndTextFieldDataCell:self];
    self.customDetailField.keyboardType = keyboardType;
    if (keyboardType == UIKeyboardTypeEmailAddress) {
        self.customDetailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.customDetailField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    self.customDetailField.secureTextEntry = [self.baseDataCellDelegate shouldTextFieldBeSecureForTitleAndTextFieldDataCell:self];
    InputAccessoryViewType inputAccessoryViewType = [self.baseDataCellDelegate getKeyboardAccessoryTypeForBaseDataCell:self];
    self.customDetailField.inputAccessoryView = [self getInputAccessoryViewWithType:inputAccessoryViewType];
    self.customDetailField.returnKeyType = [self getReturnKeyTypeForInputAccessoryView:inputAccessoryViewType];
    [self setNeedsDisplay];
}

- (void) setCellEnabled:(BOOL)isEnabled {
    [super setCellEnabled:isEnabled];
    
    self.customDetailField.enabled = isEnabled; 
    self.customDetailField.alpha = [self alphaForCellContents:isEnabled];

}

- (void)becomeFirstResponderIfCapable {
    [self.customDetailField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(TextFieldWithPlaceholderColor *)textField   {
    [self.baseDataCellDelegate titleAndTextFieldDataCellDidBecomeActive:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.baseDataCellDelegate setDetailString:textField.text forTitleAndTextFieldDataCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.baseDataCellDelegate executeNextBlockForBaseDataCell:self];
    return YES;
}

@end
