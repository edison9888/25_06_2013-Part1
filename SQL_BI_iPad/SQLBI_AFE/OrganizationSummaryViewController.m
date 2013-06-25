//
//  OrganizationSummaryViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrganizationSummaryViewController.h"
#import "AFE.h"
#import "AFEClass.h"
#import "KPIModel.h"
#import "OrganizationType.h"
#import "Organization.h"
#import "AFEsTableView.h"
#import "AFEClassesTableView.h"
#import "RVAlertMessageHandler.h"


#define TAG_REQUESTINFO_TOPBUDGETED @"TopBudgetedAFE"
#define TAG_REQUESTINFO_PROJECTWATHCLIST @"ProjectWatchlist"
#define TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesSummaryView @"AFEClassesForPieChartInTopAFEClassesSummaryView"
#define TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFESummaryView @"AFEForBarchartInTopBudgetedAFESummaryView"
#define TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistSummaryView @"AFEForHeatMapInProjectWatchlistSummaryView"


@interface OrganizationSummaryViewController ()
{
    AFEOrganizationDetailsViewController *detailsVC;
    OrganizationSearchController *organizationSearchController;
    HeadlineMetricsSummaryView *headLineMetricsSummaryView;
    TopAFEClassesSummaryView *topAFEClassSummaryView;
    TopBudgetedAFESummaryView *topBudgetedAFESummaryView;
    ProjectWatchlistSummaryView *projectWatchlistSummaryView;
    
    BOOL isDetailViewShown;
    
    KPIModel *kpiObjectForHeadlineMetrics;
    NSMutableArray *afeClassesArrayForTopAFEClasses;
    NSMutableArray *afeArrayForTopBudgetedAFE;
    NSMutableArray *afeArrayForProjectWatchlist;
    
}

@property (nonatomic,strong) UIPopoverController *searchPopOver;
@property(nonatomic, strong) OrganizationSearchAPIHandler *apiHandlerOrgSummary;
@property(nonatomic, strong) NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic, strong) NSString *currentlySelectedOrgType;
@property(nonatomic, strong) NSString *currentlySelectedOrgID;
@property(nonatomic, strong) NSString *currentlySelectedOrgName;
@property(nonatomic, strong) NSString *currentlySelectedStatus;
@property(nonatomic, strong) NSDate *currentlySelectedStartDate;
@property(nonatomic, strong) NSDate *currentlySelectedEndDate;


-(void) initializeSearchController;
-(void) initalizeSummaryViews;
-(void) initalizeDetailedViewController;
-(void) initializeOrgSummaryAPIHandlerAndRequestArray;
-(void) stopAllAPICalls;
-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj;
-(void) getKPIObjectForHeadlineMetricsFromService;
-(void) getAFEClassesArrayForTopAFEClassesFromService;
-(void) getAFEArrayForTopBudgetedFromService;
-(void) getAFEArrayForProjectWatchlistFromService;

@end

@implementation OrganizationSummaryViewController
@synthesize searchPopOver;
@synthesize apiHandlerOrgSummary, apiRequestInfoObjectArray;
@synthesize currentlySelectedOrgID;
@synthesize currentlySelectedOrgType;
@synthesize currentlySelectedStatus;
@synthesize currentlySelectedStartDate;
@synthesize currentlySelectedEndDate;
@synthesize currentlySelectedOrgName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = TAB_TITLE_ORGANIZATION_SUMMARY;
        self.navigationItem.title = [self getTabbarTitle];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"iconSummaryActive"];
        self.tabBarItem.unselectedImage = [UIImage imageNamed:@"iconSummary"];
        
    }
    return self;
}


#pragma mark - Ovverridden methods

-(NSString*) getTabbarTitle
{
    NSString *resultString = @"";
    
    [self loadSettingsFromNSUserDefaults];
    
    if(self.currentlySelectedOrgName && ![currentlySelectedOrgName isEqualToString:@""] && self.currentlySelectedStatus && ![self.currentlySelectedStatus isEqualToString:@""])
        resultString = [NSString stringWithFormat:@"%@ AFEs for %@", self.currentlySelectedStatus, self.currentlySelectedOrgName];
    
    return resultString;
}

