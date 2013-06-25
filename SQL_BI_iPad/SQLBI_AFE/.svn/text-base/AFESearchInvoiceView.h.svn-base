//
//  AFESearchInvoiceView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFESearchCustomTableViewInvoiceCell.h"
#import "AFESearchInvoiceDetailView.h"
#import "AFEInvoiceBillingCategory.h"
#import "AFESearchBillingCategoryView.h"
#import "SortingView.h"
#import "AFESearchAPIHandler.h"

@class AFESearchInvoiceView;

@protocol AFESearchInvoiceViewDelegate <NSObject>

-(void) getInvoiceTableSort:(AFESearchInvoiceView *) invoiceView forPage:(int) page sortByField:(NSString*) sortField andSortOrder:(AFESortDirection) sortDirection withRecordLimit:(int) limit;

@end

@interface AFESearchInvoiceView : UIView<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,SortingViewDelegate>
{
    IBOutlet UILabel *invoiceNoHeaderLabel;
    IBOutlet UILabel *billingCategoryHeaderLabel;
    IBOutlet UILabel *invoiceDateHeaderLabel;
    IBOutlet UILabel *invoiceAmountHeaderLabel;
    IBOutlet UILabel *propertyNameHeaderLabel;
    IBOutlet UILabel *propertyTypeHeaderLabel;
    IBOutlet UILabel *serviceDateHeaderLabel;
    IBOutlet UILabel *acctlingDateHeaderLabel;
    IBOutlet UILabel *vendorNameHeaderLabel;
    
}
@property(nonatomic,retain)IBOutlet UITableView *afeInvoiceTableView;
@property(nonatomic,strong)NSArray *afeArray;
@property(nonatomic,strong)NSArray *afeInvoiceDetailArray;
@property(nonatomic,strong)id <AFESearchInvoiceViewDelegate> delegate;
@property(nonatomic,strong)IBOutlet UILabel *noOfPagesLabel;
@property(nonatomic,assign)int totalRecords;

-(void)getAfeSearchInvoiceArray:(NSArray *)afeInvoiceArray forPage:(int) page ofTotalPages:(int) totalPages;
-(IBAction)dropDownButtonClick:(id)sender;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
