//
//  SaleViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaleViewController.h"
#import "ProductViewController.h"
#import "Constants.h"
#import "ProductListTripleCell.h"
#import "ModelContext.h"
#import "Product.h"
#import "Sale.h"
#import "SaleFilterCategory.h"
#import "OHAttributedLabel.h"
#import "Utility.h"
#import "NSAttributedString+Attributes.h"
#import "OneButtonNotificationPopupView.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "SaleFilterSize.h"
#import "GANTracker.h"

#define FILTERCELL_SEPARATOR_TAG 999

@interface SaleViewController ()

- (void) setupRightBarButtons;
- (void) productThumbnailClicked:(id)sender;
- (void) selectProductAtIndex:(int)index;
- (void) createProductsSubscription:(BOOL) forceFetch fetchMore:(BOOL)fetchMore;
- (void) createCategoriesSubscription:(BOOL)forceFetch;
- (void) createSizesSubscription:(BOOL) forceFetch;
- (void) updateViews;
- (NSInteger) getProductIndexForRow:(int)row;

- (void) triggerFilterControl:(FilterControl)filterControl;
- (void) showFilter;
- (void) hideFilter;

- (CGRect) getCategoryControlFrame:(BOOL)selected;
- (CGRect) getSizeControlFrame:(BOOL)selected;
- (UIImage*) getCategoryControlImage:(BOOL)selected;
- (UIImage*) getSizeControlImage:(BOOL)selected;
- (UIColor*) getFilterControlColorForState:(UIControlState)state isSelected:(BOOL)isSelected;
- (void) updateFilterButtons;

- (void) setFilterControlState:(FilterControlState)filterControlState forFilterControl:(UIButton*)filterControl;
- (void) scheduleClockTimer;
- (void) updateTimer;
- (void)expireCurrentView;
- (BOOL) isAnySubscriptionLoading;
- (void)shareProduct:(id)sender;

@end

@implementation SaleViewController 

@synthesize saleDetail = _saleDetail;
@synthesize wrapperView = _wrapperView;
@synthesize productTable = _productTable;
@synthesize products = _products;
@synthesize categories = _categories;
@synthesize productsSubscription = _productsSubscription;
@synthesize categoriesSubscription = _categoriesSubscription;
@synthesize sizesSubscription = _sizesSubscription;
@synthesize categoryFilterButton = _categoryFilterButton;
@synthesize sizeFilterButton = _sizeFilterButton;
@synthesize filterTable = _filterTable;
@synthesize categoryFilterSpinner = _categoryFilterSpinner;
@synthesize sizeFilterSpinner = _sizeFilterSpinner;
@synthesize currentSelectedFilterControl = _currentSelectedFilterControl;
@synthesize timerLabel = _timerLabel;
@synthesize timerBackground =_timerBackground;
@synthesize endDate = _endDate;
@synthesize clockUpdateTimer = _clockUpdateTimer;

- (id)initWithSale:(Sale*)sale genderCategory:(GenderCategory)genderCategory
{
    self.saleDetail = [[ModelContext instance] getSaleDetailForSale:(Sale*)sale genderCategory:genderCategory];
    self = [super init];
    if (self) {
        self.title = [self.saleDetail.sale.name uppercaseString];
        self.endDate = sale.endDate;
    }
    return self;
}

