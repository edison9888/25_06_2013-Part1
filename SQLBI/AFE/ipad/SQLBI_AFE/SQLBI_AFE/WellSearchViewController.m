//
//  WellSearchViewController.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellSearchViewController.h"
#import "WellDetailView.h"
#import "AFE.h"
#import "WellDetail.h"
#import "AppDelegate.h"


#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(10,18,996,622)


@interface WellSearchViewController (){
    WellSearchTableView *wellSerchTableView;
    WellDetailView *welDetailView;
    UIPopoverController *searchPopOver;
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
    NSArray *afeArray_WellSearchTableView;
    int newPageNumber_WellSearchTableView;
    int totalPageCount_WellSearchTableView;
    int totalRecordCount_WellSearchTableView;
    SearchViewController_WellSearch *wellSearchSearchController;
    PrintANDMailViewController *shareViewController;


}
@property(nonatomic,strong) WellSearchAPIHandler *wellSearchAPIHandlerObj;
@property(nonatomic,strong) NSMutableArray *apiRequestInfoObjectArray;
@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *propertyID;

@end

@implementation WellSearchViewController
@synthesize wellSearchAPIHandlerObj;
@synthesize apiRequestInfoObjectArray;
@synthesize startDate;
@synthesize endDate;
@synthesize propertyID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //Custom initialization
        self.title = TAB_TITLE_WELL_SEARCH;
        self.navigationItem.title = @"Data Warehouse - AFE Dashboard";
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"iconWellActive"];
        self.tabBarItem.unselectedImage = [UIImage imageNamed:@"iconWell"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addWellDetailView];
    [self createAFETableView];
    [self initializeWellSearchAPIHandlerAndRequestArray];
    [wellSearchAPIHandlerObj  getWellNames:@"a" numbrOfRecod:10 status:@"ALL"];
    self.propertyID = @"";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
    [self didDismissSearchController];

}


-(void)addWellDetailView{
    if(!welDetailView)
        welDetailView = [[WellDetailView alloc] initWithFrame:CGRectMake(34, 36, 950, 206)];
    [self.view addSubview:welDetailView];
    
}
-(void) createAFETableView
{
    if(!wellSerchTableView){
        wellSerchTableView = [[WellSearchTableView alloc]initWithFrame:CGRectMake(34, 266, 950, 350)];
    }
    wellSerchTableView.delegate =self;
    [self.view addSubview:wellSerchTableView];
}

-(void) initializeWellSearchAPIHandlerAndRequestArray{
    if (!self.wellSearchAPIHandlerObj) {
        self.wellSearchAPIHandlerObj = [[WellSearchAPIHandler alloc] init];
        wellSearchAPIHandlerObj.delegate = self;    
    }
    
    if(!self.apiRequestInfoObjectArray)
        {
        self.apiRequestInfoObjectArray = [[NSMutableArray alloc] init];
        }
}

-(void) stopAllAPICalls{
    NSMutableArray *tempRequestInfoArray;
    
    if(apiRequestInfoObjectArray)
    {
        tempRequestInfoArray = [apiRequestInfoObjectArray copy];
        
        for(RVAPIRequestInfo *tempRequestInfo in tempRequestInfoArray)
        {
            if(tempRequestInfo)
                [tempRequestInfo cancelAPIRequest];
        }
    }
}
-(void) removeRequestInfoObjectFromPool:(RVAPIRequestInfo*) requestinfoObj{
    if(apiRequestInfoObjectArray){
        [apiRequestInfoObjectArray removeObject:requestinfoObj];
    }
}

#pragma mark - Ovverridden methods
-(void) showSearchController
{
    
    if (searchPopOver) {
        [searchPopOver dismissPopoverAnimated:YES];
        searchPopOver = nil;
    }
    wellSearchSearchController = [[SearchViewController_WellSearch alloc] initWithNibName:@"SearchViewController_WellSearch" bundle:nil];
    wellSearchSearchController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:wellSearchSearchController];
    searchPopOver = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    searchPopOver.delegate = self;
    [searchPopOver  setPopoverContentSize:CGSizeMake(350,570) animated:YES];
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

#pragma mark - WellSearch SearchController delegate methods

- (void)searchWithDataWellCompltnName:(NSString *)wellCompltnName withStatus:(NSString *)status withfromDate:(NSString*)startDate withTodate:(NSString *)endDate  withPropertyID:(NSString*)protyID{
    if(searchPopOver){
        self.propertyID = [NSString stringWithFormat:@"%@",protyID];
        [searchPopOver dismissPopoverAnimated:YES];
        [self didDismissSearchController];
        [self initializeWellSearchAPIHandlerAndRequestArray];
        [wellSearchAPIHandlerObj  getWellDetails:protyID];//@"41967"];
        [self showActivityIndicatorOverlayView];
        [self initializeWellSearchAPIHandlerAndRequestArray];
        
        newPageNumber_WellSearchTableView = 1;
        totalPageCount_WellSearchTableView = 1;
        totalRecordCount_WellSearchTableView = 1;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [[NSDate alloc] init];
        date = [dateFormatter dateFromString:startDate];
        NSString *fromDate = [Utility getStringFromDateAPIFormat:date];
        self.startDate = fromDate;
        date = [dateFormatter dateFromString:endDate];
        NSString *toDate = [Utility getStringFromDateAPIFormat:date];
        self.endDate = toDate;
        [wellSearchAPIHandlerObj  getAfe:protyID status:@"All" startDate:fromDate endDate:toDate categoryType:status sortFieldType:@"ActualPlusAccrual" sortOrderBy:@"DESC" pageNum:1 limit:50];
            //[wellSearchAPIHandlerObj  getAfe:@"39826" status:@"ALL" startDate:@"20010101" endDate:@"20140101" categoryType:@"ALL" sortFieldType:@"ActualPlusAccrual" sortOrderBy:@"DESC" pageNum:1 limit:10];
        
        
    }

    
}

