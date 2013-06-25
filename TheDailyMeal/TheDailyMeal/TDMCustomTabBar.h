//
//  TDMCustomTabBar.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 13/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDMCustomTabBar : UITabBarController
{
     NSMutableArray *customTabItems;
     UIView *tabBarView;
}

- (void)customizeTabBarItems;
- (void)loadTabBarItems;
- (void)selectTabAtIndex:(int)index;
- (void)tabItemPressed:(UIButton *)tab;
- (int)getSelectedTabIndex;
- (void)changeInteratcion:(BOOL)value;
@end
