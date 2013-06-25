//
//  ProjectWatchListAFECustomCell.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFE.h"

@class ProjectWatchListAFECustomCell;

@protocol ProjectWatchListAFECustomCellDelegate <NSObject>

@required
-(void) didSelectAFE:(AFE*) afeSelected onCell:(ProjectWatchListAFECustomCell*) cell;

@end

@interface ProjectWatchListAFECustomCell : UITableViewCell

@property(nonatomic, assign) id<ProjectWatchListAFECustomCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *afeNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *budgetLbl;
@property (strong, nonatomic) IBOutlet UILabel *fieldEstmtLbl;
@property (strong, nonatomic) IBOutlet UILabel *actualLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalLbl;
@property (strong, nonatomic) IBOutlet UILabel *consumptionLbl;
@property(nonatomic, strong) AFE *afeObject;

@property (strong, nonatomic) IBOutlet UIButton *afeButton;
//@property (strong, nonatomic) AFEClass *afeClassObject;

@end
