//
//  TextEntryPopupView.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextEntryPopupView.h"
#import "Constants.h"
#import "TextFieldWithPlaceholderColor.h"

@interface TextEntryPopupView ()

- (void) initSubviews;
- (void) submitClicked;

@end

@implementation TextEntryPopupView

@synthesize popupTitle = _popupTitle, instructions = _instructions, errorMessage = _errorMessage, errorLabel = _errorLabel, spinner = _spinner;

- (id)initWithTitle:(NSString *)title instructions:(NSString *)instructions errorMessage:(NSString*)errorMessage textEntryDelegate:(id<TextEntryPopupViewDelegate>)textEntryDelegate {
    _popupTitle = title;
    _instructions = instructions;
    _errorMessage = errorMessage;
    
    self.popupViewDelegate = textEntryDelegate;    
    self = [super init];
    return self;
}

- (void) initSubviews {   
    [super initSubviews];
    
    int contentWidth = kPopupWidth - 2*kPopupHorizontalMargin;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:18.0f];
    CGSize titleLabelSize = [self.popupTitle sizeWithFont:titleFont
                                    constrainedToSize:CGSizeMake(contentWidth, 25)
                                        lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(kPopupHorizontalMargin, kPopupVerticalMargin, titleLabelSize.width, titleLabelSize.height);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.popupTitle;
    titleLabel.textColor = kPlndrDarkGreyTextColor;
    titleLabel.font = titleFont;
    [self addSubview:titleLabel];
    
    UIFont *instructionFont = [UIFont systemFontOfSize:16.0f];
    CGSize instructionLabelSize = [self.instructions sizeWithFont:instructionFont
                                                constrainedToSize:CGSizeMake(contentWidth, 50)
                                                    lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + kPopupVerticalMargin, instructionLabelSize.width, instructionLabelSize.height);
    instructionLabel.numberOfLines = 2;
    instructionLabel.backgroundColor = [UIColor clearColor];
    instructionLabel.font = instructionFont;
    instructionLabel.text = self.instructions;
    instructionLabel.textColor = kPlndrMediumGreyTextColor;
    [self addSubview:instructionLabel];
    
    
    UIFont *errorFont = [UIFont systemFontOfSize:12];
    CGSize errorLabelSize = [self.errorMessage sizeWithFont:errorFont
                                constrainedToSize:CGSizeMake(contentWidth, 25)
                                            lineBreakMode:UILineBreakModeTailTruncation];
    
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.frame = CGRectMake(titleLabel.frame.origin.x, instructionLabel.frame.origin.y + instructionLabel.frame.size.height + kPopupVerticalMargin/2, contentWidth, errorLabelSize.height);
    self.errorLabel.numberOfLines = 1;
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.font = errorFont;
    self.errorLabel.text = self.errorMessage;
    self.errorLabel.textColor = kPlndrTextRed;
    self.errorLabel.backgroundColor = [UIColor clearColor];
    self.errorLabel.hidden = YES;
    [self addSubview:self.errorLabel];
    
    self.spinner = [[UIActivityIndicatorView alloc] init];
    self.spinner.center = CGPointMake(self.errorLabel.frame.origin.x + self.errorLabel.frame.size.width/2, self.errorLabel.frame.origin.y + self.errorLabel.frame.size.height/2);
    self.spinner.color = kPlndrTextGold;
    [self addSubview:self.spinner];
    
    UIImage *textEntryBG = [UIImage imageNamed:@"text_entry.png"];
    UIImageView *textEntryBGView = [[UIImageView alloc] initWithImage:textEntryBG];
    textEntryBGView.frame = CGRectMake((kPopupWidth - textEntryBG.size.width)/2, self.errorLabel.frame.origin.y + self.errorLabel.frame.size.height + kPopupVerticalMargin/2, textEntryBG.size.width, textEntryBG.size.height);
    
    [self addSubview:textEntryBGView];
    
    int entryFieldHeight = 30;
    int entryHorizontalPadding = 8;
    TextFieldWithPlaceholderColor *textEntryField = [[TextFieldWithPlaceholderColor alloc] initWithFrame:CGRectMake(textEntryBGView.frame.origin.x + entryHorizontalPadding, textEntryBGView.frame.origin.y + (textEntryBG.size.height - entryFieldHeight)/2, textEntryBG.size.width - 2*entryHorizontalPadding, entryFieldHeight)];
    textEntryField.placeholderColor = kPlndrMediumGreyTextColor;
    textEntryField.placeholder = @"Email";
    textEntryField.delegate = self;
    textEntryField.keyboardType = UIKeyboardTypeEmailAddress;
    textEntryField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    textEntryField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:textEntryField];    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *submitImage = [UIImage imageNamed:@"yellow_btn.png"];
    [submitButton setBackgroundImage:submitImage forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"yellow_btn_hl.png"] forState:UIControlStateHighlighted];
    submitButton.frame = CGRectMake((kPopupWidth - submitImage.size.width)/2, textEntryBGView.frame.origin.y + textEntryBGView.frame.size.height + kPopupVerticalMargin, submitImage.size.width, submitImage.size.height);
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    submitButton.titleLabel.font = kFontBoldCond17;
    [submitButton addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
    [textEntryField becomeFirstResponder];
    
    self.frame = CGRectMake(0,0,kPopupWidth,submitButton.frame.origin.y + submitButton.frame.size.height + kPopupVerticalMargin);
    [self setBackgroundViewFrame];
}

- (void) submitClicked {
    [self endEditing:YES];
    [self.popupViewDelegate textEntryPopupViewDidSubmit:self];
}

- (void)showLoadingView {
    self.errorLabel.hidden = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)hideLoadingView {
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.popupViewDelegate textEntryPopupView:self didEnterText:textField.text];
}

@end
