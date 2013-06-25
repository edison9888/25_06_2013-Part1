#import <math.h>
#import "Utility.h"
#import "NSData+Additions.h"
#import "JSON.h"
#import "Constants.h"
#import "Reachability.h"
#import "ImageCacheManager.h"
#import "ImageLoadingManager.h"
#import <QuartzCore/QuartzCore.h>
#import "RequestSubscription.h"

@interface Utility () 

+ (id) traverseResponderChainForUIViewController:(UIView*)view;
+ (UIView*) getFirstResponderFromView:(UIView*)view;
+ (NSDateFormatter*) getISO8601DateFormatter;

@end

@implementation Utility

+ (BOOL)isScreenRetina {
    return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2;
}

+ (BOOL)noNetworkConnection {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus n = [r currentReachabilityStatus];
    return n == NotReachable;
}

+ (NSString*) networkStatus {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NSString* networkStatus = @"";
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            networkStatus = @"None";
            break;
        case ReachableViaWiFi:
            networkStatus = @"WiFi";
            break;
        case ReachableViaWWAN:
            networkStatus = @"Data";
        default:
            break;
    }
    
    return networkStatus;    
}

+ (void)prefetchImageWithUrlIfNotCached:(NSString*)url {
    UIImage *cachedImage = [[ImageCacheManager sharedInstance] getImageFromCacheForUrl:url];
	if (cachedImage) {
        return;
	}        
    [[ImageLoadingManager sharedInstance] loadImage:url delegate:nil lowPriority:YES]; //Do not need a delegate, since will save to cache automatically
}

+ (NSString *)sha1:(NSString *)str {
    unsigned char hashedChars[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([str UTF8String], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], hashedChars);
	NSMutableString *hexString = [[NSMutableString alloc] init];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [hexString appendFormat:@"%02x", (unsigned char)(hashedChars[i])];   
    }
    return hexString;
}

+ (NSString *)hmacsha1:(NSString *)data key:(NSString *)key {
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return [HMAC base64Encoding];
}

+ (NSString*)encodeWithPercentEscapes:(NSString*)str {
	if (!str) { str = @""; }
	NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[] ", kCFStringEncodingUTF8);
    return s;
}


+ (BOOL)resultOK:(id)object {
    if (object == nil || [[object objectForKey:@"HTTPResponseStatus"] intValue] != 200) {
        return NO;
    }
    return YES;
}

+ (int)checkResultForErrors:(id)object {
    if (object == nil) {
        //[[Utility notificationUtility] showNotification:kStringError message:kStringErrorConnection];
        return 1;
    } else {
        int status;
		if ([object isKindOfClass:[NSDictionary class]]) {
			status = [[object objectForKey:@"HTTPResponseStatus"] intValue];
		}
		else {
			status = [object code];
		}
        if (status >= 500) {
            id result = [object objectForKey:@"result"];
            if ([result isKindOfClass:[NSArray class]] && [result count] > 0) {
                return [Utility checkDictionaryForErrorCode:[result objectAtIndex:0]];
            } else if ([result isKindOfClass:[NSDictionary class]]) {
                return [Utility checkDictionaryForErrorCode:result];                 
            } else {
                //[[Utility notificationUtility] showNotification:kStringError message:kStringErrorServer];
                return 1;
            }
        } else if (status >= 400 || status == -1009) {
            return status;
        }
    }
    return 0;
}

+ (int)checkDictionaryForErrorCode:(NSDictionary*)result {
    if ([result objectForKey:@"code"]) {
        //NSString *description = [result objectForKey:@"desc"];
        //[[Utility notificationUtility] showNotification:kStringError message:description];
        return 1;
    }
    return 0;
}

+ (NSDictionary*)buildServerResponse:(NSString*)response {
	id object;
    SBJSON *parser = [[SBJSON alloc] init];
	if ((object = [parser objectWithString:response error:nil])) {
        return [NSDictionary dictionaryWithObject:object forKey:@"result"];
    }
    return [self buildPlainTextResponse:response];
}