-(void)dealloc {
    self.filterTable.delegate = nil;
    self.filterTable.dataSource = nil;
    
    self.productTable.delegate = nil;
    self.productTable.dataSource = nil;
    [_productsSubscription cancel];
    [_categoriesSubscription cancel];
    [_sizesSubscription cancel];
    
    [self.clockUpdateTimer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.navigationItem.rightBarButtonItem = nil;
    
    self.categoryFilterButton = nil;
    self.sizeFilterButton = nil;
    self.filterTable.delegate = nil;
    self.filterTable.dataSource = nil;
    self.filterTable = nil;
    
    self.productTable.delegate = nil;
    self.productTable.dataSource = nil;
    self.productTable = nil;
    
    self.timerLabel = nil;
    [self.clockUpdateTimer invalidate];
    self.clockUpdateTimer = nil;
    self.timerBackground = nil;
    self.wrapperView = nil;
    
    [self.productsSubscription cancel];
    self.productsSubscription = nil;
    [self.categoriesSubscription cancel];
    self.categoriesSubscription = nil;
    [self.sizesSubscription cancel];
    self.sizesSubscription = nil;
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    self.view.backgroundColor = kPlndrBgGrey;
    [self setupRightBarButtons];
    
    self.categoryFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryFilterButton.frame = [self getCategoryControlFrame:NO];
    [self.categoryFilterButton addTarget:self action:@selector(toggleCategoryFilterView) forControlEvents:UIControlEventTouchUpInside];
    self.categoryFilterButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.categoryFilterButton setTitle:@"CATEGORY" forState:UIControlStateNormal];
    [self.categoryFilterButton.titleLabel setFont:kFontBoldCond14];
    self.categoryFilterButton.adjustsImageWhenHighlighted = NO;
    
    self.sizeFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sizeFilterButton.frame = [self getSizeControlFrame:NO];
    [self.sizeFilterButton addTarget:self action:@selector(toggleSizeFilterView) forControlEvents:UIControlEventTouchUpInside];
    self.sizeFilterButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.sizeFilterButton setTitle:@"SIZE" forState:UIControlStateNormal];
    [self.sizeFilterButton.titleLabel setFont:kFontBoldCond14];
    self.sizeFilterButton.adjustsImageWhenHighlighted = NO;
    [self setFilterControlState:FilterControlStateLoading forFilterControl:self.sizeFilterButton];
    
    [self triggerFilterControl:NoFilterControl];
    
    [self.view addSubview:self.categoryFilterButton];
    [self.view addSubview:self.sizeFilterButton];
    
    CGRect selectedCategoryButtonRect = [self getCategoryControlFrame:YES];
    CGRect selectedSizeButtonRect = [self getSizeControlFrame:YES];
    
    
    self.filterTable = [[UITableView alloc] initWithFrame:CGRectMake(selectedCategoryButtonRect.origin.x, selectedCategoryButtonRect.origin.y + selectedCategoryButtonRect.size.height, selectedCategoryButtonRect.size.width + selectedSizeButtonRect.size.width, kSaleScreenFilterTableHeight)];
    self.filterTable.delegate = self;
    self.filterTable.dataSource = self;
    self.filterTable.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.filterTable.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    self.filterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hideFilter];
    
    int productTableOriginY = self.sizeFilterButton.frame.origin.y + self.sizeFilterButton.frame.size.height + kSaleScreenHeaderTopMargin;
    self.productTable = [[UITableView alloc] initWithFrame:CGRectMake(0, productTableOriginY, kSaleScreenTableWidth, self.view.frame.size.height - productTableOriginY) style:UITableViewStyleGrouped];
    self.productTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTable.separatorColor = [UIColor clearColor];
    self.productTable.backgroundColor = kPlndrBgGrey;
    
    self.productTable.delegate = self;
    self.productTable.dataSource = self;
    [self.view insertSubview:self.productTable belowSubview:self.categoryFilterButton];
    
    UIImage *timerBGImage = [UIImage imageNamed:@"timer_bg.png"];
    self.timerBackground = [[UIImageView alloc] initWithImage:timerBGImage];
    self.timerBackground.frame = CGRectMake(self.sizeFilterButton.frame.origin.x + self.sizeFilterButton.frame.size.width,
                                            0,
                                            timerBGImage.size.width,
                                             timerBGImage.size.height);
    
    self.timerLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(-kTimerShadowHeight, 0, self.timerBackground.frame.size.width, self.timerBackground.frame.size.height)]; // Offset since image has a drop shadow
    
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.centerVertically = YES;
    self.timerLabel.automaticallyAddLinksForType = 0;
    self.timerLabel.shadowColor = [UIColor whiteColor];
    self.timerLabel.shadowOffset = CGSizeMake(0.0, kTimerShadowHeight);
    
    [self.timerBackground addSubview:self.timerLabel];
    [self.view insertSubview:self.timerBackground aboveSubview:self.productTable];
    self.timerLabel.hidden = YES;
    self.timerBackground.hidden = YES;
    
    
    self.wrapperView = [[UIButton alloc] initWithFrame:self.view.frame];
    [self.wrapperView addTarget:self action:@selector(wrapperClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.wrapperView.hidden = YES;

    [self.view insertSubview:self.wrapperView belowSubview:self.categoryFilterButton];
    
    
    [self initPullDownViewOnParentView:self.productTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", self.saleDetail.sale.name] withError:nil];
    [self pullPullDownView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scheduleClockTimer];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.clockUpdateTimer invalidate];
}

#pragma mark - UITableViewDataSource/Delegate

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.productTable != tableView) {
        return 0.0f;
    } else if ([self pullDownIsLoading]) {
        return 0.0f;
    } else {
        if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
            return 0.0f;            
        } else {
            return kDeviceHeight - kNavBarFrame.size.height -kTabBarHeight - self.categoryFilterButton.frame.size.height;
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.productTable != tableView) {
        return nil;
    } else {
        if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
            return nil;
        } else if ([self pullDownIsLoading]) {
            return nil;
        }  else {
            int emptyLabelHeight = 60;
            int saleViewHeight = kDeviceHeight - kNavBarFrame.size.height - kTabBarHeight - self.categoryFilterButton.frame.size.height;
            UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, saleViewHeight/2 - emptyLabelHeight, kDeviceWidth, saleViewHeight)];
            emptyLabel.backgroundColor = [UIColor clearColor];
            emptyLabel.text = kSaleNoProductsError;
            emptyLabel.textColor = kPlndrMediumGreyTextColor;
            emptyLabel.font = kErrorFontForReplaceingTables;
            emptyLabel.textAlignment = UITextAlignmentCenter;
            emptyLabel.numberOfLines = 0;
            return emptyLabel;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.productTable != tableView) {
        return 0.0f;
    } else {
        if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
            if(self.saleDetail.hasMoreProductsToFetch) {
                return kSaleLoadingFooterHeight;
            }
        }
        return 0.0f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.productTable != tableView) {
        return nil;
    } else {
        if ([self tableView:tableView numberOfRowsInSection:0] > 0) {
            if(self.saleDetail.hasMoreProductsToFetch) {
                UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kSaleLoadingFooterHeight)];
                UILabel *label = [[UILabel alloc] initWithFrame:footerView.frame];
                [label setText:kSaleLoadingFooterTitle];
                label.textAlignment = UITextAlignmentCenter;
                label.textColor = kPlndrTextGold;
                label.font = kFontMedium14;
                label.backgroundColor = [UIColor clearColor];
                [footerView addSubview:label];
                
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
                spinner.center = CGPointMake(35, footerView.frame.size.height/2);
                spinner.color = kPlndrTextGold;
                [spinner startAnimating];
                
                [footerView addSubview:spinner];
                return footerView;
            }
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.productTable) {
        return kSaleScreenThumbnailHeight + kSaleScreenThumbnailMargin;
    } else {
        return kSaleScreenFilterTableRowHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.productTable) {
        return ceil(self.products.count/3.0);
    } else {
        if (self.currentSelectedFilterControl == CategoryFilterControl) {
            return self.categories.count;
        } else {
            return [[self.saleDetail getSizesForCurrentCategory] count];
        }
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if (tableView == self.productTable) {
        CellIdentifier = @"productTripleCell";
        
        ProductListTripleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ProductListTripleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.leftThumbnail.productThumbnailButton addTarget:self action:@selector(productThumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.middleThumbnail.productThumbnailButton addTarget:self action:@selector(productThumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightThumbnail.productThumbnailButton addTarget:self action:@selector(productThumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        int firstIndex = [self getProductIndexForRow:indexPath.row];
        [cell.leftThumbnail updateWithProduct:[self.products objectAtIndex:firstIndex] index:firstIndex];
        
        int secondIndex = firstIndex + 1;
        if (secondIndex < [self.products count]) {
            [cell.middleThumbnail updateWithProduct:[self.products objectAtIndex:secondIndex] index:secondIndex];
        } else {
            cell.middleThumbnail.hidden = YES;
        }
        
        int thirdIndex = secondIndex + 1;
        if (thirdIndex < [self.products count]) {
            [cell.rightThumbnail updateWithProduct:[self.products objectAtIndex:thirdIndex] index:thirdIndex];
        } else {
            cell.rightThumbnail.hidden = YES;
        }
        
        if((indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - ((kProductPageSize)/3)/5) && self.saleDetail.hasMoreProductsToFetch ) {
            [self createProductsSubscription:NO fetchMore:YES];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        CellIdentifier = @"filterTableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.font = kFontBold14;
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
        }
        
        for(UIView* view in [cell.contentView subviews]) {
            if(view.tag == FILTERCELL_SEPARATOR_TAG){
                [view removeFromSuperview];
            }
        }
        
        UIView *topSeparator = [[UIView alloc] initWithFrame:CGRectMake(kSaleFilterCellSeparatorPadding, 0,kSaleFilterCellSeparatorWidth, kSaleFilterCellSaparatorHeight)];
        topSeparator.backgroundColor = kPlndrMediumGreyTextColor;
        if(indexPath.row == 0) {
            CGRect frame = CGRectMake(kSaleFilterCellSeparatorPadding, 0,kSaleFilterCellSeparatorWidth,kSaleFilterCellSaparatorHeight*2);
            topSeparator.frame = frame;
        }
        topSeparator.tag = FILTERCELL_SEPARATOR_TAG;
        [cell.contentView addSubview:topSeparator];
        
        UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(topSeparator.frame.origin.x, cell.frame.size.height - kSaleFilterCellSaparatorHeight, topSeparator.frame.size.width, kSaleFilterCellSaparatorHeight)];
        bottomSeparator.backgroundColor = topSeparator.backgroundColor;
        if(indexPath.row == [self.filterTable numberOfRowsInSection:indexPath.section] - 1) {
            CGRect frame = CGRectMake(topSeparator.frame.origin.x, cell.frame.size.height - kSaleFilterCellSaparatorHeight*2,topSeparator.frame.size.width,kSaleFilterCellSaparatorHeight*2);
            bottomSeparator.frame = frame;
        }
        bottomSeparator.tag = FILTERCELL_SEPARATOR_TAG;
        [cell.contentView addSubview:bottomSeparator];

        
        if (self.currentSelectedFilterControl == CategoryFilterControl) {
            cell.textLabel.text = ((SaleFilterCategory*)[self.categories objectAtIndex:indexPath.row]).displayName;
            BOOL isCurrentSelectedCateogry = (indexPath.row == self.saleDetail.currentFilterCategoryIndex);
            cell.accessoryView =isCurrentSelectedCateogry ?
                                    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_icn.png"]] : nil;
            cell.textLabel.textColor = isCurrentSelectedCateogry ? kPlndrTextGold : kPlndrLightGreyTextColor;
        } else {
            cell.textLabel.text = ((SaleFilterSize*)[[self.saleDetail getSizesForCurrentCategory] objectAtIndex:indexPath.row]).displayName;
            BOOL isCurrentSelectedSize = (indexPath.row == self.saleDetail.currentFilterSizeIndex);
            cell.accessoryView =  isCurrentSelectedSize ?
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_icn.png"]] : nil;
            cell.textLabel.textColor = isCurrentSelectedSize ? kPlndrTextGold : kPlndrLightGreyTextColor;
        }       
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.productTable) {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.filterTable) {
        if (self.currentSelectedFilterControl == CategoryFilterControl) {
            if (self.saleDetail.currentFilterCategoryIndex == indexPath.row) {
                [self triggerFilterControl:NoFilterControl];
                return;
            } else {
                [self.saleDetail updateCurrentCategoryFilterIndex:indexPath.row];
                [self createProductsSubscription:YES fetchMore:NO];
                [self createSizesSubscription:NO];
            }
        } else {
            if (self.saleDetail.currentFilterSizeIndex == indexPath.row) {
                [self triggerFilterControl:NoFilterControl];
                return;
            } else {
                [self.saleDetail updateCurrentSizeFilterIndex:indexPath.row];
                [self createProductsSubscription:YES fetchMore:NO];
            }
        }
        [self updateFilterButtons];
        [self triggerFilterControl:NoFilterControl];
        [self.filterTable reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private

- (void)setupRightBarButtons {
    // Setup the right nav buttons
    UIImage *shareButtonImage = [UIImage imageNamed:@"share_icn.png"];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kDeviceWidth - shareButtonImage.size.width, (kNavBarFrame.size.height - shareButtonImage.size.height)/2, shareButtonImage.size.width, shareButtonImage.size.height);
    [shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_icn_hl.png"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareProduct:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
}

- (void) productThumbnailClicked:(id)sender{
    [self selectProductAtIndex:((UIButton*)sender).tag];
}

- (void) selectProductAtIndex:(int)index {
    // Re-cache the sale detail, incase the cache was destroyed by a memory warning
    [[ModelContext instance] addSaleDetailToCache:self.saleDetail];
    
    Product *product = [self.products objectAtIndex:index];
    
    ProductViewController *productVC = [[ProductViewController alloc] initWithProduct:product saleId:self.saleDetail.sale.saleId];
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void) createProductsSubscription:(BOOL)forceFetch fetchMore:(BOOL)fetchMore{
    [_productsSubscription cancel]; //Cancel any previously set up subscription
    
    BOOL shouldFetchMore = forceFetch ? NO : fetchMore;
    
    NSString *categoryId;
    NSString *sizeValue;
    
    if (self.saleDetail.currentFilterCategoryIndex < 0) {
        categoryId = @"";
        sizeValue = @"";
    } else {
        SaleFilterCategory *currentCategory = [self.saleDetail.filterCategories objectAtIndex:self.saleDetail.currentFilterCategoryIndex];
        categoryId = currentCategory.categoryId;
        
        if (self.saleDetail.currentFilterSizeIndex < 0) {
            sizeValue = @"";
        } else {
            sizeValue = ([currentCategory.sizes count] > 0) ? ((SaleFilterSize*)[currentCategory.sizes objectAtIndex:self.saleDetail.currentFilterSizeIndex]).value : @"";
        }
    }
    
    
    // Re-cache the sale detail, incase the cache was destroyed by a memory warning
    [[ModelContext instance] addSaleDetailToCache:self.saleDetail];
    
    _productsSubscription = [[ProductsSubscription alloc] initWithSale:self.saleDetail.sale
                                                            categoryId:categoryId
                                                             sizeValue:sizeValue
                                                        genderCategory:self.saleDetail.genderCategory
                                                               context:[ModelContext instance]
                                                             fetchMore:shouldFetchMore
                                                            forceFetch:forceFetch];
    _productsSubscription.delegate = self;
    [self subscriptionUpdatedState:_productsSubscription];
}

- (void) createCategoriesSubscription:(BOOL)forceFetch{
    [_categoriesSubscription cancel]; //Cancel any previously set up subscription
    _categoriesSubscription = [[SaleFilterCategorySubscription alloc] initWithSale:self.saleDetail.sale genderCategory:self.saleDetail.genderCategory context:[ModelContext instance] forceFetch:forceFetch];
    _categoriesSubscription.delegate = self;
    [self subscriptionUpdatedState:_categoriesSubscription];
}

- (void) createSizesSubscription:(BOOL)forceFetch{
    
    
    NSString *categoryId; 
    
    if (self.saleDetail.currentFilterCategoryIndex < 0) {
        categoryId = @"";
    } else {
        SaleFilterCategory *currentCategory = [self.saleDetail.filterCategories objectAtIndex:self.saleDetail.currentFilterCategoryIndex];
        if (currentCategory) {
            categoryId = currentCategory.categoryId;
        } else {
            categoryId = @"";
        }
    }    
    
    if (categoryId.length > 0) {
        [_sizesSubscription cancel]; //Cancel any previously set up subscription
        _sizesSubscription = [[SaleFilterSizeSubscription alloc] initWithSale:self.saleDetail.sale categoryId:categoryId genderCategory:self.saleDetail.genderCategory context:[ModelContext instance] forceFetch:forceFetch];
        _sizesSubscription.delegate = self;
        [self subscriptionUpdatedState:_sizesSubscription];
    } else {
        // There's no size subscription to get... you need a category first
    }
}

- (void) updateViews {    
    [self.productTable reloadData];
}

- (void)updateFilterButtons {
    [self.categoryFilterButton setTitle:[self.saleDetail getCurrentCategoryDisplayString] forState:UIControlStateNormal];
    [self.sizeFilterButton setTitle:[self.saleDetail getCurrentSizeDisplayString] forState:UIControlStateNormal];
}

- (NSInteger)getProductIndexForRow:(int)row {
    return (row*3);
}

- (void)toggleCategoryFilterView {
    if (self.currentSelectedFilterControl != CategoryFilterControl) {
        [self triggerFilterControl:CategoryFilterControl];
    } else {
        [self triggerFilterControl:NoFilterControl];
    }
}

- (void)toggleSizeFilterView {
    if (self.currentSelectedFilterControl != SizeFilterControl) {
        [self triggerFilterControl:SizeFilterControl];
    } else {
        [self triggerFilterControl:NoFilterControl];
    }
}

- (void) triggerFilterControl:(FilterControl)filterControl {
    BOOL categoryFilterSelected = filterControl == CategoryFilterControl;
    BOOL sizeFilterSelected = filterControl == SizeFilterControl;
    self.currentSelectedFilterControl = filterControl;
    self.categoryFilterButton.frame = [self getCategoryControlFrame:categoryFilterSelected];
    [self.categoryFilterButton setBackgroundImage:[self getCategoryControlImage:categoryFilterSelected] forState:UIControlStateNormal];
    [self.categoryFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateNormal isSelected:categoryFilterSelected] forState:UIControlStateNormal];
    [self.categoryFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateHighlighted isSelected:categoryFilterSelected] forState:UIControlStateHighlighted];
    [self.categoryFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateDisabled isSelected:categoryFilterSelected] forState:UIControlStateDisabled];
    
    self.sizeFilterButton.frame = [self getSizeControlFrame:sizeFilterSelected];
    [self.sizeFilterButton setBackgroundImage:[self getSizeControlImage:sizeFilterSelected] forState:UIControlStateNormal];
    [self.sizeFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateNormal isSelected:sizeFilterSelected] forState:UIControlStateNormal];
    [self.sizeFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateHighlighted isSelected:sizeFilterSelected] forState:UIControlStateHighlighted];
    [self.sizeFilterButton setTitleColor:[self getFilterControlColorForState:UIControlStateDisabled isSelected:sizeFilterSelected] forState:UIControlStateDisabled];
    
    if (categoryFilterSelected || sizeFilterSelected) {
       [self showFilter]; 
    } else {
        [self hideFilter];
    }
    
}

