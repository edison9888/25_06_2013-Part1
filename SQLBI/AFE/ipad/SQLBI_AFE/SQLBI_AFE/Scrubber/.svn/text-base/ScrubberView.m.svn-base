//
//  ScrubberView.m
//  SQLandBIiPad
//
//  Created by Apple on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrubberView.h"
#import "ScrubberMiddleView.h"
#import "ScrubberRightView.h"
#import "ScrubberLeftView.h"
#import <math.h>


#define LengthOfGraphRangeViewCaps 25

@interface ScrubberView()

-(void) loadDateValuesFromNSUserDefaults;
-(void) saveDateValuesToNsUserDefaults;
-(void) createScrubberView;
-(void) calculateTempNewDatesOfGRAndInformDelgate:(int) scrubberDraggingType;
-(void) setStartDateOfAvailableRangeForStartDateOfGR;
-(void) setEndDateOfAvailableRangeForEndDateOfGR;
-(void) calculateGraphRangeTypeFromCurrentGRDates;
-(void) arrangeViewForLPGrownBeyondMaxLPPercentAllowed;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) NSDate *currentEndDateOfAvailableRange;
@property (nonatomic, strong) NSDate *currentStartDateOfGraphRange;
@property (nonatomic, strong) NSDate *currentEndDateOfGraphRange;
@property (nonatomic, strong) NSDate *currentStartDateOfAvailableRange;

@property (nonatomic, strong) NSString *nsUserDefaultsStartDateKey;
@property (nonatomic, strong) NSString *nsUserDefaultsEndDateKey;

@end


@implementation ScrubberView

@synthesize delegate, currentEndDateOfAvailableRange, currentStartDateOfGraphRange, currentEndDateOfGraphRange, currentStartDateOfAvailableRange, nsUserDefaultsEndDateKey, nsUserDefaultsStartDateKey; //noOfPartsInScrubber, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        effectiveWidthOfScrubberView = self.frame.size.width - LengthOfGraphRangeViewCaps*2;
        
        effectiveScrubberStartPoint = CGPointMake(LengthOfGraphRangeViewCaps*1, 0);
        //effectiveScrubberEndPoint = CGPointMake(effectiveWidthOfScrubberView + LengthOfGraphRangeViewCaps*1, 0);  
        effectiveScrubberEndPoint = CGPointMake(self.frame.size.width - LengthOfGraphRangeViewCaps*1, 0);  
        
        minimumGraphRangeType = ScrubberMinimumGraphRangeTypeOneDay;
        minPercntOnLeftPadding = 25;
        minPercntOnRightPadding = 25;
        maxPercntOnLeftPadding = 300;
        maxPercntOnRightPadding = 300;
        maximumEndDateOfAvailableRange = [NSDate date];
        
        noOfGraphRangeUnits = 2;
        maximumNoOfDaysAllowedInGRraphRange = 0;
        
        self.nsUserDefaultsStartDateKey = NSUserDefaultsKeyCurrentSelectedDashboardStartDate;
        self.nsUserDefaultsEndDateKey = NSUserDefaultsKeyCurrentSelectedDashboardEndDate;        
        
        [self loadDateValuesFromNSUserDefaults];
        
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
        
        [self createScrubberView];
        
    }
    return self;
}


-(void) loadDateValuesFromNSUserDefaults
{
    self.currentEndDateOfGraphRange = [[NSUserDefaults standardUserDefaults] objectForKey:self.nsUserDefaultsEndDateKey];
    
    self.currentStartDateOfGraphRange = [[NSUserDefaults standardUserDefaults] objectForKey:self.nsUserDefaultsStartDateKey];
    
    if(!self.currentEndDateOfGraphRange)
    {
        self.currentEndDateOfGraphRange = maximumEndDateOfAvailableRange;
        
        NSDateComponents *dc = [[NSDateComponents alloc] init];
        
        [dc setDay:-noOfGraphRangeUnits];
        
        self.currentStartDateOfGraphRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentEndDateOfGraphRange options:0];
        
        
    }
    
    if(!self.currentStartDateOfGraphRange)
    {
        NSDateComponents *dc = [[NSDateComponents alloc] init];
        
        [dc setDay:-noOfGraphRangeUnits];
        
        self.currentStartDateOfGraphRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentEndDateOfGraphRange options:0];
    }
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        noOfGraphRangeUnits = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES];
        
        if(maximumNoOfDaysAllowedInGRraphRange > 0)
        {
            if(noOfGraphRangeUnits > maximumNoOfDaysAllowedInGRraphRange)
            {
                noOfGraphRangeUnits = maximumNoOfDaysAllowedInGRraphRange;
                
                self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
                
            }
        }
    }
    else 
    {
        noOfGraphRangeUnits = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreMinutes:YES];
        
        if(minimumNoOfHoursRequiredInGR > 0)
        {
            if(noOfGraphRangeUnits < minimumNoOfHoursRequiredInGR)
            {
                noOfGraphRangeUnits = minimumNoOfHoursRequiredInGR;
                
                self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
                
            }
        }

        
    }
    
}


-(void) saveDateValuesToNsUserDefaults
{
   /* [[NSUserDefaults standardUserDefaults]setObject:self.currentStartDateOfGraphRange forKey:NSUserDefaultsKeyCurrentSelectedDashboardStartDate];
    [[NSUserDefaults standardUserDefaults]setObject:self.currentEndDateOfGraphRange forKey:NSUserDefaultsKeyCurrentSelectedDashboardEndDate];
    */
}


-(NSDate*) getcurrentEndDateOfGraphRange
{
    return self.currentEndDateOfGraphRange;
}


-(NSDate*) getcurrentStartDateOfGraphRange
{
    return self.currentStartDateOfGraphRange;
}


-(NSDate*) getcurrentEndDateOfAvailableRange
{
    return self.currentEndDateOfAvailableRange;
}


-(NSDate*) getcurrentStartDateOfAvailableRange
{
    return self.currentStartDateOfAvailableRange;
}


