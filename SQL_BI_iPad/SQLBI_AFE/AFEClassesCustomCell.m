//
//  AFEClassesCustomCell.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 04/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEClassesCustomCell.h"

@interface AFEClassesCustomCell ()
{
}

-(IBAction) showAFEListButtonClicked:(id) sender;

@end

@implementation AFEClassesCustomCell
@synthesize cellBKgrndImage;
@synthesize classLbl;
@synthesize noOfAFELbl;
@synthesize budgetLbl;
@synthesize fieldEstmtLbl;
@synthesize actualLbl, afeButton, delegate, afeClassObject,totalLbl;

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

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self resetAllValues];
}

-(void) resetAllValues
{
    UIFont *font= FONT_TABLEVIEWCELL;
    font = [font fontWithSize:font.pointSize-2];
    [self.afeButton setExclusiveTouch:YES];
    self.classLbl.text = @"";
    [self.classLbl setFont:font];
    [self.classLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.noOfAFELbl.text = @"";
    [self.noOfAFELbl setFont:font];
    [self.noOfAFELbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    
    self.budgetLbl.text = @"";
    [self.budgetLbl setFont:font];
    [self.budgetLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.fieldEstmtLbl.text = @"";
    [self.fieldEstmtLbl setFont:font];
    [self.fieldEstmtLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.actualLbl.text = @"";
    [self.actualLbl setFont:font];
    [self.actualLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.totalLbl.text = @"";
    [self.totalLbl setFont:font];
    [self.totalLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
}



-(IBAction) showAFEListButtonClicked:(id) sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFEClass:onCell:)])
    {
        [self.delegate didSelectAFEClass:self.afeClassObject onCell:self];
    }
}

-(void) dealloc
{
    self.delegate = nil;
    self.afeClassObject = nil;
}


@end