- (void) showFilter {
    self.wrapperView.hidden = NO;
    [self.filterTable removeFromSuperview];
    [self.view insertSubview:self.filterTable aboveSubview:self.wrapperView];
    self.filterTable.hidden = NO;
    
    [self.filterTable reloadData];
}

- (void) hideFilter {
    self.filterTable.hidden = YES;
}

- (CGRect) getCategoryControlFrame:(BOOL)selected {
    UIImage *categoryImage = [self getCategoryControlImage:selected];
    return CGRectMake(kDeviceWidth/2 - categoryImage.size.width, kSaleScreenHeaderTopMargin, categoryImage.size.width, categoryImage.size.height);
}

- (CGRect) getSizeControlFrame:(BOOL)selected {
    UIImage *categoryImage = [self getCategoryControlImage:selected];
    return CGRectMake(kDeviceWidth/2, kSaleScreenHeaderTopMargin, categoryImage.size.width, categoryImage.size.height);
}

- (UIImage *)getCategoryControlImage:(BOOL)selected {
    if (selected) {
        return [UIImage imageNamed:@"sub_menu_hl.png"];
    } else {
        return [UIImage imageNamed:@"sub_menu_left.png"];
    }
}

- (UIImage *)getSizeControlImage:(BOOL)selected {
    if (selected) {
        return [UIImage imageNamed:@"sub_menu_hl.png"];
    } else {
        return [UIImage imageNamed:@"sub_menu_right.png"];
    }
}

