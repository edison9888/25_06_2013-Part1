//
//  Utility.m
//  Linkwell HealthiPad
//
//  Created by Apple on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (UIImage*)resizedImage:(UIImage*)image forWidth:(float) newWidth forHeight:(float) newHeight
{
    
    CGRect frame = CGRectMake(0, 0, newWidth, newHeight);
    UIGraphicsBeginImageContext(frame.size);
    [image drawInRect:frame];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}


+ (int)findNumberOfLinesInLabel:(UILabel *)label constrainedToSize:(CGSize) sizeConstrain
{
    
    if ( label.lineBreakMode != UILineBreakModeWordWrap )
    {
        return 1;
    }
    
    CGSize sizeTestForHeight = [label.text sizeWithFont: label.font forWidth: sizeConstrain.width lineBreakMode: UILineBreakModeWordWrap];
    float lineHeight = sizeTestForHeight.height;
    CGSize sizeTest = [label.text sizeWithFont: label.font constrainedToSize:sizeConstrain lineBreakMode: UILineBreakModeWordWrap];
    
    if(sizeTest.height > lineHeight)
    {
        
        if(fmodf(sizeTest.height, lineHeight)  > 0 )
        {
            return (sizeTest.height / lineHeight + 1);
        }
        else
        {
            return (sizeTest.height / lineHeight);
        }
    }
    else
    {
        return 1;
    }
    
    
    
}



+ (UIColor *) getUIColorWithHexString: (NSString *) stringToConvert;
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    else if([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    UIColor *resultColor = [UIColor colorWithRed:((float) r / 255.0f)
                                           green:((float) g / 255.0f)
                                            blue:((float) b / 255.0f)
                                           alpha:1.0f];
    return resultColor;
} 



+(NSTimeInterval) getOffsetFromGMT:(NSDate*) dateToBeChecked
{
    if(!dateToBeChecked)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    
    NSString *tempDateString;
    
    //Removing Seconds/Millisecodns from time.
    [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];    
    dateToBeChecked = [df dateFromString:[df stringFromDate:dateToBeChecked]];
    
    //Converting to GMT
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];
    [df setDateFormat:@"MM dd yyyy 'at' HH:mm"]; //Remove the time part
    
    
    tempDateString = [df stringFromDate:dateToBeChecked];
    
    NSDate *gmtDateTime =  [df dateFromString:tempDateString];
    
    return [dateToBeChecked timeIntervalSinceDate:gmtDateTime];

}


+(NSDate*) convertDateToGMT:(NSDate*) dateToBeConverted
{
    if(!dateToBeConverted)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    
    NSString *tempDateString;
    
     //Converting to GMT
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];
    [df setDateFormat:@"MM dd yyyy 'at' HH:mm"]; //Remove the time part
    
    
    tempDateString = [df stringFromDate:dateToBeConverted];
    
    NSDate *gmtDateTime =  [df dateFromString:tempDateString];
    
    return gmtDateTime;
    
}



//A negative return value will indicate that startDate is greater than endDate
//A positive return value will indicate that startDate is lesser than endDate
//A Zero value will indicate both dates are equal.
+ (int) getNumberOfDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    if(ignoreTime)
    {
        //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    }
    else
    {
        //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    }
    
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];
    
    int days = time / 60 / 60/ 24;
    
    return days;
}



+(int) getNumberOfHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    if(!startDate || !endDate)
        return 0;
    
    //GET # OF DAYS
    NSDateFormatter *df = [NSDateFormatter new];
    if(ignoreTime)
    {
        //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy"]; //Remove the time part
    }
    else
    {
        //[df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [df setDateFormat:@"MM dd yyyy 'at' HH:mm"];
    }
    NSString *startDateString = [df stringFromDate:startDate];
    NSString *endDateString = [df stringFromDate:endDate];
    NSTimeInterval time = [[df dateFromString:endDateString] timeIntervalSinceDate:[df dateFromString:startDateString]];
    
    int noOfHours = time / 60 /60; 
    
    return noOfHours;
    
}



//Use this method to get values like Sunday, Monday etc
+(NSString*) getWeekDayforTheDate:(NSDate*) tempDate
{
    if(!tempDate)
            return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDateFormatter stringFromDate:tempDate];
    
    return weekDay;

}


//The date is inclusive of the date supplied.
+(NSDate*) getDateOfNextSundayFromTheDate:(NSDate*) dateToBeChecked
{
    if(!dateToBeChecked)
        return NULL;
    
    NSDate *resultDate = dateToBeChecked;
    
    while(1)
    {
        if([[Utility getWeekDayforTheDate:resultDate] isEqualToString:@"Sunday"])
        {
            break;
        }
        else
        {
            resultDate = [NSDate dateWithTimeInterval:3600*24*1 sinceDate:resultDate];
        }
    }
    
    return resultDate;
}