-(void) setcurrentEndDateOfGraphRange:(NSDate*) endDate
{
    if(!endDate)
    {
        NSLog(@"GVNSExceptionWrongScrubberParameters: The currentEndDateOfGraphRange cannot be an Invalid date");
        
        [NSException raise:@"GVNSExceptionWrongScrubberParameters" format:@"The currentEndDateOfGraphRange cannot be an Invalid date"];
    }
    
    else if([Utility getNumberOfEpochDaysBetweenStartDate:endDate andEndDate:maximumEndDateOfAvailableRange shouldIgnoreTime:YES] < 0)
    {
        NSLog(@"GVNSExceptionEndDateOfGraphRangeGreaterThanMaximumEndDateOfAvailableRange: The currentEndDateOfGraphRange cannot be an greater than Maximum Avaialable Date Range.");
        
        [NSException raise:@"GVNSExceptionEndDateOfGraphRangeGreaterThanMaximumEndDateOfAvailableRange" format:@"The currentEndDateOfGraphRange cannot be an greater than Maximum Avaialable Date Range."];
    }
    
    self.currentEndDateOfGraphRange = endDate;
    
     NSDateComponents *dc = [[NSDateComponents alloc] init];
    
    if(minimumGraphRangeType == ScrubberMinimumGraphRangeTypeOneDay)
    {
        [dc setDay:-noOfGraphRangeUnits];
    }
    else
    {
        [dc setHour:-noOfGraphRangeUnits];
        
    }
    
     self.currentStartDateOfGraphRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentEndDateOfGraphRange options:0];
    
    [self createScrubberView];
}


-(void) setMaximumEndDateOfAvailableRange:(NSDate*) endDate
{
    if(!endDate)
    {
        NSLog(@"GVNSExceptionWrongScrubberParameters: The MaximumEndDateOfAvailableRange cannot be an Invalid date");
        
        [NSException raise:@"GVNSExceptionWrongScrubberParameters" format:@"The MaximumEndDateOfAvailableRange cannot be an Invalid date"];
    }
    
    maximumEndDateOfAvailableRange = endDate;
    
    if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:maximumEndDateOfAvailableRange shouldIgnoreTime:YES] < 0)
    {
        self.currentEndDateOfGraphRange = maximumEndDateOfAvailableRange;
        
        self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
        
    }
    
    [self setEndDateOfAvailableRangeForEndDateOfGR];
    [self setStartDateOfAvailableRangeForStartDateOfGR];
    
    [self createScrubberView];
    
}


-(void) setScrubberMinimumGraphRangeType:(ScrubberMinimumGraphRangeType) rangeType
{
    if(!((rangeType == ScrubberMinimumGraphRangeOneHour) || (rangeType == ScrubberMinimumGraphRangeTypeOneDay)))
    {
        NSLog(@"GVNSExceptionWrongScrubberParameters: The ScrubberMinimumGraphRangeType passed is Invalid.");
        
        [NSException raise:@"GVNSExceptionWrongScrubberParameters" format:@"The ScrubberMinimumGraphRangeType passed is Invalid."];
    }
    else
    {
        minimumGraphRangeType = rangeType;
        
        [self createScrubberView];
    }
}


-(ScrubberMinimumGraphRangeType) getScrubberMinimumGraphRangeType
{
    return minimumGraphRangeType;
}


-(void) setStartDateOfAvailableRangeForStartDateOfGR
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    [self setEndDateOfAvailableRangeForEndDateOfGR];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        noOfGraphRangeUnits = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES];

       if(noOfGraphRangeUnits == 1)
       {
           [dc setDay:-14];
       }
       else 
        [dc setDay:-maxPercntOnLeftPadding*noOfGraphRangeUnits/100]; 
        
        self.currentStartDateOfAvailableRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentStartDateOfGraphRange options:0];
        
    }
    else if(currentGraphRangeType == ScrubberGraphRangeTypeHours)
    {
        noOfGraphRangeUnits = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreMinutes:YES];
        
        [dc setDay:-1];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"];
        
        NSDate *tempDate =  [df dateFromString:[df stringFromDate:[NSDate dateWithTimeInterval:-1 sinceDate:self.currentEndDateOfAvailableRange]]];
        
        self.currentStartDateOfAvailableRange = tempDate; //[[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentEndDateOfAvailableRange options:0];
        

    }
    
   // [self createScrubberView];
}

-(void) setEndDateOfAvailableRangeForEndDateOfGR
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
         noOfGraphRangeUnits = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES];
        
        if(noOfGraphRangeUnits == 1)
        {
            [dc setDay:14];
        }
        else 
            [dc setDay:maxPercntOnRightPadding*noOfGraphRangeUnits/100];
        
        self.currentEndDateOfAvailableRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:self.currentEndDateOfGraphRange options:0];
        
    }
    else if(currentGraphRangeType == ScrubberGraphRangeTypeHours) 
    {
        noOfGraphRangeUnits = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreMinutes:YES];
        
        [dc setDay:1];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"];
        
        NSDate *tempDate =  [df dateFromString:[df stringFromDate:[NSDate dateWithTimeInterval:-1 sinceDate:self.currentEndDateOfGraphRange]]];
        
        self.currentEndDateOfAvailableRange = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:tempDate options:0];
    }
    
    //End date of graph should not be greater than the maximum end date allowed, which is by default the local Today's date. This can be todays date of the entity as well if set from external class.
    if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfAvailableRange andEndDate:maximumEndDateOfAvailableRange shouldIgnoreTime:YES] < 0)
    {
        self.currentEndDateOfAvailableRange = [NSDate dateWithTimeInterval:0 sinceDate: maximumEndDateOfAvailableRange];
    }
    
}

-(void) calculateGraphRangeTypeFromCurrentGRDates
{
    if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES] > 0)
    {
        //if(imMiddleView.frame.size.width < lengthOfEachUnit)
          //      currentGraphRangeType = ScrubberGraphRangeTypeHours;
        //else
            currentGraphRangeType = ScrubberGraphRangeTypeDays;
        
    }
    else if([Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreMinutes:YES] > 0)
    {
        currentGraphRangeType = ScrubberGraphRangeTypeHours;
    }
}


-(void) arrangeViewForLPDropedBelowMinLPPercentAllowed
{
    BOOL isResetRequired = NO;
    
    if(noOfGraphRangeUnits != 1)
    {
        if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] <= minPercntOnLeftPadding*noOfGraphRangeUnits/100)
        {
            isResetRequired = YES;
        }
    }
    else
    {
       if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] <= 3)
        {
            isResetRequired = YES;
        }
    }
    
    if(isResetRequired)
    {
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
        [self createScrubberView];
    }
}

