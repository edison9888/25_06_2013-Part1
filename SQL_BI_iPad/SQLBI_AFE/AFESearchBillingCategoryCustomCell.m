//
//  AFESearchBillingCategoryCustomCell.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 20/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchBillingCategoryCustomCell.h"

@implementation AFESearchBillingCategoryCustomCell

@synthesize plusButton;
@synthesize billingCategoryCodeLabel;
@synthesize billingCategoryNameLabel;
@synthesize afeEstimateLabel;
@synthesize actualLabel;
@synthesize accrualLabel;
@synthesize noOfInvoicesLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self customizeCurrentView];
        
    }
    return self;
}

-(void)customizeCurrentView
{
    UIFont *font = FONT_TABLEVIEWCELL;
    font = [font fontWithSize:font.pointSize-2];//Original 15
    
    UIFont *font2 = FONT_TABLEVIEWCELL;
    font2 = [font2 fontWithSize:font2.pointSize-3];
        
    UIView *customCellView= [[UIView alloc]initWithFrame:CGRectMake(1, 0, 950, 51)];
    
    UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,950,51)];
    cellBackground.image = [UIImage imageNamed:@"newTableRowBg"];
    [customCellView addSubview:cellBackground];
    
    self.plusButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.frame=CGRectMake(3, 12, 25, 25);
    self.plusButton.userInteractionEnabled = NO;
    [self.plusButton setImageEdgeInsets:UIEdgeInsetsMake(3,3,3,3)];
    UIImage *buttonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"plusButton" ofType:@"png"]];
    [self.plusButton setImage:buttonImage forState:UIControlStateNormal];
    [customCellView addSubview:self.plusButton];
    
    self.billingCategoryCodeLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 128, 51)];
    [self.billingCategoryCodeLabel setFont:font];
    self.billingCategoryCodeLabel.backgroundColor = [UIColor clearColor];
    [self.billingCategoryCodeLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.billingCategoryCodeLabel.text = @"";
    self.billingCategoryCodeLabel.contentMode=UIViewContentModeCenter;
    self.billingCategoryCodeLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.billingCategoryCodeLabel];
    
    self.billingCategoryNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(159, 0, 321, 51)];
    [self.billingCategoryNameLabel setFont:font2];
    self.billingCategoryNameLabel.backgroundColor = [UIColor clearColor];
    [self.billingCategoryNameLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.billingCategoryNameLabel.text = @"";
    self.billingCategoryNameLabel.numberOfLines=2;
    self.billingCategoryNameLabel.contentMode=UIViewContentModeCenter;
    self.billingCategoryNameLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.billingCategoryNameLabel];
    
    self.afeEstimateLabel =[[UILabel alloc]initWithFrame:CGRectMake(481, 0, 133, 51)];
    [self.afeEstimateLabel setFont:font];
    self.afeEstimateLabel.backgroundColor = [UIColor clearColor];
    [self.afeEstimateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.afeEstimateLabel.text = @"";
    self.afeEstimateLabel.contentMode=UIViewContentModeCenter;
    self.afeEstimateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.afeEstimateLabel];
    
    self.actualLabel =[[UILabel alloc]initWithFrame:CGRectMake(615, 0, 103, 51)];
    [self.actualLabel setFont:font];
    self.actualLabel.backgroundColor = [UIColor clearColor];
    [self.actualLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.actualLabel.text = @"";
    self.actualLabel.contentMode=UIViewContentModeCenter;
    self.actualLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.actualLabel];
    
    self.accrualLabel =[[UILabel alloc]initWithFrame:CGRectMake(719, 0, 109, 51)];
    [self.accrualLabel setFont:font];
    self.accrualLabel.backgroundColor = [UIColor clearColor];
    [self.accrualLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.accrualLabel.text = @"";
    self.accrualLabel.contentMode=UIViewContentModeCenter;
    self.accrualLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.accrualLabel];
    
    self.noOfInvoicesLabel =[[UILabel alloc]initWithFrame:CGRectMake(829, 0, 120, 51)];
    [self.noOfInvoicesLabel setFont:font];
    self.noOfInvoicesLabel.backgroundColor = [UIColor clearColor];
    [self.noOfInvoicesLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.noOfInvoicesLabel.text = @"";
    self.noOfInvoicesLabel.contentMode=UIViewContentModeCenter;
    self.noOfInvoicesLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.noOfInvoicesLabel];
    
    [self.contentView addSubview:customCellView];
    customCellView = nil; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
