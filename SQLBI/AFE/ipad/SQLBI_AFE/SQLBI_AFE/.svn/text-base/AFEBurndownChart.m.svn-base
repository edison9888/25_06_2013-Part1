//
//  AFEBurndownChart.m
//  SQLandBIiPad
//
//  Created by Apple on 05/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFEBurndownChart.h"
#import "ChartDataPoint.h"

@interface AFEBurndownChart()
{
    CALayer *_animationLayer;
    CAShapeLayer *_pathLayer;
    CAShapeLayer *_pathLayer_Budget;
}

@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
@property (nonatomic, retain) CAShapeLayer *pathLayer_Budget;


@property(nonatomic, assign) CGContextRef currentGraphicsContext;

-(void) addYAxisScaleMarking;
-(int) calculateNumberOfXAxisGridLines;
-(int) calculateNumberOfYAxisGridLines;
-(void) drawChartGridLines;
-(void) drawYAxisLines;
-(void) drawXAxisLines;
-(void) labelXAxisLines;
-(void) labelYAxisLines;
-(void) calculateAxisLengths;
-(NSArray*) getLabelValuesForXAxis;
-(void) drawHorizontalGridLineUsingFrame:(CGRect) frame;
-(void) drawVerticalGridLineUsingFrame:(CGRect) frame;
-(CGPoint) getBottomScreenLocationOfXAxisValue:(NSDate*) dateVal;
-(void) drawBarBlockForCGPoint:(CGPoint) centerPoint andValue:(int) valueToPlot withActualPercent:(float) actual acrrualPercent:(float) acrual;
-(int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;
- (UIImage*)resizedImage:(UIImage*)image forWidth:(float) newWidth forHeight:(float) newHeight;

-(int) getNumberOfFiveMinutesBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;

-(int) getNumberOfHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;
-(NSArray*) getDateSortedArrayOfDataPoints:(NSMutableArray*) toBeSorted;

@end


@implementation AFEBurndownChart

@synthesize xAxisDataPointRange,xAxisEndDateTime,xAxisStartDateTime,xAxisGranularityLevel, dataPoints;
@synthesize currentGraphicsContext;
@synthesize animationLayer = _animationLayer;
@synthesize pathLayer = _pathLayer;
@synthesize pathLayer_Budget = _pathLayer_Budget;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}



-(AFEBurndownChart*) initWithFrame:(CGRect) frame gridLineColor:(UIColor*) gridColor andXAxisGranularityLevel:(RVChartXAxisGranularityLevel) xGranLevel andXAxisDataPointRange:(RVChartDataPointRange) xDataPointRange andxAxisStartDateTime:(NSDate*) startDate andxAxisEndDateTime:(NSDate*) endDate andMaximumValueOnYAxis:(int) maxYAxisValue  shouldDisplayDecimalPoints:(BOOL) displayDecimal
{
    self = [super initWithFrame:frame];
    if (self) {
        
        labelsTextColor = [UIColor blackColor];
        
        gridLineColor = gridColor;
        
        displayDecimalPoint = displayDecimal;
        
        self->xAxisGranularityLevel = xGranLevel;
        self->xAxisDataPointRange = xDataPointRange;
        
        NSTimeInterval offsetFromGMTStart = [Utility getOffsetFromGMT:startDate];
        
        NSTimeInterval offsetFromGMTEnd = [Utility getOffsetFromGMT:endDate];
        
        if(offsetFromGMTStart != offsetFromGMTEnd)
        {
            [NSException raise:@"GVNSExceptionWrongChartParameters" format:@"xAxisStartDateTime & xAxisEndDateTime cannot be in different  Time Zones."];
        }
        
        
        cumulativeOffsetVal = 0;
        timeZoneOffsetInStartAndEndDate = offsetFromGMTStart;
        
        NSDateFormatter *df = [NSDateFormatter new];
        
        if((self.xAxisGranularityLevel == RVChartXAxisGranularityLevelHourly) ||(self.xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenMinutes)||(self.xAxisGranularityLevel == RVChartXAxisGranularityLevelFiveMinutes))
        {
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [df setDateFormat:@"MM dd yyyy 'at' HH"]; //Remove the minutes part
        }
        else
        {
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
        }
        
        
        self->xAxisStartDateTime = [df dateFromString:[df stringFromDate:startDate]];
        self->xAxisEndDateTime = [df dateFromString:[df stringFromDate:endDate]];
        
        xAxisLength = self.frame.size.width;
        yAxisLength = self.frame.size.height;
        
        [self setMaximumYAxisValue:maxYAxisValue];
        
        [self drawChartGridLines];
        [self addYAxisScaleMarking];
        
        
        self.animationLayer = [CALayer layer];
        
        self.animationLayer.frame = self.bounds;
        [self.layer addSublayer:self.animationLayer];
    }
    return self;
}

