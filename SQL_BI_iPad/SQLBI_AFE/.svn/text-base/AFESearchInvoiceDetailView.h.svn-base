//
//  AFESearchInvoiceDetailView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFESearchInvoiceDetailTableViewCell.h"
#import "AFEInvoice.h"
#import "SortingView.h"
#import "ReloadInTableView.h"

@class AFESearchInvoiceDetailView;

@protocol InvoiceDetailDelegate <NSObject>

-(void) getInvoiceDetailTableSort:(AFESearchInvoiceDetailView *) invoiceDetailView forPage:(int)page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFESearchInvoiceDetailView : UIView<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,SortingViewDelegate>
{
    IBOutlet UILabel *vendorHeaderLabel;
    IBOutlet UILabel *invoiceDateHeaderLabel;
    IBOutlet UILabel *serviceDateHeaderLabel;
    IBOutlet UILabel *grossExpenseHeaderLabel;
}

@property(nonatomic,strong)IBOutlet UITableView *afeInvoiceDetailTableView;
@property(nonatomic,strong)IBOutlet UIButton    *closeButton;
@property(nonatomic,strong) id <InvoiceDetailDelegate> delegate;
@property(nonatomic,strong)IBOutlet UILabel *noOfPagesLabel;
@property(nonatomic,assign)int totalRecords;


-(IBAction)closeButtonClick:(id)sender;
-(IBAction)dropDownButtonClick:(id)sender;
-(void)getAfeSearchInvoiceDetailArray:(NSArray *)afeInvoiceDetailArray forPage:(int) page ofTotalPages:(int) totalPages;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