-(void) arrangeViewForLPGrownBeyondMaxLPPercentAllowed
{
    BOOL isResetRequired = NO;
    
    if(noOfGraphRangeUnits != 1)
    {
        if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] >= maxPercntOnLeftPadding*noOfGraphRangeUnits/100)
        {
            isResetRequired = YES;
        }
    }
    else
    {
        if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] >= 14)
        {
            isResetRequired = YES;
        }
    }
    
    if(isResetRequired)
    {
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
        [self createScrubberView];
    }
}


-(void) arrangeViewForRPDropedBelowMinRPPercentAllowed
{
    BOOL isResetRequired = NO;
    
    if(noOfGraphRangeUnits != 1)
    {
        if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES] <= minPercntOnRightPadding*noOfGraphRangeUnits/100)
        {
            isResetRequired = YES;
        }
    }
    else
    {
        if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES] <= 3)
        {
            isResetRequired = YES;
        }
    }
    
    if(isResetRequired)
    {
        [self setEndDateOfAvailableRangeForEndDateOfGR];
        [self setStartDateOfAvailableRangeForStartDateOfGR];        
        [self createScrubberView];
    }
}


-(void) setGraphRangeViewForCurrentValues:(BOOL) isTransFromDaysToHours
{
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:NO];
        
    }
    else 
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreMinutes:YES];
    }
    
    lengthOfEachUnit = effectiveWidthOfScrubberView / totalNoOfUnitsInAvailableRange;
    
    
    //Resizing the Graph Range View to the expceted lengths of the range represented by the Actual lengths
    float currentLengthOfGR = imMiddleView.frame.size.width;
    int factorForTransFromDaysToHours = 1;
        if(isTransFromDaysToHours)
            factorForTransFromDaysToHours = 24;
    noOfGraphRangeUnits = currentLengthOfGR/(lengthOfEachUnit/factorForTransFromDaysToHours);// + ((fmodf(currentLengthOfGR, lengthOfEachUnit)>0.0)? 1:0);
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeHours && (effectiveWidthOfScrubberView - currentLengthOfGR <= 1.5))
       {
           noOfGraphRangeUnits = 24;
       }
        
    
    //Getting the number Of units in the right Padding and Left padding
    float positionOfGREndCap =  imMiddleView.frame.origin.x + imMiddleView.frame.size.width;
    positionOfGREndCap = (positionOfGREndCap - effectiveScrubberStartPoint.x); //Very important
    int unitRepsntdByGraphRangeEndCap = positionOfGREndCap / lengthOfEachUnit;// + ((fmodf(positionOfGREndCap, lengthOfEachUnit)>0.0)? 1:0);
    
    //This is done to avoid a bug. Need to trace out the issue
    if(unitRepsntdByGraphRangeEndCap > totalNoOfUnitsInAvailableRange)
        unitRepsntdByGraphRangeEndCap = totalNoOfUnitsInAvailableRange;
    
    
    noOfRightPaddingUnits = totalNoOfUnitsInAvailableRange - unitRepsntdByGraphRangeEndCap;
    noOfLeftPaddingUnits = totalNoOfUnitsInAvailableRange - (noOfGraphRangeUnits + noOfRightPaddingUnits);
    
    //Setting GR EndDate and StartDate value depending on their positions
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        
        self.currentEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
    
    }
    else
    {
        if(isTransFromDaysToHours == NO)
        {
            self.currentEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
        }
    }
    
    
    if(maximumNoOfDaysAllowedInGRraphRange > 0)
    {
        if(currentGraphRangeType == ScrubberGraphRangeTypeDays && noOfGraphRangeUnits > maximumNoOfDaysAllowedInGRraphRange)
        {
            noOfGraphRangeUnits = maximumNoOfDaysAllowedInGRraphRange;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
            
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        }
        else if(currentGraphRangeType == ScrubberGraphRangeTypeHours && noOfGraphRangeUnits < minimumNoOfHoursRequiredInGR)
        {
            
            noOfGraphRangeUnits = minimumNoOfHoursRequiredInGR;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
            
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        } 
        
    }

    
    //This is for checking the Right padding length and adjust for Maximum and minimum permitted padding lenghts
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        if(noOfGraphRangeUnits != 1)
        {
            if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES] <= minPercntOnRightPadding*noOfGraphRangeUnits/100)
            {
                [self arrangeViewForRPDropedBelowMinRPPercentAllowed];
            } 
            
            if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] <= minPercntOnLeftPadding*noOfGraphRangeUnits/100)
            {
                [self arrangeViewForLPDropedBelowMinLPPercentAllowed];
            }
            else if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] >= maxPercntOnLeftPadding*noOfGraphRangeUnits/100)
            {
                [self arrangeViewForLPGrownBeyondMaxLPPercentAllowed];
            }
            
        }
        else
        {
            if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES] <= 3)
            {
                [self arrangeViewForRPDropedBelowMinRPPercentAllowed];
            } 
            else if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES] > 24)
            {
                
                [self setStartDateOfAvailableRangeForStartDateOfGR];
                [self setEndDateOfAvailableRangeForEndDateOfGR];  
                [self createScrubberView];
                
            }  
            
            if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] <= 3)
            {
                [self arrangeViewForLPDropedBelowMinLPPercentAllowed];
            }
            else if([Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] > 24)
            {
                
                [self setStartDateOfAvailableRangeForStartDateOfGR];
                [self setEndDateOfAvailableRangeForEndDateOfGR];  
                [self createScrubberView];
                
            }
            
            
        }

    }
    else
    {
        //if(noOfGraphRangeUnits == 24)
       // {
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            [self setEndDateOfAvailableRangeForEndDateOfGR];  
            [self createScrubberView];
            
       // }
    }
    
    //This is for checking the left padding length and adjust for Maximum and minimum permitted padding lenghts
    
    
    /*
   
    */
    
}


