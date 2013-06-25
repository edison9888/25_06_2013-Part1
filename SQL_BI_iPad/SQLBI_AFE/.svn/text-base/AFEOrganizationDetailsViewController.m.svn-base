//
//  AFEOrganizationDetailsViewController.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEOrganizationDetailsViewController.h"
#import "AppDelegate.h"

#define TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView @"AFEClassesForPieChartInTopAFEClassesDetailView"
#define TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView @"AFEClassesForTableInTopAFEClassesDetailView"
#define TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView @"AFEForBarchartInTopBudgetedAFEDetailView"
#define TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView @"AFEForTableInTopBudgetedAFEDetailView"
#define TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView @"AFEForHeatMapInProjectWatchlistDetailView"
#define TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView @"AFEForTableInProjectWatchlistDetailView"
#define TAG_REQUESTINFO_AFEForTableInOverlayAFETable @"AFEForTableInOverlayAFETable"
@implementation UIPageControl (Custom)

- (void)setCurrentPage:(NSInteger)page {
    
    NSString* imgActive = [[NSBundle mainBundle] pathForResource:@"roundSelected" ofType:@"png"];
    NSString* imgInactive = [[NSBundle mainBundle] pathForResource:@"roundSelected" ofType:@"png"];
    
    for (int subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.cornerRadius=8.0;
        subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, 7, 7);
        if (subviewIndex == page)
            [subview setImage:[UIImage imageWithContentsOfFile:imgActive]];
        else 
            [subview setImage:[UIImage imageWithContentsOfFile:imgInactive]];
    }
}
@end

@interface AFEOrganizationDetailsViewController ()
{
    int selectedIndex;
    
    NSDate *startDate;
    NSDate *endDate;
    
    //HeadlineMetricsDetailedView *headLineMetricsDetailedView;
    TopAFEClassesDetailedView *topAFEClassDetailedView;
    TopBudgetedAFEDetailedView *topBudgetedAFEDetailedView;
    ProjectWatchlistDetailedView *projectWatchlistDetailedView;
    
    OverlayViewAFETable *overlayAFETableView;
    
    NSArray *afeClassesArray_PieChartInTopAFEClasses;
    NSArray *afeClassesArray_TableInTopAFEClasses;
    NSArray *afeArray_BarChartInTopBudgetedAFE;
    NSArray *afeArray_TableInTopBudgetedAFE;
    NSArray *afeArray_HeatMapInProjectWatchlist;
    NSArray *afeArray_TableInProjectWatchlist;
     NSArray *afeArray_TableInOverlayAFETable;
    
    int totalPageCount_PieChartInTopAFEClasses;
    int totalPageCount_TableInTopAFEClasses;
    int totalPageCount_BarChartInTopBudgetedAFE;
    int totalPageCount_TableInTopBudgetedAFE;
    int totalPageCount_HeatMapInProjectWatchlist;
    int totalPageCount_TableInProjectWatchlist;
    int totalPageCount_TableInOverlayAFETable;
    
    int totalRecordCount_PieChartInTopAFEClasses;
    int totalRecordCount_TableInTopAFEClasses;
    int totalRecordCount_BarChartInTopBudgetedAFE;
    int totalRecordCount_TableInTopBudgetedAFE;
    int totalRecordCount_HeatMapInProjectWatchlist;
    int totalRecordCount_TableInProjectWatchlist;
    int totalRecordCount_TableInOverlayAFETable;
    
    int newPageNumber_PieChartInTopAFEClasses;
    int newPageNumber_TableInTopAFEClasses;
    int newPageNumber_BarChartInTopBudgetedAFE;
    int newPageNumber_TableInTopBudgetedAFE;
    int newPageNumber_HeatMapInProjectWatchlist;
    int newPageNumber_TableInProjectWatchlist;
    int newPageNumber_TableInOverlayAFETable;
    
    BOOL swipeAnimationRunning;
    
}

@property(nonatomic, assign) AFEOrganizationSummaryPageType currentPageType;
@property(nonatomic, assign) AFEOrganizationSummaryPageType newPageType;
@property(nonatomic, strong) NSString *currentlySelectedOrgType;
@property(nonatomic, strong) NSString *currentlySelectedOrgID;
@property(nonatomic, strong) NSString *currentlySelectedStatus;
@property(nonatomic, strong) NSDate *currentlySelectedStartDate;
@property(nonatomic, strong) NSDate *currentlySelectedEndDate;
@property(nonatomic, strong) OrganizationSearchAPIHandler *apiHandlerOrgSummary;
@property(nonatomic, strong) NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic,strong) IBOutlet UIPageControl *pageControl;

-(void) initializeOrgSummaryAPIHandlerAndRequestArray;
-(void) stopAllAPICalls;
-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj;
-(void) setDateOnHeader;

@end


@implementation AFEOrganizationDetailsViewController
@synthesize currentPageType, dataSource, delegate, newPageType;
@synthesize apiHandlerOrgSummary, apiRequestInfoObjectArray;
@synthesize currentlySelectedOrgID;
@synthesize currentlySelectedOrgType;
@synthesize currentlySelectedStatus;
@synthesize currentlySelectedStartDate;
@synthesize currentlySelectedEndDate;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}


