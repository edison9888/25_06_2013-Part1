//
//  OneButtonNotificationPopupView.h
//  karmaloop-plndrapp-ios
//
//  Created by xtremelabs on 12-06-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupView.h"

@interface OneButtonNotificationPopupView : PopupView

@property (nonatomic, strong) NSString *popupTitle;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonOneTitle;

- (id) initWithTitle:(NSString*) title withMessage:(NSString *) message withButtonOneTitle:(NSString*) titleOne withPopupViewDelegate:(id<PopupViewDelegate>) popupViewDelegate;


@end