-(void) GraphRangeStartDateDragEnded
{
    float currentLengthOfGR = imMiddleView.frame.size.width;
    BOOL isTransFromDayToHours = NO;
    
    noOfGraphRangeUnits = currentLengthOfGR/lengthOfEachUnit;// + ((fmodf(currentLengthOfGR, lengthOfEachUnit)>0.0)? 1:0);
    
    //Getting the number Of units in the right Padding and Left padding
    float positionOfGREndCap;// =  imMiddleView.frame.origin.x + imMiddleView.frame.size.width;
    positionOfGREndCap = imRightView.frame.origin.x;
    positionOfGREndCap = (positionOfGREndCap - effectiveScrubberStartPoint.x); //Very important
    int unitRepsntdByGraphRangeEndCap = positionOfGREndCap / lengthOfEachUnit;// + ((fmodf(positionOfGREndCap, lengthOfEachUnit)>0.0)? 1:0);
    
    noOfRightPaddingUnits = totalNoOfUnitsInAvailableRange - unitRepsntdByGraphRangeEndCap;
    noOfLeftPaddingUnits = totalNoOfUnitsInAvailableRange - (noOfGraphRangeUnits + noOfRightPaddingUnits);
    
    //Calculating new GR EndDate and StartDate value depending on their positions
    NSDate *newEndDateOfGraphRange;
    NSDate *newStartDateOfGraphRange;
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
        
        if ([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange shouldIgnoreTime:YES] <= 0) {
            int multFactor = 24;
            float oneHourLength = lengthOfEachUnit / 24;
            multFactor = imMiddleView.frame.size.width/oneHourLength;
            
            newEndDateOfGraphRange = self.currentEndDateOfGraphRange;
            newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*multFactor sinceDate:newEndDateOfGraphRange];
            
            isTransFromDayToHours = YES;
            
        }
    }
    else 
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
    }
    
    if(maximumNoOfDaysAllowedInGRraphRange > 0)
    {
        if(currentGraphRangeType == ScrubberGraphRangeTypeDays && noOfGraphRangeUnits > maximumNoOfDaysAllowedInGRraphRange)
        {
            noOfGraphRangeUnits = maximumNoOfDaysAllowedInGRraphRange;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
            
            newStartDateOfGraphRange = self.currentStartDateOfGraphRange;
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        }
        else if(currentGraphRangeType == ScrubberGraphRangeTypeHours && noOfGraphRangeUnits < minimumNoOfHoursRequiredInGR)
        {
            
            noOfGraphRangeUnits = minimumNoOfHoursRequiredInGR;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
            
            newStartDateOfGraphRange = self.currentStartDateOfGraphRange;
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        } 
        
    }    
 
    //Firing delegate back to the controller class that is using Scrubber so that
    //it can perform necessary actions for the change in Graph range
  //  if([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:currentStartDateOfGraphRange shouldIgnoreTime:YES] != 0)
   // {
        self.currentEndDateOfGraphRange = newEndDateOfGraphRange;
        self.currentStartDateOfGraphRange = newStartDateOfGraphRange;
    
    if(isTransFromDayToHours)
    {
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
    }

        if([self.delegate respondsToSelector:@selector(didChangeScrubberGraphRangeStartDate:andEndDate:)])
        {
            [self.delegate didChangeScrubberGraphRangeStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange];
        }
   // }
    
    [self setGraphRangeViewForCurrentValues:isTransFromDayToHours];
       
}

-(void) GraphRangeEndDateDragEnded
{
    float currentLengthOfGR = imMiddleView.frame.size.width;
    BOOL isTransFromDayToHours = NO;
    
    noOfGraphRangeUnits = currentLengthOfGR/lengthOfEachUnit;// + ((fmodf(currentLengthOfGR, lengthOfEachUnit)>0.0)? 1:0);
    
    //Getting the number Of units in the right Padding and Left padding
    float positionOfGREndCap =  imMiddleView.frame.origin.x + imMiddleView.frame.size.width;
    positionOfGREndCap = (positionOfGREndCap - effectiveScrubberStartPoint.x); //Very important
    int unitRepsntdByGraphRangeEndCap = positionOfGREndCap / lengthOfEachUnit;// + ((fmodf(positionOfGREndCap, lengthOfEachUnit)>0.0)? 1:0);
    
    noOfRightPaddingUnits = totalNoOfUnitsInAvailableRange - unitRepsntdByGraphRangeEndCap;
    noOfLeftPaddingUnits = totalNoOfUnitsInAvailableRange - (noOfGraphRangeUnits + noOfRightPaddingUnits);
    
    //Calculating new GR EndDate and StartDate value depending on their positions
    
    NSDate *newEndDateOfGraphRange;
    NSDate *newStartDateOfGraphRange;
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
        
        if ([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange shouldIgnoreTime:YES] <= 0) {
            
            int multFactor = 24;
            float oneHourLength = lengthOfEachUnit / 24;
            multFactor = imMiddleView.frame.size.width/oneHourLength;
            
            newStartDateOfGraphRange = self.currentStartDateOfGraphRange;
            newEndDateOfGraphRange = [NSDate dateWithTimeInterval:3600*multFactor sinceDate:newStartDateOfGraphRange];
            
            isTransFromDayToHours = YES;

        }
    }
    else 
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
    }
       
    if(maximumNoOfDaysAllowedInGRraphRange > 0)
    {
        if(currentGraphRangeType == ScrubberGraphRangeTypeDays && noOfGraphRangeUnits > maximumNoOfDaysAllowedInGRraphRange)
        {
            noOfGraphRangeUnits = maximumNoOfDaysAllowedInGRraphRange;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];

            newStartDateOfGraphRange = self.currentStartDateOfGraphRange;            
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        }
        else if(currentGraphRangeType == ScrubberGraphRangeTypeHours && noOfGraphRangeUnits < minimumNoOfHoursRequiredInGR)
        {
            
            noOfGraphRangeUnits = minimumNoOfHoursRequiredInGR;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];

            newStartDateOfGraphRange = self.currentStartDateOfGraphRange;
            [self setStartDateOfAvailableRangeForStartDateOfGR];
            
            [self createScrubberView];
            
        } 
        
    }

    //Firing delegate back to the controller class that is using Scrubber so that
    //it can perform necessary actions for the change in Graph range
  //  if([Utility getNumberOfEpochDaysBetweenStartDate:newEndDateOfGraphRange andEndDate:currentEndDateOfGraphRange shouldIgnoreTime:YES] != 0)
  //  {
        self.currentEndDateOfGraphRange = newEndDateOfGraphRange;
        self.currentStartDateOfGraphRange = newStartDateOfGraphRange;
    
    if(isTransFromDayToHours)
    {
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
    }
        
        if([self.delegate respondsToSelector:@selector(didChangeScrubberGraphRangeStartDate:andEndDate:)])
        {
            [self.delegate didChangeScrubberGraphRangeStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange];
        }
  //  }
    
    [self setGraphRangeViewForCurrentValues:isTransFromDayToHours];    
    
}