-(void) setLabelsTextColor:(UIColor*) color
{
    if(color)
        labelsTextColor = color;
    
    [self labelXAxisLines];
    [self labelYAxisLines];
}


-(void) addYAxisScaleMarking
{
   
}


-(CGPoint) getCgPointOfBottomMostYAxisLine
{
    return CGPointMake(xLeftOffsetForLabels, yAxisLength+yTopOffsetForLabels);
}


-(void) drawChartGridLines
{
    xLeftOffsetForLabels = 55;

    xRightOffsetForLabels = 5;
    
    yBottomOffsetForLabels = 20;
    yTopOffsetForLabels = 10;

    
    [self calculateNumberOfXAxisGridLines];
    [self calculateNumberOfYAxisGridLines];
    
    [self calculateAxisLengths];
    
    [self drawYAxisLines];
    [self drawXAxisLines];
    
    [self labelXAxisLines];
    [self labelYAxisLines];
}


-(void) calculateAxisLengths
{
     yAxisLength = self.frame.size.height - (yTopOffsetForLabels + yBottomOffsetForLabels) - 15;
    
     xAxisLength = self.frame.size.width - (xLeftOffsetForLabels + xRightOffsetForLabels);
}


-(int) calculateNumberOfXAxisGridLines
{
    int numberOfDays = 0;
    int numberOfFiveMinutes = 0;
    int numberOfHours = 0;
    
    
    if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFiveMinutes)
    {
        numberOfFiveMinutes = [self getNumberOfFiveMinutesBetweenStartDate:self->xAxisStartDateTime andEndDate:self->xAxisEndDateTime shouldIgnoreTime:NO];
        
        numberOfXAxisLines = numberOfFiveMinutes + 1;
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenMinutes)
    {
        numberOfFiveMinutes = [self getNumberOfFiveMinutesBetweenStartDate:self->xAxisStartDateTime andEndDate:self->xAxisEndDateTime shouldIgnoreTime:NO];
        
        numberOfXAxisLines = numberOfFiveMinutes/3 + 1;
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelHourly)
    {
        numberOfHours = [self getNumberOfHoursBetweenStartDate:self->xAxisStartDateTime andEndDate:self->xAxisEndDateTime shouldIgnoreTime:NO];
        
        numberOfXAxisLines = numberOfHours + 1;
        
       
    }
    else
    {
        
        numberOfDays = [Utility getNumberOfEpochDaysBetweenStartDate:self->xAxisStartDateTime andEndDate:self->xAxisEndDateTime shouldIgnoreTime:YES];
        
        
        if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelDaily)
        {
            numberOfXAxisLines = numberOfDays;
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelWeekly)
        {
            numberOfXAxisLines = (numberOfDays / 7);
           
            if((numberOfDays % 7)>0)
                numberOfXAxisLines = numberOfXAxisLines + 1;
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenDays)
        {     
            numberOfXAxisLines = (numberOfDays / 15);
            if((numberOfDays % 15)>0)
                numberOfXAxisLines = numberOfXAxisLines + 1;
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelMonthly)
        {           
            numberOfXAxisLines = (numberOfDays / 30);
            if((numberOfDays % 30)>0)
                numberOfXAxisLines = numberOfXAxisLines + 1;
            
        }

    }
    
    numberOfXAxisLines += 1;
    
    return numberOfXAxisLines;
    
}

