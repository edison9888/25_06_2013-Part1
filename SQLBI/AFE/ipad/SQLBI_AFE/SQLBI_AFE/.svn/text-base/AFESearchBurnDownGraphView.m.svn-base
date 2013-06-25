//
//  AFESearchBurnDownGraphView.m
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 12/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFESearchBurnDownGraphView.h"
#import "AFEBurndownChart.h"
#import "ChartDataPoint.h"
#import "AFE.h"
#import "AFEBurnDownItem.h"

#define tag_Actuals_Legend 23455
#define tag_Actuals_Legend_Label 23333
#define tag_Acruals_Legend 22223
#define tag_Acruals_Legend_Label 2223
#define tag_cumulative_Legend 23411
#define tag_cumulative_Legend_Label 1234
#define tag_afeEstimate_Legend 34221
#define tag_afeEstimate_Legend_Label 5654

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,-1,505,532)

@interface AFESearchBurnDownGraphView ()
{
    AFEBurndownChart *burnDownDartObj;
    NSMutableArray *dataPointsArray;
    NSArray *afeArray;
    NSDate *startDate;
    NSDate *endDate;
    
    UIActivityIndicatorView *activityIndicView;
    UIView *activityIndicContainerView;
    UIView *activityIndicBGView;
    UILabel *messageLabel;
}

-(NSArray*) getDateSortedArrayOfDataPoints:(NSMutableArray*) toBeSorted;
-(NSDate*) getLargestDateInDataPointsArray;
-(NSDate*) getSmallestDateInDataPointsArray;

@end

@implementation AFESearchBurnDownGraphView

@synthesize afeBurndownLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)awakeFromNib
{
    [self.afeBurndownLabel setFont:FONT_SUMMARY_HEADER_TITLE];
    [self.afeBurndownLabel setTextColor:COLOR_HEADER_TITLE];
        
    [self createChart];

}

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    afeArray = afeArrayToUse;
    startDate = start;
    endDate = end;
        
    //[self createChart];
}

-(void)getAfeBurnDownDetailArray:(NSArray *)afeBurnDownItemsArray
{
    afeArray = afeBurnDownItemsArray;
    
    [self createChart];
}

-(void) createChart
{
    if(burnDownDartObj)
        [burnDownDartObj removeFromSuperview];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    
    NSDate *startDateChart;
    NSDate *endDateChart = [NSDate date];
    
    [self fillDataPointsArrayFromEnergyWindInfoArray];
    
    if(dataPointsArray)
    {
        startDateChart = [self getSmallestDateInDataPointsArray];
        endDateChart = [self getLargestDateInDataPointsArray];
    }
    
    if(!startDateChart)
        startDateChart = [df dateFromString:@"01/01/2012"];
    if(!endDateChart)
        endDateChart = [NSDate date];
    
    ChartDataPoint *tempDatePoint;
    //float carryOverCumulativeVal = 0;

    double cumulativeTotal = 0;// carryOverCumulativeVal;
    double maxBudget = 0;
    double maxActualsPlusAccrual = 0;
    
    for (int i = 0; i < dataPointsArray.count; i++) {
        
        tempDatePoint = [dataPointsArray objectAtIndex:i];
        if(tempDatePoint)
        {
            cumulativeTotal += tempDatePoint.yValue;
            
            if(tempDatePoint.afeEstimate > maxBudget)
                maxBudget = tempDatePoint.afeEstimate;
            
            if(tempDatePoint.yValue > maxActualsPlusAccrual)
                maxActualsPlusAccrual = tempDatePoint.yValue;
        }
            
    }
    
    double maxValueOfThree  = cumulativeTotal; 
    
    if(maxActualsPlusAccrual > maxValueOfThree)
        maxValueOfThree = maxActualsPlusAccrual;
    
    if(maxBudget > maxValueOfThree)
        maxValueOfThree = maxBudget;
    

    float maxVal = maxValueOfThree + maxValueOfThree*0.4;
    
    burnDownDartObj = [[AFEBurndownChart alloc] initWithFrame:CGRectMake(20, 55, self.frame.size.width - 40, self.frame.size.height - 100) gridLineColor:[UIColor grayColor] andXAxisGranularityLevel:RVChartXAxisGranularityLevelMonthly andXAxisDataPointRange:RVChartDataPointRangeOneMonth andxAxisStartDateTime:startDateChart andxAxisEndDateTime:endDateChart andMaximumValueOnYAxis:maxVal shouldDisplayDecimalPoints:NO];
    [burnDownDartObj setBackgroundColor:[UIColor clearColor]];
    
    [burnDownDartObj plotChartWithDataPoints:dataPointsArray andCumulativeOffset:cumulativeTotal];
    
    [self addSubview:burnDownDartObj];
    
    [self addLegengsToBurndownChart];
    
}

