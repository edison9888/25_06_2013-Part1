//
//  BudgetedAFECustomCell.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BudgetedAFECustomCell.h"

@interface BudgetedAFECustomCell ()

-(void) resetAllValues;
-(IBAction) showAFEDetailListButtonClicked:(id) sender;

@end

@implementation BudgetedAFECustomCell
@synthesize afeNameLabel,afeBudgetLabel,afeActualsLabel,afeFieldEstimateLabel, afeObject, delegate, afeDetailButton,afeTotalLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor redColor];
        // Initialization code
        [self resetAllValues];
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [self resetAllValues];
    
}

-(void) resetAllValues
{
    UIFont *font= FONT_TABLEVIEWCELL;
    font = [font fontWithSize:font.pointSize-2];
    
    self.afeNameLabel.text = @"";
    [self.afeNameLabel setFont:font];
    [self.afeNameLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
//    self.afeClassLabel.text = @"";
//    [self.afeClassLabel setFont:FONT_TABLEVIEWCELL];
//    [self.afeClassLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeBudgetLabel.text = @"";
    [self.afeBudgetLabel setFont:font];
    [self.afeBudgetLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeFieldEstimateLabel.text = @"";
    [self.afeFieldEstimateLabel setFont:font];
    [self.afeFieldEstimateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
    self.afeActualsLabel.text = @"";
    [self.afeActualsLabel setFont:font];
    [self.afeActualsLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeTotalLabel.text = @"";
    [self.afeTotalLabel setFont:font];
    [self.afeTotalLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction) showAFEDetailListButtonClicked:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFE:onCell:)])
    {
        [self.delegate didSelectAFE:self.afeObject onCell:self];
    }
}

-(void) dealloc
{
    self.delegate = nil;
    self.afeObject = nil;
}

@end
