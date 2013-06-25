//
//  LoginViewControllerDelegate.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LoginViewControllerDelegate <NSObject>

- (void) loginModalDidDisappear;

@optional 
- (void) loginSucceeded;
- (void) loginFailed;

@end