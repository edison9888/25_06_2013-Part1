//
//  HomeViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "SaleViewController.h"
#import "FeaturedSingleCell.h"
#import "FeaturedDoubleCell.h"
#import "Constants.h"
#import "HomeNavBarView.h"
#import "FeaturedThumbnail.h"
#import "FeaturedListCell.h"
#import "OHAttributedLabel.h"
#import "ModelContext.h"
#import "Sale.h"
#import "GANTracker.h"

@interface HomeViewController ()

- (void) selectSale:(Sale*)sale;
- (void) updateClocks;
- (void) scheduleClockTimer;
- (void) createSalesSubscription:(BOOL) forceFetch;
- (void) updateViews;
- (NSInteger) getSaleIndexForRow:(NSInteger)row;
- (GenderCategory) getCurrentCategory;
- (NSArray*) getSalesForCategory:(GenderCategory)category;
- (NSArray*) getViewDataForCategory:(GenderCategory)category;
- (void) initializeViewData;
- (NSArray*) initializeViewDataArrayFromArray:(NSArray*) dataArray;
- (int) getTagPrefixForCategory:(GenderCategory)category;
- (Sale*) getSaleWithTag:(int)tag;
- (NSMutableDictionary*) getViewDataForTag:(int)tag;
- (id) getObjectForTag:(int)tag objectType:(NSString*)type;
- (BOOL) isShowingTwoBanners;
@end

@implementation HomeViewController

@synthesize tileContainerView = _tileContainerView;
@synthesize listContainerView = _listContainerView;
@synthesize featuredTileTable = _featuredTileTable;
@synthesize featuredListTable = _featuredListTable;
@synthesize mensSales = _mensSales;
@synthesize womensSales = _womensSales;
@synthesize allSales = _allSales;
@synthesize mensSalesViewData = _mensSalesViewData;
@synthesize womensSalesViewData = _womensSalesViewData;
@synthesize allSalesViewData = _allSalesViewData;
@synthesize homeNavBar = _homeNavBar;
@synthesize clockUpdateTimer = _clockUpdateTimer;
@synthesize salesSubscription = _salesSubscription;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"HOME";
    }
    return self;
}
	
- (void)dealloc {
    self.featuredTileTable.delegate = nil;
    self.featuredTileTable.dataSource = nil;
    self.featuredListTable.delegate = nil;
    self.featuredListTable.dataSource = nil;
    
    self.homeNavBar.delegate = nil;
    
    [self.clockUpdateTimer invalidate];
    [self.salesSubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tileContainerView = nil;
    self.listContainerView = nil;
    self.featuredTileTable.dataSource = nil;
    self.featuredTileTable.delegate = nil;
    self.featuredTileTable = nil;
    self.featuredListTable.dataSource = nil;
    self.featuredListTable.delegate = nil;
    self.featuredListTable = nil;
    
    self.homeNavBar.delegate = nil;
    self.homeNavBar = nil;

    [self.salesSubscription cancel];
    self.salesSubscription = nil;
    self.mensSales = nil;
    self.womensSales = nil;
    self.allSales = nil;

    [self.clockUpdateTimer invalidate];
    self.clockUpdateTimer = nil;

}

#pragma mark - View lifecycle

- (void) loadView {
    // This frame includes the custom nav bar frame.
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - kTabBarHeight)];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = kPlndrBgGrey;
    
    self.tileContainerView = [[UIView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, kHomeNavBarFrame.size.height, self.view.frame.size.width, self.view.frame.size.height - kHomeNavBarFrame.size.height)];
    [self.view addSubview:self.tileContainerView];
    
    self.listContainerView = [[UIView alloc] initWithFrame: self.tileContainerView.frame];
    [self.view addSubview:self.listContainerView];
    self.listContainerView.hidden = YES;
    
    self.featuredTileTable = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kDeviceWidth, self.tileContainerView.frame.size.height)];
    self.featuredTileTable.delegate = self;
    self.featuredTileTable.dataSource = self;
    self.featuredTileTable.backgroundColor = [UIColor clearColor];
    self.featuredTileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.featuredTileTable.clipsToBounds = NO;
    
    self.featuredListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.tileContainerView.frame.size.height)];
    self.featuredListTable.delegate = self;
    self.featuredListTable.dataSource = self;
    self.featuredListTable.backgroundColor = [UIColor clearColor];
    self.featuredListTable.scrollsToTop = NO;
    self.featuredListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tileContainerView addSubview:self.featuredTileTable];
    [self.listContainerView addSubview:self.featuredListTable];
    
    self.homeNavBar = [[HomeNavBarView alloc] init];
    self.homeNavBar.delegate = self;
    [self.view addSubview:self.homeNavBar];
    
    [self initPullDownViewOnParentView:self.featuredTileTable];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self pullPullDownView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];   
    
    [[GANTracker sharedTracker] trackPageview:kGANPageHome withError:nil];
    
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self updateClocks];
    [self scheduleClockTimer];
    [self.featuredTileTable reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.clockUpdateTimer invalidate];
    self.clockUpdateTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

