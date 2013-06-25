//
//  TopBudgetedAFEDetailesView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetedAFETableView.h"

@class TopBudgetedAFEDetailedView;

@protocol TopBudgetedAFEDetailedViewSwipeDelegate <NSObject>
@optional
-(void) didSwipeLeftOnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) view;
-(void) didSwipeRightOnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) view;

@end

@protocol TopBudgetedAFEDetailedViewDelegate <NSObject>
@required

-(void) getAFEsForBarChartnTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) detailedView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

-(void) getAFEsForTableInTopBudgetedAFEDetailedView:(TopBudgetedAFEDetailedView*) detailedView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface TopBudgetedAFEDetailedView : UIView<BudgetedAFETableViewDelegate,UIGestureRecognizerDelegate,UIPopoverControllerDelegate>

@property(assign, nonatomic) __unsafe_unretained NSObject<TopBudgetedAFEDetailedViewSwipeDelegate> *swipeDelegate;
@property(assign, nonatomic) __unsafe_unretained NSObject<TopBudgetedAFEDetailedViewDelegate> *delegate;

//-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages  andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshBarChartWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;


//-(void) showActivityIndicatorOverlayView;
//-(void) removeActivityIndicatorOverlayView;
//-(void) showMessageOnView:(NSString*) message;
//-(void) hideMessageOnView;



-(void) showActivityIndicatorOverlayViewOnTable;
-(void) removeActivityIndicatorOverlayViewOnTable;
-(void) showMessageOnTable:(NSString*) message;
-(void) hideMessageOnTable;

-(void) showActivityIndicatorOverlayViewOnBarChart;
-(void) removeActivityIndicatorOverlayViewOnBarChart;
-(void) showMessageOnBarChart:(NSString*) message;
-(void) hideMessageOnBarChart;

@end
