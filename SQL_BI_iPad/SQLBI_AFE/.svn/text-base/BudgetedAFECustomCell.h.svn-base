//
//  BudgetedAFECustomCell.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFE.h"

@class BudgetedAFECustomCell;

@protocol BudgetedAFECustomCellDelegate <NSObject>

@required
-(void) didSelectAFE:(AFE*) afeSelected onCell:(BudgetedAFECustomCell*) cell;

@end

@interface BudgetedAFECustomCell : UITableViewCell

@property(nonatomic, assign) id<BudgetedAFECustomCellDelegate> delegate;
@property(nonatomic, strong) AFE *afeObject;
@property(nonatomic, strong) IBOutlet UILabel* afeNameLabel;
//@property(nonatomic, strong) IBOutlet UILabel* afeClassLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeBudgetLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeFieldEstimateLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeActualsLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeTotalLabel;
@property(nonatomic, strong) IBOutlet UIButton* afeDetailButton;

@end
