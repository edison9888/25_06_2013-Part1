//
//  TwoButtonNotificationPopupView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupView.h"

@interface TwoButtonNotificationPopupView : PopupView

@property (nonatomic, strong) NSString *popupTitle;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonOneTitle;
@property (nonatomic, strong) NSString *buttonTwoTitle;

- (id) initWithTitle:(NSString*) title withMessage:(NSString *) message withButtonOneTitle:(NSString*) titleOne withButtonTwoTitle:(NSString*) titleTwo withPopupViewDelegate:(id<PopupViewDelegate>) popupViewDelegate;

@end
