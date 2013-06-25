//
//  PopupView.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupView.h"
#import "Constants.h"

@interface PopupView () 

- (void) closeButtonClicked;

@end

@implementation PopupView

@synthesize popupViewDelegate = _popupViewDelegate;
@synthesize backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popup.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kPopupImageVerticalCap, kPopupImageHorizontalCap, kPopupImageVerticalCap, kPopupImageHorizontalCap)]];
    [self addSubview:self.backgroundView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImage = [UIImage imageNamed:@"close.png"];
    [closeButton setImage:[UIImage imageNamed:@"close_hl.png"] forState:UIControlStateHighlighted];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(kPopupWidth - kMagicButtonHeight, 0, kMagicButtonHeight, kMagicButtonHeight);
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -10)];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (void) setBackgroundViewFrame {
    self.backgroundView.frame = CGRectMake(-1*kPopupImageHorizontalCap, -1*kPopupImageVerticalCap, self.frame.size.width + 2*kPopupImageHorizontalCap, self.frame.size.height + 2*kPopupImageVerticalCap);
}

#pragma mark - private

- (void)closeButtonClicked {
    [self.popupViewDelegate popupViewDelegateClose:self];
}

@end