//The date is inclusive of the date supplied.
+(NSDate*) getDateOfPreviousSundayToTheDate:(NSDate*) dateToBeChecked
{
    if(!dateToBeChecked)
        return NULL;
    
    NSDate *resultDate = dateToBeChecked;
    
    while(1)
    {
        if([[Utility getWeekDayforTheDate:resultDate] isEqualToString:@"Sunday"])
        {
            break;
        }
        else
        {
            resultDate = [NSDate dateWithTimeInterval:-3600*24*1 sinceDate:resultDate];
        }
    }
    
    return resultDate;
}


+(NSString*) getDayFromDate:(NSDate*) tempDate
{
    
    if(!tempDate)
        return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"dd"];
    NSString *day =  [theDateFormatter stringFromDate:tempDate];
    
    return day;

}


+(NSString*) getMonthFromDate:(NSDate*) tempDate
{
    
    if(!tempDate)
        return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"MM"];
    NSString *month =  [theDateFormatter stringFromDate:tempDate];
    
    return month;
    
}

+(NSString*) getMonthNameFromDate:(NSDate*) tempDate
{

    if(!tempDate)
        return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"MMM"];
    NSString *month =  [theDateFormatter stringFromDate:tempDate];
    
    return month;
    
}


+(NSString*) getYearFromDate:(NSDate*) tempDate
{
    
    if(!tempDate)
        return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"yyyy"];
    NSString *year =  [theDateFormatter stringFromDate:tempDate];
    
    return year;
    
}

+(NSString*) getYearInShortFormatFromDate:(NSDate*) tempDate
{
    
    if(!tempDate)
        return @"";
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"yyyy"];
    NSString *year =  [theDateFormatter stringFromDate:tempDate];
    
    year = [year substringFromIndex:2];
    
    return year;
    
}

+(NSString*) getStringFromDate:(NSDate*) tempDate{
    NSString *resultDate = @"";
    if(tempDate){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        resultDate = [dateFormat stringFromDate:tempDate];
    }
    return resultDate;
}
+(NSString*) getStringFromDateFormatter1:(NSDate*) tempDate{
    NSString *resultDate = @"";
    if(tempDate){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        resultDate = [dateFormat stringFromDate:tempDate];
    }
    return resultDate;
}
+(NSString*) getStringFromDateAPIFormat:(NSDate*) tempDate{
    NSString *resultDate = @"";
    if(tempDate){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        resultDate = [dateFormat stringFromDate:tempDate];
        resultDate = [resultDate stringByReplacingOccurrencesOfString:@"/""" withString:@""];
    }
    return resultDate;
}
+(NSDate *)getDateFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    return date;

}
+(NSString *)getStartDate{
    NSDate *now = [NSDate date];
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //[theDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [theDateFormatter setDateFormat:@"yyyy"];
    NSString *year =  [theDateFormatter stringFromDate:now];
    NSString *startDate = [NSString stringWithFormat:@"01/01/%@",year];
    return  startDate;


}
+(NSString*) getTwelveHourTimeFromDate:(NSDate*) date shouldDiscardMinutes:(BOOL) discardMinutes
{
    
    if(!date)
        return @"";
    
    if(discardMinutes)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [df setTimeZone:gmt];
        [df setDateFormat:@"MM dd yyyy 'at' HH"];
        date = [df dateFromString:[df stringFromDate:date]];
    }
    

    
    NSDateFormatter* timeDateFormatter = [[NSDateFormatter alloc] init];
    //[timeDateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [timeDateFormatter setTimeZone:gmt];
    [timeDateFormatter setDateStyle: NSDateFormatterNoStyle]; // no date for this formatter
    [timeDateFormatter setTimeStyle: NSDateFormatterShortStyle]; // does respect 12/24 hour setting
    
    NSString* timePart = [timeDateFormatter stringFromDate:date];
    
    if(discardMinutes)
    {
        
        timePart = [NSString stringWithFormat:@"%@ %@", [timePart substringWithRange:NSMakeRange(0, [timePart rangeOfString:@":"].location)], [timePart substringFromIndex:[timePart length]-2]];
    }
    
    
    int skipZero = 0;  // extra code to remove leading zero if present 
    if ([[timePart substringToIndex:1] isEqualToString:@"0"]) skipZero = 1;
    
       
    return [NSString stringWithFormat:@"%@", [timePart substringFromIndex:skipZero]];    
}


+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}


//added by Sebin to format number

