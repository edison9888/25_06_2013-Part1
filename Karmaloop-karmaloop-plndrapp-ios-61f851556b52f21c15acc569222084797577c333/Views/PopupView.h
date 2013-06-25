//
//  PopupView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupView;

@protocol PopupViewDelegate <NSObject>

- (void) popupViewDelegateClose:(id)sender;
@optional

- (void) popupViewDelegateOneButtonClicked:(id)sender;
- (void) popupViewDelegateTwoButtonClicked:(id)sender;

@end

@interface PopupView : UIView

@property (nonatomic, weak) id popupViewDelegate;
@property (nonatomic, strong) UIImageView *backgroundView;

- (void) initSubviews;
- (void) setBackgroundViewFrame; // Call this at the end of initSubviews, after setting your frame!

@end
