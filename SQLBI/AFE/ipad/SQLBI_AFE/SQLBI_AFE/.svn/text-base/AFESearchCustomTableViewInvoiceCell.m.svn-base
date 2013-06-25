//
//  AFESearchCustomTableViewInvoiceCell.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 10/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchCustomTableViewInvoiceCell.h"

@implementation AFESearchCustomTableViewInvoiceCell

@synthesize invoiceNoLabel;
@synthesize billingCategoryLabel;
@synthesize invoiceDateLabel;
@synthesize invoiceAmountLabel;
@synthesize propertyNameLabel;
@synthesize propertyTypeLabel;
@synthesize serviceDateLabel;
@synthesize acctlingDateLabel;
@synthesize vendorNameLabel;

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

    UIFont *font2 = FONT_TABLEVIEWCELL;
    font2 = [font2 fontWithSize:font2.pointSize-5];//Original 15
    
    UIView *customCellView= [[UIView alloc]initWithFrame:CGRectMake(1, 0, 950, 51)];
    
    UIImageView *cellBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,950,51)];
    cellBackground.image = [UIImage imageNamed:@"newTableRowBg"];
    [customCellView addSubview:cellBackground];
    
    self.invoiceNoLabel =[[UILabel alloc]initWithFrame:CGRectMake(3, 0, 87, 51)];
    [self.invoiceNoLabel setFont:font2];
    self.invoiceNoLabel.backgroundColor = [UIColor clearColor];
    [self.invoiceNoLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.invoiceNoLabel.text = @"90143706";
    self.invoiceNoLabel.numberOfLines=2;
    self.invoiceNoLabel.contentMode=UIViewContentModeCenter;
    self.invoiceNoLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.invoiceNoLabel];
    
    self.billingCategoryLabel =[[UILabel alloc]initWithFrame:CGRectMake(92, 0, 119, 51)];
    [self.billingCategoryLabel setFont:font2];
    self.billingCategoryLabel.backgroundColor = [UIColor clearColor];
    [self.billingCategoryLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.billingCategoryLabel.text = @"Well Stimulation";
    self.billingCategoryLabel.numberOfLines=2;
    self.billingCategoryLabel.contentMode=UIViewContentModeCenter;
    self.billingCategoryLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.billingCategoryLabel];
    
    self.invoiceDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(215, 0, 93, 51)];
    [self.invoiceDateLabel setFont:font2];
    self.invoiceDateLabel.backgroundColor = [UIColor clearColor];
    [self.invoiceDateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.invoiceDateLabel.text = @"12/29/2011";
    self.invoiceDateLabel.contentMode=UIViewContentModeCenter;
    self.invoiceDateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.invoiceDateLabel];
    
    self.invoiceAmountLabel =[[UILabel alloc]initWithFrame:CGRectMake(309, 0, 117, 51)];
    [self.invoiceAmountLabel setFont:font2];
    self.invoiceAmountLabel.backgroundColor = [UIColor clearColor];
    [self.invoiceAmountLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.invoiceAmountLabel.text = @"$636340";
    self.invoiceAmountLabel.contentMode=UIViewContentModeCenter;
    self.invoiceAmountLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.invoiceAmountLabel];
    
    self.propertyNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(427, 0, 109, 51)];
    [self.propertyNameLabel setFont:font2];
    self.propertyNameLabel.backgroundColor = [UIColor clearColor];
    [self.propertyNameLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.propertyNameLabel.text = @"Property Name";
    self.propertyNameLabel.numberOfLines=2;
    self.propertyNameLabel.contentMode=UIViewContentModeCenter;
    self.propertyNameLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.propertyNameLabel];
    
    self.propertyTypeLabel =[[UILabel alloc]initWithFrame:CGRectMake(537, 0, 104, 51)];
    [self.propertyTypeLabel setFont:font2];
    self.propertyTypeLabel.backgroundColor = [UIColor clearColor];
    [self.propertyTypeLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.propertyTypeLabel.text = @"Property Type";
    self.propertyTypeLabel.numberOfLines=2;
    self.propertyTypeLabel.contentMode=UIViewContentModeCenter;
    self.propertyTypeLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.propertyTypeLabel];
    
    self.serviceDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(642, 0, 92, 51)];
    [self.serviceDateLabel setFont:font2];
    self.serviceDateLabel.backgroundColor = [UIColor clearColor];
    [self.serviceDateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.serviceDateLabel.text = @"3/1/2012";
    self.serviceDateLabel.contentMode=UIViewContentModeCenter;
    self.serviceDateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.serviceDateLabel];
    
    self.acctlingDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(735, 0, 99, 51)];
    [self.acctlingDateLabel setFont:font2];
    self.acctlingDateLabel.backgroundColor = [UIColor clearColor];
    [self.acctlingDateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.acctlingDateLabel.text = @"12/29/2012";
    self.acctlingDateLabel.contentMode=UIViewContentModeCenter;
    self.acctlingDateLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.acctlingDateLabel];
    
    self.vendorNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(835, 0, 104, 51)];
    [self.vendorNameLabel setFont:font2];
    self.vendorNameLabel.backgroundColor = [UIColor clearColor];
    [self.vendorNameLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.vendorNameLabel.text = @"Vendor Name";
    self.vendorNameLabel.numberOfLines=3;
    self.vendorNameLabel.contentMode=UIViewContentModeCenter;
    self.vendorNameLabel.textAlignment = UITextAlignmentCenter;
    [customCellView addSubview:self.vendorNameLabel];
    
    [self.contentView addSubview:customCellView];
    customCellView = nil; 
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
