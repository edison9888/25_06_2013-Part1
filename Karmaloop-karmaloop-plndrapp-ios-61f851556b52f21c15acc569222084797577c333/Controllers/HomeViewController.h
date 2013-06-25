//
//  HomeViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNavBarView.h"
#import "SalesSubscription.h"
#import "FeaturedThumbnail.h"
#import "PlndrBaseViewController.h"

@interface HomeViewController : PlndrBaseViewController <UITableViewDelegate, UITableViewDataSource, HomeNavBarDelegate, SubscriptionDelegate, FeaturedThumbnailDelegate>

@property (nonatomic, strong) NSArray *mensSales;
@property (nonatomic, strong) NSArray *womensSales;
@property (nonatomic, strong) NSArray *allSales;

@property (nonatomic, strong) NSArray *mensSalesViewData;
@property (nonatomic, strong) NSArray *womensSalesViewData;
@property (nonatomic, strong) NSArray *allSalesViewData;

@property (nonatomic, strong) NSTimer *clockUpdateTimer;
@property (nonatomic, strong) SalesSubscription *salesSubscription;

@property (nonatomic, strong) HomeNavBarView *homeNavBar;


@property (nonatomic, strong) UIView *tileContainerView, *listContainerView;
//Tile Container View
@property (nonatomic, strong) UITableView *featuredTileTable;
//List Container View
@property (nonatomic, strong) UITableView *featuredListTable;

@end
