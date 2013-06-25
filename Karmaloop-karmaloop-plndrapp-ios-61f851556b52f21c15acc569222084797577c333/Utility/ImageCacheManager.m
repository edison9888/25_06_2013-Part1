#import "ImageCacheManager.h"
#import "NSOperationQueue+FileQueue.h"

@interface ImageCacheManager ()

- (NSString*) getCacheKeyForUrl:(NSString*)url;

@end


@implementation ImageCacheManager

static ImageCacheManager *manager = nil;

+ (ImageCacheManager*) sharedInstance {
	@synchronized (manager) {
		if (manager == nil) {
			manager = [[ImageCacheManager alloc] init];			
		}
	}
	return manager;
}

- (id) init {
	if ((self = [super init])) {
		_cachedImages = [[NSMutableDictionary alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSOperationQueue fileQueue] addInvocationOperationWithTarget:self selector:@selector(ensureCacheRootExists) object:nil];
	}
	return self;
}

- (void) reset {
    NSLog(@"ImageCacheManager resetting cache with %d images", _cachedImages.count);
	[_cachedImages removeAllObjects];
}

- (NSString*) getCacheKeyForUrl:(NSString*)url {
	return url;
}

- (UIImage*)getImageFromCacheForUrl:(NSString*)url {
	return [_cachedImages objectForKey:[self getCacheKeyForUrl:url]];
}

- (void) addImage:(UIImage*)image toCacheForUrl:(NSString*)url {
	[_cachedImages setObject:image forKey:[self getCacheKeyForUrl:url]];
}

- (void) removeImageFromCacheForUrl:(NSString*)url {
	[_cachedImages removeObjectForKey:url];
}
- (void) removeImagesFromCacheForUrls:(NSArray*)urls {
	[_cachedImages removeObjectsForKeys:urls];
}


#pragma mark -
#pragma mark Disk Caching Methods

+ (NSString*) cachePathRoot {
	NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = [cacheDirectories lastObject];
	return [cachePath stringByAppendingPathComponent:@"images"];
}

+ (NSString*) filenameForUrl:(NSString*)url {
	// This logic assumes the URLS are in this format: http://beta.images.theglobeandmail.com/archive/01238/web_quake_bf_39_1238597cl-4.jpg
    // Turn into --> 01238_web_quake_bf_39_1238597cl-4.jpg
    // TODO: Adapt to Metro image format: http://media.metronews.topscms.com/images/e9/88/90c8eb814115be6764446a0ad57f.jpeg (additional part?)
	NSArray *urlComponents = [url componentsSeparatedByString:@"/"];
    int secondLast = [urlComponents count] - 2;
    int last = [urlComponents count] - 1;
	return [NSString stringWithFormat:@"%@_%@", [urlComponents objectAtIndex:secondLast], [urlComponents objectAtIndex:last]];
}

+ (NSString*) cachePathForUrl:(NSString*)url {
	return [[self cachePathRoot] stringByAppendingPathComponent:[self filenameForUrl:url]];
}

- (void) ensureCacheRootExists {
	if (![[NSFileManager defaultManager] fileExistsAtPath:[ImageCacheManager cachePathRoot]]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:[ImageCacheManager cachePathRoot] withIntermediateDirectories:YES attributes:nil error:NULL]; 
	}
}

- (void) cacheImage:(UIImage*)image toDiskFromUrl:(NSString*)url {
	[[NSOperationQueue fileQueue] addInvocationOperationWithTarget:self selector:@selector(doCacheImage:) object:[NSDictionary dictionaryWithObjectsAndKeys:image,@"image", url,@"url", nil]];
}
- (void) cacheImageToDiskFromUrl:(NSString*)url {
	UIImage *image = [self getImageFromCacheForUrl:url];
	if (image) {
		NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doCacheImage:) object:[NSDictionary dictionaryWithObjectsAndKeys:image,@"image", url,@"url", nil]];
		[[NSOperationQueue fileQueue] addOperation:op];
	}
}

- (void) doCacheImage:(NSDictionary*)dict {
	// CALLED ON BACKGROUND THREAD!
	UIImage *image = [dict objectForKey:@"image"];
	NSString *url = [dict objectForKey:@"url"];
	NSString *path = [ImageCacheManager cachePathForUrl:url];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { // Only cache if it isn't already there
		NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
		[imageData writeToFile:path atomically:NO];
	}
}


- (void) deleteImageFromDiskFromUrl:(NSString *)url {
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doDeleteCachedImage:) object:url];
	[[NSOperationQueue fileQueue] addOperation:op];
}

- (void) doDeleteCachedImage:(NSString*)url {
	// CALLED ON BACKGROUND THREAD
	NSString *path = [ImageCacheManager cachePathForUrl:url];
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}


- (BOOL) imageForUrlExistsInDiskCache:(NSString*)url {
	NSString *path = [ImageCacheManager cachePathForUrl:url];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (UIImage*) getImageFromDiskCacheForUrl:(NSString*)url {
	// This method is potentially blocking, so it should be called on a background thread!
	
	NSString *path = [ImageCacheManager cachePathForUrl:url];
	
	NSData *imageData = [[NSData alloc] initWithContentsOfFile:path];
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	
	if (image) {
		[self performSelectorOnMainThread:@selector(addImageToCache:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:image,@"image", url,@"url", nil] waitUntilDone:YES];
	}
	
	
	return image;
}

- (void) addImageToCache:(NSDictionary*)info {
	// This is called on the main thread
	[self addImage:[info objectForKey:@"image"] toCacheForUrl:[info objectForKey:@"url"]];
}


#pragma mark -

- (NSString*) description {
	return [NSString stringWithFormat:@"In-memory image cache contains %d images: %@", [_cachedImages count], _cachedImages];
}

- (void) didReceiveMemoryWarning {
	// Flush the image cache
    NSLog(@"ImageCacheManager didReceiveMemoryWarning, flushing image cache");
	[self reset];
}


@end