- (UIColor*) getFilterControlColorForState:(UIControlState)state isSelected:(BOOL)isSelected {
    switch (state) {
        case UIControlStateHighlighted:
            return kPlndrMediumGreyTextColor;
        case UIControlStateDisabled:
            return kPlndrMediumGreyTextColor;
        case UIControlStateNormal: //fall into default
        default:
            if (isSelected) {
                return kPlndrWhite;
            } else {
                return kPlndrBlack;
            }
    }
}

- (void) setFilterControlState:(FilterControlState)filterControlState forFilterControl:(UIButton*)filterControl {    
    switch (filterControlState) {
        case FilterControlStateReady:
            filterControl.enabled = YES;
            break;
        case FilterControlStateLoading:
            filterControl.enabled = NO;
            break;
        case FilterControlStateDisabled:
            filterControl.enabled = NO;
            break;
    }

}

- (void) updateTimer {
    NSString *redTxt = @"";
    RemainingSaleTime unusedRST = RemainingSaleTimeLots;
    NSString *txt = [Utility stringForSaleEndDate:self.endDate textToMakeRed:&redTxt remainingSaleTime:&unusedRST];
    
    
    int totalSecondsUntilEnd = [self.endDate timeIntervalSinceNow];
    int daysUntilEnd = totalSecondsUntilEnd / kSecondsInDay;
    
    if (daysUntilEnd == 0) {
        if (self.timerBackground.hidden) {
            self.timerBackground.hidden = NO;
            self.timerLabel.hidden = NO;
        }        
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
        [attrStr setFont:kFontTimer];
        [attrStr setTextColor:kPlndrTextRed range:[txt rangeOfString:redTxt]];
        
        self.timerLabel.attributedText = attrStr;
        self.timerLabel.textAlignment = UITextAlignmentCenter;
        if (![Utility isTimeInFuture:self.endDate]) {
            [self.clockUpdateTimer invalidate]; // Invalidate the Timer as it has hit 0.
            [self expireCurrentView];
        }
    }
    
    // Else Do nothing as timer is more than 1 day
    
}


