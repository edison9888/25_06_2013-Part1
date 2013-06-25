//
//  TDMForgotPasswordViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/12/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMForgotPasswordHandlerAndProvider.h"


@interface TDMForgotPasswordViewController : TDMBaseViewController<UITextFieldDelegate,TDMForgotPasswordHandlerAndProviderDelegate>{
    
}
@property (retain,nonatomic) IBOutlet UITextField *emailTextField;
@property (retain,nonatomic) IBOutlet UIButton *submitButton;
@property (retain,nonatomic) IBOutlet UIScrollView *forgotScrollView;

@end
