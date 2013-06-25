//
//  AFESearchBillingCategoryCustomCell.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFESearchBillingCategoryCustomCell;

@interface AFESearchBillingCategoryCustomCell : UITableViewCell
{
    
}
@property(nonatomic,strong)UIButton *plusButton;
@property(nonatomic,strong)UILabel *billingCategoryCodeLabel;
@property(nonatomic,strong)UILabel *billingCategoryNameLabel;
@property(nonatomic,strong)UILabel *afeEstimateLabel;
@property(nonatomic,strong)UILabel *actualLabel;
@property(nonatomic,strong)UILabel *accrualLabel;
@property(nonatomic,strong)UILabel *noOfInvoicesLabel;

@end
