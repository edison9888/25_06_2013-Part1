//
//  MyCartViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCartTableCell.h"
#import "PlndrBaseViewController.h"
#import "LoginViewController.h"
#import "CartStockSubscription.h"


@interface MyCartViewController : PlndrBaseViewController <UITableViewDelegate, UITableViewDataSource, MyCartTableCellDelegate, LoginViewControllerDelegate, SubscriptionDelegate>

@property (nonatomic, strong) UITableView *cartTable;
@property (nonatomic, strong) UILabel *numberItemsLabel;
@property (nonatomic, strong) UILabel *subtotalLabel;

@property (nonatomic, strong) UIView *errorHeader;

@property BOOL isRefreshing;

@property (nonatomic, strong) CartStockSubscription *cartStockSubscription;

- (NSIndexPath*) getIndexPathForCell:(UITableViewCell*)cell;
- (void)handleConnectionError:(PlndrBaseViewController*)vc;

@end
