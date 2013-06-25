//
//  TDMMyProfileViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMAsyncImage.h"
@interface TDMMyProfileViewController : TDMBaseViewController<UITextFieldDelegate>{

    TDMAsyncImage *image;
    
    NSMutableArray *userProfile;
    NSString *username;
    NSString *emailId;
}

@property (retain, nonatomic) IBOutlet UITextField *usersName;
@property (retain, nonatomic) IBOutlet UITextField *eMailId;
@property (retain, nonatomic) IBOutlet UITextField *rateInfo;

@property (retain, nonatomic) IBOutlet UITableView *profileTable;

- (void)initialize;
- (IBAction)myReviewsClicked:(id)sender;


@end
