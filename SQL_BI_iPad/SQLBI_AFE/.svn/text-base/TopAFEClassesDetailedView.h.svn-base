//
//  TopAFEClassesDetailedView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "AFEClass.h"
#import "AFEClassesTableView.h"

@class TopAFEClassesDetailedView;

@protocol TopAFEClassesDetailedViewSwipeDelegate <NSObject>
@optional
-(void) didSwipeLeftOnTopAFEClassesDetailedView:(TopAFEClassesDetailedView*) view;
-(void) didSwipeRightOnTopAFEClassesDetailedView:(TopAFEClassesDetailedView*) view;

@end

@protocol TopAFEClassesDetailedViewDelegate <NSObject>
@required

-(void) getAFEClassesForPieChartInTopAFEClassesDetailView:(TopAFEClassesDetailedView*) detailedView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

-(void) getAFEClassesForTableInTopAFEClassesDetailView:(TopAFEClassesDetailedView*) detailedView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@optional
-(void) didSelectTheAFEClassToSeeListOfAFEs:(AFEClass*) afeClassObj;

@end

@interface TopAFEClassesDetailedView : UIView <XYPieChartDelegate, XYPieChartDataSource , AFEClassesTableViewDelegate>

@property(assign, nonatomic) __unsafe_unretained NSObject<TopAFEClassesDetailedViewSwipeDelegate> *swipeDelegate;
@property(assign, nonatomic) __unsafe_unretained NSObject<TopAFEClassesDetailedViewDelegate> *delegate;


-(void) refreshTableWithAFEClassesArray:(NSArray*) afeClassesArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords  andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshPieChartWithAFEClassesArray:(NSArray*) afeClassesArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

//-(void) showActivityIndicatorOverlayView;
//-(void) removeActivityIndicatorOverlayView;
//-(void) showMessageOnView:(NSString*) message;
//-(void) hideMessageOnView;


-(void) showActivityIndicatorOverlayViewOnTable;
-(void) removeActivityIndicatorOverlayViewOnTable;
-(void) showMessageOnTable:(NSString*) message;
-(void) hideMessageOnTable;

-(void) showActivityIndicatorOverlayViewOnPieChart;
-(void) removeActivityIndicatorOverlayViewOnPieChart;
-(void) showMessageOnPieChart:(NSString*) message;
-(void) hideMessageOnPieChart;

@end