-(void) searchWithDataOrganizationType:(NSString *)orgType organizationID:(NSString *)orgID status:(NSString *)orgStatus begingDate:(NSString *)beginDate endDate:(NSString *)endDate
{
    if(searchPopOver)
        {
            [searchPopOver dismissPopoverAnimated:YES];
            [self didDismissSearchController];
        }
}

-(void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo *)requestInfoObj{
    
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
    switch (requestInfoObj.requestType) {
        case RVAPIRequestTypeGetWellNames:{
                                            break;}
        case RVAPIRequestTypeGetWellDetails:{
            
            [welDetailView refreshDataWithWellArray:requestInfoObj.resultObject];
            break;}
        case RVAPIRequestTypeGetAfe:{
            NSDictionary *resultDict = requestInfoObj.resultObject;
            NSArray *resultArray = [resultDict objectForKey:@"AFEArray"]? [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:@"AFEArray"]]:[[NSMutableArray alloc] init];
            int recordCount = [resultDict objectForKey:@"totrcnt"]? [[resultDict objectForKey:@"totrcnt"] intValue]:[resultArray count];
            int pageCount = [resultDict objectForKey:@"totpgcnt"]?[[resultDict objectForKey:@"totpgcnt"] intValue]:1;
            
            totalRecordCount_WellSearchTableView = recordCount;
            totalPageCount_WellSearchTableView = pageCount;
            
            [self didReceiveAFEArrayForWellSearchTableView:resultArray forPage:newPageNumber_WellSearchTableView ofTotalPages:pageCount andTotalRecordCount:recordCount];
                // [wellSerchTableView refreshDataWithWellArray:requestInfoObj.resultObject];
            [self removeActivityIndicatorOverlayView];
            break;}
            
        default:
            break;
    }

    

}

-(void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo *)requestInfoObj
{
    
    NSLog(@"Failure Reason: %@", requestInfoObj.statusMessage);
    if(![apiRequestInfoObjectArray count])
        [self removeActivityIndicatorOverlayView];
    [self removeRequestInfoObjectFromPool:requestInfoObj];
    
}
#pragma mark -
#pragma mark WellTable View Delegate method
//
//-(void) getWellAFETableSort:(WellSearchTableView *) wellSearchTableView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit{
//    [self initializeWellSearchAPIHandlerAndRequestArray];
//    
//    [wellSearchAPIHandlerObj  getAfe:self.propertyID status:@"ALL" startDate:self.startDate endDate:self.endDate categoryType:@"ALL" sortFieldType:sortField sortOrderBy:@"DESC" pageNum:1 limit:limit];
//    
//
//}
-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnAFEsTableView:(WellSearchTableView *)tableView{
    AppDelegate *tempAppDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(tempAppDelegate)
        {
        [tempAppDelegate jumpToAFESearchAndSearchAFEWithID:afeObj.afeID];
        }

}

-(void) didReceiveAFEArrayForWellSearchTableView:(NSArray*) afeArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) recordCount
{
    afeArray_WellSearchTableView = afeArray;
    newPageNumber_WellSearchTableView = page;
    totalPageCount_WellSearchTableView = totalPages;
    totalRecordCount_WellSearchTableView = recordCount;
    [wellSerchTableView refreshDataWithWellArray:afeArray_WellSearchTableView forPage:newPageNumber_WellSearchTableView ofTotalPages:totalPageCount_WellSearchTableView];
    
    
}
-(void)getWellAFETableSort:(WellSearchTableView *) wellSearchTableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit{
    NSLog(@"%@",self.propertyID);
    
    newPageNumber_WellSearchTableView = page;
    
    NSString *sortDirectAstr = @"DESC";
    
    switch (sortDirection) {
        case AFESortDirectionAscending:
            sortDirectAstr = @"ASC";
            break;
        case AFESortDirectionDescending:
            sortDirectAstr = @"DESC";
            break;
        default:
            break;
    }
    
    [wellSearchAPIHandlerObj  getAfe:self.propertyID status:@"ALL" startDate:self.startDate endDate:self.endDate categoryType:@"ALL" sortFieldType:sortField sortOrderBy:sortDirectAstr pageNum:page limit:limit];

}

-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicView)
        {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
        {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
        }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
        //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self.view addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
        {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
        }
    
    if(!messageLabel)
        {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerView.frame.size.height-15)/2, activityIndicContainerView.frame.size.width, 15)];
        }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
        //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor redColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:messageLabel];
    [self.view addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}



@end
