//
//  WellSearchTableView.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortingView.h"
#import "WellSearchCustomCell.h"
#import "AFE.h"


@class WellSearchTableView;
@protocol WellSearchALllAFEDelegate <NSObject>
@required

-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnAFEsTableView:(WellSearchTableView *)tableView;

//-(void) getWellAFETableSort:(WellSearchTableView *) wellSearchTableView sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

-(void) getWellAFETableSort:(WellSearchTableView *) wellSearchTableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;
@end

@interface WellSearchTableView : UIView<UITableViewDelegate, UITableViewDataSource,SortingViewDelegate,UIPopoverControllerDelegate, WellSearchCustomCellDelegate >

@property(nonatomic,strong) id <WellSearchALllAFEDelegate> delegate;
-(void) refreshDataWithWellArray:(NSArray*)wellArrayToUse forPage:(int) page ofTotalPages:(int) totalPages;
-(void) refreshDataWithWellArray:(NSArray*) wellArrayToUse;
@end
