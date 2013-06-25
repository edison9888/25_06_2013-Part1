//
//  TopAFEClassesSummaryView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@class TopAFEClassesSummaryView;

@protocol TopAFEClassesSummaryDelgate <NSObject>

-(void)showDetailedViewOfTopAFEClassSummaryView :(TopAFEClassesSummaryView *)summaryView ;
-(void) getAFEClassesForPieChartInTopAFEClassesSummaryView:(TopAFEClassesSummaryView*) summaryView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface TopAFEClassesSummaryView : UIView <XYPieChartDelegate, XYPieChartDataSource >
{

}
@property(assign, nonatomic) __unsafe_unretained id <TopAFEClassesSummaryDelgate> delegate;
//
//-(void) refreshDataWithAFEClassesArray:(NSArray*) afeArrayClassesToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshPieChartWithAFEClassesArray:(NSArray*) afeClassesArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
