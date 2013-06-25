//
//  PopupUtil.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupViewController.h"
#import "PopupView.h"

@class PopupQueueItem;

@interface PopupUtil : NSObject

@property (nonatomic, strong) NSMutableArray *popupQueue;
@property (nonatomic, strong) PopupQueueItem *currentPopupItem;
@property (nonatomic, strong) UIView *transparentOverlay;

+ (void) presentPopup:(PopupViewController*)popupVC withDelegate:(id)delegate;
+ (BOOL) isPopupShowing;
+ (void) transitionFromPopupView:(PopupView*)fromPopupView toPopupView:(PopupView*)toPopupView;
+ (void) dismissPopup;
- (void) instructControllerDelegateToDismiss;
@end
