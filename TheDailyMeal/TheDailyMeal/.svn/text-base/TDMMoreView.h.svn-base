//
//  TDMMoreView.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "TDMCityListService.h"
#import "TDMOverlayView.h"


@interface TDMMoreView : UIView<UITableViewDelegate,UITableViewDataSource,TDMCityListServiceDelegate>
{
    UITableView *moreTable;
    TDMCityListService *cityService;
    NSMutableArray *cityGuideArray;
    TDMOverlayView *overlayView;
    
}

@property (assign, nonatomic) TDMCityListService *cityService;
@property (retain, nonatomic) NSMutableArray *cityGuideArray;
- (void)addMoreView;
- (UIView *)addWishList;
- (void)showOverlayView;
- (void)removeOverlayView;
- (void)startAnimation:(CGRect )rect uiview:(UIView *)animatedView;
@end