-(NSString*) getEmailSubjectLine
{
    NSString *resultString = [self getTabbarTitle];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    if(self.currentlySelectedStartDate && self.currentlySelectedEndDate)
        resultString = [NSString stringWithFormat:@"%@ between %@ and %@", resultString, [df stringFromDate:self.currentlySelectedStartDate], [df stringFromDate:self.currentlySelectedEndDate]];
    
    return resultString;
    
}

-(void) showSearchController
{
    if (searchPopOver) {
        [searchPopOver dismissPopoverAnimated:YES];
        searchPopOver = nil;
    }
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:organizationSearchController];
    searchPopOver = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    searchPopOver.delegate = self;
    [searchPopOver  setPopoverContentSize:CGSizeMake(350,620) animated:YES];
    [searchPopOver presentPopoverFromBarButtonItem:searchBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

-(void) showShareViewController
{
    if(searchPopOver)
    {
        @try {
            [searchPopOver dismissPopoverAnimated:NO];
            
            UIView *tempView = searchBarButtonItem.customView;
            UIButton *tempBtn = (UIButton*) tempView;
            
            if(tempBtn)
            {
                [tempBtn setSelected:NO];
            }
        }
            @catch (NSException *exception) {
            
        }
        
    }

    [super showShareViewController];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{

    [self didDismissSearchController];
 
}



#pragma mark - View life cycles

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isDetailViewShown = NO;
    [self initializeSearchController];
    [self initalizeSummaryViews];
    [self initalizeDetailedViewController];
    [self showSummaryViewsWithAnimation:NO];
    
    if(headLineMetricsSummaryView)
        [headLineMetricsSummaryView showActivityIndicatorOverlayView];
    
    if(topAFEClassSummaryView)
        [topAFEClassSummaryView showActivityIndicatorOverlayView];
    
    if(topBudgetedAFESummaryView)
        [topBudgetedAFESummaryView showActivityIndicatorOverlayView];
    
    if(projectWatchlistSummaryView)
        [projectWatchlistSummaryView showActivityIndicatorOverlayView];
    
    if(detailsVC)
    {
        [detailsVC showActivityIndicatorOnAllDetailedViews];
    }
    
    [organizationSearchController autoSearchWithDefaultValues];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [apiHandlerOrgSummary getStatusTypes];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}


#pragma mark - Member methods

-(void) initializeSearchController
{
    if(!organizationSearchController)
        organizationSearchController = [[OrganizationSearchController alloc] initWithNibName:@"OrganizationSearchController" bundle:nil];
    
    organizationSearchController.delegate = self;

}

-(void) initalizeSummaryViews
{
    if(!headLineMetricsSummaryView)
    {
        headLineMetricsSummaryView = [[HeadlineMetricsSummaryView alloc] initWithFrame:CGRectMake(16, 22, 0, 0)];
    }
    
    if(!topAFEClassSummaryView)
    {
        topAFEClassSummaryView = [[TopAFEClassesSummaryView alloc] initWithFrame:CGRectMake(517, 22, 0, 0)];
        topAFEClassSummaryView.delegate = self;
    }
    
    if(!topBudgetedAFESummaryView)
    {
        topBudgetedAFESummaryView = [[TopBudgetedAFESummaryView alloc] initWithFrame:CGRectMake(16, 340, 0, 0)];
        topBudgetedAFESummaryView.delegate = self;
    }
    
    if(!projectWatchlistSummaryView)
    {
        projectWatchlistSummaryView = [[ProjectWatchlistSummaryView alloc] initWithFrame:CGRectMake(517, 340, 0, 0)];
        projectWatchlistSummaryView.delegate = self;
    }
}

-(void) showSummaryViewsWithAnimation:(BOOL) animation
{
    isDetailViewShown = NO;
    
    if(animation)
    {
        if(headLineMetricsSummaryView)
        {
            headLineMetricsSummaryView.alpha = 0;
            [headLineMetricsSummaryView removeFromSuperview];
            [self.view addSubview:headLineMetricsSummaryView];
        }
        
        if(topAFEClassSummaryView)
        {
            topAFEClassSummaryView.alpha = 0;
            [topAFEClassSummaryView removeFromSuperview];
            [self.view addSubview:topAFEClassSummaryView];
        }        
        
        if(topBudgetedAFESummaryView)
        {
            topBudgetedAFESummaryView.alpha = 0;
            [topBudgetedAFESummaryView removeFromSuperview];
            [self.view addSubview:topBudgetedAFESummaryView];
        }
        
        if(projectWatchlistSummaryView)
        {
            projectWatchlistSummaryView.alpha = 0;
            [projectWatchlistSummaryView removeFromSuperview];
            [self.view addSubview:projectWatchlistSummaryView];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            headLineMetricsSummaryView.alpha = 1;
            topAFEClassSummaryView.alpha = 1;
            topBudgetedAFESummaryView.alpha = 1;
            projectWatchlistSummaryView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [headLineMetricsSummaryView refreshDataWithKPIModel:kpiObjectForHeadlineMetrics andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
            
            [topBudgetedAFESummaryView refreshBarChartWithAFEArray:afeArrayForTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
            [projectWatchlistSummaryView refreshHeatMapWithAFEArray:afeArrayForProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
            [topAFEClassSummaryView refreshPieChartWithAFEClassesArray:afeClassesArrayForTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];   
            
        }];
    }
    else
    {
        if(headLineMetricsSummaryView)
        {
            headLineMetricsSummaryView.alpha = 1;
            [headLineMetricsSummaryView removeFromSuperview];
            [self.view addSubview:headLineMetricsSummaryView];
        }
        
        if(topAFEClassSummaryView)
        {
            topAFEClassSummaryView.alpha = 1;
            [topAFEClassSummaryView removeFromSuperview];
            [self.view addSubview:topAFEClassSummaryView];
        }        
        
        if(topBudgetedAFESummaryView)
        {
            topBudgetedAFESummaryView.alpha = 1;
            [topBudgetedAFESummaryView removeFromSuperview];
            [self.view addSubview:topBudgetedAFESummaryView];
        }
        
        if(projectWatchlistSummaryView)
        {
            projectWatchlistSummaryView.alpha = 1;
            [projectWatchlistSummaryView removeFromSuperview];
            [self.view addSubview:projectWatchlistSummaryView];
        }
        
        
        [headLineMetricsSummaryView refreshDataWithKPIModel:kpiObjectForHeadlineMetrics andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
        
        [topBudgetedAFESummaryView refreshBarChartWithAFEArray:afeArrayForTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
        [projectWatchlistSummaryView refreshHeatMapWithAFEArray:afeArrayForProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
        [topAFEClassSummaryView refreshPieChartWithAFEClassesArray:afeClassesArrayForTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];   
    }
}

-(void) removeAllSummaryViewsWithAnimation:(BOOL) animation
{
    
    if(animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            if(headLineMetricsSummaryView)
                headLineMetricsSummaryView.alpha = 0;
            
            if(topAFEClassSummaryView)
                topAFEClassSummaryView.alpha = 0;
            
            if(topBudgetedAFESummaryView)
                topBudgetedAFESummaryView.alpha = 0;
            
            if(projectWatchlistSummaryView)
                projectWatchlistSummaryView.alpha = 0;
            
            
        } completion:^(BOOL finished) {
            
            if(headLineMetricsSummaryView)
                [headLineMetricsSummaryView removeFromSuperview];
            
            if(topAFEClassSummaryView)
                [topAFEClassSummaryView removeFromSuperview];
            
            if(topBudgetedAFESummaryView)
            [topBudgetedAFESummaryView removeFromSuperview];
            
            if(projectWatchlistSummaryView)
            [projectWatchlistSummaryView removeFromSuperview];
            
        }];
    }
    else
    {
        if(headLineMetricsSummaryView)
            [headLineMetricsSummaryView removeFromSuperview];
        
        if(topAFEClassSummaryView)
            [topAFEClassSummaryView removeFromSuperview];
        
        if(topBudgetedAFESummaryView)
            [topBudgetedAFESummaryView removeFromSuperview];
        
        if(projectWatchlistSummaryView)
            [projectWatchlistSummaryView removeFromSuperview];
    }
    
    
}

-(void) initalizeDetailedViewController
{
    if(!detailsVC)
    {
        detailsVC = [[AFEOrganizationDetailsViewController alloc] initWithOrganizationSummaryPageSeleted:AFEOrganizationSummaryPageTypeTopAFEClasses];
    }
    
    if(detailsVC.view.superview != self.view)
    {
        detailsVC.view.frame = CGRectMake(16,16,detailsVC.view.frame.size.width, detailsVC.view.frame.size.height);
    }
   
    detailsVC.delegate = self;
    
}

-(void) showDetailViewControllerWithAnimation:(BOOL) animation
{
    
    isDetailViewShown = YES;
    
    if(animation)
    {
        if(detailsVC && detailsVC.view)
        {
            detailsVC.view.alpha = 0;
            [detailsVC.view removeFromSuperview];
            [self.view addSubview:detailsVC.view];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                detailsVC.view.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else
    {
        detailsVC.view.alpha = 1;
        [detailsVC.view removeFromSuperview];
        [self.view addSubview:detailsVC.view];
    }
    
    
    
    
}

-(void) removeDetaildViewWithAnimation:(BOOL) animation
{
    isDetailViewShown = NO;
    
    if(animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            if(detailsVC)
                detailsVC.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            if(detailsVC)
                [detailsVC.view removeFromSuperview];
            
        }];
    }
    else
    {
        if(detailsVC)
            [detailsVC.view removeFromSuperview];
        
    }
}

-(void) loadSettingsFromNSUserDefaults
{
    self.currentlySelectedOrgType = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgTypeSelected];
    self.currentlySelectedOrgID = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgIDSelected];
    
    self.currentlySelectedStatus = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStatusSelected];
    
    self.currentlySelectedStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentStartDateSelected];
    
    self.currentlySelectedEndDate = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentEndDateSelected];
    
    self.currentlySelectedOrgName = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaultsKeyOrganisationSearchCurrentOrgNameSelected];
    
}



