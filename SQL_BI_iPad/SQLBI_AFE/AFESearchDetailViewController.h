//
//  AFESearchDetailViewController.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AFEDetailsSummaryTableView.h"
#import "AFESearchBurnDownGraphView.h"
#import "AFESearchInvoiceView.h"
#import "AFESearchAPIHandler.h"
#import "AFESearchBillingCategoryView.h"
#import "AFEBurndownTableView.h"
#import "AFEBurnDownGraphDetailedView.h"

@interface AFESearchDetailViewController : UIViewController<AFESearchAPIHandlerDelegate,BillingCategoryDelegate,SummaryViewDelegate,AFESearchInvoiceViewDelegate, AFEBurndownTableViewDelegate, AFESearchBurnDownGraphViewDelegate, AFEBurnDownGraphDetailedViewDelegate>
{
    
}

@property(nonatomic, assign) __unsafe_unretained NSObject *delegate;

@property(nonatomic,retain)IBOutlet UIButton *afeBurnDownButton;
@property(nonatomic,retain)IBOutlet UIButton *afeDetailsButton;
@property(nonatomic,retain)IBOutlet UIButton *afeInvoiceButton;
@property(nonatomic,retain)IBOutlet AFEDetailsSummaryTableView  *afeDetailsLeftView;
@property(nonatomic,retain)IBOutlet AFESearchBurnDownGraphView  *afeBurnDownGraphView;
@property(nonatomic,retain)IBOutlet AFEBurndownTableView  *afeBurnDownTableView;
@property(nonatomic,retain)IBOutlet AFESearchInvoiceView        *afeInvoiceView;
@property(nonatomic,retain)IBOutlet AFESearchBillingCategoryView *afeBillingView;


- (IBAction)AFEDetailsButtonClick:(id)sender;
- (IBAction)AFEInvoiceButtonClick:(id)sender;
- (IBAction)AFEBurnDownButtonClick:(id)sender;

- (void)callAPIforAFEDetailWithAfeID:(NSString *)afeID;

-(IBAction)selectionType:(id)sender;

-(IBAction) showBurnDownGraphClicked;
-(IBAction) showBurnDownTableClicked;

@end
