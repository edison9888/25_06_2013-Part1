//
//  AFECustomCell.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFE.h"

@class AFECustomCell;

@protocol AFECustomCellDelegate <NSObject>

@required
-(void) didSelectAFE:(AFE*) afeSelected onCell:(AFECustomCell*) cell;

@end

@interface AFECustomCell : UITableViewCell

@property(nonatomic, assign) id<AFECustomCellDelegate> delegate;
@property(nonatomic, strong) AFE *afeObject;
@property(nonatomic, strong) IBOutlet UILabel* afeNameLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeClassLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeBudgetLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeFieldEstimateLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeActualsLabel;
@property(nonatomic, strong) IBOutlet UILabel* afeTotalLabel;
@property(nonatomic, strong) IBOutlet UIButton* afeDetailButton;


@end
