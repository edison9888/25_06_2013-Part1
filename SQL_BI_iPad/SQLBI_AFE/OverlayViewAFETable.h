//
//  OverlayViewAFETable.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEsTableView.h"
#import "AFEClass.h"

@class OverlayViewAFETable;

@protocol OverlayViewAFETableDelegate <NSObject>
@required
-(void) didCloseOverlayViewAFETable:(OverlayViewAFETable*) view;

-(void) getAFEsForTableInOverlayViewAFETable:(OverlayViewAFETable*) view withAFEClass:(AFEClass*) afeClassObj forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface OverlayViewAFETable : UIView<AFEsTableViewDelegate>
{
    IBOutlet UIView *containerView;
    IBOutlet UIButton *btnClose;
}

@property (nonatomic, assign) NSObject<OverlayViewAFETableDelegate> *delegate;
@property (nonatomic, assign) __unsafe_unretained AFEClass *afeClass;
@property (nonatomic, strong) IBOutlet UILabel *displayLbl;

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords  andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;


@end
