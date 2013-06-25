//
//  TDMRestaurantReviewDetailView.h
//  TheDailyMeal
//
//  Created by Apple on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeController.h"

@interface TDMRestaurantReviewDetailView : SwipeController <UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
{
    int businessType;
}

@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) int currentPageIndex;
@property (retain, nonatomic) IBOutlet UIButton *previousButton;
@property (retain, nonatomic) NSString *restaurantNameTitle;
@property (retain, nonatomic) IBOutlet UILabel *restaurantName;
@property (retain, nonatomic) IBOutlet UIScrollView *reviewScrollView;
@property (nonatomic,assign) int businessType;
@property (nonatomic, retain) NSMutableArray *pageViews;
//@property (nonatomic, retain) UIWebView *review ;

//-(void) loadBusinessReview;
//- (IBAction)changePage:(id)sender;

@end
