//
//  PopupNotificationViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupViewController.h"

@class PopupNotificationViewController;

@protocol PopupNotificationDelegate <NSObject>

@optional
- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController*) popupViewController;
- (void) popupButtonTwoClicked:(id)sender popupViewController:(PopupNotificationViewController*) popupViewController;

@end

@interface PopupNotificationViewController : PopupViewController

@property (nonatomic, strong) NSString *notificationTitle;
@property (nonatomic, strong) NSString *notificationMessage;
@property (nonatomic, strong) NSString *buttonOneTitle;
@property (nonatomic, strong) NSString *buttonTwoTitle;

- (id) initWithTitle:(NSString*)title message:(NSString*)message;
- (id) initWithTitle:(NSString*)title message:(NSString*)message buttonOneTitle:(NSString*)buttonOneTitle;
- (id) initWithTitle:(NSString*)title message:(NSString*)message buttonOneTitle:(NSString*)buttonOneTitle buttonTwoTitle:(NSString*)buttonTwoTitle;
- (int) numberOfButtons;

@end
