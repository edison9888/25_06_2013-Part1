//
//  AFEBurndownChart.h
//  SQLandBIiPad
//
//  Created by Apple on 05/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//The values assigned to RVChartXAxisGranularityLevel And RVChartDataPointRange are co-related.
//Please refer the .m file if you plan to change any of their values.
typedef enum RVChartXAxisGranularityLevel
{
    RVChartXAxisGranularityLevelFiveMinutes = 1,
    RVChartXAxisGranularityLevelFifteenMinutes = 2,
    RVChartXAxisGranularityLevelThirtyMinutes = 3,    
    RVChartXAxisGranularityLevelHourly = 4,
    RVChartXAxisGranularityLevelDaily = 5,
    RVChartXAxisGranularityLevelWeekly = 6,
    RVChartXAxisGranularityLevelFifteenDays = 7,
    RVChartXAxisGranularityLevelMonthly = 8    
    
}RVChartXAxisGranularityLevel;

typedef enum RVChartDataPointRange
{
    RVChartDataPointRangeFiveMinutes = 1,
    RVChartDataPointRangeOneHour = 4,
    RVChartDataPointRangeOneDay = 5,
    RVChartDataPointRangeOneMonth = 6
    
}RVChartDataPointRange;


@interface AFEBurndownChart : UIView
{
    
    CGFloat currentRed;
    CGFloat currentGreen;
    CGFloat currentBlue;
    CGFloat currentAlpha;
    CGPoint currentCursorPoint;
    
    float cumulativeOffsetVal;
    
    float xAxisLength;
    float yAxisLength;
    
    float xLeftOffsetForLabels;
    float xRightOffsetForLabels;    
    float yTopOffsetForLabels;
    float yBottomOffsetForLabels;  
    
    float yAxisIntervalWidth;
    float xAxisIntervalWidth; 
    
    float dataPointBarWidth;
    
    CGPoint bottomOfFirstXAxisLine;
    
    int numberOfXAxisLines;
    int numberOfYAxisLines;
    
    double maximumYAxisValue;
    
    NSArray *yAxisGridLineValues;
    NSArray *xAxisGridLineDatesValues;  
    
    UILabel *lblYAxisScaleUnit;
    UIImageView *imgvwGreenIndicator;
    
    NSTimeInterval timeZoneOffsetInStartAndEndDate;
    
    UIColor *labelsTextColor;
    
    NSMutableArray *xAxisUILabels;
    NSMutableArray *yAxisUILabels;
    
    NSString *gridColorHexCode;
    
    UIColor *gridLineColor;
    
    BOOL displayDecimalPoint;
    
}

@property(nonatomic,strong, readonly) NSArray *dataPoints;
@property(nonatomic,strong, readonly) NSDate *xAxisStartDateTime;
@property(nonatomic,strong, readonly) NSDate *xAxisEndDateTime;
@property(nonatomic,assign, readonly) RVChartXAxisGranularityLevel xAxisGranularityLevel;
@property(nonatomic,assign, readonly) RVChartDataPointRange xAxisDataPointRange;

-(void) setMaximumYAxisValue:(int) value;
-(void) setYAxisScaleUnitText:(NSString*) value;
-(void) setLabelsTextColor:(UIColor*) color;


-(AFEBurndownChart*) initWithFrame:(CGRect) frame gridLineColor:(UIColor*) gridColor andXAxisGranularityLevel:(RVChartXAxisGranularityLevel) xGranLevel andXAxisDataPointRange:(RVChartDataPointRange) xDataPointRange andxAxisStartDateTime:(NSDate*) startDate andxAxisEndDateTime:(NSDate*) endDate andMaximumValueOnYAxis:(int) maxYAxisValue shouldDisplayDecimalPoints:(BOOL) displayDecimal;

-(void) plotChartWithDataPoints:(NSArray*) dataPointsList andCumulativeOffset:(float) cumulativeOffset;

-(CGPoint) getCgPointOfBottomMostYAxisLine;

@end