+ (NSDictionary*)buildPlainTextResponse:(NSString*)response {
    NSMutableDictionary *oauth = [NSMutableDictionary dictionary];
    NSArray *data = [response componentsSeparatedByString:@"&"];
    for (NSString *pairs in data) {
        NSArray *keyValue = [pairs componentsSeparatedByString:@"="];
        if ([keyValue count] > 1){
            [oauth setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
        } else if ([data count] == 1 && [keyValue count] == 1) {
            [oauth setObject:response forKey:@"error"];
        }
    }
    return oauth;
}


+ (UIColor *) colorForHex:(NSString *)hexColor {
	hexColor = [[hexColor stringByTrimmingCharactersInSet:
				 [NSCharacterSet whitespaceAndNewlineCharacterSet]
				 ] uppercaseString];
	
    if ([hexColor length] != 6) 
		return nil;//[UIColor blackColor];
	
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2; 
	
    NSString *rString = [hexColor substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [hexColor substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [hexColor substringWithRange:range];  
	
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];  
}

+ (UIViewController*)getViewControllerForView:(UIView*)view {
    return [Utility traverseResponderChainForUIViewController:view];
}

+ (id)traverseResponderChainForUIViewController:(UIView *)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [Utility traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

+ (UIView*)getFirstResponder {
    for (UIView *view in [[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews]) {
        UIView *responder = [self getFirstResponderFromView:view];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

+ (UIView *)getFirstResponderFromView:(UIView *)view {
    if (view.isFirstResponder) {
        return view;
    } else {
        for (UIView *subView in view.subviews) {
            UIView *firstResponder = [self getFirstResponderFromView:subView];
            if (firstResponder) {
                return firstResponder;
            }
        }
    }
    return nil;
}
                          
+ (NSString*) localizedStringForKey:(NSString*) key
{
    NSBundle *languageBundle;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    languageBundle = [NSBundle bundleWithPath:path];

	NSString *str = [languageBundle localizedStringForKey:key value:key table:nil];
	return str;
}

+ (NSDateFormatter *)getISO8601DateFormatter {
    static NSDateFormatter* sISO8601 = nil;
    
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [sISO8601 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    
    return sISO8601;
}

+ (NSDate *) dateFromISO8601:(NSString *) str {
    NSDateFormatter* sISO8601 = [self getISO8601DateFormatter];
    
    if ([str hasSuffix:@"Z"]) {
        str = [str substringToIndex:(str.length-1)];
    }

    NSDate *d = [sISO8601 dateFromString:str];
    return d;
    
}

+ (NSString *)iso8601FromDate:(NSDate *)date {
    NSDateFormatter* sISO8601 = [self getISO8601DateFormatter];
    
    NSString *dateString = [NSString stringWithFormat:@"%@Z", [sISO8601 stringFromDate:date]];
    
    return dateString;
}

+ (NSString*) stringForSaleEndDate:(NSDate *)saleEnd textToMakeRed:(NSString **)redText remainingSaleTime:(RemainingSaleTime *)remainingSaleTime{

    int totalSecondsUntilEnd = [saleEnd timeIntervalSinceNow];
    int daysUntilEnd = totalSecondsUntilEnd / kSecondsInDay;
    
    *redText = @"";
    *remainingSaleTime = RemainingSaleTimeLots;
    
    if (totalSecondsUntilEnd < 0) {
        *remainingSaleTime = RemainingSaleTimeNone;
        *redText = @"EXPIRED";
        return *redText;
    } else if (daysUntilEnd == 0) {        
        int hoursUntilEnd = totalSecondsUntilEnd / kSecondsInHour;
        int minutesUntilEnd = (totalSecondsUntilEnd - hoursUntilEnd * kSecondsInHour) / kSecondsInMinute;
        int secondsUntilEnd = (totalSecondsUntilEnd - hoursUntilEnd * kSecondsInHour - minutesUntilEnd * kSecondsInMinute);
                
        NSString* timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", hoursUntilEnd, minutesUntilEnd, secondsUntilEnd];
        if (hoursUntilEnd < kTimerRedThresholdInHours) {
            *redText = timeString;
            *remainingSaleTime = RemainingSaleTimeLittle;
        }
        return [NSString stringWithFormat:@"%@", timeString];
    } else if (daysUntilEnd == 1) {
        return [NSString stringWithFormat:@"%d day", daysUntilEnd];
    } else {
        return [NSString stringWithFormat:@"%d days", daysUntilEnd];
    }
}

+ (void) strikethroughFromView:(UIView *)view forLabel:(UILabel *)label {   
    view.backgroundColor = label.textColor;
    CGSize textSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:UILineBreakModeTailTruncation];
    view.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + label.frame.size.height/2, textSize.width, 1);
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

+ (NSString *)currencyStringForFloat:(float)currencyFloat {
    return [NSString stringWithFormat:@"%@$%.02f", currencyFloat >= 0 ? @"" : @"-", fabs(currencyFloat)];
}

+ (NSString *)safeStringWithString:(NSString *)inString {
    return inString.length > 0 ? [NSString stringWithString:inString] : @"";
}

+ (NSString *)userAgentString {
    return [NSString stringWithFormat:@"%@/%@/%@/%@", 
                           @"Plndr",
                           [UIDevice currentDevice].model,
                           [[UIDevice currentDevice] systemVersion],
                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

+ (BOOL)isCacheStillValid:(NSDate *)cacheDate cacheTime:(int)cacheTime {
    NSTimeInterval timeSinceLastCache = [[NSDate date] timeIntervalSinceDate:cacheDate];
    return timeSinceLastCache < cacheTime;
}

+ (BOOL) isEqualNumber:(NSNumber*)number1 number2:(NSNumber*)number2 {
    if (number1 == nil && number2 == nil) {
        return YES;
    }
    
    if (number1 == nil || number2 == nil) {
        return NO;
    }
    
    return (([number1 class] == [number2 class]) && [number1 intValue] == [number2 intValue]);
}

+ (NSString *)getDefaultErrorStringFromSubscription:(RequestSubscription *)subscription {
    NSDictionary *errorDictionary = (NSDictionary*)subscription.errorResult;
    if (![errorDictionary isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    return [errorDictionary objectForKey:@"displayMessage"];
}

+ (BOOL)isTimeInFuture:(NSDate *)time {
    int totalSecondsUntilEnd = [time timeIntervalSinceNow];
    
    return totalSecondsUntilEnd > 0;
}

@end
