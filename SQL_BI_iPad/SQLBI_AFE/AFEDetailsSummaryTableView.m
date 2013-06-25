//
//  AFEDetailsSummaryTableView.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEDetailsSummaryTableView.h"
#import "AFE.h"

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,-1,950,528)

@interface AFEDetailsSummaryTableView()
{
    NSArray *summaryTableLabelArray;
    NSArray *afeArray;
    NSDate *startDate;
    NSDate *endDate;
    
    UIActivityIndicatorView *activityIndicatorView;
    UIView *activityIndicatorContainerView;
    UIView *activityIndicatorBGView;
    UILabel *messageLabel;
}

@end

@implementation AFEDetailsSummaryTableView

@synthesize afeMainTableView;
@synthesize afeSearchSummaryArray;
@synthesize afeDateBurnDownLabel;
@synthesize afeDateInvoiceLabel;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.afeMainTableView.layer.borderWidth = 1.0f;
    self.afeMainTableView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.50].CGColor;
    [self.afeDateBurnDownLabel setFont:FONT_SUMMARY_DATE];
    [self.afeDateInvoiceLabel setFont:FONT_SUMMARY_DATE];
    [self.afeDateBurnDownLabel setTextColor:COLOR_DASHBORD_DATE];
    
    summaryTableLabelArray = [[NSArray alloc]initWithObjects:@"Name",@"Class",@"AFE Estimate",@"Actuals",@"Total Accruals",@"Actuals + Accrual",@"Start Date",@"End Date",@"AFE Desc", nil];
}

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    afeArray = afeArrayToUse;
    startDate = start;
    endDate = end;
}

-(void)getAfeSearchSummaryArray:(NSArray *)afeSummaryArray
{
    self.afeSearchSummaryArray = afeSummaryArray;
    [self.afeMainTableView reloadData ];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AFESearchCustomDetailViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[AFESearchCustomDetailViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    if([summaryTableLabelArray count])
        cell.nameLabel.text = [summaryTableLabelArray objectAtIndex:indexPath.row];
    if (self.afeSearchSummaryArray == NULL)
    {
        cell.valueLabel.text = @"";
        cell.percentageValueLabel.text = @"";
    }
    AFE *tempAFEClass = (AFE *)[self.afeSearchSummaryArray objectAtIndex:0];
    if(tempAFEClass)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(setAfeNumberToTabButton:)])
        {
            [self.delegate setAfeNumberToTabButton:tempAFEClass.afeNumber];
        }
        self.afeDateBurnDownLabel.text = [NSString stringWithFormat:@"%@ - %@",tempAFEClass.fromDate,tempAFEClass.endDate];
        self.afeDateInvoiceLabel.text = self.afeDateBurnDownLabel.text;
        switch (indexPath.row) 
        {
            case 0:
            {
                cell.valueLabel.text = tempAFEClass.name;
            }
                break;
            case 1:
            {
                cell.valueLabel.text = tempAFEClass.afeClassName;
            }
                break;
            case 2:
            {
                cell.valueLabel.text = tempAFEClass.budgetAsStr;//afe estimate
            }
                break;
            case 3:
            {
                cell.valueLabel.text = tempAFEClass.actualsAsStr;
            }
                break;
            case 4:
            {
                cell.valueLabel.text = tempAFEClass.fieldEstimateAsStr;//accrual
            }
                break;
            case 5:
            {
                cell.valueLabel.text = tempAFEClass.actualPlusAccrualAsStr;
                if (tempAFEClass.percntgConsmptn > 100) 
                {
                    [cell setPercentageValueLabel:[NSString stringWithFormat:@"%@",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",tempAFEClass.percntgConsmptn]]] withColor:COLOR_RED];
                }
                else 
                {
                    [cell setPercentageValueLabel:[NSString stringWithFormat:@"%@",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",tempAFEClass.percntgConsmptn]]] withColor:COLOR_GREEN];
                }
            }
                break;
            case 6:
            {
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",tempAFEClass.fromDate] ;
                
            }
                break;
            case 7:
            {
                cell.valueLabel.text = [NSString stringWithFormat:@"%@",tempAFEClass.endDate];             
            }
                break;
            case 8:
            {   
                cell.valueLabel.text = tempAFEClass.afeDescription;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void) showActivityIndicatorOverlayView
{
    [self removeActivityIndicatorOverlayView];
    
    if(!activityIndicatorView)
    {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else
        [activityIndicatorView removeFromSuperview];
    
    if(!activityIndicatorContainerView)
        activityIndicatorContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicatorContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicatorContainerView removeFromSuperview];
        
    }
    
    if(!activityIndicatorBGView)
        activityIndicatorBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicatorContainerView.frame.size.width, activityIndicatorContainerView.frame.size.height)];
    else
        [activityIndicatorBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicatorContainerView.backgroundColor = [UIColor clearColor];
    activityIndicatorBGView.backgroundColor = [UIColor blackColor];
    activityIndicatorBGView.alpha = 0.1;
    activityIndicatorBGView.layer.cornerRadius = 20;
    activityIndicatorView.frame = CGRectMake((activityIndicatorContainerView.frame.size.width-50)/2, (activityIndicatorContainerView.frame.size.height-50)/2, 50, 50);
    activityIndicatorView.color = [UIColor darkGrayColor];
    
    [activityIndicatorContainerView addSubview:activityIndicatorBGView];
    [activityIndicatorContainerView addSubview:activityIndicatorView];
    [self addSubview:activityIndicatorContainerView];
    
    [activityIndicatorView startAnimating];
    
}

-(void) removeActivityIndicatorOverlayView
{
    if(activityIndicatorContainerView)
        [activityIndicatorContainerView removeFromSuperview];
    
    if(activityIndicatorView)
        [activityIndicatorView stopAnimating];
    
}

-(void) showMessageOnView:(NSString*) message
{
    if(!activityIndicatorContainerView)
        activityIndicatorContainerView = [[UIView alloc] initWithFrame:FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW];
    else
    {
        [activityIndicatorContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityIndicatorContainerView removeFromSuperview];
        
    }
    
    if(!messageLabel)
    {
        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (activityIndicatorContainerView.frame.size.height-15)/2, activityIndicatorContainerView.frame.size.width, 15)];
    }
    
    if(!activityIndicatorBGView)
        activityIndicatorBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, activityIndicatorContainerView.frame.size.width, activityIndicatorContainerView.frame.size.height)];
    else
        [activityIndicatorBGView removeFromSuperview];
    
    //Set Styling for all Views
    activityIndicatorContainerView.backgroundColor = [UIColor clearColor];
    activityIndicatorBGView.backgroundColor = [UIColor blackColor];
    activityIndicatorBGView.alpha = 0.1;
    activityIndicatorBGView.layer.cornerRadius = 5;
    
    messageLabel.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15];
    messageLabel.textColor = [UIColor redColor];
    messageLabel.backgroundColor= [UIColor clearColor];
    messageLabel.text = message? message:@"";
    messageLabel.textAlignment = UITextAlignmentCenter;
    
    [activityIndicatorContainerView addSubview:activityIndicatorBGView];
    [activityIndicatorContainerView addSubview:messageLabel];
    [self addSubview:activityIndicatorContainerView];
    
}

-(void) hideMessageOnView
{
    if(activityIndicatorContainerView)
        [activityIndicatorContainerView removeFromSuperview];
    
    if(messageLabel)
        messageLabel.text = @"";
}

@end