+ (NSString*)formatNumber:(NSString*)value
{
    if(!value)
        return @"";
    else
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *number=value;
    
    int numberLength;
    int lengthToDecimal = 0;
    
    NSRange range = [value rangeOfString:@"."];
    
    if(range.location != NSNotFound )
    {
        NSString *tempStringWithoutDecimal = [NSString stringWithString :[value substringFromIndex:range.location] ];
        
        lengthToDecimal = [tempStringWithoutDecimal length];
    }
    
    numberLength = [value length] - lengthToDecimal;
    
    if (numberLength==4) 
    {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:1],[number substringFromIndex:1]];
        NSLog(@"%@",number);
    }
    
    else if (numberLength==5) {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:2],[number substringFromIndex:2]];
        NSLog(@"%@",number);
        
    }
    
    else if (numberLength==6) {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:3],[number substringFromIndex:3]];
        //number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:4],[number substringFromIndex:4]];
        NSLog(@"%@",number);
    }
    
    else if (numberLength==7) {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:1],[number substringFromIndex:1]];
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:5],[number substringFromIndex:5]];
        NSLog(@"%@",number);
    }
    
    else if (numberLength==8) {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:2],[number substringFromIndex:2]];
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:6],[number substringFromIndex:6]];
        NSLog(@"%@",number);
    }
    
    else if (numberLength==9) {
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:3],[number substringFromIndex:3]];
        number=[NSString stringWithFormat:@"%@,%@",[number substringToIndex:7],[number substringFromIndex:7]];
        NSLog(@"%@",number);
        
    }
    else
    {
        NSLog(@"%@",number);
    }
    return number;
    
}

+ (float) getNumberOfEpochDaysBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreTime:(BOOL) ignoreTime
{
    float noOfDays;
    int noOfDaysWithoutTime;
    
    noOfDays = ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970])/(3600*24);
    
    if(ignoreTime)
    {
        noOfDaysWithoutTime = noOfDays;
        noOfDays = noOfDaysWithoutTime;

    }
    
    return noOfDays;
}

+ (float) getNumberOfEpochHoursBetweenStartDate:(NSDate*) startDate andEndDate:(NSDate*) endDate shouldIgnoreMinutes:(BOOL) ignoreMinutes
{
    float noOfHours;
    int noOfHoursWithoutMinutes;
    
    noOfHours = ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970])/3600;
    
    if(ignoreMinutes)
    {
        noOfHoursWithoutMinutes = noOfHours;
        noOfHours = noOfHoursWithoutMinutes;
        
    }
    
    return noOfHours;
}

+(NSDate*) getCurrentTimeWithOffsetAppliedToGMT:(NSTimeInterval) offset
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    return [NSDate dateWithTimeInterval:offset sinceDate:[NSDate date]];
    
}

+(void) removeAllSubViewsFromSuperView:(UIView*) viewToClean
{
    if(viewToClean.subviews.count > 0)
    {
        for(UIView *tempSubView in viewToClean.subviews)
            [Utility removeAllSubViewsFromSuperView:tempSubView];
    }
    
    [viewToClean removeFromSuperview];
    viewToClean = nil;
}

+(void) addRightSwipeGestureToViewsRecursively:(UIView*) viewToAddGesture targetDelegate:(NSObject*) target handleSelector:(SEL) handle
{
    if(viewToAddGesture && viewToAddGesture.subviews.count > 0)
    {
        for(UIView *tempSubView in viewToAddGesture.subviews)
            [Utility addRightSwipeGestureToViewsRecursively:tempSubView targetDelegate:target handleSelector:handle];
    }
    
    if(viewToAddGesture)
    {
        UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:handle];
        [gestureR setDirection:UISwipeGestureRecognizerDirectionRight];
        [viewToAddGesture addGestureRecognizer:gestureR];   
    }
    
}

+(void) addLeftSwipeGestureToViewsRecursively:(UIView*) viewToAddGesture targetDelegate:(NSObject*) target handleSelector:(SEL) handle
{
    if(viewToAddGesture && viewToAddGesture.subviews.count > 0)
    {
        for(UIView *tempSubView in viewToAddGesture.subviews)
            [Utility addLeftSwipeGestureToViewsRecursively:tempSubView targetDelegate:target handleSelector:handle];
    }
    
    if(viewToAddGesture)
    {
        UISwipeGestureRecognizer *gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:handle];
        [gestureR setDirection:UISwipeGestureRecognizerDirectionLeft];
        [viewToAddGesture addGestureRecognizer:gestureR];
    }
    
    
}