- (void) scheduleClockTimer {
    BOOL isTimeInFuture = [Utility isTimeInFuture:self.endDate];
    // This needs to be checked before calling updatedTimer
    
    [self updateTimer];
    [self.clockUpdateTimer invalidate];
    
    if (isTimeInFuture) {
        self.clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES]; 
    }
}

- (void)expireCurrentView {
    PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:kSaleEndTitle message:[NSString stringWithFormat: kSaleEndErrorMessage, self.saleDetail.sale.name] buttonOneTitle:kSaleEndButtonTitle ];
    [PopupUtil presentPopup:popup withDelegate:self];
}

- (BOOL)isAnySubscriptionLoading {
    return (self.productsSubscription.state == SubscriptionStatePending || self.categoriesSubscription.state == SubscriptionStatePending || self.sizesSubscription.state == SubscriptionStatePending);
}

- (void)handleConnectionError {
    [self setFilterControlState:FilterControlStateReady forFilterControl:self.categoryFilterButton];
    [self setFilterControlState:FilterControlStateReady forFilterControl:self.sizeFilterButton];
    [super handleConnectionError];
}


#pragma mark - SimplifiedEGORefreshTableHeaderDelegate Methods

- (void)pullDownToRefreshContent {
    [self createProductsSubscription:YES fetchMore:NO];
    [self createCategoriesSubscription:YES];
    [self createSizesSubscription:YES];
}

