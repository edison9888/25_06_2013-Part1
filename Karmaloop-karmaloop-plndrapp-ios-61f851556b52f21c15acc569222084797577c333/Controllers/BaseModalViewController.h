//
//  BaseModalViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataViewController.h"
#import "BaseDataCell.h"

@interface BaseModalViewController : BaseDataViewController

//Base Implementations for purchase modal views
- (void) setupNavBar;
- (void) doneButtonPressed;
- (void) cancelButtonPressed;
- (void) saveModalData;
- (BOOL) isModalDataValid;

- (BOOL) canBeVerifiedLocally;
@end