#pragma mark - private

- (void) selectSale:(Sale *)sale {
    SaleViewController *saleVC = [[SaleViewController alloc] initWithSale:sale genderCategory:[ModelContext instance].genderCategory];
    [self.navigationController pushViewController:saleVC animated:YES];
}

- (Sale*) getSaleWithTag:(int)tag {
    return (Sale*)[self getObjectForTag:tag objectType:@"sale"];
}

- (void) updateClocks {
    for (UITableViewCell *cell in self.featuredTileTable.visibleCells) {
        [(FeaturedSingleCell*)cell updateClock];
    }
    for (UITableViewCell *cell in self.featuredListTable.visibleCells) {
        [(FeaturedListCell*)cell updateClock];
    }
}

- (void) scheduleClockTimer {
    [self.clockUpdateTimer invalidate];
    self.clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClocks) userInfo:nil repeats:YES];
}

- (void) createSalesSubscription:(BOOL)forceFetch{
    [_salesSubscription cancel]; //Cancel any previously set up subscription
    _salesSubscription = [[SalesSubscription alloc] initWithContext:[ModelContext instance] forceFetch:forceFetch];
    _salesSubscription.delegate = self;
    [self subscriptionUpdatedState:_salesSubscription];
}

- (void) updateViews {    
    [self.featuredTileTable reloadData];
    [self.featuredListTable reloadData];
}

- (NSInteger)getSaleIndexForRow:(NSInteger)row {
    if ([self isShowingTwoBanners]) {
        if (row < 2) {
            return row;
        } else {
            return (2*(row-1));
        }
    } else {
        if (row < 1) {
            return row;
        } else {
            return (2*row -1);
        }
    }
}

- (GenderCategory) getCurrentCategory {
    
    return [[ModelContext instance] genderCategory];
}

- (NSArray *)getSalesForCategory:(GenderCategory)category {
    switch (category) {
        case GenderCategoryMen:
            return self.mensSales;
            break;
        case GenderCategoryWomen:
            return self.womensSales;
            break;
        case GenderCategoryAll:
            return self.allSales;
            break;
    }
}

- (NSArray *)getViewDataForCategory:(GenderCategory)category {
    switch (category) {
        case GenderCategoryMen:
            return self.mensSalesViewData;
            break;
        case GenderCategoryWomen:
            return self.womensSalesViewData;
            break;
        case GenderCategoryAll:
            return self.allSalesViewData;
            break;
    }
}

- (void)initializeViewData {
    self.mensSalesViewData = [self initializeViewDataArrayFromArray:self.mensSales];
    self.womensSalesViewData = [self initializeViewDataArrayFromArray:self.womensSales];
    self.allSalesViewData = [self initializeViewDataArrayFromArray:self.allSales];
}

- (NSArray*) initializeViewDataArrayFromArray:(NSArray*) dataArray {
    NSMutableArray *viewDataArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    for (int i = 0; i < dataArray.count; i++) {
        NSMutableDictionary *viewData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isTimerVisible", nil];
        [viewDataArray addObject:viewData];
    }
    return viewDataArray;
}

- (NSMutableDictionary *)getViewDataForTag:(int)tag {
    return (NSMutableDictionary*)[self getObjectForTag:tag objectType:@"viewData"];
}

