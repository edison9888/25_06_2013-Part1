//
//  TDMAddSignatureDishViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMPlaceHolderTextView.h"

#import "TDMAddSignatureDishHandlerAndProvider.h"

@interface TDMAddSignatureDishViewController : TDMBaseViewController<UITextViewDelegate,TDMAddSignatureDishHandlerAndProviderDelegate>{
    TDMPlaceHolderTextView *reviewTitleTextView;
    TDMPlaceHolderTextView *reviewDescriptionTextView;
    UIImageView *backgroungImageView;
    UIImageView *titleViewImage;
    UILabel *viewTitleImageTitle;

    UIButton *submitButton;
    UILabel *reviewDescriptionLabel;
    UIButton *adButton;
    int icontentsize;
    BOOL position;
	BOOL bcontentflag;
    
    TDMAddSignatureDishHandlerAndProvider *addSignatureDish;
}

@property (assign, nonatomic) int businessType;
@property (retain, nonatomic)  UIScrollView *addDishScrollView;
@property (retain, nonatomic) TDMPlaceHolderTextView *reviewTitleTextView;
@property (retain, nonatomic) TDMPlaceHolderTextView *reviewDescriptionTextView;

@property (retain, nonatomic) UIImageView *backgroungImageView;
@property (retain, nonatomic) IBOutlet UIButton *findRestaurantBtn;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;

@property (retain, nonatomic)  UIImageView *titleViewImage;
@property (retain, nonatomic)  UILabel *viewTitleImageTitle;

@property (retain, nonatomic)  UIButton *submitButton;
@property (retain, nonatomic)  UILabel *reviewDescriptionLabel;
@property (retain, nonatomic)  UIButton *adButton;

- (IBAction)addDishFindRestaurantClicked:(id)sender;
- (IBAction)addDishSubmitClicked:(id)sender;

@end