-(id) initWithOrganizationSummaryPageSeleted:(AFEOrganizationSummaryPageType) pageType
{
    self = [super initWithNibName:@"AFEOrganizationDetailsViewController" bundle:nil];
    
    if(self)
    {
        startDate = [NSDate dateWithTimeIntervalSinceNow:-3600*24*1];
        endDate = [NSDate date];
        currentPageType = pageType;
        
        [self setFontsForHeaderTabs];
        [self initalizeDetailedViews];
           
    
    }
    
    return self;
}

-(void)awakeFromNib
{
    
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 3;
    
    dateLabel.text = @"";
    
}
    
-(void) setFontsForHeaderTabs
{
    [headerBtnTopBudget.titleLabel setFont:FONT_DETAIL_PAGE_TAB];
    [headerBtnTopAFEClass.titleLabel setFont:FONT_DETAIL_PAGE_TAB];
    [headerBtnProjectWatchlist.titleLabel setFont:FONT_DETAIL_PAGE_TAB];  
    
    [dateLabel setFont:FONT_SUMMARY_DATE];
    [dateLabel setTextColor:COLOR_DASHBORD_DATE];
}


-(void) initalizeDetailedViews
{   
    controllerConatiner.clipsToBounds = YES;
    
    if(!topAFEClassDetailedView)
    {
        topAFEClassDetailedView = [[TopAFEClassesDetailedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        topAFEClassDetailedView.swipeDelegate = self;
        topAFEClassDetailedView.delegate = self;
        topAFEClassDetailedView.clipsToBounds = YES;
        topAFEClassDetailedView.delegate = self;
    }
    
    if(!topBudgetedAFEDetailedView)
    {
        topBudgetedAFEDetailedView = [[TopBudgetedAFEDetailedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        topBudgetedAFEDetailedView.swipeDelegate = self;  
        topBudgetedAFEDetailedView.clipsToBounds = YES;
        topBudgetedAFEDetailedView.delegate = self;
    }
    
    if(!projectWatchlistDetailedView)
    {
        projectWatchlistDetailedView = [[ProjectWatchlistDetailedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        projectWatchlistDetailedView.swipeDelegate = self;
        projectWatchlistDetailedView.delegate = self;
    }
    
}


-(void) selectTabForNewPageType:(AFEOrganizationSummaryPageType) newType
{
    switch (newType) {
        case AFEOrganizationSummaryPageTypeTopAFEClasses:
            [headerBtnTopAFEClass setSelected:YES];
            [headerBtnTopAFEClass setUserInteractionEnabled:NO];
            [headerBtnTopBudget setSelected:NO];
            [headerBtnTopBudget setUserInteractionEnabled:YES];
            [headerBtnProjectWatchlist setSelected:NO];
            [headerBtnProjectWatchlist setUserInteractionEnabled:YES];
            break;
        case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
            [headerBtnTopAFEClass setSelected:NO];
            [headerBtnTopAFEClass setUserInteractionEnabled:YES];
            [headerBtnTopBudget setSelected:YES];
            [headerBtnTopBudget setUserInteractionEnabled:NO];
            [headerBtnProjectWatchlist setSelected:NO];
            [headerBtnProjectWatchlist setUserInteractionEnabled:YES];
            break;
            
        case AFEOrganizationSummaryPageTypeProjectWatchlist:
            [headerBtnTopAFEClass setSelected:NO];
            [headerBtnTopAFEClass setUserInteractionEnabled:YES];
            [headerBtnTopBudget setSelected:NO];
            [headerBtnTopBudget setUserInteractionEnabled:YES];
            [headerBtnProjectWatchlist setSelected:YES];
            [headerBtnProjectWatchlist setUserInteractionEnabled:NO];
            break;
            
        default:
            break;
    }
    
}

-(void) loadPageForPageType:(AFEOrganizationSummaryPageType) pageType WithAnimation:(BOOL) animation animationDirection:(AFEAnimationDirection) direction
{
    currentPageType = pageType;
    
    switch (pageType) {
        case AFEOrganizationSummaryPageTypeTopAFEClasses:
            [self selectTabForNewPageType:AFEOrganizationSummaryPageTypeTopAFEClasses];
            //[self loadTopAFEClassViewWithAnimation:animation animationDirection:direction];
            pageControl.currentPage = 0;
            break;
        case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
            [self selectTabForNewPageType:AFEOrganizationSummaryPageTypeTopBudgetedAFE];
            //[self loadTopBudgettedAFEViewWithAnimation:animation animationDirection:direction];
            pageControl.currentPage = 1;
            break;
            
        case AFEOrganizationSummaryPageTypeProjectWatchlist:
            [self selectTabForNewPageType:AFEOrganizationSummaryPageTypeProjectWatchlist];
            //[self loadProjectWatchlistiewWithAnimation:animation animationDirection:direction];
            pageControl.currentPage = 2;
            break;

        default:
            break;
    }
    
    
    UIView *newPage;
    
    switch (pageType) {
        case AFEOrganizationSummaryPageTypeTopAFEClasses:
            newPage = topAFEClassDetailedView;
            break;
            
        case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
            newPage = topBudgetedAFEDetailedView;
            break;
            
        case AFEOrganizationSummaryPageTypeProjectWatchlist:
            newPage = projectWatchlistDetailedView;
            break;
            
        default:
            break;
    }
    
    if(!newPage)
        return;

    if(animation)
    {
        swipeAnimationRunning = YES;
        
        float startingX;
        float endingX;
        
        switch (direction) {
            case AFEAnimationDirectionLeft:
            {
                startingX = 1000;
                endingX = 0;
            }
                break;
            case AFEAnimationDirectionRight:
            {
                startingX = -1000;
                endingX = 0;
            }
                break;
            
                default:
                break;
        }
        
        newPage.frame = CGRectMake(startingX, newPage.frame.origin.y, newPage.frame.size.width, newPage.frame.size.height);
        [controllerConatiner addSubview:newPage];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             newPage.frame = CGRectMake(endingX, newPage.frame.origin.y, newPage.frame.size.width, newPage.frame.size.height);
                         } 
                         completion:^(BOOL finished){
                             
                             switch (pageType) {
                                 case AFEOrganizationSummaryPageTypeTopAFEClasses:
                                  
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView])
                                     {
                                         [topAFEClassDetailedView showActivityIndicatorOverlayViewOnPieChart];
                                     }
                                     else
                                     {
                                         [topAFEClassDetailedView refreshPieChartWithAFEClassesArray:afeClassesArray_PieChartInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }
                                     
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView])
                                     {
                                         [topAFEClassDetailedView showActivityIndicatorOverlayViewOnTable];
                                     }
                                     else
                                     {
                                         [topAFEClassDetailedView refreshTableWithAFEClassesArray:afeClassesArray_TableInTopAFEClasses forPage:newPageNumber_TableInTopAFEClasses ofTotalPages:totalPageCount_TableInTopAFEClasses  andTotalRecords:totalRecordCount_TableInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }

                                     break;
                                     
                                 case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
                                     
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView])
                                     {
                                         [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnBarChart];
                                     }
                                     else
                                     {
                                         [topBudgetedAFEDetailedView refreshBarChartWithAFEArray:afeArray_BarChartInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }
                                     
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView])
                                     {
                                         [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnTable];
                                     }
                                     else
                                     {
                                         [topBudgetedAFEDetailedView refreshTableWithAFEArray:afeArray_TableInTopBudgetedAFE forPage:newPageNumber_TableInTopBudgetedAFE ofTotalPages:totalPageCount_TableInTopBudgetedAFE  andTotalRecords:totalRecordCount_TableInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }

                                     break;
                                     
                                 case AFEOrganizationSummaryPageTypeProjectWatchlist:
                                     
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView])
                                     {
                                         [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnHeatMap];
                                     }
                                     else
                                     {
                                         [projectWatchlistDetailedView refreshHeatMapWithAFEArray:afeArray_HeatMapInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }
                                     
                                     if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView])
                                     {
                                         [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnTable];
                                     }
                                     else
                                     {
                                         [projectWatchlistDetailedView refreshTableWithAFEArray:afeArray_TableInProjectWatchlist forPage:newPageNumber_TableInProjectWatchlist ofTotalPages:totalPageCount_TableInProjectWatchlist andTotalRecords:totalRecordCount_TableInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                                     }
                                     
                                     break;
                                     
                                 default:
                                     break;
                             }
                             
                                                        
//                             currentPageType = pageType;
                             
                             swipeAnimationRunning = NO;
                             
                         }];
        
    }
    else
    {
        
        [controllerConatiner.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        newPage.frame = CGRectMake(0, newPage.frame.origin.y, newPage.frame.size.width, newPage.frame.size.height);
        [controllerConatiner addSubview:newPage];
        
        switch (pageType) {
            case AFEOrganizationSummaryPageTypeTopAFEClasses:
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView])
                {
                    [topAFEClassDetailedView showActivityIndicatorOverlayViewOnPieChart];
                }
                else
                {
                    [topAFEClassDetailedView refreshPieChartWithAFEClassesArray:afeClassesArray_PieChartInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView])
                {
                    [topAFEClassDetailedView showActivityIndicatorOverlayViewOnTable];
                }
                else
                {
                    [topAFEClassDetailedView refreshTableWithAFEClassesArray:afeClassesArray_TableInTopAFEClasses forPage:newPageNumber_TableInTopAFEClasses ofTotalPages:totalPageCount_TableInTopAFEClasses  andTotalRecords:totalRecordCount_TableInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                break;
                
            case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView])
                {
                    [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnBarChart];
                }
                else
                {
                    [topBudgetedAFEDetailedView refreshBarChartWithAFEArray:afeArray_BarChartInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView])
                {
                    [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnTable];
                }
                else
                {
                    [topBudgetedAFEDetailedView refreshTableWithAFEArray:afeArray_TableInTopBudgetedAFE forPage:newPageNumber_TableInTopBudgetedAFE ofTotalPages:totalPageCount_TableInTopBudgetedAFE  andTotalRecords:totalRecordCount_TableInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                break;
                
            case AFEOrganizationSummaryPageTypeProjectWatchlist:
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView])
                {
                    [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnHeatMap];
                }
                else
                {
                    [projectWatchlistDetailedView refreshHeatMapWithAFEArray:afeArray_HeatMapInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView])
                {
                    [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnTable];
                }
                else
                {
                    [projectWatchlistDetailedView refreshTableWithAFEArray:afeArray_TableInProjectWatchlist forPage:newPageNumber_TableInProjectWatchlist ofTotalPages:totalPageCount_TableInProjectWatchlist andTotalRecords:totalRecordCount_TableInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
                }
                
                break;
                
            default:
                break;
        }
        
        
        //currentPageType = pageType;
        swipeAnimationRunning = NO;
    }

}