-(void) addLegengsToBurndownChart
{
    UIView *tempView = [self viewWithTag:3333];
    if(tempView)
        [tempView removeFromSuperview];
    tempView = [self viewWithTag:22222];
    if(tempView)
        [tempView removeFromSuperview];
    tempView = [self viewWithTag:tag_Actuals_Legend];
    if(tempView)
        [tempView removeFromSuperview];
    tempView = [self viewWithTag:tag_Actuals_Legend_Label];
    if(tempView)
        [tempView removeFromSuperview];
    tempView = [self viewWithTag:tag_Acruals_Legend];
    if(tempView)
        [tempView removeFromSuperview];
    tempView = [self viewWithTag:tag_Acruals_Legend_Label];
    if(tempView)
        [tempView removeFromSuperview];
    
    UIView *legendFieldEstimate  = [[UIView alloc] initWithFrame:CGRectMake(80, 75, 30, 3)];
    legendFieldEstimate.tag = 3333;
    legendFieldEstimate.backgroundColor = [Utility getUIColorWithHexString:@"#4AA02C"];
    [self addSubview:legendFieldEstimate];
    
    UILabel *legendFieldEstimate_label = [[UILabel alloc] initWithFrame:CGRectMake(115, 70, 90, 12)];
    legendFieldEstimate_label.textColor = [UIColor blackColor];
    legendFieldEstimate_label.text = @"AFE Estimate";
    legendFieldEstimate_label.textAlignment = UITextAlignmentLeft;
    legendFieldEstimate_label.backgroundColor = [UIColor clearColor];
    legendFieldEstimate_label.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0];
    legendFieldEstimate_label.tag = 22222;
    [self addSubview:legendFieldEstimate_label];

    
    
    UIImageView *legendActuals  = [[UIImageView alloc] initWithFrame:CGRectMake(210, 68, 15, 15)];
    legendActuals.image = [UIImage imageNamed:@"LegendBlueBar2"];
    legendActuals.backgroundColor = [UIColor clearColor];
    legendActuals.tag = tag_Actuals_Legend;
    [self addSubview:legendActuals];
    
    UILabel *legendActuals_label = [[UILabel alloc] initWithFrame:CGRectMake(230, 70, 50, 12)];
    legendActuals_label.textColor = [UIColor blackColor];
    legendActuals_label.text = @"Actuals";
    legendActuals_label.textAlignment = UITextAlignmentLeft;
    legendActuals_label.backgroundColor = [UIColor clearColor];
    legendActuals_label.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0];
    legendActuals.tag = tag_Actuals_Legend_Label;
    [self addSubview:legendActuals_label];
    
    UIImageView *legendAcruals  = [[UIImageView alloc] initWithFrame:CGRectMake(285, 68, 15, 15)];
    legendAcruals.image = [UIImage imageNamed:@"LegendRedBar2"];
    legendActuals.tag = tag_Acruals_Legend;
    legendAcruals.backgroundColor = [UIColor clearColor];
    [self addSubview:legendAcruals];
    
    UILabel *legendAcruals_label = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 50, 12)];
    legendAcruals_label.textColor = [UIColor blackColor];
    legendAcruals_label.text = @"Accruals";
    legendAcruals_label.textAlignment = UITextAlignmentLeft;
    legendAcruals_label.backgroundColor = [UIColor clearColor];
    legendAcruals_label.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0];
    legendActuals.tag = tag_Acruals_Legend_Label;
    [self addSubview:legendAcruals_label];

    UIView *legendCumulative  = [[UIView alloc] initWithFrame:CGRectMake(360, 73, 30, 5)];
    legendCumulative.tag = tag_Acruals_Legend;
    legendCumulative.backgroundColor = [UIColor redColor];
    [self addSubview:legendCumulative];
    
    UILabel *legendCumulative_label = [[UILabel alloc] initWithFrame:CGRectMake(395, 70, 70, 12)];
    legendCumulative_label.textColor = [UIColor blackColor];
    legendCumulative_label.text = @"Cumulative";
    legendCumulative_label.textAlignment = UITextAlignmentLeft;
    legendCumulative_label.backgroundColor = [UIColor clearColor];
    legendCumulative_label.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0];
    legendCumulative_label.tag = tag_Acruals_Legend_Label;
    [self addSubview:legendCumulative_label];
    
    
}