#pragma mark - API related Member methods

-(void) getKPIObjectForHeadlineMetricsFromService
{
    if(headLineMetricsSummaryView)
        [headLineMetricsSummaryView showActivityIndicatorOverlayView];

    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetHeadlineMetric withTag:nil];
    
    if(self.apiHandlerOrgSummary)
    {
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getHeadlineMetricOfOrganisation:currentlySelectedOrgID withAFEClassID:@"ALL" withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate]];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
    }

}

-(void) getAFEClassesArrayForTopAFEClassesFromService
{
    if(topAFEClassSummaryView)
        [topAFEClassSummaryView showActivityIndicatorOverlayView]; 
    
    [self getAFEClassesForPieChartInTopAFEClassesSummaryView:topAFEClassSummaryView sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];

}

-(void) getAFEArrayForTopBudgetedFromService
{
    
    if(topBudgetedAFESummaryView)
        [topBudgetedAFESummaryView showActivityIndicatorOverlayView];
    
    [self getAFEsForBarchartInTopBudgetedAFESummaryView:topBudgetedAFESummaryView sortByField:SORTFIELD_AFEEstimate andSortOrder:AFESortDirectionDescending withRecordLimit:5];

}

-(void) getAFEArrayForProjectWatchlistFromService
{
    
    if(projectWatchlistSummaryView)
        [projectWatchlistSummaryView showActivityIndicatorOverlayView];
    
    [self getAFEsForHeatMapInProjectWatchlistSummaryView:projectWatchlistSummaryView sortByField:SORTFIELD_PercentageConsumption andSortOrder:AFESortDirectionDescending withRecordLimit:10];

}

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