-(void) removeCurrentPageWtihAnimation:(BOOL) animation animationDirection:(AFEAnimationDirection) direction
{
    UIView *currentView;
    
    switch (currentPageType) {
        case AFEOrganizationSummaryPageTypeTopAFEClasses:
            currentView = topAFEClassDetailedView;
            break;
            
        case AFEOrganizationSummaryPageTypeTopBudgetedAFE:
            currentView = topBudgetedAFEDetailedView;
            break;
            
        case AFEOrganizationSummaryPageTypeProjectWatchlist:
            currentView = projectWatchlistDetailedView;
            break;
            
        default:
            break;
    }

    if(!currentView)
        return;
    
    if(animation)
    {
        swipeAnimationRunning = YES;
        switch (direction) 
        {
            case AFEAnimationDirectionLeft:
            {
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options: UIViewAnimationCurveEaseOut
                                 animations:^{
                                     currentView.frame = CGRectMake(-1000, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
                                 } 
                                 completion:^(BOOL finished){
                                     
                                     if(currentPageType == AFEOrganizationSummaryPageTypeTopAFEClasses && ![currentView isKindOfClass:[TopAFEClassesDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     else if(currentPageType == AFEOrganizationSummaryPageTypeTopBudgetedAFE && ![currentView isKindOfClass:[TopBudgetedAFEDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     else if(currentPageType == AFEOrganizationSummaryPageTypeProjectWatchlist && ![currentView isKindOfClass:[ProjectWatchlistDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     
                                     
                                 }];
            }
                break;
                
            case AFEAnimationDirectionRight:
            {
                [UIView animateWithDuration:0.5
                                      delay:0
                                    options: UIViewAnimationCurveEaseOut
                                 animations:^{
                                     currentView.frame = CGRectMake(+1000, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height);
                                 } 
                                 completion:^(BOOL finished){
                                     
                                     if(currentPageType == AFEOrganizationSummaryPageTypeTopAFEClasses && ![currentView isKindOfClass:[TopAFEClassesDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     else if(currentPageType == AFEOrganizationSummaryPageTypeTopBudgetedAFE && ![currentView isKindOfClass:[TopBudgetedAFEDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     else if(currentPageType == AFEOrganizationSummaryPageTypeProjectWatchlist && ![currentView isKindOfClass:[ProjectWatchlistDetailedView class]])
                                     {
                                         [currentView removeFromSuperview];
                                     }
                                     
                                 }];
            }
                break;
                
            default:
                break;
        }
        
    }
    else
    {
        [currentView removeFromSuperview];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    pageControl.numberOfPages = 3;
    [self setFontsForHeaderTabs];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    minimizeDetailButton.userInteractionEnabled = NO;
    //This is done inorder to fix and issue
    [minimizeDetailButton performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];
    
    //For Top AFE Classes activity indicators
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView])
    {
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnPieChart];
    }
    else
    {
        [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnPieChart];
    }
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView])
    {
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnTable];
    }
    else
    {
        [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnTable];
    }
    
    
    //For Top Budgeted AFE activity indicators
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView])
    {
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnBarChart];
    }
    else
    {
        [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnBarChart];
    }
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView])
    {
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnTable];
    }
    else
    {
        [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnTable];
    }

    
    //For Project Wathclist activity indicators
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView])
    {
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnHeatMap];
    }
    else
    {
        [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnHeatMap];
    }
    
    
    if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView])
    {
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnTable];
    }
    else
    {
        [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnTable];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}

