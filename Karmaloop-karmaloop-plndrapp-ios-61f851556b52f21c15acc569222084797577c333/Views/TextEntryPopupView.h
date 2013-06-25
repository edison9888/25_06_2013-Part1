//
//  TextEntryPopupView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupView.h"

@class TextEntryPopupView;

@protocol TextEntryPopupViewDelegate <NSObject>

- (void) textEntryPopupView:(TextEntryPopupView*)sender didEnterText:(NSString*)text;
- (void) textEntryPopupViewDidSubmit:(TextEntryPopupView *)sender;

@end

@interface TextEntryPopupView : PopupView <UITextFieldDelegate>

@property (nonatomic, strong) NSString *popupTitle;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

- (id) initWithTitle:(NSString*)title instructions:(NSString*)instructions errorMessage:(NSString*)errorMessage textEntryDelegate:(id<TextEntryPopupViewDelegate>)textEntryDelegate;
- (void) showLoadingView;
- (void) hideLoadingView;

@end
