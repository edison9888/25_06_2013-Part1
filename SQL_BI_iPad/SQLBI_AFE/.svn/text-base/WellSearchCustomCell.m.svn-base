//
//  WellSearchCustomCell.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WellSearchCustomCell.h"

@interface WellSearchCustomCell ()

@end

@implementation WellSearchCustomCell
@synthesize indicatorImage;
@synthesize jumpButton;
@synthesize afeObject;
@synthesize delegate;

@synthesize afeLbl,startDateLbl,statusLbl,budgetLbl,fieldEstmtLbl,feldEstmtBudgtLbl,actualLbl,actualBudgtLbl;

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
    self.afeLbl.text = @"";
    [self.afeLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.afeLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.startDateLbl.text = @"";
    [self.startDateLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.startDateLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.statusLbl.text = @"";
    [self.statusLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.statusLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.budgetLbl.text = @"";
    [self.budgetLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.budgetLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.fieldEstmtLbl.text = @"";
    [self.fieldEstmtLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.fieldEstmtLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.feldEstmtBudgtLbl.text = @"";
    [self.feldEstmtBudgtLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.feldEstmtBudgtLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.actualLbl.text = @"";
    [self.actualLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.actualLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
    self.actualBudgtLbl.text = @"";
    [self.actualBudgtLbl setFont:FONT_DETAIL_PAGE_TAB];
    [self.actualBudgtLbl setTextColor:[Utility getUIColorWithHexString:@"22313f"]];
   
}
-(IBAction) showAFEDetailListButtonClicked:(id) sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFE:onCell:)]){
        [self.delegate didSelectAFE:self.afeObject onCell:self];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectAFE:onCell:)]){
        [self.delegate didSelectAFE:self.afeObject onCell:self];
    }
}

-(void) dealloc
{
    self.indicatorImage = nil;
}

@end