-(void) loadPageWithType:(AFEOrganizationSummaryPageType) pageType
{
    [self loadPageForPageType:pageType WithAnimation:NO animationDirection:AFEAnimationDirectionLeft];
}


-(void) setSelectedIndex:(int)index
{
    selectedIndex = index;
}


#pragma mark - Swipe Delegate Methods
-(void) didSwipeLeftOnTopAFEClassesDetailedView:(TopAFEClassesDetailedView*) view
{
    //if(!swipeAnimationRunning)
    //{
        [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionLeft];
        [self loadPageForPageType: AFEOrganizationSummaryPageTypeTopBudgetedAFE WithAnimation:YES animationDirection:AFEAnimationDirectionLeft];
    //}
    
}


-(void) didSwipeRightOnProjectWatchlistDetailedView:(ProjectWatchlistDetailedView*) view
{
    
   // if(!swipeAnimationRunning)
    //{
        [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionRight];
        [self loadPageForPageType: AFEOrganizationSummaryPageTypeTopBudgetedAFE WithAnimation:YES animationDirection:AFEAnimationDirectionRight];
    //}
    
}

-(void) didSwipeLeftOnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) view
{
   // if(!swipeAnimationRunning)
   // {
        [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionLeft];
        [self loadPageForPageType: AFEOrganizationSummaryPageTypeProjectWatchlist WithAnimation:YES animationDirection:AFEAnimationDirectionLeft];
   // }
    
}

