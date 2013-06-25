//
//  HeadlineMetricsSummaryView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadlineMetricsSummaryView.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(4,48,483,253)

@interface HeadlineMetricsSummaryView ()
{
    KPIModel *kpiObject;
    NSDate *startDate;
    NSDate *endDate;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
}


@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *numbOfAfeLbl;
@property (strong, nonatomic) IBOutlet UILabel *numbOfAfeTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *totlBudgetValLbl;
@property (strong, nonatomic) IBOutlet UILabel *totlBudgetTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *tolFldEstmtValLbel;
@property (strong, nonatomic) IBOutlet UILabel *tolFldEstmtTitlelLbel;
@property (strong, nonatomic) IBOutlet UILabel *actualValLbl;
@property (strong, nonatomic) IBOutlet UILabel *actualTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgDurtnValLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgDurtnTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgAmntValLbl;
@property (strong, nonatomic) IBOutlet UILabel *avgAmntTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *totlFldEstimtPerntLbl;
@property (strong, nonatomic) IBOutlet UILabel *actualPerntLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerDatetLbl;
@property (strong, nonatomic) IBOutlet UILabel *actalPlsAccrlsLbl;
@property (strong, nonatomic) IBOutlet UILabel *actalPlsAccrlsValLbl;
@property (strong, nonatomic) IBOutlet UILabel *actualplsAccralPerntgLbl;


-(void)setNumbOfAfe :  (double)value;
-(void)setTotalBudget : (double)value;
-(void)setTotlFldEstmt :  (double)value;
-(void)setActual:  (double)value;
-(void)setAvgDuration:  (double)value;
-(void)setAvgAmntperAFE:  (double)value;
-(void)setTotlFldEstmtPer: (double)value;
-(void)setActualPercentage: (double)value;

@end


@implementation HeadlineMetricsSummaryView
@synthesize actalPlsAccrlsLbl;
@synthesize actalPlsAccrlsValLbl;
@synthesize actualplsAccralPerntgLbl;