-(void) fillDataPointsArrayFromEnergyWindInfoArray
{
    ChartDataPoint *tempDataPoint;
    
    NSMutableArray *resultDataPointsArray;
    
    if(dataPointsArray)
        dataPointsArray = nil;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"MM/dd/yyyy"];

    NSDate *startDateDatapoint = [df dateFromString:@"01/01/2012"];
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    [dc setMonth:1];
    
    resultDataPointsArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    if(afeArray)
        for(AFEBurnDownItem *tempAFE in afeArray)
        {
            if(tempAFE)
            {
                i++;
                
                tempDataPoint = [[ChartDataPoint alloc] init];
                tempDataPoint.entityID = [NSString stringWithFormat:@"%d",i];
                tempDataPoint.xDateValue = tempAFE.date;//[df dateFromString:tempAFE];
                tempDataPoint.yValue = tempAFE.actualPlusAccrual;
                
                tempDataPoint.stackPercntAcrual = (tempAFE.fieldEstimate/tempAFE.actualPlusAccrual) *100;
                tempDataPoint.stackPercntActual = (tempAFE.actual/tempAFE.actualPlusAccrual) *100;
                tempDataPoint.cumulativeValue = tempAFE.cumulativeActual + tempAFE.cumulativeFieldEstimate;
                tempDataPoint.afeEstimate = tempAFE.budget;
                
                //tempDataPoint.stackPercntActual = tempAFE.actualPercent;
                //tempDataPoint.stackPercntAcrual = tempAFE.fieldEstimatePercent;
                                
                [resultDataPointsArray addObject:tempDataPoint];
                
                startDateDatapoint = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:startDateDatapoint options:0];

            }
        }
    
    dataPointsArray = resultDataPointsArray;
}

-(NSDate*) getSmallestDateInDataPointsArray
{
    NSDate *smallestDate;
    
    NSArray *tempDataPointArray = [self getDateSortedArrayOfDataPoints:dataPointsArray];
    
    if(tempDataPointArray && tempDataPointArray.count>0)
    {
        smallestDate = ((ChartDataPoint*)[tempDataPointArray objectAtIndex:0]).xDateValue;
    }
    
    return smallestDate;
}

-(NSDate*) getLargestDateInDataPointsArray
{
    NSDate *largestDate;
    
    NSArray *tempDataPointArray = [self getDateSortedArrayOfDataPoints:dataPointsArray];
    
    if(tempDataPointArray && tempDataPointArray.count>0)
    {
        largestDate = ((ChartDataPoint*)[tempDataPointArray objectAtIndex:tempDataPointArray.count-1]).xDateValue;
    }
    
    return largestDate;
}


-(NSArray*) getDateSortedArrayOfDataPoints:(NSMutableArray*) toBeSorted
{
    NSArray *resultArray = toBeSorted;
    if(toBeSorted)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"xDateValue" ascending:TRUE];
        resultArray = [toBeSorted sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];   
    }
    
    return resultArray;
}

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

@end