-(void) didSwipeRightOnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) view
{
   // if(!swipeAnimationRunning)
   // {
        [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionRight];
        [self loadPageForPageType: AFEOrganizationSummaryPageTypeTopAFEClasses WithAnimation:YES animationDirection:AFEAnimationDirectionRight];
   // }
    
}


-(void) setDateOnHeader
{
    if(self.currentlySelectedStartDate && self.currentlySelectedEndDate)
    {
        dateLabel.text = [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:self.currentlySelectedStartDate],[Utility getStringFromDate:self.currentlySelectedEndDate]];
    }
}

-(void) refreshDataFromServiceForOrganizationType:(NSString *)orgType organizationID:(NSString *)orgID status:(NSString *)orgStatus begingDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    
    [self loadSettingsFromNSUserDefaults];
    
    [self setDateOnHeader];
    
    [self getAFEClassesForPieChartInTopAFEClassesDetailView:topAFEClassDetailedView sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    [self getAFEClassesForTableInTopAFEClassesDetailView:topAFEClassDetailedView forPage:1 sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    
    [self getAFEsForBarChartnTopBudgetedAFEDetailedView:topBudgetedAFEDetailedView sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    [self getAFEsForTableInTopBudgetedAFEDetailedView:topBudgetedAFEDetailedView forPage:1 sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    
    [self getAFEsForHeatMapInProjectWatchlistDetailedView:projectWatchlistDetailedView sortByField:SORTFIELD_PercentageConsumption andSortOrder:AFESortDirectionDescending withRecordLimit:5];
    [self getAFEsForTableInProjectWatchlistDetailedView:projectWatchlistDetailedView forPage:1 sortByField:SORTFIELD_PercentageConsumption andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    
}


#pragma mark - API handler methods
-(void) initializeOrgSummaryAPIHandlerAndRequestArray
{
    if (!self.apiHandlerOrgSummary) {
        self.apiHandlerOrgSummary = [[OrganizationSearchAPIHandler alloc] init];
        apiHandlerOrgSummary.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray)
    {
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
    }
}

-(void) stopAllAPICalls
{
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            if(tempRequestInfo)
            {
                [tempRequestInfo cancelAPIRequest];
                [self removeRequestInfoObjectFromPool:tempRequestInfo];
            }
        }
    }
}

-(void) stopAPICallOfType:(RVAPIRequestType) requestType withTag:(id) tag
{
    BOOL shouldCancel = NO;
    NSMutableArray *tempRequestInfoArray;

    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            shouldCancel = NO;
            
            if(tempRequestInfo && tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    shouldCancel = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        shouldCancel = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    shouldCancel = YES;
                }
                
                if(shouldCancel)
                {
                    [tempRequestInfo cancelAPIRequest];
                    [self removeRequestInfoObjectFromPool:tempRequestInfo];
                }
                
            }
        }
    }
    
}

-(BOOL) checkIfAPIRequestTypeAlive:(RVAPIRequestType) requestType withTag:(id) tag
{
    BOOL result = NO;
    
    if(self.apiRequestInfoObjectArray)
    {
        for(RVAPIRequestInfo *tempRequestInfo in self.apiRequestInfoObjectArray)
        {
            if(tempRequestInfo.requestType == requestType)
            {
                if(!tempRequestInfo.tag || !tag)
                {
                    result = YES;
                }
                else if([tag isKindOfClass:[NSString class]] && [tempRequestInfo.tag isKindOfClass:[NSString class]])
                {
                    NSString *orginalTag = (NSString*) tempRequestInfo.tag;
                    NSString *tagToCompare = (NSString*) tag;
                    
                    if([orginalTag caseInsensitiveCompare:tagToCompare] == NSOrderedSame)
                        result = YES;
                }
                else if(tag == tempRequestInfo.tag)
                {
                    result = YES;
                }
                
                if(result)
                {
                    break;     
                }              
            }
            
        }
    }
    
    return result;
}


-(void) loadSettingsFromNSUserDefaults
{
    self.currentlySelectedOrgType = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgTypeSelected];
    self.currentlySelectedOrgID = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgIDSelected];
    
    self.currentlySelectedStatus = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStatusSelected];
    
    self.currentlySelectedStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStartDateSelected];
    
    self.currentlySelectedEndDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentEndDateSelected];
    
}

-(void) showActivityIndicatorOnAllDetailedViews
{
    if(topAFEClassDetailedView)
    {
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnPieChart];
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnTable];
    }
    
    if(topBudgetedAFEDetailedView)
    {
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnBarChart];
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnTable];
    }
    
    if(projectWatchlistDetailedView)
    {
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnHeatMap];
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnTable];
    }
}

-(void) removeActivityIndicatorOnAllDetailedViews
{
    if(topAFEClassDetailedView)
    {
        [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnPieChart];
        [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnTable];
    }
    
    if(topBudgetedAFEDetailedView)
    {
        [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnBarChart];
        [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnTable];
    }
    
    if(projectWatchlistDetailedView)
    {
        [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnHeatMap];
        [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnTable];
    }
}


-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    if(apiRequestInfoObjectArray)
    {
       
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
        
    }
}


