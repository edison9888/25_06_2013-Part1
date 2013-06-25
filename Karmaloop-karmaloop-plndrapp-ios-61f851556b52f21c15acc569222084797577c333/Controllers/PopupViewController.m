//
//  PopupViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopupViewController.h"

@implementation PopupViewController

@synthesize popupDelegate = _popupDelegate;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) popupViewDelegateClose:(id)sender {
    [self.popupDelegate dismissPopup:self];
}

@end
