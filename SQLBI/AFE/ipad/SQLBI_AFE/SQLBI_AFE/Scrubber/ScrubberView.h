//
//  ScrubberView.h
//  SQLandBIiPad
//
//  Created by Apple on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrubberMiddleView;
@class ScrubberLeftView;
@class ScrubberRightView;

typedef enum ScrubberMinimumGraphRangeType
{
    ScrubberMinimumGraphRangeTypeOneDay = 1,
    ScrubberMinimumGraphRangeOneHour
    
}ScrubberMinimumGraphRangeType;


typedef enum ScrubberGraphRangeType
{
    ScrubberGraphRangeTypeDays = 1,
    ScrubberGraphRangeTypeHours
    
}ScrubberGraphRangeType;


@protocol ScrubberViewComponentsDelegate <NSObject>

-(void) draggingEndDateOfGraphRange:(CGPoint) p :(CGPoint)previousPoint;
-(void) draggingCompleteGraphRange:(CGPoint) p :(CGPoint)previousPoint;
-(void) draggingStartDateOfGraphRange:(CGPoint )p :(CGPoint)previousPoint;

-(void) GraphRangeStartDateDragEnded;
-(void) GraphRangeEndDateDragEnded;
-(void) GraphRangeCompleteDragEnded;

@end


@protocol ScrubberViewDelegate <NSObject>

@required 

//This method intimates the delegate that the user has changed the date values from old values and 
//hence the delagate can take action. This will be fired only when the user stops dragging and
//the dragging caused new values to be there for start and end dates.
-(void) didChangeScrubberGraphRangeStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate;

//The below method is meant for reflecting the scrubber graph range value changes when 
//the user is dragging and this can be used to update any label values on the recieving delagate.
//But this does not indicate that user stopped dragging and hence these might not be the
//final dates chose.
-(void) scrubberGraphRangeMovingTowardsStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate;

@end


@interface ScrubberView : UIView<ScrubberViewComponentsDelegate>
{

    //Newly added section..................
    int noOfLeftPaddingUnits;
    int noOfRightPaddingUnits;
    int noOfGraphRangeUnits;
    int totalNoOfUnitsInAvailableRange;
    
    ScrubberMiddleView *imMiddleView;
    ScrubberLeftView *imLeftView;
    ScrubberRightView *imRightView;
    
    CGRect currentFrameLeftView;
    CGRect currentFrameRightView;
    CGRect currentFrameMiddleView;
    
    float lengthOfEachUnit;
    float lenghtOfGraphRange;
    float lenghtOfLeftPadding;
    float lengthOfRightPadding;

    
    float minPercntOnRightPadding;
    float maxPercntOnRightPadding;
    float minPercntOnLeftPadding;
    float maxPercntOnLeftPadding; 
    
    NSDate *maximumEndDateOfAvailableRange;
    int maximumNoOfDaysAllowedInGRraphRange;
    int minimumNoOfHoursRequiredInGR;
    ScrubberMinimumGraphRangeType minimumGraphRangeType;
    
    float effectiveWidthOfScrubberView;
    CGPoint effectiveScrubberStartPoint;
    CGPoint effectiveScrubberEndPoint;
    
    ScrubberGraphRangeType currentGraphRangeType;
    
}

-(NSDate*) getcurrentEndDateOfGraphRange;
-(NSDate*) getcurrentStartDateOfGraphRange;
-(NSDate*) getcurrentEndDateOfAvailableRange;
-(NSDate*) getcurrentStartDateOfAvailableRange;

-(void) setcurrentEndDateOfGraphRange:(NSDate*) endDate;
-(void) setMaximumEndDateOfAvailableRange:(NSDate*) endDate;
-(void) setScrubberMinimumGraphRangeType:(ScrubberMinimumGraphRangeType) rangeType;
-(ScrubberMinimumGraphRangeType) getScrubberMinimumGraphRangeType;
-(void) setScrubberMinimumHoursRequiredInGraphDateRange:(int) noOfHoursMinRequired;

@property (nonatomic, strong) NSObject<ScrubberViewDelegate> *delegate;

-(void) reloadScrubberFromStartDateKey:(NSString*) userDefaultsStartDateKey andEndDateKey:(NSString*) userDefaultsEndDateKey forMaximumEndDateOfAvailableRange:(NSDate*) endDate andMaximumDaysAllowedInGraphDateRange:(int) noOfDaysAllowedInGR;

/*
-(void) draggingEndDateOfGraphRange:(CGPoint) p :(CGPoint)previousPoint;
-(void) draggingCompleteGraphRange:(CGPoint) p :(CGPoint)previousPoint;
-(void) draggingStartDateOfGraphRange:(CGPoint )p :(CGPoint)previousPoint;

*/


@end