- (id)getObjectForTag:(int)tag objectType:(NSString *)type {
    int categoryId = tag / kGenderCategoryMenPrefix;
    switch (categoryId) {
        case 1:
        {
            // Men
            NSArray *array = [type isEqualToString:@"viewData"] ? [self getViewDataForCategory:GenderCategoryMen] : [self getSalesForCategory:GenderCategoryMen];
            return [array objectAtIndex:(tag % kGenderCategoryMenPrefix)];
            break;
        }
        case 2:
        {
            // Women
            NSArray *array = [type isEqualToString:@"viewData"] ? [self getViewDataForCategory:GenderCategoryWomen] : [self getSalesForCategory:GenderCategoryWomen];
            return [array objectAtIndex:(tag % kGenderCategoryMenPrefix)];
            break;
        }
        case 3:
        {
            //All
            NSArray *array = [type isEqualToString:@"viewData"] ? [self getViewDataForCategory:GenderCategoryAll] : [self getSalesForCategory:GenderCategoryAll];
            return [array objectAtIndex:(tag % kGenderCategoryMenPrefix)];
            break;
        }
        default:
            NSLog(@"WARNING: HomeViewController attempt to get object with unknown tag: tag = %d", tag);
            return nil;
    }

}

- (int) getTagPrefixForCategory:(GenderCategory)category {
    switch (category) {
        case GenderCategoryMen:
            return kGenderCategoryMenPrefix;
        case GenderCategoryWomen:
            return kGenderCategoryWomenPrefix;
        case GenderCategoryAll:
            return kGenderCategoryAllPrefix;
        default:
            break;
    }
}

- (BOOL) isShowingTwoBanners {
    return ([self getSalesForCategory:[self getCurrentCategory]].count % 2 == 0);
}

#pragma mark - PlndrBaseController override

- (CGRect)loadingViewFrame {
    return self.tileContainerView.frame;
}

#pragma mark - SimplifiedEGORefreshTableHeaderDelegate Methods

- (void)pullDownToRefreshContent {
    [[ModelContext instance] clearSales];
    [self createSalesSubscription:YES];
}

- (BOOL)pullDownIsLoading{
    return self.salesSubscription.state == SubscriptionStatePending;
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    
    if(subscription.state == SubscriptionStateNoConnection) {
        [self resetPullDownView];
        [self handleConnectionError];
    }else if (subscription.state == SubscriptionStateAvailable ||
              subscription.state == SubscriptionStateUnknown ||
              subscription.state == SubscriptionStateUnavailable) {
        if (subscription.state == SubscriptionStateAvailable) {
            [_salesSubscription cancel];  
        }
        self.mensSales = [ModelContext instance].mensSales;
        self.womensSales = [ModelContext instance].womensSales;
        self.allSales = [ModelContext instance].allSales;
        [self initializeViewData];
        [self updateViews];
        [self resetPullDownView];
    }  else  { //Pending SubscriptionStatePending
        [self updateViews];
    }
}

#pragma mark - HomeNavBarDelegate

- (void) toggleList {
    if ([self isListView]) {
        self.listContainerView.hidden = YES;
        self.tileContainerView.hidden = NO;
        self.featuredTileTable.scrollsToTop = YES;
        self.featuredListTable.scrollsToTop = NO;
        
        [self transferPullDownViewToParentView:self.featuredTileTable];
    } else {
        self.tileContainerView.hidden = YES;
        self.listContainerView.hidden = NO;
        self.featuredListTable.scrollsToTop = YES;
        self.featuredTileTable.scrollsToTop = NO;
        
        [self transferPullDownViewToParentView:self.featuredListTable];
    }
}

- (BOOL) isListView {
    return !self.listContainerView.hidden;
}

- (void)scrollWheelIndexDidUpdate {
    [self updateViews];
}

