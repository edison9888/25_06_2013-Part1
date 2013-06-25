//
//  TDMCustomTabBar.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMAppDelegate.h"
#import "TDMCityGuideListOfCitiesHandler.h"

@interface TDMCustomTabBar : UITabBarController<UITableViewDelegate,UITableViewDataSource,TDMLocationDelegate,UITabBarDelegate,TDMCityGuideListOfCitiesHandlerDelegate> {
    
    NSMutableDictionary *tabBarItems;
    NSMutableArray *customTabItems;
    NSMutableArray *listOfCities;
    UIView *tabBarView;
    UIView *moreView;

    UITableView *moreTable;
}
@property (nonatomic, retain) NSMutableArray *listOfCities;
-(void)tabItemPressed:(UIButton *)tab ;
@end