-(int) calculateNumberOfYAxisGridLines
{
    
    numberOfYAxisLines = 8;
    
    return numberOfYAxisLines;
    
}

-(void) drawYAxisLines
{
    
    yAxisIntervalWidth = yAxisLength/numberOfYAxisLines;
    
    float tempInitialY = yTopOffsetForLabels + yAxisIntervalWidth;

    for(int i = 0; i< numberOfYAxisLines; i++)
    {
        
        if(i == numberOfYAxisLines - 1)
            [self drawHorizontalGridLineUsingFrame:CGRectMake(xLeftOffsetForLabels, tempInitialY, xAxisLength, 2)];
        else
            [self drawHorizontalGridLineUsingFrame:CGRectMake(xLeftOffsetForLabels - 7, tempInitialY, 7, 2)];
            
        tempInitialY += yAxisIntervalWidth;
        
    }        
    
}


-(void) drawXAxisLines
{

    xAxisIntervalWidth = xAxisLength/(numberOfXAxisLines);
    
    float tempInitialX = xLeftOffsetForLabels + xAxisIntervalWidth;

    //This is important for ploting bar graph.
    bottomOfFirstXAxisLine =CGPointMake(tempInitialX, yTopOffsetForLabels+ yAxisLength);
    
    for(int i = 0; i< numberOfXAxisLines; i++)
    {
        
        if(i == 0)
            [self drawVerticalGridLineUsingFrame:CGRectMake(tempInitialX - xAxisIntervalWidth, yTopOffsetForLabels, 2, yAxisLength)];
        else
            [self drawVerticalGridLineUsingFrame:CGRectMake(tempInitialX - xAxisIntervalWidth, yTopOffsetForLabels + yAxisLength, 2, 7)];
        
        tempInitialX += xAxisIntervalWidth;
        
    }       
    
}