#pragma mark - UITableViewDataSource/Delegate


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sales = [self getSalesForCategory:[self getCurrentCategory]];
    if (tableView == self.featuredTileTable) {
        if (sales.count > 0) {
            return (sales.count/2 + 1);
        } else {
            return 0;
        }
    } else {
        return sales.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
        return 0.0f;
    } else if ([self pullDownIsLoading]) {
        return 0.0f;
    } else {
        return kDeviceHeight - kHomeNavBarFrame.size.height -kTabBarHeight;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
        return nil;
    } else if ([self pullDownIsLoading]) {
        return nil;
    } else {
        int emptyLabelHeight = 60;
        int homeViewHeight = kDeviceHeight - kHomeNavBarFrame.size.height - kTabBarHeight;
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, homeViewHeight/2 - emptyLabelHeight, kDeviceWidth, homeViewHeight)];
        emptyLabel.backgroundColor = [UIColor clearColor];
        emptyLabel.text = kHomeNoSalesError;
        emptyLabel.textColor = kPlndrMediumGreyTextColor;
        emptyLabel.font = kErrorFontForReplaceingTables;
        emptyLabel.textAlignment = UITextAlignmentCenter;
        emptyLabel.numberOfLines = 0;
        return emptyLabel;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.featuredTileTable) {
        if (indexPath.row == 0 || (indexPath.row == 1 && [self isShowingTwoBanners])) {   
            return kHomeLongTileCellHeight;
        } else {
            return kHomeShortTileCellHeight;
        }
    } else {
        return kHomeScreenListCellHeight;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSArray *sales = [self getSalesForCategory:[self getCurrentCategory]];
    static NSString *CellIdentifier;
    
    if (tableView == self.featuredTileTable) {
        if (indexPath.row == 0 || (indexPath.row == 1 && [self isShowingTwoBanners])) {    
            CellIdentifier = @"featuredSaleSingleCell";
            FeaturedSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeaturedSingleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.thumbnail.thumbnailDelegate = self;
            }

            // Configure the cell.
            int index = indexPath.row;
            int tag = index + [self getTagPrefixForCategory:[self getCurrentCategory]];
            [cell.thumbnail updateWithSale:[sales objectAtIndex:index] tag:tag];
            
            // Animate timer down if its folded up
            if(cell.thumbnail.clockButton.hidden) {
                [cell.thumbnail toggleTimer];
            }
            
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"featuredSaleDoubleCell";
            FeaturedDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeaturedDoubleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.leftThumbnail.thumbnailDelegate = self;
                cell.rightThumbnail.thumbnailDelegate = self;
            }
            
            int firstIndex = [self getSaleIndexForRow:indexPath.row];
            int firstTag = firstIndex + [self getTagPrefixForCategory:[self getCurrentCategory]];
            [cell.leftThumbnail updateWithSale:[sales objectAtIndex:firstIndex] tag:firstTag];
            
            int secondIndex = firstIndex + 1;
            int secondTag = secondIndex + [self getTagPrefixForCategory:[self getCurrentCategory]];
            if (secondIndex < [sales count]) {
                [cell.rightThumbnail updateWithSale:[sales objectAtIndex:secondIndex] tag:secondTag];
            } else {
                cell.rightThumbnail.hidden = YES;
            }
            // Animate timer down if its folded up
            if(cell.leftThumbnail.clockButton.hidden) {
                [cell.leftThumbnail toggleTimer];
            }
            if(cell.rightThumbnail.clockButton.hidden) {
                [cell.rightThumbnail toggleTimer];
            }

            
            return cell;
        }
    } else {
        CellIdentifier = @"featuredListCell";
        FeaturedListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[FeaturedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        int index = indexPath.row;
        int tag = index + [self getTagPrefixForCategory:[self getCurrentCategory]];
        [cell updateWithSale:[sales objectAtIndex:index] tag:tag];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.featuredListTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Sale *selectedSale = [[self getSalesForCategory:[self getCurrentCategory]] objectAtIndex:indexPath.row];
        [self selectSale:selectedSale]; 
    }
}

#pragma mark - FeaturedThumbnailDelegate 

- (void)toggleTimer:(int)senderId {
    NSMutableDictionary *viewData = [self getViewDataForTag:senderId];
    BOOL oldVal = [[viewData objectForKey:@"isTimerVisible"] boolValue];
    [viewData setObject:[NSNumber numberWithBool:!oldVal] forKey:@"isTimerVisible"];
}

- (BOOL)isTimerShowing:(int)senderId {
    NSMutableDictionary *viewData = [self getViewDataForTag:senderId];
    return [[viewData objectForKey:@"isTimerVisible"] boolValue];
}

- (void) thumbnailClicked:(id)sender {
    Sale *selectedSale = [self getSaleWithTag:((UIButton*)sender).tag];
    [self selectSale:selectedSale];
}

@end
