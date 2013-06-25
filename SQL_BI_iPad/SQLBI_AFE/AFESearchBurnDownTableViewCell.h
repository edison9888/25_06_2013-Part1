//
//  AFESearchBurnDownTableViewCell.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFESearchBurnDownTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *serviceMonthLabel;
@property(nonatomic,strong)UILabel *actualsLabel;
@property(nonatomic,strong)UILabel *accrualsLabel;
@property(nonatomic,strong)UILabel *totalsLabel;

@end