-(void) drawHorizontalGridLineUsingFrame:(CGRect) frame
{
    
    CGFloat components[3];
    [Utility getRGBComponents:components forColor:gridLineColor];
    
    CGFloat colorActual[4] = {components[0], components[1],components[2], 1.0};
    
    
    CGContextSetLineWidth(currentGraphicsContext, 1.0);
    
    CGContextMoveToPoint(currentGraphicsContext, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(currentGraphicsContext, frame.origin.x + frame.size.width , frame.origin.y);
    
    CGContextSetStrokeColor(currentGraphicsContext, colorActual);
    CGContextStrokePath(currentGraphicsContext);
     

}


-(void) drawVerticalGridLineUsingFrame:(CGRect) frame
{
        
    CGFloat components[3];
    [Utility getRGBComponents:components forColor:gridLineColor];
    
    CGFloat colorActual[4] = {components[0], components[1],components[2], 1.0};
    
    CGContextSetLineWidth(currentGraphicsContext, 1.0);
    
    CGContextMoveToPoint(currentGraphicsContext, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(currentGraphicsContext, frame.origin.x , frame.origin.y + frame.size.height);
    
    CGContextSetStrokeColor(currentGraphicsContext, colorActual);
    CGContextStrokePath(currentGraphicsContext);
     

    
}


-(void) labelXAxisLines
{
    UILabel *pXAxisLabel;
    
    NSArray *tempLabelValuesForXAxis = [self getLabelValuesForXAxis];
    
    if(!xAxisUILabels)
        xAxisUILabels = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<[xAxisUILabels count]; i++)
    {
        pXAxisLabel = [xAxisUILabels objectAtIndex:i];
        
        if(pXAxisLabel)
            [pXAxisLabel removeFromSuperview];
    }
    [xAxisUILabels removeAllObjects];
    
    
    for(int i = 0; i<numberOfXAxisLines-1; i++)
    {
        pXAxisLabel = [[UILabel alloc] init];
        
        pXAxisLabel.text=[NSString stringWithFormat:@"%@",[tempLabelValuesForXAxis objectAtIndex:i]];
        [pXAxisLabel setFrame:CGRectMake(bottomOfFirstXAxisLine.x - 25 + (xAxisIntervalWidth*i), bottomOfFirstXAxisLine.y + 15, 50, 12)];
        pXAxisLabel.textColor= labelsTextColor;
        pXAxisLabel.backgroundColor=[UIColor clearColor];
        pXAxisLabel.textAlignment=UITextAlignmentCenter;
        [pXAxisLabel setFont:[UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0]];          
        //pXAxisLabel.transform=CGAffineTransformMakeRotation(M_PI/3);
        //[pXAxisLabel setFont:[UIFont fontWithName:@"Arial" size:14]];      
        pXAxisLabel.tag=888;
        [self addSubview:pXAxisLabel];
        [xAxisUILabels addObject:pXAxisLabel];
        
    }
}



-(void) labelYAxisLines
{
    
    UILabel *pYAxisLabel;
    
    float tempYIntervalValue = maximumYAxisValue / numberOfYAxisLines;
    
    if(!yAxisUILabels)
        yAxisUILabels = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<[yAxisUILabels count]; i++)
    {
        pYAxisLabel = [yAxisUILabels objectAtIndex:i];
        
        if(pYAxisLabel)
            [pYAxisLabel removeFromSuperview];
    }
    [yAxisUILabels removeAllObjects];
    
    
    for(int i = 0; i<numberOfYAxisLines; i++)
    {
        pYAxisLabel = [[UILabel alloc] init];
    
//        if(displayDecimalPoint)
//            pYAxisLabel.text=[NSString stringWithFormat:@"$%@",[Utility formatNumber:[NSString stringWithFormat:@"%.1f",tempYIntervalValue*i]]];
//        else
//            pYAxisLabel.text=[NSString stringWithFormat:@"$%@",[Utility formatNumber:[NSString stringWithFormat:@"%.f",tempYIntervalValue*i]]];
        
        pYAxisLabel.text= [Utility formatNumberForAFEMMString:(double)tempYIntervalValue*i];
        
        [pYAxisLabel setFrame:CGRectMake(xLeftOffsetForLabels - 70 , bottomOfFirstXAxisLine.y - 5 - (yAxisIntervalWidth*i), 60, 11.0)];
        pYAxisLabel.textColor= labelsTextColor;
        pYAxisLabel.backgroundColor=[UIColor clearColor];
        pYAxisLabel.textAlignment=UITextAlignmentRight;
        //pXAxisLabel.transform=CGAffineTransformMakeRotation(M_PI/3);
        //[pYAxisLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [pYAxisLabel setFont:[UIFont fontWithName:COMMON_FONTNAME_BOLD size:11.0]];
        pYAxisLabel.tag=888;
        [self addSubview:pYAxisLabel];
        [yAxisUILabels addObject:pYAxisLabel];
    }
    
}