-(void) GraphRangeCompleteDragEnded
{
    float currentLengthOfGR = imMiddleView.frame.size.width;
    BOOL isTransFromDayToHours = NO;
    
    noOfGraphRangeUnits = currentLengthOfGR/lengthOfEachUnit;// + ((fmodf(currentLengthOfGR, lengthOfEachUnit)>0.0)? 1:0);
    
    //Getting the number Of units in the right Padding and Left padding
    float positionOfGREndCap =  imMiddleView.frame.origin.x + imMiddleView.frame.size.width;
    positionOfGREndCap = (positionOfGREndCap - effectiveScrubberStartPoint.x); //Very important
    int unitRepsntdByGraphRangeEndCap = positionOfGREndCap / lengthOfEachUnit;// + ((fmodf(positionOfGREndCap, lengthOfEachUnit)>0.0)? 1:0);
    
    noOfRightPaddingUnits = totalNoOfUnitsInAvailableRange - unitRepsntdByGraphRangeEndCap;
    noOfLeftPaddingUnits = totalNoOfUnitsInAvailableRange - (noOfGraphRangeUnits + noOfRightPaddingUnits);
    
    //Calculating new GR EndDate and StartDate value depending on their positions
    
    NSDate *newEndDateOfGraphRange;
    NSDate *newStartDateOfGraphRange;
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
        
        if ([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange shouldIgnoreTime:YES] <= 0) {
            
            newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24 sinceDate:newEndDateOfGraphRange];
            
            isTransFromDayToHours = YES;

        }
    }
    else 
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
    }

    self.currentEndDateOfGraphRange = newEndDateOfGraphRange;
    self.currentStartDateOfGraphRange = newStartDateOfGraphRange;
    
    if(isTransFromDayToHours)
    {
        [self setStartDateOfAvailableRangeForStartDateOfGR];
        [self setEndDateOfAvailableRangeForEndDateOfGR];
    }
    
   // NSDate *tempCurrentStartDateOfGR = self.currentStartDateOfGraphRange;
    //NSDate *tempCurrentEndDateOfGR = self.currentEndDateOfGraphRange;
    
  /*  BOOL didChangeDates = NO;
    
    //Firing delegate back to the controller class that is using Scrubber so that
    //it can perform necessary actions for the change in Graph range
    if([Utility getNumberOfEpochDaysBetweenStartDate:newEndDateOfGraphRange andEndDate:currentEndDateOfGraphRange shouldIgnoreTime:YES] != 0)
    {
        self.currentEndDateOfGraphRange = newEndDateOfGraphRange;
        self.currentStartDateOfGraphRange = newStartDateOfGraphRange;
        
        //didChangeDates = YES;
    }
    else if([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:currentStartDateOfGraphRange shouldIgnoreTime:YES] != 0)
    {
        self.currentEndDateOfGraphRange = newEndDateOfGraphRange;
        self.currentStartDateOfGraphRange = newStartDateOfGraphRange;
        
        //didChangeDates = YES;
    }

    didChangeDates = YES;
   */
    
   // if(didChangeDates)
    
    if([self.delegate respondsToSelector:@selector(didChangeScrubberGraphRangeStartDate:andEndDate:)])
    {
        [self.delegate didChangeScrubberGraphRangeStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange];
    }

    [self setGraphRangeViewForCurrentValues:isTransFromDayToHours];    
    
}


