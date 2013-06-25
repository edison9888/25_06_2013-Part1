//
//  TDMRestaurantReviewList.h
//  TheDailyMeal
//
//  Created by Apple on 17/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TDMRestaurantReviewList : TDMBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableViewCell *cell;
    NSMutableArray *reviewHeaders;
    int busibessType;
    NSMutableDictionary *imageCache;
}
@property (retain, nonatomic) NSString *restaurantNameTitle;
@property (retain, nonatomic) IBOutlet UILabel *restaurantName;
@property (retain, nonatomic) IBOutlet UILabel *noReviewLabel;
@property (retain, nonatomic) NSMutableArray *reviewHeaders;
@property (retain, nonatomic) UITableViewCell *cell;
@property (retain, nonatomic) IBOutlet UITableView *displayTable;
@property (nonatomic, assign) int busibessType;
@property (nonatomic, retain) NSMutableDictionary *imageCache;
- (void)cofigureCell:(UITableViewCell *)aCell withRow:(int)aRow;
@end