-(NSArray*) getLabelValuesForXAxis
{
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempActualGridDatesValues = [[NSMutableArray alloc] init];
    
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    
    if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFiveMinutes)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
               
        NSDate *tempInitialDate = [NSDate dateWithTimeInterval:-timeZoneOffsetInStartAndEndDate sinceDate:self->xAxisStartDateTime];
        
        [dc setMinute:5];
        
        for(int i = 0; i<numberOfXAxisLines-1; i++)
        {
            
            [tempResultArray addObject:[Utility getTwelveHourTimeFromDate:tempInitialDate shouldDiscardMinutes:NO]];
            [tempActualGridDatesValues addObject:tempInitialDate];
            
            tempInitialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempInitialDate options:0];
        }

    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenMinutes)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
               
        NSDate *tempInitialDate = [NSDate dateWithTimeInterval:-timeZoneOffsetInStartAndEndDate sinceDate:self->xAxisStartDateTime];
        
        [dc setMinute:15];
        
        for(int i = 0; i<numberOfXAxisLines-1; i++)
        {
            
            [tempResultArray addObject:[Utility getTwelveHourTimeFromDate:tempInitialDate shouldDiscardMinutes:NO]];
            [tempActualGridDatesValues addObject:tempInitialDate];
            
            tempInitialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempInitialDate options:0];
        }
        
        xAxisGridLineDatesValues = tempActualGridDatesValues;
        
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelHourly)
    {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSDate *tempInitialDate = [NSDate dateWithTimeInterval:-timeZoneOffsetInStartAndEndDate sinceDate:self->xAxisStartDateTime];
        
        [dc setHour:1];
        
        for(int i = 0; i<numberOfXAxisLines-1; i++)
        {
            
            [tempResultArray addObject:[Utility getTwelveHourTimeFromDate:tempInitialDate shouldDiscardMinutes:YES]];
            [tempActualGridDatesValues addObject:tempInitialDate];
            
            tempInitialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempInitialDate options:0];
        }
        
        xAxisGridLineDatesValues = tempActualGridDatesValues;
        
    }
    else 
    {   
        if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelDaily)
        {
            [dc setDay:1];
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelWeekly)
        {
            [dc setDay:7];
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenDays)
        {
            [dc setDay:15];
        }
        else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelMonthly)
        {
            [dc setMonth:1];
        }
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM / dd"];       //Remove the time part
        
        
        //NSDate *tempInitialDate = self->xAxisStartDateTime;
        
        NSDate *tempInitialDate = [NSDate dateWithTimeInterval:-timeZoneOffsetInStartAndEndDate sinceDate:self->xAxisStartDateTime];
        
        for(int i = 0; i<numberOfXAxisLines-1; i++)
        {
            if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelMonthly)
                [tempResultArray addObject:[Utility getMonthNameFromDate:tempInitialDate]];
            else
                [tempResultArray addObject:[df stringFromDate:tempInitialDate]];
            
            [tempActualGridDatesValues addObject:tempInitialDate];
            
            if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelMonthly)
            {
                tempInitialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempInitialDate options:0];
            }
            else
                tempInitialDate = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempInitialDate options:0];
            
        }
        
        xAxisGridLineDatesValues = tempActualGridDatesValues;
    
    }
    
    
    return tempResultArray;
}



-(void) setMaximumYAxisValue:(int) value
{
    if(value == 0)
    {
        value = 16;
    }
    
    maximumYAxisValue = value;
    
}

-(void) setYAxisScaleUnitText:(NSString*) value
{
    if(lblYAxisScaleUnit)
    {
        lblYAxisScaleUnit.text = value? value:@"";
    }
}


-(void) plotChartWithDataPoints:(NSArray*) dataPointsList andCumulativeOffset:(float) cumulativeOffset
{
    cumulativeOffsetVal = cumulativeOffset;
    
    //if((!dataPointsList)||([dataPointsList count]==0))
    if(!dataPointsList)
    {
        NSLog(@"GVNSExceptionWrongChartParameters: dataPointsList cannot be null or empty NSArray.");
        
        [NSException raise:@"GVNSExceptionWrongChartParameters" format:@"dataPointsList cannot be null or empty NSArray."];
    }
    else
    {
        for(int i = 0; i <[dataPointsList count]; i++)
        {
            if(![[dataPointsList objectAtIndex:i] isKindOfClass:[ChartDataPoint class]])
            {
                NSLog(@"GVNSExceptionWrongChartParameters: All data points should be of class: ChartDataPoint");
                
                [NSException raise:@"GVNSExceptionWrongChartParameters" format:@"All data points should be of class: ChartDataPoint"];
            }
        }
        
        self->dataPoints = dataPointsList;
    }
    
    
    if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelDaily)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeOneDay)
        {
            dataPointBarWidth = xAxisIntervalWidth;
            
        }
        else if(self->xAxisDataPointRange == RVChartDataPointRangeOneHour)
        {
            dataPointBarWidth = xAxisIntervalWidth / 24;
            
        }
        else  if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth / 24/12;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelHourly)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeOneHour)
        {
            dataPointBarWidth = xAxisIntervalWidth;
        }
        else  if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/12;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenMinutes)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/3;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFiveMinutes)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/1;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelWeekly)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeOneDay)
        {
            dataPointBarWidth = xAxisIntervalWidth/7;
        }
        else if(self->xAxisDataPointRange == RVChartDataPointRangeOneHour)
        {
            dataPointBarWidth = xAxisIntervalWidth/7/24;
        }
        else  if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/7/24/12;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelFifteenDays)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeOneDay)
        {
            dataPointBarWidth = xAxisIntervalWidth/15;
        }
        else if(self->xAxisDataPointRange == RVChartDataPointRangeOneHour)
        {
            dataPointBarWidth = xAxisIntervalWidth/15/24;
        }
        else  if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/15/24/12;
        }
    }
    else if(self->xAxisGranularityLevel == RVChartXAxisGranularityLevelMonthly)
    {
        if(self->xAxisDataPointRange == RVChartDataPointRangeOneMonth)
        {
            dataPointBarWidth = xAxisIntervalWidth;
        }
        else if(self->xAxisDataPointRange == RVChartDataPointRangeOneDay)
        {
            dataPointBarWidth = xAxisIntervalWidth/30;
        }
        else if(self->xAxisDataPointRange == RVChartDataPointRangeOneHour)
        {
            dataPointBarWidth = xAxisIntervalWidth/30/24;
        }
        else  if(self->xAxisDataPointRange == RVChartDataPointRangeFiveMinutes)
        {
            dataPointBarWidth = xAxisIntervalWidth/30/24/12;
        }

    }
    
    self->dataPoints = [self getDateSortedArrayOfDataPoints:(NSMutableArray*)self->dataPoints];

