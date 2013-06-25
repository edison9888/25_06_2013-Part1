//
//  TDMFilterViewController.h
//  TheDailyMeal
//
//  Created by user on 13/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation/Foundation.h"
#import "TDMBaseHttpHandler.h"
@protocol TDMFilterDelegate <NSObject>
@required
-(void)toGetFilterText;
@end
@interface TDMFilterViewController : TDMBaseViewController{   
    NSMutableArray *searchArray;
    NSString *guideName;
    id <TDMFilterDelegate> filterDelegate;
    NSInteger sectionCount;
    NSString *guide;
    
    
}
@property (retain, nonatomic) id filterDelegate;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) IBOutlet UITableView *filterTable;
@property (retain, nonatomic) IBOutlet UIPickerView *CriteriaSearchView;
@property (retain, nonatomic) NSString *guideName;
@property (assign) BOOL isFilterByRestaurant;//YES restaurant else Bar
@property (nonatomic, retain) NSIndexPath *lastIndex;
@property (nonatomic, retain) NSIndexPath *lastIndexAfterDone;
@property (assign) BOOL criteriaSearch;
@end
