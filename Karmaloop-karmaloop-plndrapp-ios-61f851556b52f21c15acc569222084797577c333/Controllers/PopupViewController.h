//
//  PopupViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupView.h"

@protocol PopupViewControllerDelegate <NSObject>

- (void) dismissPopup:(id)sender;
- (BOOL) isStillVisible:(id)sender;

@end

@interface PopupViewController : UIViewController <PopupViewDelegate>

@property (nonatomic, weak) id popupDelegate;

@end