-(void) createScrubberView
{
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    UIView *tempViewObj;
    while ([self subviews].count > 0) {
        
        tempViewObj = [[self subviews] objectAtIndex:[self subviews].count - 1];
        
        [tempViewObj removeFromSuperview];
        tempViewObj = nil;
        
    }
    
    UIImage *imgBackgroundCenter=[UIImage imageNamed:@"scrubberBg.png"];
    UIImage *imgBackgroundLeftCap=[UIImage imageNamed:@"scrubberBg.png"];
    UIImage *imgBackgroundRightCap=[UIImage imageNamed:@"scrubberBg.png"];
    
    UIImageView *backgrndLeftCap = [[UIImageView alloc] initWithImage:imgBackgroundLeftCap];
    backgrndLeftCap.frame = CGRectMake(0, 0, 6, 12);
    UIImageView *backgrndCenter = [[UIImageView alloc] initWithImage:imgBackgroundCenter];
    backgrndCenter.frame = CGRectMake(backgrndLeftCap.frame.size.width, 0,self.frame.size.width - 6*2, 12);
    UIImageView *backgrndRightCap = [[UIImageView alloc] initWithImage:imgBackgroundRightCap];
    backgrndRightCap.frame = CGRectMake(backgrndCenter.frame.origin.x + backgrndCenter.frame.size.width, 0,6, 12);
    
    UITapGestureRecognizer *singleFingerTap1 = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *singleFingerTap2 = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *singleFingerTap3 = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(handleSingleTap:)];

    [backgrndLeftCap addGestureRecognizer:singleFingerTap1];
    [backgrndCenter addGestureRecognizer:singleFingerTap2];
    [backgrndRightCap addGestureRecognizer:singleFingerTap3];    

    [backgrndLeftCap setUserInteractionEnabled:YES];
    [backgrndCenter setUserInteractionEnabled:YES];
    [backgrndRightCap setUserInteractionEnabled:YES];    
    
    [self addSubview:backgrndCenter];
    [self addSubview:backgrndLeftCap];
    [self addSubview:backgrndRightCap];
    
    
    UIImage *imgLeft=[UIImage imageNamed:@"scrubberRound.png"];
    UIImage *imgRight=[UIImage imageNamed:@"scrubberRound.png"];    
    UIImage *imgMiddle=[UIImage imageNamed:@"scrubberBar.png"];
    imMiddleView=[[ScrubberMiddleView alloc] initWithImage:[imgMiddle resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
    imLeftView=[[ScrubberLeftView alloc] initWithImage:imgLeft];
    imRightView=[[ScrubberRightView alloc] initWithImage:imgRight];
    
    //imMiddleView.image = 
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:NO];

    }
    else 
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreMinutes:YES];
    }
        
    if(totalNoOfUnitsInAvailableRange <= 0 )
        return;
    
    lengthOfEachUnit = effectiveWidthOfScrubberView / totalNoOfUnitsInAvailableRange;
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        noOfRightPaddingUnits = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:YES];
        
        noOfGraphRangeUnits = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES];
    }
    else 
    {
        noOfRightPaddingUnits = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentEndDateOfGraphRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreMinutes:YES];
        
        noOfGraphRangeUnits = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreMinutes:YES];
    }
    
    
    //Resizing the Graph Range View to the expceted lengths of the range represented by the Actual lengths
    
    if(maximumNoOfDaysAllowedInGRraphRange > 0)
    {
        if(currentGraphRangeType == ScrubberGraphRangeTypeDays && noOfGraphRangeUnits > maximumNoOfDaysAllowedInGRraphRange)
        {
            noOfGraphRangeUnits = maximumNoOfDaysAllowedInGRraphRange;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];

        }
        else if(currentGraphRangeType == ScrubberGraphRangeTypeHours && noOfGraphRangeUnits < minimumNoOfHoursRequiredInGR)
        {
           
            noOfGraphRangeUnits = minimumNoOfHoursRequiredInGR;
            
            self.currentStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:self.currentEndDateOfGraphRange];
          
        } 
        
    }
    
    float expectedLengthForGR = lengthOfEachUnit * noOfGraphRangeUnits;
    
    currentFrameMiddleView = CGRectMake(effectiveScrubberEndPoint.x -  (lengthOfEachUnit*noOfRightPaddingUnits + expectedLengthForGR), 0, expectedLengthForGR, 12);
    imMiddleView.frame = currentFrameMiddleView;
    
    currentFrameRightView = CGRectMake(imMiddleView.frame.origin.x+imMiddleView.frame.size.width, -6, LengthOfGraphRangeViewCaps, LengthOfGraphRangeViewCaps);
    imRightView.frame = currentFrameRightView;
    
    currentFrameLeftView = CGRectMake(imMiddleView.frame.origin.x - LengthOfGraphRangeViewCaps, -6, LengthOfGraphRangeViewCaps, LengthOfGraphRangeViewCaps);
    imLeftView.frame = currentFrameLeftView;
    
    
    imMiddleView.backgroundColor=[UIColor colorWithRed:0.016 green:0.476 blue:0.004 alpha:1.0];//[UIColor greenColor];
    imLeftView.backgroundColor=[UIColor clearColor];
    imRightView.backgroundColor=[UIColor clearColor];
    
    imLeftView.delegate = self;
    imRightView.delegate = self;
    imMiddleView.delegate = self;
    
    [self addSubview:imMiddleView];
    [self addSubview:imLeftView];
    [self addSubview:imRightView];
    
}



- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   
     CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
     float currentLengthOfGR = imMiddleView.frame.size.width;
     
     noOfGraphRangeUnits = currentLengthOfGR/lengthOfEachUnit;
    
    int noOfUnitsPossibleToJump = 0;
    
        if(location.x < imLeftView.frame.origin.x)
        {
            
            if(imMiddleView.frame.origin.x - lengthOfEachUnit >= effectiveScrubberStartPoint.x)
            {
                int noOfUnitsRemainingTillMaxPoint = (imMiddleView.frame.origin.x - effectiveScrubberStartPoint.x)/lengthOfEachUnit;
                
                if(noOfUnitsRemainingTillMaxPoint >= noOfGraphRangeUnits)
                {
                    noOfUnitsPossibleToJump = noOfGraphRangeUnits;
                }
                else
                {
                    noOfUnitsPossibleToJump = noOfUnitsRemainingTillMaxPoint;
                }
                
                imLeftView.frame = CGRectMake(imLeftView.frame.origin.x - lengthOfEachUnit*noOfUnitsPossibleToJump, imLeftView.frame.origin.y, imLeftView.frame.size.width, imLeftView.frame.size.height);
                imMiddleView.frame = CGRectMake(imMiddleView.frame.origin.x - lengthOfEachUnit*noOfUnitsPossibleToJump, imMiddleView.frame.origin.y, imMiddleView.frame.size.width, imMiddleView.frame.size.height);
                imRightView.frame = CGRectMake(imRightView.frame.origin.x - lengthOfEachUnit*noOfUnitsPossibleToJump, imLeftView.frame.origin.y, imRightView.frame.size.width, imRightView.frame.size.height);
                
                [self GraphRangeCompleteDragEnded];
            }
        }
        else if(location.x > imRightView.frame.origin.x + imRightView.frame.size.width)
        {
            if(imMiddleView.frame.origin.x + imMiddleView.frame.size.width + lengthOfEachUnit <= effectiveScrubberEndPoint.x)
            {
                int noOfUnitsRemainingTillMaxPoint = (effectiveScrubberEndPoint.x - (imMiddleView.frame.origin.x + imMiddleView.frame.size.width))/lengthOfEachUnit;
                
                if(noOfUnitsRemainingTillMaxPoint >= noOfGraphRangeUnits)
                {
                    noOfUnitsPossibleToJump = noOfGraphRangeUnits;
                }
                else
                {
                    noOfUnitsPossibleToJump = noOfUnitsRemainingTillMaxPoint;
                }
                
                imLeftView.frame = CGRectMake(imLeftView.frame.origin.x + lengthOfEachUnit*noOfUnitsPossibleToJump, imLeftView.frame.origin.y, imLeftView.frame.size.width, imLeftView.frame.size.height);
                imMiddleView.frame = CGRectMake(imMiddleView.frame.origin.x + lengthOfEachUnit*noOfUnitsPossibleToJump, imMiddleView.frame.origin.y, imMiddleView.frame.size.width, imMiddleView.frame.size.height);
                imRightView.frame = CGRectMake(imRightView.frame.origin.x + lengthOfEachUnit*noOfUnitsPossibleToJump, imRightView.frame.origin.y, imRightView.frame.size.width, imRightView.frame.size.height);
                
                [self GraphRangeCompleteDragEnded];
                
            }

        }

}


