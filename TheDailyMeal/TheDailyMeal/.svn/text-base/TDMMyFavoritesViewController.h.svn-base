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
#import "TDMBusinessViewController.h"
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
    BOOL isFromMyProfile;
    UISegmentedControl *segment;
    
    
}

@property (nonatomic, assign) BOOL isFromMyProfile;
@property (nonatomic, assign) BOOL isAnimated;
@property (retain, nonatomic) IBOutlet TDMFavoritesCustomCell *favoritesCell;

@property (retain, nonatomic) IBOutlet UITableView *detailsTable;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *addBar;
@property (retain, nonatomic) IBOutlet UIButton *addRestaurantButton;

- (void)initialize;
- (IBAction)segmentClicked:(id)sender;
- (IBAction)addABarAction:(id)sender;
- (IBAction)addARestaurantAction:(id)sender;
-(void)addsegmentControl;
- (void)customizeView;
-(void) changeUISegmentFont:(UIView*) myView;

@end
