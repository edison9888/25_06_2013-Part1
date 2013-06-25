//
//  BudgetedAFETableView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetedAFECustomCell.h"
#import "SortingView.h"
#import "ReloadInTableView.h"

@class BudgetedAFETableView;

@protocol BudgetedAFETableViewDelegate
@required

-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnBudgetedAFETableView:(BudgetedAFETableView *)tableView;

-(void) getAFEsForBudgetedAFETableView:(BudgetedAFETableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface BudgetedAFETableView : UIView<UITableViewDelegate, UITableViewDataSource,BudgetedAFECustomCellDelegate,SortingViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITableView* afeTableView;
    
    IBOutlet UILabel* afeNameHeaderLabel;
    IBOutlet UILabel* afeClassHeaderLabel;
    IBOutlet UILabel* afeBudgetHeaderLabel;
    IBOutlet UILabel* afeFieldEstimateHeaderLabel;
    IBOutlet UILabel* afeActualsHeaderLabel;
}

@property(nonatomic, strong) NSArray *afeArray;
@property (nonatomic, assign) __unsafe_unretained NSObject<BudgetedAFETableViewDelegate> *delegate;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages andTotalRecords:(int) totalRecords;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
