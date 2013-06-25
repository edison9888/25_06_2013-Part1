//
//  TDMAboutUsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/6/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDMAboutUsViewController :TDMBaseViewController<UITextViewDelegate>{
    
}

@property (retain,nonatomic) IBOutlet UITextView *aboutTextView;
@property (retain,nonatomic) IBOutlet UIImageView *dailyMealLogoImageView;
@end
