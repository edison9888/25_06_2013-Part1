//
//  ProjectWatchListAFETableView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEClass.h"
#import "ProjectWatchListAFECustomCell.h"
#import "SortingView.h"
#import "ReloadInTableView.h"

@class ProjectWatchListAFETableView;

@protocol ProjectWatchListAFETableViewDelegate
@required

-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnProjectWatchListAFETableView:(ProjectWatchListAFETableView *)tableView;

-(void) getAFEsForProjectWatchListAFETableView:(ProjectWatchListAFETableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface ProjectWatchListAFETableView : UIView<UITableViewDelegate, UITableViewDataSource,ProjectWatchListAFECustomCellDelegate,SortingViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITableView* afeClassesTableView;
    IBOutlet UILabel* classHeaderLabel;
    IBOutlet UILabel* noOfAFEsHeaderLabel;
    IBOutlet UILabel* afeBudgetHeaderLabel;
    IBOutlet UILabel* afeFieldEstimateHeaderLabel;
    IBOutlet UILabel* afeActualsHeaderLabel;
    IBOutlet UILabel*consumptionLabel;

}

@property (nonatomic, assign) __unsafe_unretained NSObject <ProjectWatchListAFETableViewDelegate> *delegate;

//-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
