//
//  AFEOrganizationDetailsViewController.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEBaseViewController.h"

#import "HeadlineMetricsDetailedView.h"
#import "TopAFEClassesDetailedView.h"
#import "TopBudgetedAFEDetailedView.h"
#import "ProjectWatchlistDetailedView.h"
#import "OrganizationSearchAPIHandler.h"
#import "OverlayViewAFETable.h"

@class AFEOrganizationDetailsViewController;

@protocol AFEOrganizationDetailsViewControllerDataSource <NSObject>
@optional

//-(NSDate*) getSearchStartDateForTopBudgetedDetailedView;
//-(NSDate*) getSearchEndDateForTopBudgetedDetailedView;
//-(NSDate*) getSearchStartDateForTopAFEClassesDetailedView;
//-(NSDate*) getSearchEndDateForTopAFEClassesDetailedView;
//-(NSDate*) getSearchStartDateForProjectWatchlistDetailedView;
//-(NSDate*) getSearchEndDateForProjectWatchlistDetailedView;

@end

@protocol AFEOrganizationDetailsViewControllerDelegate <NSObject>
@required

-(void) didClickShowSummaryButtonOnDetailsViewController:(AFEOrganizationDetailsViewController*) controller;

@end

@interface AFEOrganizationDetailsViewController : AFEBaseViewController<TopAFEClassesDetailedViewDelegate, TopAFEClassesDetailedViewSwipeDelegate,ProjectWatchlistDetailedViewDelegate, ProjectWatchlistDetailedViewSwipeDelegate,TopBudgetedAFEDetailedViewDelegate, TopBudgetedAFEDetailedViewSwipeDelegate, TopAFEClassesDetailedViewDelegate, OrganizationSearchAPIHandlerDelegate, OverlayViewAFETableDelegate>
{
    IBOutlet UIView *headerTabConatiner;
    IBOutlet UIView *controllerConatiner;    
    IBOutlet UIButton *headerBtnTopBudget;    
    IBOutlet UIButton *headerBtnTopAFEClass;    
    IBOutlet UIButton *headerBtnProjectWatchlist;  
    IBOutlet UIButton *minimizeDetailButton;  
    IBOutlet UILabel *dateLabel;
}


@property(nonatomic, assign) __unsafe_unretained NSObject<AFEOrganizationDetailsViewControllerDataSource> *dataSource;
@property(nonatomic, assign) __unsafe_unretained NSObject<AFEOrganizationDetailsViewControllerDelegate> *delegate;

-(id) initWithOrganizationSummaryPageSeleted:(AFEOrganizationSummaryPageType) pageType;

-(void) loadPageWithType:(AFEOrganizationSummaryPageType) pageType;
//-(void) refreshData;

-(void) refreshDataFromServiceForOrganizationType:(NSString *)orgType organizationID:(NSString *)orgID status:(NSString *)orgStatus begingDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

//-(void) showActivityIndicatorOverlayViewOnTopAFEDetails;
//-(void) removeActivityIndicatorOverlayViewOnTopAFEDetails;
//-(void) showActivityIndicatorOverlayViewOnTopBudgetedAFE;
//-(void) removeActivityIndicatorOverlayViewOnTopBudgetedAFE;
//-(void) showActivityIndicatorOverlayViewOnProjectWatchlist;
//-(void) removeActivityIndicatorOverlayViewOnProjectWatchlist;

-(void) showActivityIndicatorOnAllDetailedViews;
-(void) removeActivityIndicatorOnAllDetailedViews;

@end
