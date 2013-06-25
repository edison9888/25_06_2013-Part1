//
//  AFESearchBurnDownTableViewCell.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchBurnDownTableViewCell.h"

@implementation AFESearchBurnDownTableViewCell

@synthesize serviceMonthLabel;
@synthesize actualsLabel;
@synthesize accrualsLabel;
@synthesize totalsLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self populateCustomCellView];
        
    }
    return self;
}

- (void)populateCustomCellView
{   
    
    UIFont *font2 = FONT_TABLEVIEWCELL;
    font2 = [font2 fontWithSize:font2.pointSize-2];//Original 15
    
    UIView *customCellView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 499, 51)];
    
    UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,550,51)];
    cellBackground.image = [UIImage imageNamed:@"newTableRowBg"];
    [customCellView addSubview:cellBackground];
    
    self.serviceMonthLabel =[[UILabel alloc]initWithFrame:CGRectMake(3, 0, 96, 51)];
    [self.serviceMonthLabel setFont:font2];
    self.serviceMonthLabel.backgroundColor = [UIColor clearColor];
    [self.serviceMonthLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.serviceMonthLabel.text = @"90143706";
    self.serviceMonthLabel.numberOfLines=2;
    self.serviceMonthLabel.contentMode=UIViewContentModeCenter;
    self.serviceMonthLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.serviceMonthLabel];
    
    self.actualsLabel =[[UILabel alloc]initWithFrame:CGRectMake(105, 0, 110, 51)];
    [self.actualsLabel setFont:font2];
    self.actualsLabel.backgroundColor = [UIColor clearColor];
    [self.actualsLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.actualsLabel.text = @"Well Stimulation";
    self.actualsLabel.numberOfLines=2;
    self.actualsLabel.contentMode=UIViewContentModeCenter;
    self.actualsLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.actualsLabel];
    
    self.accrualsLabel =[[UILabel alloc]initWithFrame:CGRectMake(215, 0, 110, 51)];
    [self.accrualsLabel setFont:font2];
    self.accrualsLabel.backgroundColor = [UIColor clearColor];
    [self.accrualsLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.accrualsLabel.text = @"12/29/2011";
    self.accrualsLabel.contentMode=UIViewContentModeCenter;
    self.accrualsLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.accrualsLabel];
    
    self.totalsLabel =[[UILabel alloc]initWithFrame:CGRectMake(330, 0, 110, 51)];
    [self.totalsLabel setFont:font2];
    self.totalsLabel.backgroundColor = [UIColor clearColor];
    [self.totalsLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.totalsLabel.text = @"$636340";
    self.totalsLabel.contentMode=UIViewContentModeCenter;
    self.totalsLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.totalsLabel];
    
    [self.contentView addSubview:customCellView];
    customCellView = nil; 
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
