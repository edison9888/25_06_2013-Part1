//
//  NotificationPopupView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupView.h"

@interface NotificationPopupView : PopupView

@property (nonatomic, strong) NSString *popupTitle;
@property (nonatomic, strong) NSString *message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message popupViewDelegate:(id<PopupViewDelegate>)popupViewDelegate;

@end