+(void) removeLeftSwipeGestureFromViewsRecursively:(UIView*) viewToRemoveGesture
{
    if(viewToRemoveGesture && viewToRemoveGesture.subviews.count > 0)
    {
        for(UIView *tempSubView in viewToRemoveGesture.subviews)
            [Utility removeLeftSwipeGestureFromViewsRecursively:tempSubView];
    }
    
    if(viewToRemoveGesture)
        for(UIGestureRecognizer *tempGesture in viewToRemoveGesture.gestureRecognizers)
        {
            if([tempGesture isMemberOfClass:[UISwipeGestureRecognizer class]])
            {
                UISwipeGestureRecognizer *tempSwipeGesture = (UISwipeGestureRecognizer*) tempGesture;
                
                if(tempSwipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
                {
                    [viewToRemoveGesture removeGestureRecognizer:tempSwipeGesture];
                }
            }
        }
    
}

+(void) removeRightSwipeGestureFromViewsRecursively:(UIView*) viewToRemoveGesture
{
    if(viewToRemoveGesture && viewToRemoveGesture.subviews.count > 0)
    {
        for(UIView *tempSubView in viewToRemoveGesture.subviews)
            [Utility removeRightSwipeGestureFromViewsRecursively:tempSubView];
    }
    
    if(viewToRemoveGesture)
        for(UIGestureRecognizer *tempGesture in viewToRemoveGesture.gestureRecognizers)
        {
            if([tempGesture isMemberOfClass:[UISwipeGestureRecognizer class]])
            {
                UISwipeGestureRecognizer *tempSwipeGesture = (UISwipeGestureRecognizer*) tempGesture;
                
                if(tempSwipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
                {
                    [viewToRemoveGesture removeGestureRecognizer:tempSwipeGesture];
                }
            }
        }
    
}


+ (BOOL)isRetina {
    
    BOOL isRetina = NO;
    
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            isRetina = YES;
        }
    }
    
    return isRetina;
}

+(NSDate*) currentDateByIgnoringTime:(BOOL) shouldIgnoreTime
{
    NSDate *resultDate = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if(shouldIgnoreTime)
    {   
        [df setDateFormat:@"MM/dd/yyy"];
        resultDate = [df dateFromString:[df stringFromDate:[NSDate date]]];            
    }
    
    return resultDate;
    
}


#pragma mark - AFE Methods

+(BOOL) isValidEmail:(NSString*) email
{
    if(!email)
        return NO;
    
    NSString *emailReg =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg]; 
    
    return [emailTest evaluateWithObject:email];
}


+(NSArray*)sortArrayWithParameter:(NSString*)fieldToSort ascending:(BOOL)ascending typeCastType:(typeCastType)tCastType arrayToSort:(NSArray*)dataArray{

    NSSortDescriptor *aSortDescriptor;
    NSArray *sortedArray;
    
    if(tCastType == castInt)
    {
        aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:fieldToSort ascending:ascending comparator:^(id obj1, id obj2) 
        {
            if ([obj1 integerValue] > [obj2 integerValue]) 
            {        
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) 
            {
        
                return (NSComparisonResult)NSOrderedAscending;    
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    else if(tCastType == castDate)
    {
      __block  NSDateFormatter * dfm = [[NSDateFormatter alloc] init];
        dfm.dateFormat = @"MM/dd/yyyy";
        aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:fieldToSort ascending:ascending comparator:^(id obj1, id obj2) 
                           {
                                                             
                               if ([dfm dateFromString:obj1] > [dfm dateFromString:obj2]) 
                               {        
                                   return (NSComparisonResult)NSOrderedDescending;
                               }
                               if ([dfm dateFromString:obj1] < [dfm dateFromString:obj2]) 
                               {
                                   
                                   return (NSComparisonResult)NSOrderedAscending;    
                               }
                               
                               return (NSComparisonResult)NSOrderedSame;
                           }];
    }
    else if(tCastType == castString)
    {
        aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:fieldToSort ascending:ascending];
    }
    
     sortedArray = [NSMutableArray arrayWithArray:[dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];

    return sortedArray;

}
+(NSString *)formatDoubleValue:(double)input{
    NSString *result = @"";
    if(input > 0)
       result = [NSString stringWithFormat:@"%.7f", input]; 
    else
        result = @"0";
    return result;
    
}

+(NSString*) formatDateforAFEAPICalls:(NSDate*) date
{
    NSString *result = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    
    if(date)
    {
        result = [df stringFromDate:date];
    }
    
    return result;
}

+(NSString*) formatNumberForAFEMMString:(double) number
{
    NSString *resultStr;
    
    NSLog(@"%f",number/100000);
    NSLog(@"%f",fmodf(number,1000000));
    
    if(number > 1000000)
    {
        resultStr = [NSString stringWithFormat:@"$%@MM",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",number/1000000]]];
    }
    else if(number > 1000)
    {
        resultStr = [NSString stringWithFormat:@"$%@M",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",number/1000]]];
    }
    else
    {
        resultStr = [NSString stringWithFormat:@"$%@",[Utility formatNumber:[NSString stringWithFormat:@"%.2f",number]]];
    }
    
    return resultStr;
    
}

@end
