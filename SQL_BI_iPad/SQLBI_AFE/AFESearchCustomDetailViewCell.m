//
//  AFESearchCustomDetailViewCell.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchCustomDetailViewCell.h"


@implementation AFESearchCustomDetailViewCell
@synthesize nameLabel;
@synthesize valueLabel;
@synthesize percentageValueLabel;

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
    UIFont *font= FONT_HEADLINE_TITLE;
    font = [font fontWithSize:font.pointSize+1];
    UIFont *font1 = FONT_HEADLINE_VALUE;
    font1 = [font1 fontWithSize:font1.pointSize-3];
    
    UIView *customCellView= [[UIView alloc]initWithFrame:CGRectMake(1, 0, 950, 55)];
    
    UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:customCellView.frame];
    cellBackground.image = [UIImage imageNamed:@"tableRowBg"];
    [customCellView addSubview:cellBackground];
    
    self.nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 130, 55)];
    self.nameLabel.text = @"Name";
    [self.nameLabel setFont:font];
    [self.nameLabel setTextColor:COLOR_HEADLINE_METRICS_COLUMN_TITLE];
    self.nameLabel.backgroundColor=[UIColor clearColor];
    self.nameLabel.contentMode=UIViewContentModeCenter;
    self.nameLabel.textAlignment = UITextAlignmentLeft;
    [customCellView addSubview:self.nameLabel];
    
    self.valueLabel =[[UILabel alloc]initWithFrame:CGRectMake(174, 0, 252, 55)];
    self.valueLabel.text = @"";
    [self.valueLabel setFont:font1];
    self.valueLabel.numberOfLines=2;
    [self.valueLabel setTextColor:COLOR_HEADLINE_METRICS_COLUMN_VALUE];
    self.valueLabel.backgroundColor=[UIColor clearColor];
    self.valueLabel.contentMode=UIViewContentModeCenter;
    self.valueLabel.textAlignment = UITextAlignmentLeft;
    [customCellView addSubview:self.valueLabel];
    
    self.percentageValueLabel =[[UILabel alloc]initWithFrame:CGRectMake(336, 0, 90, 55)];
    self.percentageValueLabel.text = @"";
    [self.percentageValueLabel setFont:font1];
    self.percentageValueLabel.backgroundColor=[UIColor clearColor];
    self.percentageValueLabel.contentMode=UIViewContentModeCenter;
    self.percentageValueLabel.textAlignment = UITextAlignmentLeft;
    [customCellView addSubview:self.percentageValueLabel];

    [self.contentView addSubview:customCellView];
    customCellView = nil; 
    
}

-(void)setPercentageValueLabel:(NSString *)percentageValue withColor:(UIColor*)color
{
    self.percentageValueLabel.text = [NSString stringWithFormat:@"(%@%%)",percentageValue];
    [self.percentageValueLabel setTextColor:color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