- (BOOL)pullDownIsLoading{
    return [self isAnySubscriptionLoading];
}

- (void)resetPullDownViewIfDoneLoading {
    if (![self isAnySubscriptionLoading]) {
        [self resetPullDownView];
    }
}

- (void)shareProduct:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Email",@"Facebook",@"Twitter",@"SMS", nil];
	[actionSheet showInView:self.tabBarController.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case ShareActionSheetFacebook:
			[[SocialManager instance] setSocialManagerDelegate:self];
			[[SocialManager instance] loginFacebookAndPopDialog];
			break;
		case ShareActionSheetEmail:
		case ShareActionSheetSMS:
		case ShareActionSheetTwitter:
		default:
			[[SocialManager instance] shareSaleViaShareActionType:(ShareActionSheetType)buttonIndex brandName:self.saleDetail.sale.name url:self.saleDetail.sale.url viewController:self];
			break;
	}	
}

#pragma mark - SocialManagerDelegate Methods

- (void) onFacebookLoginSuccess {
	[[SocialManager instance] setSocialManagerDelegate:nil];
    [[SocialManager instance] facebookShareSaleWithBrandName:self.saleDetail.sale.name url:self.saleDetail.sale.url];
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription == self.productsSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [_productsSubscription cancel];
            self.products = [[ModelContext instance] getProductsForSaleId:self.saleDetail.sale.saleId];
            [self hideLoadingView];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            self.products = nil;
            [self hideLoadingView];
        } else { //Pending
            // Do nothing as we are showing a pull to refresh
        } 
    } else if (subscription == self.categoriesSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [_categoriesSubscription cancel];
            
            self.categories = [[ModelContext instance] getCategoryFiltersForSaleId:self.saleDetail.sale.saleId];
            [self setFilterControlState:FilterControlStateReady forFilterControl:self.categoryFilterButton];
            
            if (self.sizesSubscription.state != SubscriptionStatePending) {
                // Size starts out disabled: if it's not making its own call, enable it
                [self setFilterControlState:FilterControlStateReady forFilterControl:self.sizeFilterButton];
            }
            [self updateFilterButtons];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self setFilterControlState:FilterControlStateDisabled forFilterControl:self.categoryFilterButton];
            [self setFilterControlState:FilterControlStateDisabled forFilterControl:self.sizeFilterButton];
        } else { //Pending
            [self setFilterControlState:FilterControlStateLoading forFilterControl:self.categoryFilterButton];
        } 
    } else if (subscription == self.sizesSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [_sizesSubscription cancel];
            
            self.categories = [[ModelContext instance] getCategoryFiltersForSaleId:self.saleDetail.sale.saleId];
            [self setFilterControlState:FilterControlStateReady forFilterControl:self.sizeFilterButton];
            [self updateFilterButtons];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self setFilterControlState:FilterControlStateDisabled forFilterControl:self.sizeFilterButton];
        } else { //Pending
            [self setFilterControlState:FilterControlStateLoading forFilterControl:self.sizeFilterButton];
        } 
    }
    
    if (subscription.state != SubscriptionStatePending) {
        [self updateViews];
    }
    [self resetPullDownViewIfDoneLoading];
}
#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) moveToHomePage];

}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [self dismissPopup:sender];
}

#pragma mark - wrapperView Method

- (void)wrapperClicked:(id)sender {
    if (self.currentSelectedFilterControl == CategoryFilterControl) {
        [self toggleCategoryFilterView];
    } else if (self.currentSelectedFilterControl == SizeFilterControl) {
        [self toggleSizeFilterView];
    }
    self.wrapperView.hidden = YES;
}

@end
