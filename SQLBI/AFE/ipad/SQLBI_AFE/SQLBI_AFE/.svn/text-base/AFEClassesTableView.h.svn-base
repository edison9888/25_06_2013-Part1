//
//  AFEClassesTableView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEClass.h"
#import "AFEClassesCustomCell.h"
#import "SortingView.h"
#import "ReloadInTableView.h"

@class AFEClassesTableView;

@protocol AFEClassesTableViewDelegate
@required

-(void) didSelectAFEClassObjectForMoreDetais:(AFEClass *)afeClassObj OnAFEClassesTableView:(AFEClassesTableView *)tableView;

-(void) getAFEClassesForAFEClassesTableView:(AFEClassesTableView*) tableView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFEClassesTableView : UIView<UITableViewDelegate, UITableViewDataSource,AFEClassesCustomCellDelegate,SortingViewDelegate,UIPopoverControllerDelegate>
{
    
    IBOutlet UILabel* classHeaderLabel;
    IBOutlet UILabel* noOfAFEsHeaderLabel;
    IBOutlet UILabel* afeBudgetHeaderLabel;
    IBOutlet UILabel* afeFieldEstimateHeaderLabel;
    IBOutlet UILabel* afeActualsHeaderLabel;
    IBOutlet UILabel* afeTotalLabel;

}
@property(nonatomic,strong)IBOutlet UITableView* afeClassesTableView;
@property (nonatomic, assign) __unsafe_unretained NSObject<AFEClassesTableViewDelegate> *delegate;

//-(void) refreshDataWithafeClassesArray:(NSArray*) afeClassesArrayToUse;

-(void) refreshTableWithAFEClassesArray:(NSArray*) afeClassesArrayToUse forPage:(int) page ofTotalPages:(int) totalPages;


-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
