//
//  TDMUtilities.m
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMUtilities.h"

@implementation NSString (TDM_Extension)

- (NSString *)nullCheck:(NSString *)text {
    
    if(text != nil && [NSNull null] != (NSNull *)text && [text length] > 0)
    {
        return text;
    }
    
    return @"";
}

@end

@implementation TDMUtilities
NSString *restaurantIds;
NSString *restaurantName;
#pragma mark - Alert View Methods

+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate
{
    [TDMUtilities showAlert:alertTitle message:strAlertMessage delegateObject:delegate viewTag:0];
}

+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag  {
    [TDMUtilities showAlert:alertTitle message:strAlertMessage delegateObject:delegate viewTag:iTag showCancel:NO];
}

+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag showCancel:(BOOL)bShow
{
    UIAlertView *alertView = nil;;
    
    @try
    {
        if (bShow)
        {
            alertView=[[UIAlertView alloc] initWithTitle:alertTitle message:strAlertMessage delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel",nil];
		}
		else
        {
            alertView=[[UIAlertView alloc] initWithTitle:alertTitle message:strAlertMessage delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
		}
        
        alertView.tag=iTag;
        
        [alertView show];
		[alertView release];
		alertView   =   nil;
	}
	@catch (NSException * e)
    {
    }
	@finally
    {
    }
}

+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag otherButtonTitle:(NSString*)strTitle
{
    [TDMUtilities showAlert:alertTitle message:strAlertMessage delegateObject:delegate viewTag:iTag otherButtonTitle:strTitle secondButtonTitle:@"Cancel"];
}

+ (void)showAlert:(NSString *)alertTitle message:(NSString *)strAlertMessage delegateObject:(id)delegate viewTag:(int)iTag otherButtonTitle:(NSString*)strTitle secondButtonTitle:(NSString *)strSecondBtnTitle
{
    UIAlertView *alertView = nil;
    
    @try
    {
        alertView=[[UIAlertView alloc] initWithTitle:alertTitle message:strAlertMessage delegate:delegate cancelButtonTitle:nil otherButtonTitles:strTitle,strSecondBtnTitle,nil];
        
		alertView.tag=iTag;
		
		[alertView show];
		[alertView release];
		alertView   =   nil;
	}
	@catch (NSException * e)
    {
    }
	@finally
    {
    }
}

+ (NSString*)createHTMLString:(NSString *)text {
    
    NSString *htmlString = [NSString stringWithFormat:@"<html><body><font face=\"Trebuchet MS\" color=\"#AAAAAA\"size=2>%@</font></body><html>",text];
    return htmlString;
}
+ (void) clearCookies
{
    [TDMBaseHttpHandler clearSession];
    //to clear caching of seesion variables.
    [ASIHTTPRequest clearSession];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])   {
        [storage deleteCookie:cookie];
        cookie = nil;
    }

}

+ (NSString *)getRestaurantId
{
    NSString *ids = @" ";
      NSUserDefaults * localDefaultObject =[NSUserDefaults standardUserDefaults];
      ids = [localDefaultObject objectForKey:@"restaurantId"];
    return ids;
}
+(void)setRestaurantId:(NSString *)restaurantId
{
    restaurantIds = restaurantId;
         NSUserDefaults * localDefaultObject =[NSUserDefaults standardUserDefaults];
       [localDefaultObject setObject:restaurantId forKey:@"restaurantId"];
        [localDefaultObject synchronize];
}


+ (NSString *)getRestaurantName
{
    NSString *name = @"";
    NSUserDefaults * localDefaultObject =[NSUserDefaults standardUserDefaults];
    name = [localDefaultObject objectForKey:@"restaurantName"];
    return name;
}
+(void)setRestaurantName:(NSString *)restaurantName
{
    restaurantName = restaurantName;
    NSUserDefaults * localDefaultObject =[NSUserDefaults standardUserDefaults];
    [localDefaultObject setObject:restaurantName forKey:@"restaurantName"];
    [localDefaultObject synchronize];
}





@end