-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj
{
    if(apiRequestInfoObjectArray)
    {
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}

-(void) didReceiveKPIObjectForHeadlineMetricsFromService
{
    
    if(headLineMetricsSummaryView)
    {
        [headLineMetricsSummaryView removeActivityIndicatorOverlayView];
        [headLineMetricsSummaryView refreshDataWithKPIModel:kpiObjectForHeadlineMetrics andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}

-(void) didReceiveAFEClassesArrayForTopAFEClassesFromService
{
    if(topAFEClassSummaryView)
    {
        [topAFEClassSummaryView removeActivityIndicatorOverlayView];
        [topAFEClassSummaryView refreshPieChartWithAFEClassesArray:afeClassesArrayForTopAFEClasses andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }

}

-(void) didReceiveAFEArrayForTopBudgetedFromService
{

    if(topBudgetedAFESummaryView)
    {
        [topBudgetedAFESummaryView removeActivityIndicatorOverlayView];
        [topBudgetedAFESummaryView refreshBarChartWithAFEArray:afeArrayForTopBudgetedAFE andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
        

}

-(void) didReceiveAFEArrayForProjectWatchlistFromService
{
    
    if(projectWatchlistSummaryView)
    {
        [projectWatchlistSummaryView removeActivityIndicatorOverlayView];
        [projectWatchlistSummaryView refreshHeatMapWithAFEArray:afeArrayForProjectWatchlist andStartDate:self.currentlySelectedStartDate andEndDate:self.currentlySelectedEndDate];
    }
    
}



#pragma mark - OrganisationSearchAPIHandler delegate methods

-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetHeadlineMetric:
        {
            kpiObjectForHeadlineMetrics = requestInfoObj.resultObject;
            [self didReceiveKPIObjectForHeadlineMetricsFromService];
            
        }
            break;
        case RVAPIRequestTypeGetAFEs:
        case RVAPIRequestTypeGetAFEsByClass:
        {
            NSDictionary *resultDict = requestInfoObj.resultObject;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFESummaryView] == NSOrderedSame)
            {
                afeArrayForTopBudgetedAFE = [resultDict objectForKey:@"AFEArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEArray"]]:[[NSMutableArray alloc] init];
                
                [self didReceiveAFEArrayForTopBudgetedFromService];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistSummaryView] == NSOrderedSame)
            {
                afeArrayForProjectWatchlist = [resultDict objectForKey:@"AFEArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEArray"]]:[[NSMutableArray alloc] init];

                [self didReceiveAFEArrayForProjectWatchlistFromService];
            }
               
        }
            break;
        case RVAPIRequestTypeGetAFEClass:
        {
            NSDictionary *resultDict = requestInfoObj.resultObject;
            
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesSummaryView] == NSOrderedSame)
            {
                afeClassesArrayForTopAFEClasses = [resultDict objectForKey:@"AFEClassesArray"];
                [self didReceiveAFEClassesArrayForTopAFEClassesFromService];
                
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
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesSummaryView] == NSOrderedSame)
            {
                afeClassesArrayForTopAFEClasses = [[NSMutableArray alloc] init];
                [self didReceiveAFEClassesArrayForTopAFEClassesFromService];

            }
        }
            break;
        case RVAPIRequestTypeGetAFEs:
        case RVAPIRequestTypeGetAFEsByClass:
        {
            if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFESummaryView] == NSOrderedSame)
            {
                afeArrayForTopBudgetedAFE = [[NSMutableArray alloc] init];
                [self didReceiveAFEArrayForTopBudgetedFromService];
            }
            else if([((NSString*)requestInfoObj.tag) caseInsensitiveCompare:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistSummaryView] == NSOrderedSame)
            {
                afeArrayForProjectWatchlist = [[NSMutableArray alloc] init];
                [self didReceiveAFEArrayForProjectWatchlistFromService];
            }
            
        }
            break;
            
        case RVAPIRequestTypeGetHeadlineMetric:
        {
            kpiObjectForHeadlineMetrics = requestInfoObj.resultObject;
            [self didReceiveKPIObjectForHeadlineMetricsFromService];
            
        }
            break;            
        default:
            break;
    }
    
}



