//
//  TDMRestaurantReviewDetailView.h
//  TheDailyMeal
//
//  Created by Apple on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeController.h"

@interface TDMBestDishDetailView : SwipeController <UITextViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>
{
    int businessType;
}
@property (retain, nonatomic) NSString *restaurantNameTitle;
@property (retain, nonatomic) IBOutlet UILabel *restaurantName;
@property (retain, nonatomic) IBOutlet UIScrollView *reviewScrollView;
@property (nonatomic,assign) int businessType;
@property (retain, nonatomic) IBOutlet UIButton *pageControlLeftButton;
@property (retain, nonatomic) IBOutlet UIButton *pageControlRightButton;
@property (nonatomic, assign) int currentPageIndex;
@property (nonatomic, retain) NSMutableArray *pageViews;
@property (nonatomic, assign) UIWebView *review;
//@property(nonatomic,assign)NSInteger index;

- (IBAction)pageControlLeftButtonClicked:(id)sender;
- (IBAction)pageControlRightButtonClicked:(id)sender;


@end