#pragma mark - OrganisationSearchAPIHandler delegate methods
-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj
{

    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAFEs:
        case RVAPIRequestTypeGetAFEsByClass:
        {
            NSDictionary *resultDict = requestInfoObj.resultObject;
            NSArray *resultArray = [resultDict objectForKey:@"AFEArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEArray"]]:[[NSMutableArray alloc] init];
            int recordCount = [resultDict objectForKey:@"TotRecordCount"]? [[resultDict objectForKey:@"TotRecordCount"] intValue]:[resultArray count];
            int pageCount = [resultDict objectForKey:@"TotPageCount"]?[[resultDict objectForKey:@"TotPageCount"] intValue]:1;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForBarChartInTopBudgetedAFE:resultArray forPage:newPageNumber_BarChartInTopBudgetedAFE ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView] == NSOrderedSame)
            {
               [self didReceiveAFEArrayForTableInTopBudgetedAFE:resultArray forPage:newPageNumber_TableInTopBudgetedAFE ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForHeatMapInProjectWatchlist:resultArray forPage:newPageNumber_HeatMapInProjectWatchlist ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView] == NSOrderedSame)
            {
               [self didReceiveAFEArrayForTableInProjectWatchlist:resultArray forPage:newPageNumber_TableInProjectWatchlist ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInOverlayAFETable] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForTableInOverlayTable:resultArray forPage:newPageNumber_TableInOverlayAFETable ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            
        }
            break;
        case RVAPIRequestTypeGetAFEClass:
        {
            NSDictionary *resultDict = requestInfoObj.resultObject;
            NSArray *resultArray = [resultDict objectForKey:@"AFEClassesArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEClassesArray"]]:[[NSMutableArray alloc] init];
            int recordCount = [resultDict objectForKey:@"TotRecordCount"]? [[resultDict objectForKey:@"TotRecordCount"] intValue]:[resultArray count];
            int pageCount = [resultDict objectForKey:@"TotPageCount"]?[[resultDict objectForKey:@"TotPageCount"] intValue]:1;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEClassesArrayForPieChartInTopAFEClasses:resultArray forPage:newPageNumber_PieChartInTopAFEClasses ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEClassesArrayForTableInTopAFEClasses:resultArray forPage:newPageNumber_TableInTopAFEClasses ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    
    NSLog(@"Failure Reason: %@", requestInfoObj.statusMessage);
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetAFEClass:
        {
            NSArray *resultArray = [[NSArray alloc] init];
            int recordCount = 0;
            int pageCount = 1;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEClassesArrayForPieChartInTopAFEClasses:resultArray forPage:newPageNumber_PieChartInTopAFEClasses ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEClassesArrayForTableInTopAFEClasses:resultArray forPage:newPageNumber_TableInTopAFEClasses ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }

        }
            break;
        case RVAPIRequestTypeGetAFEs:
        case RVAPIRequestTypeGetAFEsByClass:
        {
            NSArray *resultArray = [[NSArray alloc] init];
            int recordCount = 0;
            int pageCount = 1;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForBarChartInTopBudgetedAFE:resultArray forPage:newPageNumber_BarChartInTopBudgetedAFE ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForTableInTopBudgetedAFE:resultArray forPage:newPageNumber_TableInTopBudgetedAFE ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForHeatMapInProjectWatchlist:resultArray forPage:newPageNumber_HeatMapInProjectWatchlist ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForTableInProjectWatchlist:resultArray forPage:newPageNumber_TableInProjectWatchlist ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForTableInOverlayAFETable] == NSOrderedSame)
            {
                [self didReceiveAFEArrayForTableInOverlayTable:resultArray forPage:newPageNumber_TableInOverlayAFETable ofTotalPages:pageCount andTotalRecordCount:recordCount];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


-(void) didReceiveAFEClassesArrayForPieChartInTopAFEClasses:(NSArray*) afeClassArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeClassesArray_PieChartInTopAFEClasses = afeClassArray;
    newPageNumber_PieChartInTopAFEClasses = page;
    totalPageCount_PieChartInTopAFEClasses = totalPages;
    totalRecordCount_PieChartInTopAFEClasses = recordCount;
    
    if(topAFEClassDetailedView)
    {
        if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView])
            [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnPieChart];
        
        [topAFEClassDetailedView refreshPieChartWithAFEClassesArray:afeClassesArray_PieChartInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }

}

