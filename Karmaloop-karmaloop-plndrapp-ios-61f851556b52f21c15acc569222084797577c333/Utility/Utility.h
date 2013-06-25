#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CoreLocation/CoreLocation.h>
#import "FeaturedThumbnail.h"

@class RequestSubscription;

@interface Utility : NSObject {
    
}

+ (BOOL)isScreenRetina;

+ (BOOL)noNetworkConnection;
+ (NSString*) networkStatus;

+ (void)prefetchImageWithUrlIfNotCached:(NSString*)url;

+ (UIColor *) colorForHex:(NSString *)hexColor;

+ (NSString *)hmacsha1:(NSString *)data key:(NSString *)key;
+ (NSString*)encodeWithPercentEscapes:(NSString*)str;
+ (BOOL)resultOK:(id)object;
+ (int)checkResultForErrors:(id)object;
+ (int)checkDictionaryForErrorCode:(NSDictionary*)result;
+ (NSDictionary*)buildServerResponse:(NSString*)response;
+ (NSDictionary*)buildPlainTextResponse:(NSString*)response;
  
+ (UIViewController*)getViewControllerForView:(UIView*)view;
+ (UIView*)getFirstResponder;

+ (NSString*) localizedStringForKey:(NSString*) key;
+ (NSDate *) dateFromISO8601:(NSString *) str;
+ (NSString *) iso8601FromDate:(NSDate *) date;

+ (NSString*) stringForSaleEndDate:(NSDate*)saleEnd textToMakeRed:(NSString**)redText remainingSaleTime:(RemainingSaleTime*)remainingSaleTime;

+ (void) strikethroughFromView:(UIView*)view forLabel:(UILabel*)label;

+ (UIImage *) imageWithView:(UIView *)view;

+ (NSString*) currencyStringForFloat:(float)currencyFloat;

+ (NSString*) safeStringWithString:(NSString*)inString;

+ (NSString*) userAgentString;

+ (BOOL) isCacheStillValid:(NSDate*)cacheDate cacheTime:(int)cacheTime;
+ (BOOL) isEqualNumber:(NSNumber*)number1 number2:(NSNumber*)number2;

+ (NSString *)getDefaultErrorStringFromSubscription:(RequestSubscription *)subscription;
+ (BOOL) isTimeInFuture:(NSDate*)time;

@end
