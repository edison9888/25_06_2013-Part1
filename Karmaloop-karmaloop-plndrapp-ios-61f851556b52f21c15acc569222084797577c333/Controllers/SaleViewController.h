//
//  SaleViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsSubscription.h"
#import "PlndrBaseViewController.h"
#import "SaleFilterCategorySubscription.h"
#import "SaleDetail.h"
#import "SaleFilterSizeSubscription.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"
#import "SocialManager.h"

typedef enum {
    NoFilterControl,
    CategoryFilterControl,
    SizeFilterControl
} FilterControl;

typedef enum {
    FilterControlStateReady,
    FilterControlStateLoading,
    FilterControlStateDisabled
} FilterControlState;

@class Sale, OHAttributedLabel;

@interface SaleViewController : PlndrBaseViewController <UITableViewDelegate, UITableViewDataSource, SubscriptionDelegate, UIActionSheetDelegate, SocialManagerDelegate>

@property (nonatomic, strong) SaleDetail *saleDetail;
@property (nonatomic, strong) UITableView *productTable;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) ProductsSubscription *productsSubscription;
@property (nonatomic, strong) SaleFilterCategorySubscription *categoriesSubscription;
@property (nonatomic, strong) SaleFilterSizeSubscription *sizesSubscription;
@property (nonatomic, strong) UIButton *categoryFilterButton;
@property (nonatomic, strong) UIButton *sizeFilterButton;
@property (nonatomic, strong) UIActivityIndicatorView *categoryFilterSpinner;
@property (nonatomic, strong) UIActivityIndicatorView *sizeFilterSpinner;
@property FilterControl currentSelectedFilterControl;
@property (nonatomic, strong) OHAttributedLabel *timerLabel;
@property (nonatomic, strong) UIImageView *timerBackground;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimer *clockUpdateTimer;

@property (nonatomic, strong) UITableView *filterTable;

@property (nonatomic, strong) UIButton *wrapperView;

- (id)initWithSale:(Sale*)sale genderCategory:(GenderCategory)genderCategory;


@end
