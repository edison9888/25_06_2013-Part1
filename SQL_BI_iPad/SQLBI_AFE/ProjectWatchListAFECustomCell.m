//
//  ProjectWatchListAFECustomCell.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectWatchListAFECustomCell.h"

@interface ProjectWatchListAFECustomCell ()
{
}

-(IBAction) showAFEListButtonClicked:(id) sender;

@end

@implementation ProjectWatchListAFECustomCell

@synthesize afeNameLbl;
@synthesize totalLbl;
@synthesize consumptionLbl;
@synthesize budgetLbl;
@synthesize fieldEstmtLbl;
@synthesize actualLbl, afeButton, delegate, afeObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
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
    
    self.budgetLbl.text = @"";
    [self.budgetLbl setFont:font];
    [self.budgetLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
    self.fieldEstmtLbl.text = @"";
    [self.fieldEstmtLbl setFont:font];
    [self.fieldEstmtLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.actualLbl.text = @"";
    [self.actualLbl setFont:font];
    [self.actualLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    
    self.consumptionLbl.text = @"";
    [self.consumptionLbl setFont:font];
    [self.consumptionLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.afeNameLbl.text = @"";
    [self.afeNameLbl setFont:font];
    [self.afeNameLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.totalLbl.text = @"";
    [self.totalLbl setFont:font];
    [self.totalLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.consumptionLbl.text = @"";
    [self.consumptionLbl setFont:font];
    [self.consumptionLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
}



-(IBAction) showAFEListButtonClicked:(id) sender
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
