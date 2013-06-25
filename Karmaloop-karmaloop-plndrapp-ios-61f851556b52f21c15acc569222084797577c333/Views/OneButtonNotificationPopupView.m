//
//  OneButtonNotificationPopupView.m
//  karmaloop-plndrapp-ios
//
//  Created by xtremelabs on 12-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OneButtonNotificationPopupView.h"


#import "Constants.h"

@interface OneButtonNotificationPopupView ()

- (void) initSubviews;
- (void) buttonOneClicked:(id)sender;

@end

@implementation OneButtonNotificationPopupView

@synthesize popupTitle = _popupTitle;
@synthesize message = _message;
@synthesize buttonOneTitle = _buttonOneTitle;


- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message withButtonOneTitle:(NSString *)titleOne withPopupViewDelegate:(id<PopupViewDelegate>)popupViewDelegate{
    _popupTitle = title;
    _message = message;
    _buttonOneTitle = titleOne;
    self.popupViewDelegate = popupViewDelegate;
    self = [super init];
    return  self;
}

- (void) initSubviews {
    [super initSubviews];
    
    int contentWidth = kPopupWidth - 2*kPopupHorizontalMargin;
    
    UIFont *titleFont = kFontBoldCond20;
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
    
    UIFont *messageFont = kFontRoman16;
    CGSize messageLabelSize = [self.message sizeWithFont:messageFont
                                       constrainedToSize:CGSizeMake(contentWidth, 80)
                                           lineBreakMode:UILineBreakModeTailTruncation];
    
    UIImage *yellowButtonImg = [UIImage imageNamed:@"yellow_btn.png"];
    UIImage *yellowButtonImgHL = [UIImage imageNamed:@"yellow_btn_hl.png"];
    int maxHeight = MAX(kPopupOneButtonHeight,kPopupVerticalMargin+titleLabel.frame.size.height+messageLabelSize.height+kPopupVerticalMargin+yellowButtonImg.size.height+kPopupVerticalMargin);
    self.frame = CGRectMake(0,0,kPopupWidth,maxHeight);

    UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonOne setBackgroundImage:yellowButtonImg forState:UIControlStateNormal];
    [buttonOne setBackgroundImage:yellowButtonImgHL forState:UIControlStateHighlighted];
    [buttonOne setTitle:self.buttonOneTitle forState:UIControlStateNormal];
    [buttonOne setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    buttonOne.titleLabel.font = kFontBoldCond17;
    buttonOne.frame = CGRectMake((kPopupWidth - yellowButtonImg.size.width)/2, maxHeight - (2*kPopupVerticalMargin) - yellowButtonImg.size.height, yellowButtonImg.size.width, yellowButtonImg.size.height);
    [buttonOne addTarget:self action:@selector(buttonOneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonOne];
    
    
    UILabel *messageLabel = [[UILabel alloc] init];
    int messageTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + kPopupVerticalMargin;
    int buttonOneHeight = buttonOne.frame.size.height + 2*kPopupVerticalMargin;
    
    messageLabel.frame = CGRectMake(titleLabel.frame.origin.x, messageTop, messageLabelSize.width, maxHeight - messageTop - buttonOneHeight);
    messageLabel.numberOfLines = 0;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = messageFont;
    messageLabel.textColor = kPlndrMediumGreyTextColor;
    messageLabel.text = self.message;
    [self addSubview:messageLabel];
    
    [self setBackgroundViewFrame];
}


- (void) buttonOneClicked:(id)sender {
    [self.popupViewDelegate popupViewDelegateOneButtonClicked:sender];
}

@end
