//
//  ProjectWatchlistSummaryView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreemapView.h"
#import "TreeMapAnimationCell.h"

@class ProjectWatchlistSummaryView;

@protocol ProjectWatchlistSummaryViewDelegate <NSObject>

-(void)showDetailedViewOfProjectWatchlistSummaryView:(ProjectWatchlistSummaryView *)summaryView;

-(void) getAFEsForHeatMapInProjectWatchlistSummaryView:(ProjectWatchlistSummaryView*) summaryView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface ProjectWatchlistSummaryView : UIView < TreemapViewDelegate, TreemapViewDataSource ,TreeMapAnimationCellDelegate >


@property(nonatomic ,assign) __unsafe_unretained id <ProjectWatchlistSummaryViewDelegate> delegate;
@property(nonatomic ,strong) IBOutlet TreemapView *treeMapV;
@property(nonatomic ,strong) TreeMapAnimationCell *treeMapAnmtnCell;
@property(nonatomic, strong) UIView *backgroundView; 
@property(nonatomic, strong) NSMutableArray *afeArray;

@property(nonatomic, assign) CGRect actualSizeTRemember;
-(IBAction)feldEstmtBtnTouched:(id) sender;
-(IBAction)actualsBtnTouched;
    //-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse;
//-(void)refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*)end;

-(void) refreshHeatMapWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void)drawTreeGraph;


-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