-(void)draggingEndDateOfGraphRange:(CGPoint )p :(CGPoint)previousPoint
{
    CGRect frameRightView=imRightView.frame;
   // CGRect frameLeftView=imLeftView.frame;
    CGRect frameMiddleView = imMiddleView.frame;
    int factorForDaysToHoursTransition = 1;
    
    if((p.x - previousPoint.x) > 0.0)
        if(imMiddleView.frame.origin.x + imMiddleView.frame.size.width + (p.x - previousPoint.x) > effectiveScrubberEndPoint.x)
        {
           /* frameMiddleView.size.width= effectiveScrubberEndPoint.x - frameMiddleView.origin.x;
            frameRightView.origin.x= effectiveScrubberEndPoint.x;
            imMiddleView.frame=frameMiddleView;
            imRightView.frame=frameRightView;

            return;*/
            
            imMiddleView.frame = CGRectMake(effectiveScrubberEndPoint.x - imMiddleView.frame.size.width, imMiddleView.frame.origin.y, imMiddleView.frame.size.width, imMiddleView.frame.size.height);
            imRightView.frame = CGRectMake(effectiveScrubberEndPoint.x, imRightView.frame.origin.y, imRightView.frame.size.width, imRightView.frame.size.height);
            
            imLeftView.frame = CGRectMake(imMiddleView.frame.origin.x - imLeftView.frame.size.width , imLeftView.frame.origin.y, imLeftView.frame.size.width, imLeftView.frame.size.height);
            
            [self calculateTempNewDatesOfGRAndInformDelgate:3];
            
            return;

        }
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:NO];

        if(minimumNoOfHoursRequiredInGR < 24)
            factorForDaysToHoursTransition = 24;
        
    }
    else 
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreMinutes:YES];
        
        factorForDaysToHoursTransition = 1;
    }

    
    lengthOfEachUnit = effectiveWidthOfScrubberView / totalNoOfUnitsInAvailableRange;
    
    if (frameMiddleView.size.width + (p.x - previousPoint.x) >= lengthOfEachUnit/factorForDaysToHoursTransition) {
        
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(p.x-previousPoint.x, 0);
        [imRightView setTransform: CGAffineTransformConcat([imRightView transform], translate)];
        frameMiddleView.size.width+=(p.x-previousPoint.x);
        imMiddleView.frame=frameMiddleView;
    }
    else
    {
        
        if (p.x<previousPoint.x) {
            frameMiddleView.size.width=lengthOfEachUnit/factorForDaysToHoursTransition;
            frameRightView.origin.x=frameMiddleView.origin.x+ lengthOfEachUnit/factorForDaysToHoursTransition;
            imMiddleView.frame=frameMiddleView;
            imRightView.frame=frameRightView;
        }
        
    }
    
    [self calculateTempNewDatesOfGRAndInformDelgate:3];
    
}

-(void)draggingCompleteGraphRange:(CGPoint )p :(CGPoint)previousPoint
{
    
    if((p.x - previousPoint.x) > 0.0)
    {
       // if(imRightView.frame.origin.x + imRightView.frame.size.width + (p.x - previousPoint.x) > self.frame.origin.x + self.frame.size.width)
            //return;
        
        if(imMiddleView.frame.origin.x + imMiddleView.frame.size.width + (p.x - previousPoint.x) > effectiveScrubberEndPoint.x)
        {
            imMiddleView.frame = CGRectMake(effectiveScrubberEndPoint.x - imMiddleView.frame.size.width, imMiddleView.frame.origin.y, imMiddleView.frame.size.width, imMiddleView.frame.size.height);
            imRightView.frame = CGRectMake(effectiveScrubberEndPoint.x, imRightView.frame.origin.y, imRightView.frame.size.width, imRightView.frame.size.height);
            
            imLeftView.frame = CGRectMake(imMiddleView.frame.origin.x - imLeftView.frame.size.width , imLeftView.frame.origin.y, imLeftView.frame.size.width, imLeftView.frame.size.height);
            
            [self calculateTempNewDatesOfGRAndInformDelgate:2];

            return;
        }
    }
    else if((p.x - previousPoint.x) < 0.0)
    {
            //if(imLeftView.frame.origin.x - (p.x - previousPoint.x) < self.frame.origin.x)
             //   return;
        
        if(imMiddleView.frame.origin.x + (p.x - previousPoint.x)  < effectiveScrubberStartPoint.x)
            return;
    }
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(p.x-previousPoint.x, 0);
    [imMiddleView setTransform: CGAffineTransformConcat([imMiddleView transform], translate)];
    
    CGRect tempFrame = imRightView.frame;
    tempFrame.origin.x+=(p.x-previousPoint.x);
    imRightView .frame=tempFrame;
    
    tempFrame=imLeftView.frame;
    tempFrame.origin.x+=(p.x-previousPoint.x);
    imLeftView.frame=tempFrame;
    
    [self calculateTempNewDatesOfGRAndInformDelgate:2];
    
}

-(void)draggingStartDateOfGraphRange:(CGPoint )p :(CGPoint)previousPoint
{
    CGRect frameMiddleView=imMiddleView.frame;
    CGRect frameRightView=imRightView.frame;
    CGRect frameLeftView = imLeftView.frame;
    int factorForDaysToHoursTransition = 1;
    
    if((p.x - previousPoint.x) < 0.0)
        if(imMiddleView.frame.origin.x + (p.x - previousPoint.x)  < effectiveScrubberStartPoint.x)
            return;
    
    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochDaysBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreTime:NO];
        
        if(minimumNoOfHoursRequiredInGR < 24)
            factorForDaysToHoursTransition = 24;
        
    }
    else 
    {
        totalNoOfUnitsInAvailableRange = [Utility getNumberOfEpochHoursBetweenStartDate:self.currentStartDateOfAvailableRange andEndDate:self.currentEndDateOfAvailableRange shouldIgnoreMinutes:YES];
        
        factorForDaysToHoursTransition = 1;
    }
    
    lengthOfEachUnit = effectiveWidthOfScrubberView / totalNoOfUnitsInAvailableRange;
    
    
    if (frameMiddleView.size.width - (p.x - previousPoint.x) >= lengthOfEachUnit/factorForDaysToHoursTransition) {
        
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(p.x-previousPoint.x, 0);
        [imLeftView setTransform: CGAffineTransformConcat([imLeftView transform], translate)];
        //CGRect frame1 = imLeftView.frame;
        CGRect frame2=imMiddleView.frame;
        if((p.x-previousPoint.x)<0.0)
        {
            //if (frame1.origin.x+10<frame2.origin.x) {
                frame2.origin.x-=-(p.x-previousPoint.x);
                frame2.size.width+=-(p.x-previousPoint.x);
           // }
        }
        else //if(frame1.origin.x+10>frame2.origin.x)
        {
            frame2.origin.x+=(p.x-previousPoint.x);
            frame2.size.width-=(p.x-previousPoint.x);
        }
        
        imMiddleView.frame=frame2;
    }
    else
    {
        if (p.x > previousPoint.x) {
            frameMiddleView.size.width=lengthOfEachUnit/factorForDaysToHoursTransition;
            frameMiddleView.origin.x=frameRightView.origin.x - lengthOfEachUnit/factorForDaysToHoursTransition;
            imMiddleView.frame=frameMiddleView;
            frameLeftView.origin.x=frameMiddleView.origin.x - LengthOfGraphRangeViewCaps*1;
            imLeftView.frame=frameLeftView;

        }
    }
    
    [self calculateTempNewDatesOfGRAndInformDelgate:1];
    
}



