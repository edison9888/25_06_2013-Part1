//
//  TopBudgetedAFESummaryView.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MIMBarGraph.h"
#import "MIMColor.h"

@class TopBudgetedAFESummaryView;

@protocol TopBudgetedAFESummaryViewDelegate <NSObject>
@required
-(void) showDetailViewOfBudgetedAFESummaryView:(TopBudgetedAFESummaryView*) summaryView;

-(void) getAFEsForBarchartInTopBudgetedAFESummaryView:(TopBudgetedAFESummaryView*) summaryView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;


@end

@interface TopBudgetedAFESummaryView : UIView <BarGraphDelegate ,UIGestureRecognizerDelegate, UIPopoverControllerDelegate>
{
    
    MIMBarGraph *myBarChart;
    NSArray *xValuesArray;
    NSArray *yValuesArray;
    NSArray *xTitlesArray;
    NSDictionary *barProperty;
    
}

@property(assign, nonatomic) __unsafe_unretained NSObject<TopBudgetedAFESummaryViewDelegate> *delegate;

//-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) refreshBarChartWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