/*    ChartDataPoint *tempDataPoint;
    for(int i=0; i<[self->dataPoints count]; i++)
    {
        tempDataPoint = [self->dataPoints objectAtIndex:i];
        
        CGPoint tempLoc = [self getBottomScreenLocationOfXAxisValue:[Utility convertDateToGMT:tempDataPoint.xDateValue]];
        if(!(tempLoc.x == 0 && tempLoc.y == 0))
        {
            [self drawBarBlockForCGPoint:tempLoc andValue:tempDataPoint.yValue withActualPercent:50 acrrualPercent:50];
        }
    }
*/

    [self drawCumulativeLineWithDataPointsArray:self->dataPoints];
    [self drawBudgetLinesWithDataPointsArray:self->dataPoints];
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

- (void) drawCumulativeLineWithDataPointsArray:(NSArray*) dataPointArray
{
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    
    float carryOverCumulativeVal = cumulativeOffsetVal;
    CGPoint initCumulativePoint 	= CGPointMake(xLeftOffsetForLabels, bottomOfFirstXAxisLine.y - (yAxisIntervalWidth * carryOverCumulativeVal/maximumYAxisValue));
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    BOOL didMove = NO;
    ChartDataPoint *tempDataPoint;
    for(int i=0; i<[dataPointArray count]; i++)
    {
        tempDataPoint = [dataPointArray objectAtIndex:i];
        carryOverCumulativeVal = tempDataPoint.cumulativeValue;
        CGPoint tempLoc = [self getBottomScreenLocationOfXAxisValue:[Utility convertDateToGMT:tempDataPoint.xDateValue]];
        
        if(!(tempLoc.x == 0 && tempLoc.y == 0))
        {
            
            float tempHeight = yAxisLength * (carryOverCumulativeVal/maximumYAxisValue);
            CGPoint finalPoint = CGPointMake(tempLoc.x, tempLoc.y - tempHeight);
            
            if(!didMove)
            {
                [path moveToPoint:CGPointMake(finalPoint.x,finalPoint.y)];
                didMove = YES;
            }
            
            [path addLineToPoint:finalPoint];
        }
    }
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.fillColor = nil;
    pathLayer.strokeColor = [[UIColor redColor] CGColor];
    pathLayer.lineWidth = 4.0f;
    pathLayer.lineJoin = kCALineJoinRound;
    self.animationLayer.backgroundColor = [UIColor clearColor].CGColor;
    

    [self.animationLayer addSublayer:pathLayer];
    self.pathLayer = pathLayer;
    
}

