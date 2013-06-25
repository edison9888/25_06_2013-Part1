//
//  TDMAccountsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/4/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMLogoutHandler.h"
@interface TDMAccountsViewController : TDMBaseViewController<TDMLogoutHandlerDelegate>{
    
}
@property (retain, nonatomic) IBOutlet UIButton *myProfileButton;
@property (retain, nonatomic) IBOutlet UIButton *loginsignupButton;


- (IBAction)loginClicked:(id)sender;
- (IBAction)aboutUsClicked:(id)sender;
- (IBAction)myProfileClicked:(id)sender;

@end
