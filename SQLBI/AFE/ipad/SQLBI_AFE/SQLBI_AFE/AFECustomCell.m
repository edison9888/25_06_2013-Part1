//
//  AFECustomCell.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFECustomCell.h"

@interface AFECustomCell ()

-(void) resetAllValues;
-(IBAction) showAFEDetailListButtonClicked:(id) sender;

@end

@implementation AFECustomCell
@synthesize afeNameLabel,afeClassLabel,afeBudgetLabel,afeActualsLabel,afeFieldEstimateLabel, afeObject, delegate, afeDetailButton,afeTotalLabel;

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
    self.afeNameLabel.text = @"";
    [self.afeNameLabel setFont:FONT_TABLEVIEWCELL];
    [self.afeNameLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
    self.afeClassLabel.text = @"";
    [self.afeClassLabel setFont:FONT_TABLEVIEWCELL];
    [self.afeClassLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeBudgetLabel.text = @"";
    [self.afeBudgetLabel setFont:FONT_TABLEVIEWCELL];
    [self.afeBudgetLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeFieldEstimateLabel.text = @"";
    [self.afeFieldEstimateLabel setFont:FONT_TABLEVIEWCELL];
    [self.afeFieldEstimateLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
    self.afeActualsLabel.text = @"";
    [self.afeActualsLabel setFont:FONT_TABLEVIEWCELL];
    [self.afeActualsLabel setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeTotalLabel.text = @"";
    [self.afeTotalLabel setFont:FONT_TABLEVIEWCELL];
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
