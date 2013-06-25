//
//  TDMMyFavoritesViewController.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseViewController.h"
#import "TDMFavoritesCustomCell.h"
#import "DatabaseManager.h"
#import "TDMBusinessHomeViewController.h"
#import "TDMBusinessDetails.h"

@interface TDMMyFavoritesViewController : TDMBaseViewController
{
    NSDictionary *dict;
    NSMutableDictionary *info;
    NSMutableDictionary *favDict;
    NSMutableArray *businesIdArray;
    NSArray *businessIDArray;
    NSMutableArray *restaurantArray;
    NSMutableArray *barArray;
    NSMutableArray *infoArray;
}
@property (retain, nonatomic) IBOutlet TDMFavoritesCustomCell *favoritesCell;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segment;
@property (retain, nonatomic) IBOutlet UITableView *detailsTable;


- (void)initialize;
- (IBAction)segmentClicked:(id)sender;


@end