-(void) didReceiveAFEClassesArrayForTableInTopAFEClasses:(NSArray*) afeClassArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeClassesArray_TableInTopAFEClasses = afeClassArray;
    newPageNumber_TableInTopAFEClasses = page;
    totalPageCount_TableInTopAFEClasses = totalPages;
    totalRecordCount_TableInTopAFEClasses = recordCount;
    
    if(topAFEClassDetailedView)
    {
         if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView])
             [topAFEClassDetailedView removeActivityIndicatorOverlayViewOnTable];
        
        [topAFEClassDetailedView refreshTableWithAFEClassesArray:afeClassesArray_TableInTopAFEClasses forPage:page ofTotalPages:totalPages andTotalRecords:totalRecordCount_TableInTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEArrayForBarChartInTopBudgetedAFE:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_BarChartInTopBudgetedAFE = afeArray;
    newPageNumber_BarChartInTopBudgetedAFE = page;
    totalPageCount_BarChartInTopBudgetedAFE = totalPages;
    totalRecordCount_BarChartInTopBudgetedAFE = recordCount;
    
    if(topBudgetedAFEDetailedView)
    {
       if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView] && ![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView])
       {
            [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnBarChart];
       }
        
        [topBudgetedAFEDetailedView refreshBarChartWithAFEArray:afeArray_BarChartInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEArrayForTableInTopBudgetedAFE:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_TableInTopBudgetedAFE = afeArray;
    newPageNumber_TableInTopBudgetedAFE = page;
    totalPageCount_TableInTopBudgetedAFE = totalPages;
    totalRecordCount_TableInTopBudgetedAFE = recordCount;

    
    if(topBudgetedAFEDetailedView)
    {
        if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView] && ![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView])
        {
            [topBudgetedAFEDetailedView removeActivityIndicatorOverlayViewOnTable];
        }
        
        [topBudgetedAFEDetailedView refreshTableWithAFEArray:afeArray_TableInTopBudgetedAFE forPage:newPageNumber_TableInTopBudgetedAFE ofTotalPages:totalPageCount_TableInTopBudgetedAFE andTotalRecords:totalRecordCount_TableInTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEArrayForHeatMapInProjectWatchlist:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_HeatMapInProjectWatchlist = afeArray;
    newPageNumber_HeatMapInProjectWatchlist = page;
    totalPageCount_HeatMapInProjectWatchlist = totalPages;
    totalRecordCount_HeatMapInProjectWatchlist = recordCount;
    
    if(projectWatchlistDetailedView)
    {
        if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView] && ![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView])
        {
            [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnHeatMap];
        }
        
            [projectWatchlistDetailedView refreshHeatMapWithAFEArray:afeArray_HeatMapInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEArrayForTableInProjectWatchlist:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_TableInProjectWatchlist = afeArray;
    newPageNumber_TableInProjectWatchlist = page;
    totalPageCount_TableInProjectWatchlist = totalPages;
    totalRecordCount_TableInProjectWatchlist = recordCount;
    
    
    if(projectWatchlistDetailedView)
    {
        if(![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView] && ![self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView])
        {
            [projectWatchlistDetailedView removeActivityIndicatorOverlayViewOnTable];
        }
        
        [projectWatchlistDetailedView refreshTableWithAFEArray:afeArray_TableInProjectWatchlist forPage:newPageNumber_TableInProjectWatchlist ofTotalPages:totalPageCount_TableInProjectWatchlist andTotalRecords:totalRecordCount_TableInProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEArrayForTableInOverlayTable:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_TableInOverlayAFETable = afeArray;
    newPageNumber_TableInOverlayAFETable = page;
    totalPageCount_TableInOverlayAFETable = totalPages;
    totalRecordCount_TableInOverlayAFETable = recordCount;
    
    
    if(overlayAFETableView)
    {
        [overlayAFETableView removeActivityIndicatorOverlayView];
        
        [overlayAFETableView refreshTableWithAFEArray:afeArray_TableInOverlayAFETable forPage:newPageNumber_TableInOverlayAFETable ofTotalPages:totalPageCount_TableInOverlayAFETable andTotalRecords:totalRecordCount_TableInOverlayAFETable andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }

}


#pragma mark - OverlayAFETableView delegate methods

-(void) didCloseOverlayViewAFETable:(OverlayViewAFETable *)view
{
    if(overlayAFETableView && view == overlayAFETableView)
    {
        [overlayAFETableView removeActivityIndicatorOverlayView];
        
        if([self checkIfAPIRequestTypeAlive:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForTableInOverlayAFETable])
        {
            [self stopAPICallOfType:RVAPIRequestTypeGetAFEsByClass withTag:TAG_REQUESTINFO_AFEForTableInOverlayAFETable];
        }
    }
}

#pragma mark - TopAFEClassesDetailedView delegate methods
-(void) didSelectTheAFEClassToSeeListOfAFEs:(AFEClass*) afeClassObj
{
    if(afeClassObj && afeClassObj.afeCount <= 0)
        return;
    
    overlayAFETableView = [[OverlayViewAFETable alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        overlayAFETableView.delegate = self;    
    overlayAFETableView.alpha = 0;
    overlayAFETableView.afeClass = afeClassObj;
    UIViewController *tempOrgSummary = (UIViewController*) self.delegate;
    [tempOrgSummary.navigationController.view addSubview:overlayAFETableView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        overlayAFETableView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self getAFEsForTableInOverlayViewAFETable:overlayAFETableView withAFEClass:afeClassObj forPage:1 sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:50];
    
}

-(void) getAFEsForTableInOverlayViewAFETable:(OverlayViewAFETable*) view withAFEClass:(AFEClass*) afeClassObj forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    newPageNumber_TableInOverlayAFETable = (page>=1)? page:1;
    
    if(overlayAFETableView)
        [overlayAFETableView showActivityIndicatorOverlayView]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInOverlayAFETable];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_TableInTopBudgetedAFE = page;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withAFEClass:(afeClassObj && afeClassObj.afeClassID)? afeClassObj.afeClassID:@"0" withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:page recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForTableInOverlayAFETable;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}

-(void) getAFEClassesForPieChartInTopAFEClassesDetailView:(TopAFEClassesDetailedView*) detailedView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(topAFEClassDetailedView)
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnPieChart]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_PieChartInTopAFEClasses = 1;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEClassesOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}

-(void) getAFEClassesForTableInTopAFEClassesDetailView:(TopAFEClassesDetailedView*) detailedView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    newPageNumber_TableInTopAFEClasses = (page>=1)? page:1;
    
    if(topAFEClassDetailedView)
        [topAFEClassDetailedView showActivityIndicatorOverlayViewOnTable]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_TableInTopAFEClasses = page;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEClassesOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:page recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEClassesForTableInTopAFEClassesDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}