@synthesize headerTitleLabel;
@synthesize numbOfAfeLbl;
@synthesize totlBudgetValLbl;
@synthesize tolFldEstmtValLbel;
@synthesize actualValLbl;
@synthesize avgDurtnValLbl;
@synthesize avgAmntValLbl;
@synthesize totlFldEstimtPerntLbl;
@synthesize actualPerntLbl, numbOfAfeTitleLbl,tolFldEstmtTitlelLbel,totlBudgetTitleLbl,headerDatetLbl,avgDurtnTitleLbl,avgAmntTitleLbl,actualTitleLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = (HeadlineMetricsSummaryView*) [[[NSBundle mainBundle] loadNibNamed:@"HeadlineMetricsSummaryView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

-(void) awakeFromNib
{
    //self.headerTitleLabel.font = 
    
    [self.totlFldEstimtPerntLbl setHidden:YES];
    [self.actualPerntLbl setHidden:YES];
    
    self.headerTitleLabel.font = FONT_SUMMARY_HEADER_TITLE;
    [self.headerTitleLabel setTextColor:[Utility getUIColorWithHexString:@"ffffff"]];
    
    self.headerDatetLbl.font = FONT_SUMMARY_DATE;
    [self.headerDatetLbl setTextColor:[Utility getUIColorWithHexString:@"a1e2ff"]];
    
    self.numbOfAfeTitleLbl.font = FONT_HEADLINE_TITLE;
    [self.numbOfAfeTitleLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.totlBudgetTitleLbl.font = FONT_HEADLINE_TITLE;
    [self.totlBudgetTitleLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.tolFldEstmtTitlelLbel.font = FONT_HEADLINE_TITLE;
    [self.tolFldEstmtTitlelLbel setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.actualTitleLbl.font = FONT_HEADLINE_TITLE;
    [self.actualTitleLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.avgDurtnTitleLbl.font = FONT_HEADLINE_TITLE;
    [self.avgDurtnTitleLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.avgAmntTitleLbl.font = FONT_HEADLINE_TITLE;    
    [self.avgAmntTitleLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];
    self.actalPlsAccrlsLbl.font = FONT_HEADLINE_TITLE;    
    [self.actalPlsAccrlsLbl setTextColor:[Utility getUIColorWithHexString:@"467182"]];

    
    
    
    self.numbOfAfeLbl.font = FONT_HEADLINE_VALUE;
    [self.numbOfAfeLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.totlBudgetValLbl.font = FONT_HEADLINE_VALUE;
    [self.totlBudgetValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.tolFldEstmtValLbel.font = FONT_HEADLINE_VALUE;
    [self.tolFldEstmtValLbel setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.actualValLbl.font = FONT_HEADLINE_VALUE;
    [self.actualValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.avgDurtnValLbl.font = FONT_HEADLINE_VALUE;
    [self.avgDurtnValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.avgAmntValLbl.font = FONT_HEADLINE_VALUE;
    [self.avgAmntValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    self.actalPlsAccrlsValLbl.font = FONT_HEADLINE_VALUE;
    [self.actalPlsAccrlsValLbl setTextColor:[Utility getUIColorWithHexString:@"1b2128"]];
    
    self.totlFldEstimtPerntLbl.font = FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE;
    [self.totlFldEstimtPerntLbl setTextColor:[Utility getUIColorWithHexString:@"ff0000"]];
    self.actualPerntLbl.font = FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE;
    [self.actualPerntLbl setTextColor:[Utility getUIColorWithHexString:@"2ac500"]];   
    self.actualplsAccralPerntgLbl.font = FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE;
    [self.actualplsAccralPerntgLbl setTextColor:[Utility getUIColorWithHexString:@"2ac500"]]; 
}


-(void) refreshDataWithKPIModel:(KPIModel*) kpiModel andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    
    kpiObject = kpiModel;
    startDate = start;
    endDate = end;
    self.headerDatetLbl.text = (startDate && endDate)? [NSString stringWithFormat:@"%@ - %@",[Utility getStringFromDate:start],[Utility getStringFromDate:endDate]]:@"";

    [self setNumbOfAfe:kpiModel.afeCount];
    self.totlBudgetValLbl.text = kpiModel.totalBudgetAsStr;
    self.tolFldEstmtValLbel.text = kpiModel.totalFieldEstAsStr;
    self.actualValLbl.text = kpiModel.totalActualsAsStr;
    [self setAvgDuration:kpiModel.avgAFEDuration];
    self.avgAmntValLbl.text = kpiModel.avgAFEBudgetASsStr;
    [self setTotlFldEstmtPer:kpiModel.totalFieldEstPercent];
    [self setActualPercentage:kpiModel.totalActualsPercent];
    self.actalPlsAccrlsValLbl.text = kpiModel.actualsPlusAccrualsASsStr;
    self.actualplsAccralPerntgLbl.text = [NSString stringWithFormat:@"(%.2f\%%)", kpiModel.avgConsumption];
    
}


#pragma mark - View modification methods

-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicView)
    {
        activityIndicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicView removeFromSuperview];
    
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    activityIndicView.frame = CGRectMake((activityIndicContainerView.frame.size.width-50)/2, (activityIndicContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicView.color = [UIColor darkGrayColor];
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:activityIndicView];
    [self addSubview:activityIndicContainerView];
    
    [activityIndicView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(activityIndicView)
        [activityIndicView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(!activityIndicContainerView)
        activityIndicContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicContainerView removeFromSuperview];
        
    }
    
    if(!messageLabel)
    {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicContainerView.frame.size.height-15)/2, activityIndicContainerView.frame.size.width, 15)];
    }
    
    if(!activityIndicBGView)
        activityIndicBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicContainerView.frame.size.width, activityIndicContainerView.frame.size.height)];
    else
        [activityIndicBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicContainerView.backgroundColor = [UIColor clearColor];
    activityIndicBGView.backgroundColor = [UIColor blackColor];
    activityIndicBGView.alpha = 0.1;
    activityIndicBGView.layer.cornerRadius = 5;
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor redColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicContainerView addSubview:activityIndicBGView];
    [activityIndicContainerView addSubview:messageLabel];
    [self addSubview:activityIndicContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicContainerView)
        [activityIndicContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}


-(void)setNumbOfAfe : (double)value {
    
    self.numbOfAfeLbl.text = [Utility formatNumber:[NSString stringWithFormat:@"%.f",value]];
}
-(void)setTotalBudget : (double)value{
    self.totlBudgetValLbl.text = [NSString stringWithFormat:@"$%.f MM",value];
}
-(void)setTotlFldEstmt :  (double)value{
    self.tolFldEstmtValLbel.text =[NSString stringWithFormat:@"$%.f MM",value];
    
}
-(void)setActual:  (double)value{
    self.actualValLbl.text = [NSString stringWithFormat:@"$%.f MM",value];
}
-(void)setAvgDuration:  (double)value{
    self.avgDurtnValLbl.text = [NSString stringWithFormat:@"%.f",value];
    
}

-(void)setAvgAmntperAFE:  (double)value{
    self.avgAmntValLbl.text = [NSString stringWithFormat:@"$%.f M",value];
    
}

-(void)setTotlFldEstmtPer: (double)value
{   
    self.totlFldEstimtPerntLbl.text = [NSString stringWithFormat:@"(%.f%%)",value];
    CGRect temFrame = self.totlFldEstimtPerntLbl.frame;
    temFrame.origin.x = self.tolFldEstmtValLbel.frame.origin.x + [self.tolFldEstmtValLbel.text sizeWithFont:self.tolFldEstmtValLbel.font].width +10;
    self.totlFldEstimtPerntLbl.frame = temFrame;
}
-(void)setActualPercentage: (double)value
{
    self.actualPerntLbl.text = [NSString stringWithFormat:@"(%.f%%)",value];
    
    CGRect temFrame = self.actualPerntLbl.frame;
    temFrame.origin.x = self.actualValLbl.frame.origin.x + [self.actualValLbl.text sizeWithFont:self.actualValLbl.font].width +10;
    self.actualPerntLbl.frame = temFrame;
}
-(void)setActualPlusAccrual:  (double)value{
    self.actalPlsAccrlsValLbl.text = [NSString stringWithFormat:@"$%.f M",value];
    
}
-(void) dealloc
{
    kpiObject = nil;
}


@end
