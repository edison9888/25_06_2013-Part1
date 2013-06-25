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
#import "AFEBurnDownGraphDetailedView.h"

#define tag_Actuals_Legend 23455
#define tag_Actuals_Legend_Label 23333
#define tag_Acruals_Legend 22223
#define tag_Acruals_Legend_Label 2223
#define tag_cumulative_Legend 23411
#define tag_cumulative_Legend_Label 1234
#define tag_afeEstimate_Legend 34221
#define tag_afeEstimate_Legend_Label 5654

#define FRAME_ACTIVITY_INDICATOR_CONTAINER_VIEW CGRectMake(0,2,480,504)

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

@synthesize afeBurndownLabel, delegate;


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
    //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"MM/01/yyyy"];
    
    
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

    
    RVChartXAxisGranularityLevel calculatedGranularityLevel = [self calculateGranularityLevelForStarDate:startDateChart andEndDate:endDateChart];
    
    ChartDataPoint *tempDatePoint;
    //float carryOverCumulativeVal = 0;

    double maxBudget = 0;
    double maxCumulative = 0;
    double maxActualsPlusAccrual = 0;
    
    for (int i = 0; i < dataPointsArray.count; i++) {
        
        tempDatePoint = [dataPointsArray objectAtIndex:i];
        if(tempDatePoint)
        {   
            if(tempDatePoint.afeEstimate > maxBudget)
                maxBudget = tempDatePoint.afeEstimate;
            
            if(tempDatePoint.cumulativeValue > maxCumulative)
                maxCumulative = tempDatePoint.cumulativeValue;
            
            if(tempDatePoint.yValue > maxActualsPlusAccrual)
                maxActualsPlusAccrual = tempDatePoint.yValue;
        }
            
    }
    
    
    double maxValueOfThree  = maxCumulative; 
    
    if(maxActualsPlusAccrual > maxValueOfThree)
        maxValueOfThree = maxActualsPlusAccrual;
    
    if(maxBudget > maxValueOfThree)
        maxValueOfThree = maxBudget;
    

    float maxVal = maxValueOfThree + maxValueOfThree*0.4;
    
    burnDownDartObj = [[AFEBurndownChart alloc] initWithFrame:CGRectMake(20, 45, self.frame.size.width - 50, self.frame.size.height - 80) gridLineColor:[UIColor grayColor] andXAxisGranularityLevel:calculatedGranularityLevel andXAxisDataPointRange:RVChartDataPointRangeOneMonth andxAxisStartDateTime:startDateChart andxAxisEndDateTime:endDateChart andMaximumValueOnYAxis:maxVal shouldDisplayDecimalPoints:NO maximumNumberOfSAxisLabel:6 xAxisLabelsFontSize:11.0 yAxisLabelsFontSize:11.0];
    [burnDownDartObj setBackgroundColor:[UIColor clearColor]];
    
    [burnDownDartObj plotChartWithDataPoints:dataPointsArray andCumulativeOffset:0];
    
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
    
    tempView = [self viewWithTag:234234];
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
    
    UIView *legendFieldEstimate  = [[UIView alloc] initWithFrame:CGRectMake(195, 45, 30, 3)];
    legendFieldEstimate.tag = 3333;
    legendFieldEstimate.backgroundColor = [Utility getUIColorWithHexString:@"#4AA02C"];
    [self addSubview:legendFieldEstimate];
    
    UILabel *legendFieldEstimate_label = [[UILabel alloc] initWithFrame:CGRectMake(125, 40, 90, 12)];
    legendFieldEstimate_label.textColor = [UIColor blackColor];
    legendFieldEstimate_label.text = @"AFE Estimate";
    legendFieldEstimate_label.textAlignment = UITextAlignmentLeft;
    legendFieldEstimate_label.backgroundColor = [UIColor clearColor];
    legendFieldEstimate_label.font = [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0];
    legendFieldEstimate_label.tag = 22222;
    [self addSubview:legendFieldEstimate_label];

    
    UIView *legendCumulative  = [[UIView alloc] initWithFrame:CGRectMake(280, 43, 30, 3)];
    legendCumulative.tag = tag_Acruals_Legend;
    legendCumulative.backgroundColor = [Utility getUIColorWithHexString:@"4682B4"];
    [self addSubview:legendCumulative];
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(291, 38.7 , 12, 12)];
    circleView.layer.cornerRadius = 7.5;
    circleView.layer.borderColor = [UIColor redColor].CGColor;
    circleView.layer.borderWidth = 0.5;
    circleView.tag = 234234;
    circleView.backgroundColor = [Utility getUIColorWithHexString:@"4682B4"];
    circleView.layer.borderColor = [Utility getUIColorWithHexString:@"63B8FF"].CGColor;
    [self addSubview:circleView];
    
    UILabel *legendCumulative_label = [[UILabel alloc] initWithFrame:CGRectMake(315, 40, 70, 12)];
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
    //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [df setDateFormat:@"MM/01/yyyy"];

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
                tempDataPoint.xDateValue = [df dateFromString:[df stringFromDate:tempAFE.date]];
                tempDataPoint.yValue = tempAFE.actualPlusAccrual;
                
                tempDataPoint.stackPercntAcrual = (tempAFE.fieldEstimate/tempAFE.actualPlusAccrual) *100;
                tempDataPoint.stackPercntActual = (tempAFE.actual/tempAFE.actualPlusAccrual) *100;
                tempDataPoint.cumulativeValue = tempAFE.actualPlusAccrualCumulative;
                tempDataPoint.afeEstimate = tempAFE.budget;
                tempDataPoint.actual = tempAFE.actual;
                tempDataPoint.fieldEstimate = tempAFE.fieldEstimate;
                tempDataPoint.exceededActualsPlusAccruals = tempAFE.exceedeActualsPlusAccrual;
                
                //tempDataPoint.stackPercntActual = tempAFE.actualPercent;
                //tempDataPoint.stackPercntAcrual = tempAFE.fieldEstimatePercent;
                                
                [resultDataPointsArray addObject:tempDataPoint];
                
                startDateDatapoint = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:startDateDatapoint options:0];

            }
        }
    
    dataPointsArray = resultDataPointsArray;
}

-(RVChartXAxisGranularityLevel) calculateGranularityLevelForStarDate:(NSDate*) startDateChart andEndDate:(NSDate*) endDateChart
{
    RVChartXAxisGranularityLevel result = RVChartXAxisGranularityLevelMonthly;
    
    if(dataPointsArray)
    {
        startDateChart = [self getSmallestDateInDataPointsArray];
        endDateChart = [self getLargestDateInDataPointsArray];
    }

    int numberOfDays = [Utility getNumberOfEpochDaysBetweenStartDate:startDateChart andEndDate:endDateChart shouldIgnoreTime:YES];
    int totalNumberOfMonths = 0;
    
    totalNumberOfMonths = (numberOfDays / 30);
    if((numberOfDays % 30)>0)
        totalNumberOfMonths = totalNumberOfMonths + 1;
    
    if(totalNumberOfMonths > 8)
    {
        result = RVChartXAxisGranularityLevelMonthsDynamically;
    }
    
    result = RVChartXAxisGranularityLevelMonthsDynamically;
    
    return result;
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
    activityIndicBGView.layer.cornerRadius = 16;
    
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

-(IBAction) showExpandViewOfGraph:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showExpandedBurndownGraphWithBurnDownItemArray:andStartDate:andEndDate:)])
    {
        [self.delegate showExpandedBurndownGraphWithBurnDownItemArray:afeArray andStartDate:startDate andEndDate:endDate];
    }
    
}

@end
