//
//  TDMAddReviewViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseViewController.h"
#import "TDMPlaceHolderTextView.h"

@interface TDMAddReviewViewController : TDMBaseViewController<UITextViewDelegate>{
    
    int icontentsize;
    BOOL position;
	BOOL bcontentflag;
}


@property (retain, nonatomic) TDMPlaceHolderTextView *reviewTitleTextView;
@property (retain, nonatomic) TDMPlaceHolderTextView *reviewDescriptionTextView;

@property (retain, nonatomic) IBOutlet UIImageView *backgroungImageView;

@property (retain, nonatomic) IBOutlet UIImageView *titleViewImage;
@property (retain, nonatomic) IBOutlet UILabel *viewTitleImageTitle;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet UILabel *reviewDescriptionLabel;
@property (retain, nonatomic) IBOutlet UIButton *adButton;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)submitReviewButtonClicked:(id)sender;
- (IBAction)adButtonClicked:(id)sender;

@end