#pragma mark - TopBudgetedAFESummaryView delegate methods

-(void) showDetailViewOfBudgetedAFESummaryView:(TopBudgetedAFESummaryView*) summaryView
{
    [self removeAllSummaryViewsWithAnimation:YES];
    
    [self showDetailViewControllerWithAnimation:YES];
    
    [detailsVC loadPageWithType:AFEOrganizationSummaryPageTypeTopBudgetedAFE];
    
}

-(void) getAFEsForBarchartInTopBudgetedAFESummaryView:(TopBudgetedAFESummaryView *)summaryView sortByField:(NSString *)sortField andSortOrder:(AFESortDirection)sortDirection withRecordLimit:(int)limit
{
    if(topBudgetedAFESummaryView)
        [topBudgetedAFESummaryView showActivityIndicatorOverlayView]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFESummaryView];
    
    if(self.apiHandlerOrgSummary)
    {
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForBarchartInTopBudgetedAFESummaryView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}



#pragma mark - ProjectWatchlistSummaryView delegate methods

-(void)showDetailedViewOfProjectWatchlistSummaryView:(ProjectWatchlistSummaryView *)summaryView
{
    [self removeAllSummaryViewsWithAnimation:YES];
    
    [self showDetailViewControllerWithAnimation:YES];
    
    [detailsVC loadPageWithType:AFEOrganizationSummaryPageTypeProjectWatchlist];

}

