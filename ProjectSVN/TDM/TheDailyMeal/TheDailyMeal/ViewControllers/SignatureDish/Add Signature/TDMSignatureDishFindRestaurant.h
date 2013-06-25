//
//  TDMSignatureDishFindRestaurant.h
//  TheDailyMeal
//
//  Created by Apple on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDMSignatureDishFindRestaurant : UIViewController<UITableViewDataSource,UITableViewDataSource>
{
    UISegmentedControl *segmentControl;
    UITableViewCell *cell;
    NSMutableArray *arrayRestaurants;
}
@property (nonatomic, retain) UISegmentedControl *segmentControl;
@end
