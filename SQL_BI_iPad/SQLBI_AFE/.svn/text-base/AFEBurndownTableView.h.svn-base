//
//  AFEBurndownTableView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortingView.h"
#import "AFESearchAPIHandler.h"
#import "ReloadInTableView.h"

@class AFEBurndownTableView;

@protocol AFEBurndownTableViewDelegate <NSObject>

-(void) getBillingCategoryTableSort:(AFEBurndownTableView *) billingCategoryView forPage:(int)page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFEBurndownTableView : UIView<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,SortingViewDelegate>
{
    IBOutlet UILabel *serviceMonthHeaderLabel;
    IBOutlet UILabel *actualsHeaderLabel;
    IBOutlet UILabel *accrualsHeaderLabel;
    IBOutlet UILabel *totalHeaderLabel;

}

@property(nonatomic,strong) id <AFEBurndownTableViewDelegate> delegate;
@property(nonatomic,retain)IBOutlet UITableView *afeBurnDownTable;
@property(nonatomic,strong)IBOutlet UILabel *noOfPagesLabel;
@property(nonatomic,retain)NSArray *afeBurnDownItemArray;

-(void)refreshWithAfeBurnDownItemArray:(NSArray *)afeBurndownItemArray forPage:(int) page ofTotalPages:(int) totalPages andTotalRecordCount:(int) totalRecordCount;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
