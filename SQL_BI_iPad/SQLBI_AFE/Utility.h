//
//  Utility.h
//  Linkwell HealthiPad
//
//  Created by Apple on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    
    castString=0,
    castInt,
    castDate
    
}typeCastType;

@interface Utility : NSObject

+ (UIImage*)resizedImage:(UIImage*)image forWidth:(float) newWidth forHeight:(float) newHeight;

+ (UIColor *) getUIColorWithHexString: (NSString *) stringToConvert;

+ (int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;

+ (float) getNumberOfEpochDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;

+(int) getNumberOfHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime;

+ (float) getNumberOfEpochHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreMinutes:(BOOL) ignoreMinutes;

//Use this method to get values like Sunday, Monday etc
+(NSString*) getWeekDayforTheDate:(NSDate*) tempDate;


+(NSDate*) getDateOfNextSundayFromTheDate:(NSDate*) dateToBeChecked;

//The date is inclusive of the date supplied.
+(NSDate*) getDateOfPreviousSundayToTheDate:(NSDate*) dateToBeChecked;


+(NSString*) getDayFromDate:(NSDate*) tempDate;

+(NSString*) getMonthFromDate:(NSDate*) tempDate;

+(NSString*) getYearFromDate:(NSDate*) tempDate;

+(NSString*) getYearInShortFormatFromDate:(NSDate*) tempDate;

+(NSString*) getStringFromDate:(NSDate*) tempDate;

+(NSString*) getStringFromDateAPIFormat:(NSDate*) tempDate;

+(NSDate *)getDateFromString:(NSString*)dateString;
+(NSString*) getStringFromDateFormatter1:(NSDate*) tempDate;

+(NSString *)getStartDate;

+ (int)findNumberOfLinesInLabel:(UILabel *)label constrainedToSize:(CGSize) sizeConstrain;

+(NSTimeInterval) getOffsetFromGMT:(NSDate*) dateToBeChecked;

+(NSDate*) convertDateToGMT:(NSDate*) dateToBeConverted;

+(NSString*) getTwelveHourTimeFromDate:(NSDate*) date shouldDiscardMinutes:(BOOL) discardMinutes;

+(NSString*) getMonthNameFromDate:(NSDate*) tempDate;

+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;

+ (NSString*)formatNumber:(NSString*)value;

+(NSDate*) getCurrentTimeWithOffsetAppliedToGMT:(NSTimeInterval) offset;

+(BOOL) isValidEmail:(NSString*) email;

+(void) removeAllSubViewsFromSuperView:(UIView*) viewToClean;

+(void) addRightSwipeGestureToViewsRecursively:(UIView*) viewToAddGesture targetDelegate:(NSObject*) target handleSelector:(SEL) handle;

+(void) addLeftSwipeGestureToViewsRecursively:(UIView*) viewToAddGesture targetDelegate:(NSObject*) target handleSelector:(SEL) handle;

+(void) removeLeftSwipeGestureFromViewsRecursively:(UIView*) viewToRemoveGesture;

+(void) removeRightSwipeGestureFromViewsRecursively:(UIView*) viewToRemoveGesture;

+(NSArray*)sortArrayWithParameter:(NSString*)fieldToSort ascending:(BOOL) ascending typeCastType:(typeCastType)tCastType arrayToSort:(NSArray*)dataArray;

+(NSString *)formatDoubleValue:(double)input;

+(NSDate*) currentDateByIgnoringTime:(BOOL) shouldIgnoreTime;

#pragma mark - AFE Methods

+(NSString*) formatDateforAFEAPICalls:(NSDate*) date;

+(NSString*) formatNumberForAFEMMString:(double) number;

+ (BOOL)isRetina;

@end