-(void) drawBudgetLinesWithDataPointsArray:(NSArray*) dataPointArray
{
    if (self.pathLayer_Budget != nil) {
        [self.pathLayer_Budget removeFromSuperlayer];
        self.pathLayer_Budget = nil;
    }
    
    float carryOverCumulativeVal = cumulativeOffsetVal;
    CGPoint initCumulativePoint 	= CGPointMake(xLeftOffsetForLabels, bottomOfFirstXAxisLine.y - (yAxisIntervalWidth * carryOverCumulativeVal/maximumYAxisValue));
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    BOOL didMove = NO;
    
    ChartDataPoint *tempDataPoint;
    for(int i=0; i<[dataPointArray count]; i++)
    {
        tempDataPoint = [dataPointArray objectAtIndex:i];
        carryOverCumulativeVal = tempDataPoint.afeEstimate;
        CGPoint tempLoc = [self getBottomScreenLocationOfXAxisValue:[Utility convertDateToGMT:tempDataPoint.xDateValue]];
        
        if(!(tempLoc.x == 0 && tempLoc.y == 0))
        {
            
            float tempHeight = yAxisLength * (carryOverCumulativeVal/maximumYAxisValue);
            CGPoint finalPoint = CGPointMake(tempLoc.x, tempLoc.y - tempHeight);
            
            if(!didMove)
            {
                [path moveToPoint:CGPointMake(finalPoint.x,finalPoint.y)];
                didMove = YES;
            }
            
            [path addLineToPoint:finalPoint];
            
        }
    }
    
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.fillColor = nil;
    pathLayer.strokeColor = [[Utility getUIColorWithHexString:@"#4AA02C"] CGColor];
    pathLayer.lineWidth = 2.0f;
    pathLayer.lineJoin = kCALineJoinRound;
    self.animationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    
    [self.animationLayer addSublayer:pathLayer];
    self.pathLayer_Budget = pathLayer;
}


-(CGPoint) getBottomScreenLocationOfXAxisValue:(NSDate*) dateVal
{
    CGPoint result = CGPointMake(0, 0);
    float tempX = 0;
    float tempY = 0;
    
    
    int noOfPartsToPlotDate = 0;
    
    int noOfPartsToEndDate = 0;
    
    if(self->xAxisDataPointRange == RVChartDataPointRangeOneDay)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [formatter setTimeZone:gmt];
        [formatter setDateFormat:@"MM dd yyyy"];
        
        dateVal = [formatter dateFromString:[formatter stringFromDate:dateVal]];
    }
    
    noOfPartsToEndDate =  [self->xAxisEndDateTime timeIntervalSince1970] - [self->xAxisStartDateTime timeIntervalSince1970];
    
    noOfPartsToPlotDate = [dateVal timeIntervalSince1970] - [self->xAxisStartDateTime timeIntervalSince1970];
    
    if(noOfPartsToEndDate <= 0)
    {
        return result;
    }
    else if(noOfPartsToPlotDate < 0)
    {
        return result;
    }
    
    tempX = bottomOfFirstXAxisLine.x + ((float) noOfPartsToPlotDate)*xAxisLength/(float)noOfPartsToEndDate;
    
    tempY = bottomOfFirstXAxisLine.y;
    
    if(tempX > xAxisLength + xLeftOffsetForLabels || tempX < bottomOfFirstXAxisLine.x - xAxisIntervalWidth/2)
    {
        tempX = 0;
        tempY = 0;
    }
    
    result = CGPointMake(tempX, tempY);
    
    return result;
    
}


