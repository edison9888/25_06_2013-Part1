//
//  SignupViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseModalViewController.h"
#import "SignUpSubscription.h"
#import "PopupViewController.h"

typedef enum{
	SignupSectionError,
	SignupSectionCell,
	SignupSectionNUM
}SignupSections;

typedef enum {
    SignupCellFirstName,
    SignupCellLastName,
    SignupCellGender,
    SignupCellEmail,
    SignupCellPassword,
    SignupCellConfirmPassword,
	SignupCellNUM
} SignupCell;

@protocol SignupViewControllerDelegate <NSObject>

- (void) signupModalDidDisappear;

@end

@interface SignupViewController : BaseModalViewController <SubscriptionDelegate>


@property (nonatomic, weak) id<SignupViewControllerDelegate> signupDelegate;
@property (nonatomic, strong) SignUpSubscription *signupSubscription;
@property (nonatomic, strong) NSArray *genderPickerValue;


- (id) initWithSignupDelegate:(id<SignupViewControllerDelegate>)signupDelegate;

@end