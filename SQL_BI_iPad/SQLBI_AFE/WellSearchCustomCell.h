//
//  WellSearchCustomCell.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFE.h"

@class WellSearchCustomCell;

@protocol WellSearchCustomCellDelegate <NSObject>

@required
-(void) didSelectAFE:(AFE*) afeSelected onCell:(WellSearchCustomCell*) cell;

@end

@interface WellSearchCustomCell : UITableViewCell

@property(nonatomic, assign) id<WellSearchCustomCellDelegate> delegate;
@property(nonatomic, strong) AFE *afeObject;
@property (nonatomic,strong) IBOutlet UILabel *afeLbl;
@property (nonatomic,strong) IBOutlet UILabel *startDateLbl;
@property (nonatomic,strong) IBOutlet UILabel *statusLbl;
@property (nonatomic,strong) IBOutlet UILabel *budgetLbl;
@property (nonatomic,strong) IBOutlet UILabel *fieldEstmtLbl;
@property (nonatomic,strong) IBOutlet UILabel *feldEstmtBudgtLbl;
@property (nonatomic,strong) IBOutlet UILabel *actualLbl;
@property (nonatomic,strong) IBOutlet UILabel *actualBudgtLbl;
@property (strong, nonatomic) IBOutlet UIImageView *indicatorImage;
@property (strong, nonatomic) IBOutlet UIButton *jumpButton;


@end
