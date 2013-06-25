//
//  PopupUtil.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupUtil.h"
#import "Constants.h"
#import "PopupQueueItem.h"
#import "PopupViewController.h"

@interface PopupUtil ()

- (void) enqueuePopup:(PopupViewController*)popupVC withDelegate:(id)delegate;
- (PopupQueueItem*) dequeuePopUp;
- (BOOL) isPopupPending;
- (void) presentNextPopupInQueue;
- (void) darkenIfNeeded;
- (void) animateNextPopupUp;
- (void) dismissPopup;

@end

@implementation PopupUtil

@synthesize currentPopupItem = _currentPopupItem, transparentOverlay = _transparentOverlay, popupQueue = _popupQueue;

static PopupUtil *instance = nil;
+ (PopupUtil*)instance {
	if (!instance) {
		instance = [[PopupUtil alloc] init];
        instance.transparentOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + kStatusBarHeight)];
        instance.transparentOverlay.backgroundColor = kPlndrTransparencyColor;
        instance.transparentOverlay.alpha = 0.0f;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(instructControllerDelegateToDismiss)];
        [instance.transparentOverlay addGestureRecognizer:tapRecognizer];
        
        instance.popupQueue = [NSMutableArray array];
	}
	return instance;
}

+ (void)presentPopup:(PopupViewController*)popupVC  withDelegate:(id)delegate {    
    [[PopupUtil instance] enqueuePopup:popupVC withDelegate:delegate];
    [[PopupUtil instance] presentNextPopupInQueue];
}

- (BOOL)isPopupPending {
    return (self.popupQueue.count > 0);
}

- (void)enqueuePopup:(PopupViewController *)popupVC withDelegate:(id)delegate {
    PopupQueueItem *item = [[PopupQueueItem alloc] init];
    item.popupViewController = popupVC;
    item.delegate = delegate;
    
    [self.popupQueue addObject:item];
}

- (PopupQueueItem*)dequeuePopUp {
    if (self.popupQueue) {
        PopupQueueItem * item = [self.popupQueue objectAtIndex:0];
        [self.popupQueue removeObjectAtIndex:0];
        return item;
    } else {
        return nil;
    }
}

- (void)presentNextPopupInQueue {
    while (!self.currentPopupItem && [self isPopupPending]) {
        self.currentPopupItem = [self dequeuePopUp];
        self.currentPopupItem.popupViewController.popupDelegate = self.currentPopupItem.delegate;

        if([self.currentPopupItem.popupViewController.popupDelegate isStillVisible:self]){
            [self darkenIfNeeded];
            [self animateNextPopupUp];
        } else {
            self.currentPopupItem.popupViewController.popupDelegate = nil;
            self.currentPopupItem = nil;
            // This popup is no longer relevant. Discard and try the next one
            
            // If nothing is pending, make sure the screen isn't still dimmed
            if (![self isPopupPending]) {
                [self dismissPopup];
            }
        }
    } // else do nothing - it'll happen when this current popup is dismissed
}

- (void) darkenIfNeeded {
    if (self.transparentOverlay.alpha < 1.0f) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [mainWindow addSubview:self.transparentOverlay];
        self.transparentOverlay.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.transparentOverlay.alpha = 1.0f;
                         } 
                         completion:nil];
    }
}

- (void)animateNextPopupUp {
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];

    UIView *popupView = self.currentPopupItem.popupViewController.view;
    [mainWindow addSubview:popupView];
    CGPoint popupOriginInWindowCoords = CGPointMake((kDeviceWidth - popupView.frame.size.width)/2, kNavBarFrame.size.height + kStatusBarHeight + 3);
    popupView.frame = CGRectMake(popupOriginInWindowCoords.x, kDeviceHeight + kStatusBarHeight, popupView.frame.size.width, popupView.frame.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         popupView.frame = CGRectMake(popupView.frame.origin.x, popupOriginInWindowCoords.y, popupView.frame.size.width, popupView.frame.size.height); 
                     } 
                     completion:nil];

}

+ (void)dismissPopup {
    [[PopupUtil instance] dismissPopup];
}

- (void)dismissPopup {
    UIView *popupView = self.currentPopupItem.popupViewController.view;
    BOOL shouldLighten = ![self isPopupPending];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         popupView.frame = CGRectMake(popupView.frame.origin.x, kDeviceHeight + kStatusBarHeight + 20, popupView.frame.size.width, popupView.frame.size.height); 
                         
                         if (shouldLighten) {
                             self.transparentOverlay.alpha = 0.0f;
                         }
                         
                     } 
                     completion:^(BOOL finished){
                         self.currentPopupItem.popupViewController.popupDelegate = nil;
                         self.currentPopupItem = nil;
                         
                         if (shouldLighten) {
                             [self.transparentOverlay removeFromSuperview];
                         }
                         
                         [self presentNextPopupInQueue];
                     }];
}

+ (BOOL)isPopupShowing {
    return [PopupUtil instance].currentPopupItem != nil;
}

- (void) instructControllerDelegateToDismiss {
    [self.currentPopupItem.popupViewController popupViewDelegateClose:self];
}

+ (void)transitionFromPopupView:(PopupView *)fromPopupView toPopupView:(PopupView *)toPopupView {
    [UIView transitionFromView:fromPopupView toView:toPopupView duration:0.3f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromTop completion:nil];
}

@end
