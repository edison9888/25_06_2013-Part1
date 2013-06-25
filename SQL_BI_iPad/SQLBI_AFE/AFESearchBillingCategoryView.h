//
//  AFESearchBillingCategoryView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEInvoiceBillingCategory.h"
#import "AFESearchBillingCategoryCustomCell.h"
#import "SortingView.h"
#import "AFESearchInvoiceDetailView.h"
#import "AFESearchAPIHandler.h"
#import "ReloadInTableView.h"

@class AFESearchBillingCategoryView;

@protocol BillingCategoryDelegate <NSObject>

-(void) getBillingCategoryTableSort:(AFESearchBillingCategoryView *) billingCategoryView forPage:(int)page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFESearchBillingCategoryView : UIView<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,SortingViewDelegate,AFESearchAPIHandlerDelegate,InvoiceDetailDelegate>
{
    IBOutlet UILabel *billingCategoryCodeHeaderLabel;
    IBOutlet UILabel *billingCategoryNameHeaderLabel;
    IBOutlet UILabel *afeEstimateHeaderLabel;
    IBOutlet UILabel *actualHeaderLabel;
    IBOutlet UILabel *accrualHeaderLabel;
    IBOutlet UILabel *noOfInvoicesHeaderLabel;
    
}
@property(nonatomic,retain)IBOutlet UITableView *afeBillingCategoryTableView;
@property(nonatomic,retain)NSArray *afeBillingCategoryDetailArray;
@property(nonatomic,strong)IBOutlet AFESearchInvoiceDetailView *detailOverlayView;
@property(nonatomic,strong) id <BillingCategoryDelegate> delegate;
@property(nonatomic,strong)IBOutlet UILabel *noOfPagesLabel;
@property(nonatomic,assign)int totalRecordCount_InvoiceDetailTable;
-(void)getAfeSearchBillingCategoryArray:(NSArray *)afeBillingCategoryArray forPage:(int) page ofTotalPages:(int) totalPages;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
