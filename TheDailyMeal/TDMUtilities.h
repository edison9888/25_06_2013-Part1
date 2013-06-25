//
//  TDMUtilities.h
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDMUtilities : NSObject

#pragma mark - Alert View Methods
+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate;
+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag  ;
+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag showCancel:(BOOL)bShow;
+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag otherButtonTitle:(NSString*)strTitle;
+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag otherButtonTitle:(NSString*)strTitle secondButtonTitle:(NSString *)strSecondBtnTitle;

+ (NSString*)createHTMLString:(NSString *)text;
+ (void) clearCookies;
+(void)setRestaurantId:(NSString *)restaurantId;
+ (NSString *)getRestaurantId;

+ (NSString *)getRestaurantName;
+(void)setRestaurantName:(NSString *)restaurantName;

@end
