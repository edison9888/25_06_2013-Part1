//
//  AFEDetailsSummaryTableView.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFESearchCustomDetailViewCell.h"

@protocol SummaryViewDelegate <NSObject>

-(void)setAfeNumberToTabButton:(NSString *)afeNumber;

@end

@interface AFEDetailsSummaryTableView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,retain)IBOutlet UITableView *afeMainTableView;
@property(nonatomic,strong) NSArray* afeSearchSummaryArray;
@property(nonatomic,strong)id <SummaryViewDelegate> delegate;
@property(nonatomic,retain)IBOutlet UILabel *afeDateBurnDownLabel;
@property(nonatomic,retain)IBOutlet UILabel *afeDateInvoiceLabel;

-(void)getAfeSearchSummaryArray:(NSArray *)afeSummaryArray;
-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

-(void) showActivityIndicatorOverlayView;
-(void) removeActivityIndicatorOverlayView;
-(void) showMessageOnView:(NSString*) message;
-(void) hideMessageOnView;

@end
