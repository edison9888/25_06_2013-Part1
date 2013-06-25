//
//  AFESearchInvoiceDetailTableViewCell.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchInvoiceDetailTableViewCell.h"

@implementation AFESearchInvoiceDetailTableViewCell

@synthesize venderLabel;
@synthesize invoiceDateLabel;
@synthesize serviceDateLabel;
@synthesize grossExpenseLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self populateCustomCellView];
    }
    return self;
}

- (void)populateCustomCellView
{
    UIFont *font = FONT_TABLEVIEWCELL;
    font = [font fontWithSize:font.pointSize-3];
        
    UIView *customCellView= [[UIView alloc]initWithFrame:CGRectMake(1, 0, 530, 50)];
    
    UIImageView *cellBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableRowBg"]];
    cellBackground.frame = customCellView.frame;
    [customCellView addSubview:cellBackground];
    
    self.venderLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 201, 49)];
    self.venderLabel.text = @"Baker";
    self.venderLabel.numberOfLines=2;
    [self.venderLabel setFont:font];
    self.venderLabel.backgroundColor = [UIColor clearColor];
    self.venderLabel.contentMode=UIViewContentModeCenter;
    self.venderLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.venderLabel];
    
    self.invoiceDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(207, 0, 102, 49)];
    self.invoiceDateLabel.text = @"1/1/2012";
    [self.invoiceDateLabel setFont:font];
    self.invoiceDateLabel.backgroundColor = [UIColor clearColor];
    self.invoiceDateLabel.contentMode=UIViewContentModeCenter;
    self.invoiceDateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.invoiceDateLabel];
    
    self.serviceDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(310, 0, 101, 49)];
    self.serviceDateLabel.text = @"1/1/2012";
    [self.serviceDateLabel setFont:font];
    self.serviceDateLabel.backgroundColor = [UIColor clearColor];
    self.serviceDateLabel.contentMode=UIViewContentModeCenter;
    self.serviceDateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.serviceDateLabel];
    
    self.grossExpenseLabel =[[UILabel alloc]initWithFrame:CGRectMake(412, 0, 111, 49)];
    self.grossExpenseLabel.text = @"$4156";
    [self.grossExpenseLabel setFont:font];
    self.grossExpenseLabel.backgroundColor = [UIColor clearColor];
    self.grossExpenseLabel.contentMode=UIViewContentModeCenter;
    self.grossExpenseLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.grossExpenseLabel];
    
    [self.contentView addSubview:customCellView];
    customCellView = nil; 
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end