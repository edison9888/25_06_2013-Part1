//
//  TwoButtonNotificationPopupView.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwoButtonNotificationPopupView.h"
#import "Constants.h"

@interface TwoButtonNotificationPopupView ()

- (void) initSubviews;
- (void) buttonOneClicked:(id)sender;
- (void) buttonTwoClicked:(id)sender;

@end

@implementation TwoButtonNotificationPopupView

@synthesize popupTitle = _popupTitle;
@synthesize message = _message;
@synthesize buttonOneTitle = _buttonOneTitle;
@synthesize buttonTwoTitle = _buttonTwoTitle;


- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message withButtonOneTitle:(NSString *)titleOne withButtonTwoTitle:(NSString *)titleTwo withPopupViewDelegate:(id<PopupViewDelegate>)popupViewDelegate {
    _popupTitle = title;
    _message = message;
    _buttonOneTitle = titleOne;
    _buttonTwoTitle = titleTwo;
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
    
    UILabel *messageLabel = [[UILabel alloc] init];
    
    UIImage *yellowButtonImg = [UIImage imageNamed:@"yellow_btn.png"];
    UIImage *yellowButtonImgHL = [UIImage imageNamed:@"yellow_btn_hl.png"];
    
    int maxHeight = MAX(kPopupTwoButtonHeight,kPopupVerticalMargin+titleLabel.frame.size.height+messageLabelSize.height+2*(kPopupVerticalMargin+yellowButtonImg.size.height+kPopupVerticalMargin));
    self.frame = CGRectMake(0,0,kPopupWidth,maxHeight);
    
    

    
    UIImage *blackButtonImg = [UIImage imageNamed:@"black_btn.png"];
    UIImage *blackButtonImgHL = [UIImage imageNamed:@"black_btn_hl.png"];
    
    UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonTwo setBackgroundImage:blackButtonImg forState:UIControlStateNormal];
    [buttonTwo setBackgroundImage:blackButtonImgHL forState:UIControlStateHighlighted];
    [buttonTwo setTitle:self.buttonTwoTitle forState:UIControlStateNormal];
    [buttonTwo setTitleColor:kPlndrTextGold forState:UIControlStateNormal];
    buttonTwo.titleLabel.font = kFontBoldCond17;
    buttonTwo.frame = CGRectMake((kPopupWidth - blackButtonImg.size.width)/2, maxHeight - (2*kPopupVerticalMargin) - blackButtonImg.size.height, blackButtonImg.size.width, blackButtonImg.size.height);
    [buttonTwo addTarget:self action:@selector(buttonTwoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonTwo];

    UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonOne setBackgroundImage:yellowButtonImg forState:UIControlStateNormal];
    [buttonOne setBackgroundImage:yellowButtonImgHL forState:UIControlStateHighlighted];
    [buttonOne setTitle:self.buttonOneTitle forState:UIControlStateNormal];
    [buttonOne setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    buttonOne.titleLabel.font = kFontBoldCond17;
    buttonOne.frame = CGRectMake((kPopupWidth - yellowButtonImg.size.width)/2,buttonTwo.frame.origin.y - kPopupVerticalMargin - yellowButtonImg.size.height, yellowButtonImg.size.width, yellowButtonImg.size.height);
    
    [buttonOne addTarget:self action:@selector(buttonOneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonOne];
    
    int messageTop = titleLabel.frame.origin.y + titleLabel.frame.size.height + kPopupVerticalMargin;
    int buttonsHeight = buttonOne.frame.size.height + 2*kPopupVerticalMargin + buttonTwo.frame.size.height + kPopupVerticalMargin;
    
    messageLabel.frame = CGRectMake(titleLabel.frame.origin.x, messageTop, messageLabelSize.width,maxHeight-messageTop-buttonsHeight);
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
- (void) buttonTwoClicked:(id)sender {
    [self.popupViewDelegate popupViewDelegateTwoButtonClicked:sender];
}

@end
