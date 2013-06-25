//
//  AFEClassesCustomCell.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEClass.h"

@class AFEClassesCustomCell;

@protocol AFEClassesCustomCellDelegate <NSObject>

@required
-(void) didSelectAFEClass:(AFEClass*) afeClassSelected onCell:(AFEClassesCustomCell*) cell;

@end

@interface AFEClassesCustomCell : UITableViewCell

@property(nonatomic, assign) id<AFEClassesCustomCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *classLbl;
@property (strong, nonatomic) IBOutlet UILabel *noOfAFELbl;
@property (strong, nonatomic) IBOutlet UILabel *budgetLbl;
@property (strong, nonatomic) IBOutlet UILabel *fieldEstmtLbl;
@property (strong, nonatomic) IBOutlet UILabel *actualLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalLbl;
@property (strong, nonatomic) IBOutlet UIButton *afeButton;
@property (strong, nonatomic) AFEClass *afeClassObject;

@end
