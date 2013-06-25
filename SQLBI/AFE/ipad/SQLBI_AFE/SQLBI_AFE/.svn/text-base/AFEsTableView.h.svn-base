//
//  AFEsTableView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFECustomCell.h"
#import "SortingView.h"
#import "ReloadInTableView.h"

@class AFEsTableView;

@protocol AFEsTableViewDelegate
@required

-(void) didSelectAFEObjectForMoreDetais:(AFE *)afeObj OnAFEsTableView:(AFEsTableView *)tableView;

-(void) getAFEsForAFEsTableView:(AFEsTableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFEsTableView : UIView<UITableViewDelegate, UITableViewDataSource,AFECustomCellDelegate,SortingViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITableView* afeTableView;
    
    IBOutlet UILabel* afeNameHeaderLabel;
    IBOutlet UILabel* afeClassHeaderLabel;
    IBOutlet UILabel* afeBudgetHeaderLabel;
    IBOutlet UILabel* afeFieldEstimateHeaderLabel;
    IBOutlet UILabel* afeActualsHeaderLabel;
    IBOutlet UILabel* afeTotalHeaderLabel;
}

@property (nonatomic, assign) __unsafe_unretained NSObject<AFEsTableViewDelegate> *delegate;

@property(nonatomic, strong) NSArray *afeArray;

//-(id) initWithAFEArray:(NSArray*) afeArrayToBeUsed;

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse;

-(void) refreshTableWithAFEArray:(NSArray*) afeArrayToUse forPage:(int) page ofTotalPages:(int) totalPages;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
