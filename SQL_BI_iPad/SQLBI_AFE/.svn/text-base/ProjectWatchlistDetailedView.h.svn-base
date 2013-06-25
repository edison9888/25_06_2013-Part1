//
//  ProjectWatchlistDetailedView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreemapView.h"
#import "TreeMapAnimationCell.h"
#import "ProjectWatchListAFETableView.h"

@class ProjectWatchlistDetailedView;

@protocol ProjectWatchlistDetailedViewSwipeDelegate <NSObject>
@optional
-(void) didSwipeLeftOnProjectWatchlistDetailedView:(ProjectWatchlistDetailedView*) view;
-(void) didSwipeRightOnProjectWatchlistDetailedView:(ProjectWatchlistDetailedView*) view;

@end

@protocol ProjectWatchlistDetailedViewDelegate <NSObject>
@required

-(void) getAFEsForHeatMapInProjectWatchlistDetailedView:(ProjectWatchlistDetailedView*) detailedView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

-(void) getAFEsForTableInProjectWatchlistDetailedView:(ProjectWatchlistDetailedView*) detailedView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface ProjectWatchlistDetailedView : UIView < TreemapViewDataSource,TreemapViewDelegate, ProjectWatchListAFETableViewDelegate, TreeMapAnimationCellDelegate> 

@property(assign, nonatomic) __unsafe_unretained NSObject<ProjectWatchlistDetailedViewSwipeDelegate> *swipeDelegate;
@property(assign, nonatomic) __unsafe_unretained NSObject<ProjectWatchlistDetailedViewDelegate> *delegate;
@property(nonatomic ,strong) IBOutlet TreemapView *treeMapV;
@property(nonatomic ,strong) TreeMapAnimationCell *treeMapAnmtnCell;
@property(nonatomic, strong) UIView *backgroundView; 

//-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*)end;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords  andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshHeatMapWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;


-(void) showActivityIndicatorOverlayViewOnTable;
-(void) removeActivityIndicatorOverlayViewOnTable;
-(void) showMessageOnTable:(NSString*) message;
-(void) hideMessageOnTable;

-(void) showActivityIndicatorOverlayViewOnHeatMap;
-(void) removeActivityIndicatorOverlayViewOnHeatMap;
-(void) showMessageOnHeatMap:(NSString*) message;
-(void) hideMessageOnHeatMap;

@end
