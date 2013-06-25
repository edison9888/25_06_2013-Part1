#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject {

	NSMutableDictionary *_cachedImages;
}

+ (ImageCacheManager*) sharedInstance;

- (void) reset;

- (UIImage*)getImageFromCacheForUrl:(NSString*)url;
- (void) addImage:(UIImage*)image toCacheForUrl:(NSString*)url;

- (void) removeImageFromCacheForUrl:(NSString*)url;
- (void) removeImagesFromCacheForUrls:(NSArray*)urls;

+ (NSString*) cachePathRoot;
+ (NSString*) filenameForUrl:(NSString*)url;
+ (NSString*) cachePathForUrl:(NSString*)url;	// Combines the results of the previous two methods

- (void) cacheImageToDiskFromUrl:(NSString*)url; // Assumes that the "url" image has already been loaded and is in the in-memory cache
- (void) cacheImage:(UIImage*)image toDiskFromUrl:(NSString*)url;
- (void) deleteImageFromDiskFromUrl:(NSString*)url;

// Note that these methods accesses the disk and should ideally be called from a background thread

- (BOOL) imageForUrlExistsInDiskCache:(NSString*)url;
- (UIImage*) getImageFromDiskCacheForUrl:(NSString*)url;

@end