-(void) getAFEsForHeatMapInProjectWatchlistSummaryView:(ProjectWatchlistSummaryView *)summaryView sortByField:(NSString *)sortField andSortOrder:(AFESortDirection)sortDirection withRecordLimit:(int)limit
{
    if(projectWatchlistSummaryView)
        [projectWatchlistSummaryView showActivityIndicatorOverlayView]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEs withTag:TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistSummaryView];
    
    if(self.apiHandlerOrgSummary)
    {
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEsOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_PercentageConsumption withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEForHeatMapInProjectWatchlistSummaryView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}



#pragma mark - TopAFEClassesSummaryView delegate methods

-(void)showDetailedViewOfTopAFEClassSummaryView :(TopAFEClassesSummaryView *)summaryView
{
    [self removeAllSummaryViewsWithAnimation:NO];
    
    [self showDetailViewControllerWithAnimation:YES];
    
    [detailsVC loadPageWithType:AFEOrganizationSummaryPageTypeTopAFEClasses];
}

-(void) getAFEClassesForPieChartInTopAFEClassesSummaryView:(TopAFEClassesSummaryView *)summaryView sortByField:(NSString *)sortField andSortOrder:(AFESortDirection)sortDirection withRecordLimit:(int)limit
{    
    if(topAFEClassSummaryView)
        [topAFEClassSummaryView showActivityIndicatorOverlayView]; 
    
    [self initializeOrgSummaryAPIHandlerAndRequestArray];
    
    [self stopAPICallOfType:RVAPIRequestTypeGetAFEClass withTag:TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesSummaryView];
    
    if(self.apiHandlerOrgSummary)
    {
        RVAPIRequestInfo *tempRequestInfo = [self.apiHandlerOrgSummary getAFEClassesOfOrganisation:self.currentlySelectedOrgID withStatus:self.currentlySelectedStatus fromStartDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedStartDate] toEndDate:[Utility formatDateforAFEAPICalls:self.currentlySelectedEndDate] sortedBy:sortField? sortField:SORTFIELD_AFEEstimate withSortDirection:sortDirection atPageNumber:1 recordLimitPerPage:limit];
        
        if(!self.apiRequestInfoObjectArray)
            self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        
        tempRequestInfo.tag = TAG_REQUESTINFO_AFEClassesForPieChartInTopAFEClassesSummaryView;
        [self.apiRequestInfoObjectArray addObject:tempRequestInfo];
        
    }
}



#pragma mark - AFEOrganizationDetailesViewController Delegate methods