-(void) calculateTempNewDatesOfGRAndInformDelgate:(int) scrubberDraggingType
{
    float currentLengthOfGR = imMiddleView.frame.size.width;
    
    //float oo = fmodf(currentLengthOfGR, lengthOfEachUnit);
    
    noOfGraphRangeUnits = currentLengthOfGR/lengthOfEachUnit;// + ((fmodf(currentLengthOfGR, lengthOfEachUnit)>0.0)? 1:0);
    
    //Getting the number Of units in the right Padding and Left padding
    float positionOfGREndCap =  imMiddleView.frame.origin.x + imMiddleView.frame.size.width;
    positionOfGREndCap = (positionOfGREndCap - effectiveScrubberStartPoint.x); //Very important
    int unitRepsntdByGraphRangeEndCap = positionOfGREndCap / lengthOfEachUnit;// + ((fmodf(positionOfGREndCap, lengthOfEachUnit)>0.0)? 1:0);
    
    noOfRightPaddingUnits = totalNoOfUnitsInAvailableRange - unitRepsntdByGraphRangeEndCap;
    noOfLeftPaddingUnits = totalNoOfUnitsInAvailableRange - (noOfGraphRangeUnits + noOfRightPaddingUnits);
    
    
    //Calculating new GR EndDate and StartDate value depending on their positions
    NSDate *newEndDateOfGraphRange;
    NSDate *newStartDateOfGraphRange;

    [self calculateGraphRangeTypeFromCurrentGRDates];
    
    if(currentGraphRangeType == ScrubberGraphRangeTypeDays)
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*24*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
        
        if ([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange shouldIgnoreTime:YES] <= 0) {
            
            int multFactor = 24;
            float oneHourLength = lengthOfEachUnit / 24;
            multFactor = imMiddleView.frame.size.width/oneHourLength;
            
            if(scrubberDraggingType == 1)
            {
                newEndDateOfGraphRange = self.currentEndDateOfGraphRange;
                newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*multFactor sinceDate:newEndDateOfGraphRange];
            }
            else if(scrubberDraggingType == 3)
            {
                newStartDateOfGraphRange = self.currentStartDateOfGraphRange;
                newEndDateOfGraphRange = [NSDate dateWithTimeInterval:3600*multFactor sinceDate:newStartDateOfGraphRange];
            }
            
        }
        
    }
    else 
    {
        newEndDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfRightPaddingUnits sinceDate:self.currentEndDateOfAvailableRange];
        
        newStartDateOfGraphRange = [NSDate dateWithTimeInterval:-3600*noOfGraphRangeUnits sinceDate:newEndDateOfGraphRange];
    }

   // BOOL didChangeDates = NO;
    
    NSLog(@"========================");
    NSLog(@"Old Date: %@", self.currentEndDateOfGraphRange);
    NSLog(@"New Date: %@", newEndDateOfGraphRange);
    NSLog(@"========================");
    
    //Firing delegate back to the controller class that is using Scrubber so that
    //it can perform necessary actions for the change in Graph range
  /*  if([Utility getNumberOfEpochDaysBetweenStartDate:newEndDateOfGraphRange andEndDate:self.currentEndDateOfGraphRange shouldIgnoreTime:YES] != 0)
    {
        //didChangeDates = YES;
    }
    else if([Utility getNumberOfEpochDaysBetweenStartDate:newStartDateOfGraphRange andEndDate:self.currentStartDateOfGraphRange shouldIgnoreTime:YES] != 0)
    {
        //didChangeDates = YES;
    }
   */
    
    //didChangeDates = YES;
    
    //if(didChangeDates)
    
    if([self.delegate respondsToSelector:@selector(scrubberGraphRangeMovingTowardsStartDate:andEndDate:)])
    {
        [self.delegate scrubberGraphRangeMovingTowardsStartDate:newStartDateOfGraphRange andEndDate:newEndDateOfGraphRange];
    }
    
}


-(void) reloadScrubberFromStartDateKey:(NSString*) userDefaultsStartDateKey andEndDateKey:(NSString*) userDefaultsEndDateKey forMaximumEndDateOfAvailableRange:(NSDate*) endDate andMaximumDaysAllowedInGraphDateRange:(int) noOfDaysAllowedInGR
{
    
    self.nsUserDefaultsStartDateKey = userDefaultsStartDateKey;
    self.nsUserDefaultsEndDateKey = userDefaultsEndDateKey;
    [self loadDateValuesFromNSUserDefaults];
    
    if(noOfDaysAllowedInGR <= 0)
        noOfDaysAllowedInGR = 0;
    
    maximumNoOfDaysAllowedInGRraphRange = noOfDaysAllowedInGR;
    
    if(minimumNoOfHoursRequiredInGR <= 0)
        minimumNoOfHoursRequiredInGR = 0;
    
    if(maximumNoOfDaysAllowedInGRraphRange < 0 )
        maximumNoOfDaysAllowedInGRraphRange = 0;
    
    
    [self setMaximumEndDateOfAvailableRange:endDate];
    
}



-(void) setScrubberMinimumHoursRequiredInGraphDateRange:(int) noOfHoursMinRequired
{
    minimumNoOfHoursRequiredInGR = noOfHoursMinRequired;
}


@end