#pragma mark - TopBudgetedAFEDetailedView delegate methods

-(void) getAFEsForBarChartnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) detailedView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    if(topBudgetedAFEDetailedView)
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnBarChart]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_BarChartInTopBudgetedAFE = 1;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFEDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }

}

-(void) getAFEsForTableInTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) detailedView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit
{
    newPageNumber_TableInTopBudgetedAFE = (page>=1)? page:1;
    
    if(topBudgetedAFEDetailedView)
        [topBudgetedAFEDetailedView showActivityIndicatorOverlayViewOnTable]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_TableInTopBudgetedAFE = page;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:page recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForTableInTopBudgetedAFEDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }

}

#pragma mark - ProjectWatchlistDetailedView delegate methods

-(void) getAFEsForHeatMapInProjectWatchlistDetailedView:(ProjectWatchlistDetailedView *)detailedView sortByField:(NSString *)sortField andSortOrder:(AFESortDirection)sortDirection withRecordLimit:(int)limit
{
    if(projectWatchlistDetailedView)
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnHeatMap]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_HeatMapInProjectWatchlist = 1;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_PercentageConsumption withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }

}


-(void) getAFEsForTableInProjectWatchlistDetailedView:(ProjectWatchlistDetailedView *)detailedView forPage:(int)page sortByField:(NSString *)sortField andSortOrder:(AFESortDirection)sortDirection withRecordLimit:(int)limit
{
    newPageNumber_TableInProjectWatchlist = (page>=1)? page:1;
    
    if(projectWatchlistDetailedView)
        [projectWatchlistDetailedView showActivityIndicatorOverlayViewOnTable]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView];
    
    if(self.apiHandlerOrgSummary)
    {
        newPageNumber_TableInProjectWatchlist = page;
        
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:(sortField && ![sortField isEqualToString:@""])? sortField:SORTFIELD_PercentageConsumption withSortDirection:sortDirection atPageNumber:page recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForTableInProjectWatchlistDetailView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }

}


#pragma mark - Event Handlers

-(IBAction)pageChangedOnControl:(id)sender
{
    
    pageControl.currentPage = ((UIPageControl*)sender).currentPage;
    switch (pageControl.currentPage) {
        case 0:
            
            if(currentPageType == AFEOrganizationSummaryPageTypeTopBudgetedAFE)
            {
                [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionRight];
                [self loadPageForPageType:AFEOrganizationSummaryPageTypeTopAFEClasses WithAnimation:YES animationDirection:AFEAnimationDirectionRight];
            }
            break;
        case 1:
            if(currentPageType == AFEOrganizationSummaryPageTypeTopAFEClasses)
            {
                [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionLeft];
                [self loadPageForPageType:AFEOrganizationSummaryPageTypeTopBudgetedAFE WithAnimation:YES animationDirection:AFEAnimationDirectionLeft];
            }
            else if(currentPageType == AFEOrganizationSummaryPageTypeProjectWatchlist)
            {
                [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionRight];
                [self loadPageForPageType:AFEOrganizationSummaryPageTypeTopBudgetedAFE WithAnimation:YES animationDirection:AFEAnimationDirectionRight];
            }
            break;
            
        case 2:
            if(currentPageType == AFEOrganizationSummaryPageTypeTopBudgetedAFE)
            {
                [self removeCurrentPageWtihAnimation:YES animationDirection:AFEAnimationDirectionLeft];
                [self loadPageForPageType:AFEOrganizationSummaryPageTypeProjectWatchlist WithAnimation:YES animationDirection:AFEAnimationDirectionLeft];
            }
            break;
        default:
            break;
    }
}


-(IBAction)minimizeDetailButtonClicked:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickShowSummaryButtonOnDetailsViewController:)])
    {
        [self.delegate didClickShowSummaryButtonOnDetailsViewController:self];
    }
}

-(IBAction) topAFEClassesTabClicked:(id) sender
{
    [self loadPageForPageType:AFEOrganizationSummaryPageTypeTopAFEClasses WithAnimation:NO animationDirection:AFEAnimationDirectionLeft];
}


-(IBAction) budgettedAFETabClicked:(id) sender
{
    [self loadPageForPageType:AFEOrganizationSummaryPageTypeTopBudgetedAFE WithAnimation:NO animationDirection:AFEAnimationDirectionLeft];
}


-(IBAction)projectWatchlistTabClicked:(id) sender
{
    [self loadPageForPageType:AFEOrganizationSummaryPageTypeProjectWatchlist WithAnimation:NO animationDirection:AFEAnimationDirectionLeft];
}


-(void) dealloc
{
   // headLineMetricsDetailedView = nil;
    topBudgetedAFEDetailedView = nil;
    topBudgetedAFEDetailedView = nil;
    projectWatchlistDetailedView = nil;
    startDate = nil;
    endDate = nil;
    self.delegate = nil;
    self.dataSource = nil;
}

@end