-(void) drawBarBlockForCGPoint:(CGPoint) centerPoint andValue:(int) valueToPlot withActualPercent:(float) actual acrrualPercent:(float) acrual
{
    if(valueToPlot == 0)
        return;
        
    float tempWidth;
    
    int correction = 0.40*dataPointBarWidth;
    
    tempWidth = dataPointBarWidth - correction;
    
    if(tempWidth < 2)
    {
       // correction = 0;
        tempWidth = 2;
    }
    //float tempHeight = (yAxisLength-yAxisIntervalWidth) * valueToPlot/maximumYAxisValue;
    
    float tempHeightActual = yAxisLength * (actual/100) * valueToPlot/maximumYAxisValue;
    float tempHeightAcrual = yAxisLength * (acrual/100) * valueToPlot/maximumYAxisValue;
    
    UIImage *resizedImageActual = [self resizedImage:[UIImage imageNamed:@"blueBar2.png"] forWidth:tempWidth forHeight:tempHeightActual]; 
    UIImage *resizedImageAcrual = [self resizedImage:[UIImage imageNamed:@"redBar2.png"] forWidth:tempWidth forHeight:tempHeightActual]; 
    
    UIImageView *tempBarActual = [[UIImageView alloc] initWithImage:resizedImageActual];
    tempBarActual.frame = CGRectMake(centerPoint.x + 2 - tempWidth/2, centerPoint.y, tempWidth, -tempHeightActual);
    
    UIImageView *tempBarAcrual = [[UIImageView alloc] initWithImage:resizedImageAcrual];
    tempBarAcrual.frame = CGRectMake(centerPoint.x + 2 - tempWidth/2, tempBarActual.frame.origin.y+1, tempWidth, -tempHeightAcrual);
    
    [self addSubview:tempBarActual];
    [self addSubview:tempBarAcrual];
    
    //Animation code
  /*  CGRect frameActual = tempBarActual.frame;
    CGRect frameAcrual = tempBarAcrual.frame;
    frameActual.size.height = 0;
    frameActual.origin.y += tempHeightActual;
    frameAcrual.size.height = 0;
    frameAcrual.origin.y += tempHeightAcrual;    
    
    tempBarActual.frame = frameActual;
    tempBarAcrual.frame = frameAcrual;
    
    //tempBarActual.alpha = 0;
    //tempBarActual.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        tempBarActual.frame = CGRectMake(frameActual.origin.x, frameActual.origin.y, frameActual.size.width, -tempHeightActual);
        //tempBarActual.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 animations:^{
           
            tempBarAcrual.frame = CGRectMake(frameAcrual.origin.x, frameAcrual.origin.y, frameAcrual.size.width, -tempHeightAcrual);
            
            //tempBarAcrual.alpha = 1;
        }];
        
    }];*/
}


- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    currentGraphicsContext = UIGraphicsGetCurrentContext();
    
	CGContextBeginPath(currentGraphicsContext);
    
    [self drawChartGridLines];
    [self addYAxisScaleMarking]; 
}
 

#pragma mark - Misceleneous methods

-(int) getNumberOfFiveMinutesBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];

    if(ignoreTime)
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    else
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];
    
    int noOfFiveMinues = time / 60 /5; 
    
    return noOfFiveMinues;

}

-(int) getNumberOfHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    if(ignoreTime)
    {
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    }
    else
    {
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    }
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];
    
    int noOfHours = time / 60 /60; 
    
    return noOfHours;
    
}

//A negative return value will indicate that startDate is greater than endDate
//A positive return value will indicate that startDate is lesser than endDate
//A Zero value will indicate both dates are equal.
-(int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    if(ignoreTime)
    {
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    }
    else
    {
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    }

    
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];

    int days = time / 60 / 60/ 24;
    
    return days;
}


- (UIImage*)resizedImage:(UIImage*)image forWidth:(float) newWidth forHeight:(float) newHeight
{
   
        CGRect frame = CGRectMake(0, 0, newWidth, newHeight);
        UIGraphicsBeginImageContext(frame.size);
        [image drawInRect:frame];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resizedImage;
}


-(void) dealloc
{
    _animationLayer = nil;
    _pathLayer = nil;
    self.animationLayer = nil;
    self.pathLayer = nil;
    yAxisGridLineValues = nil;
    xAxisGridLineDatesValues = nil;
    lblYAxisScaleUnit = nil;
    imgvwGreenIndicator = nil;
    labelsTextColor = nil;
    xAxisUILabels  = nil;
    yAxisUILabels = nil;
    gridColorHexCode = nil;

    
}

@end