-(void) didClickShowSummaryButtonOnDetailsViewController:(AFEOrganizationDetailsViewController*) controller
{
    if(detailsVC == controller)
    {
        [self removeDetaildViewWithAnimation:NO];
        [self showSummaryViewsWithAnimation:YES];
    }
}



#pragma mark - OrganizationSearchController delegate methods

-(void) searchWithDataOrganizationType:(NSString *)orgType organizationID:(NSString *)orgID status:(NSString *)orgStatus begingDate:(NSString *)beginDate endDate:(NSString *)endDate
{
    self.navigationItem.title = [self getTabbarTitle];
    
    if(searchPopOver && [searchPopOver isPopoverVisible] && organizationSearchController && !organizationSearchController.isAutoSearchRunning)
    {
        [searchPopOver dismissPopoverAnimated:YES];
        [self didDismissSearchController];
        
    }
    
    [self loadSettingsFromNSUserDefaults];
    
    if((!self.currentlySelectedOrgID || ([self.currentlySelectedOrgID caseInsensitiveCompare:@""] ==   NSOrderedSame)) && (!self.currentlySelectedOrgType || ([self.currentlySelectedOrgType caseInsensitiveCompare:@""] ==   NSOrderedSame)))
    {
        [RVAlertMessageHandler showAlertWithTitle:@"AFE Analytics" message:@"Please select values for Organization and Organization Name." delegateObject:nil viewTag:123 otherButtonTitle:@"OK" showCancel:NO];
    }
    else if(!self.currentlySelectedOrgType || ([self.currentlySelectedOrgType caseInsensitiveCompare:@""] ==   NSOrderedSame))
    {
        [RVAlertMessageHandler showAlertWithTitle:@"AFE Analytics" message:@"Please select a value for Organization." delegateObject:nil viewTag:123 otherButtonTitle:@"OK" showCancel:NO];
    }
    else if(!self.currentlySelectedOrgID || ([self.currentlySelectedOrgID caseInsensitiveCompare:@""] ==   NSOrderedSame))
    {
         [RVAlertMessageHandler showAlertWithTitle:@"AFE Analytics" message:@"Please select a value for Organization Name." delegateObject:nil viewTag:123 otherButtonTitle:@"OK" showCancel:NO];
    }
    else
    {
        if(detailsVC)
        {
            [detailsVC refreshDataFromServiceForOrganizationType:self.currentlySelectedOrgType organizationID:self.currentlySelectedOrgID status:self.currentlySelectedStatus begingDate:self.currentlySelectedStartDate endDate:self.currentlySelectedEndDate];
        }
        
        [self getKPIObjectForHeadlineMetricsFromService];
        [self getAFEClassesArrayForTopAFEClassesFromService];
        [self getAFEArrayForTopBudgetedFromService];
        [self getAFEArrayForProjectWatchlistFromService];
    }
    
}

-(void) didFailAutoSearchOnSearchController:(OrganizationSearchController*) controller
{
    if(headLineMetricsSummaryView)
        [headLineMetricsSummaryView removeActivityIndicatorOverlayView];
    
    if(topAFEClassSummaryView)
        [topAFEClassSummaryView removeActivityIndicatorOverlayView];
    
    if(topBudgetedAFESummaryView)
        [topBudgetedAFESummaryView removeActivityIndicatorOverlayView];
    
    if(projectWatchlistSummaryView)
        [projectWatchlistSummaryView removeActivityIndicatorOverlayView];
    
    if(detailsVC)
    {
        [detailsVC removeActivityIndicatorOnAllDetailedViews];
    }
    
}



#pragma mark - Memory management 

-(void) dealloc
{
    detailsVC = nil;
    headLineMetricsSummaryView = nil;
    topAFEClassSummaryView = nil;
    topBudgetedAFESummaryView = nil;
    projectWatchlistSummaryView = nil;
    organizationSearchController = nil;
    
    afeClassesArrayForTopAFEClasses = nil;
    afeArrayForTopBudgetedAFE = nil;
    afeArrayForProjectWatchlist = nil;
    kpiObjectForHeadlineMetrics = nil;
}

@end
