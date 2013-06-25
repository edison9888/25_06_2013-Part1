//
//  NotificationPopupView.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationPopupView.h"
#import "Constants.h"

@interface NotificationPopupView ()

- (void) initSubviews;
- (void) submitClicked;

@end

@implementation NotificationPopupView

@synthesize popupTitle = _popupTitle, message = _message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message popupViewDelegate:(id<PopupViewDelegate>)popupViewDelegate{
    _popupTitle = title;
    _message = message;
    self.popupViewDelegate = popupViewDelegate;    
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
    
    UIFont *messageFont = kFontRoman16;
    CGSize messageLabelSize = [self.message sizeWithFont:messageFont
                                       constrainedToSize:CGSizeMake(contentWidth, 80)
                                           lineBreakMode:UILineBreakModeTailTruncation];
    
    UIImage *yellowButtonImg = [UIImage imageNamed:@"yellow_btn.png"];
    UIImage *yellowButtonImgHL = [UIImage imageNamed:@"yellow_btn_hl.png"];
    int maxHeight = MAX(kPopupOneButtonHeight,kPopupVerticalMargin+titleLabel.frame.size.height+messageLabelSize.height+kPopupVerticalMargin+yellowButtonImg.size.height+kPopupVerticalMargin);
    self.frame = CGRectMake(0,0,kPopupWidth,maxHeight);
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [submitButton setBackgroundImage:yellowButtonImg forState:UIControlStateNormal];
    [submitButton setBackgroundImage:yellowButtonImgHL forState:UIControlStateHighlighted];
    [submitButton setTitle:@"OK" forState:UIControlStateNormal];
    [submitButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    submitButton.titleLabel.font = kFontBoldCond17;
    submitButton.frame = CGRectMake((kPopupWidth - yellowButtonImg.size.width)/2, maxHeight - (2*kPopupVerticalMargin) - yellowButtonImg.size.height, yellowButtonImg.size.width, yellowButtonImg.size.height);
    [submitButton addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
    
    UILabel *messageLabel = [[UILabel alloc] init];
    int messageTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + kPopupVerticalMargin;
    int submitButtonHeight = submitButton.frame.size.height + 2*kPopupVerticalMargin;
    
    messageLabel.frame = CGRectMake(titleLabel.frame.origin.x, messageTop, messageLabelSize.width, maxHeight - messageTop - submitButtonHeight);
    messageLabel.numberOfLines = 0;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = messageFont;
    messageLabel.textColor = kPlndrMediumGreyTextColor;
    messageLabel.text = self.message;
    [self addSubview:messageLabel];
    
    self.frame = CGRectMake(0,0,kPopupWidth,submitButton.frame.origin.y + submitButton.frame.size.height + kPopupVerticalMargin);
    [self setBackgroundViewFrame];
}

- (void) submitClicked {
    [self.popupViewDelegate popupViewDelegateClose:self];
}

@end
