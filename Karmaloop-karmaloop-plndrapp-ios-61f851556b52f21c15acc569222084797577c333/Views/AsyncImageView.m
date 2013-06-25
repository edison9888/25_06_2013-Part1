#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "ImageCacheManager.h"
#import "ImageUrlConnection.h"
#import "Utility.h"

#define PLACEHOLDER_TAG 9876

@interface AsyncImageView (Private)
- (void)initProperties;
- (void) fadeOutOverlay;
@end

@implementation AsyncImageView

@synthesize loaded, delegate, overlayView = _overlayView, overlayBorder, placeholderImage = _placeholderImage;

- (id)init {
	return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}

- (void)initProperties {
    _overlayBackgroundColor = [UIColor clearColor];
    self.overlayBorder = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProperties];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
        [self initProperties];
	}
	return self;
}

- (void) setBackgroundColor:(UIColor *)color {
	if (color != _overlayBackgroundColor) {
		_overlayBackgroundColor = color;
		
		_overlayView.backgroundColor = color;
	}
}

- (void) setOverlayBorder:(BOOL)show {
	overlayBorder = show;
	_overlayView.layer.borderWidth = show ? 1 : 0;
}

- (void) layoutOverlayLogo:(UIView*)logo {
    
    // Commented out padding logic, as this doesn't apply for Metro image
    //	CGFloat size = self.frame.size.width; // 113.0f; // The native size of the logo image
    //	CGFloat padding = 0;	
    //	if (self.frame.size.height < size+(padding*2)) {
    //		size = self.frame.size.height-(padding*2);
    //	}
    //	if (self.frame.size.width < size+(padding*2)) {
    //		size = self.frame.size.width-(padding*2);
    //	}
	
	logo.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	logo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	if (_overlayView) {
		// Fix the layout of the placeholder logo
		[self layoutOverlayLogo:[_overlayView viewWithTag:PLACEHOLDER_TAG]];
	}
}

#pragma mark -

- (void) removeOverlayView {
	if (_overlayView) {
		[_overlayView removeFromSuperview];
		_overlayView = nil;
	}
}


- (void) setupOverlayView {
	if (!_overlayView) {
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_overlayView.backgroundColor = _overlayBackgroundColor;
        
		CALayer *layer = [_overlayView layer];
		layer.borderWidth = overlayBorder ? 1 : 0;
		layer.borderColor = [UIColor clearColor].CGColor;
		
        
        UIImage *overlayImage = self.placeholderImage ? self.placeholderImage : [UIImage imageNamed:@"image_default.png"];
		UIImageView *defaultLogoView = [[UIImageView alloc] initWithImage:overlayImage];
		defaultLogoView.tag = PLACEHOLDER_TAG;
        defaultLogoView.contentMode = UIViewContentModeScaleAspectFill;
        [self layoutOverlayLogo:defaultLogoView];
		[_overlayView addSubview:defaultLogoView];
	}
	
	[_overlayView removeFromSuperview];
	_overlayView.alpha = 1.0;
	[self addSubview:_overlayView];
}

- (void) fadeOutOverlay {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeOverlayView)];
	_overlayView.alpha = 0.0;
	[UIView commitAnimations];
}

+ (NSString *)urlFromUrl:(NSString *)url withWidth:(float)width {
    // Modify the url to request the image at the optimal size:
    int retinaMultiplier = [Utility isScreenRetina] ? 2 : 1;
    return [NSString stringWithFormat:@"%@?width=%.00f", url, width*retinaMultiplier];
}

- (void) loadImageFromUrl:(NSString*)url sizedForFrame:(BOOL)sizedForFrame{
    NSString *correctedUrl = url;
    if (sizedForFrame) {
        correctedUrl = [AsyncImageView urlFromUrl:url withWidth:self.frame.size.width];
    }
    
    if (_connection) { // If there is a connection in progress
        [[ImageLoadingManager sharedInstance] cancelLoadingImageConnection:_connection];
        _connection = nil;		
    }
    
	UIImage *cachedImage = [[ImageCacheManager sharedInstance] getImageFromCacheForUrl:correctedUrl];
	if (cachedImage) {
		self.image = cachedImage;
		[self removeOverlayView]; // Remove the overlay instantly if we already have the image
		
		self.loaded = YES;
		[self.delegate imageDidLoad:self];
	}
	else {
		self.loaded = NO;
		
		_requestedUrl = correctedUrl;
		
		self.image = nil;
        
        [self setupOverlayView];
        
        if (!correctedUrl || [correctedUrl length] == 0) { return; }
        
		_connection = [[ImageLoadingManager sharedInstance] loadImage:_requestedUrl delegate:self];
	}
}

- (void) clearImage {
	self.image = nil;
    [self setupOverlayView];
}

#pragma mark -
#pragma mark Callbacks After Load Success/Failure

- (void) imageLoadedSuccessfully:(UIImage*)img fromUrl:(NSString*)url {
	if ([url isEqualToString:_requestedUrl]) {
		self.image = img;
		
		if (![delegate respondsToSelector:@selector(imageShouldFadeIn:)] || [delegate imageShouldFadeIn:self]) {
            [self fadeOutOverlay];
		}
		else {
			[self removeOverlayView];
		}
		
		_requestedUrl = nil;
		
		self.loaded = YES;
		[self.delegate imageDidLoad:self];
	}
}
- (void) imageLoadedSuccessfully:(NSDictionary*)info {
	[self imageLoadedSuccessfully:[info objectForKey:@"image"] fromUrl:[info objectForKey:@"url"]];
}

- (void) imageFailedToLoadFromUrl:(NSString*)url {
	_requestedUrl = nil;
	
	[self.delegate imageFailedToLoad:self];
}

#pragma mark -
#pragma mark Delegate Methods

- (void) finishedLoadingImage: (UIImage*)img fromUrl:(NSString*)url connection:(ImageUrlConnection*)conn {
	// Cache the image as-is
	[[ImageCacheManager sharedInstance] addImage:img toCacheForUrl:url];
	
	_connection = nil;
	
	[self imageLoadedSuccessfully:img fromUrl:url];
}

- (void) failedLoadingImageFromUrl:(NSString *)url connection:(ImageUrlConnection*)conn {
	_connection = nil;
	
	// If the image didn't load from the server, try loading it from disk (on a background thread)!
	[self performSelectorInBackground:@selector(loadFromDiskCacheForUrl:) withObject:url];
}

- (void) loadFromDiskCacheForUrl:(NSString*)url {
	// CALLED ON BACKGROUND THREAD!
	
	// We need an autorelease pool for all this stuff...
	@autoreleasepool {
        
        // Try loading the URL from the disk cache. If it isn't there, try loading it in various sizes as fallbacks
		UIImage *img = [[ImageCacheManager sharedInstance] getImageFromDiskCacheForUrl:url];
		
		if(!img) {
            //Old logic for GlobeAndMail with multiple image sizes
            //		for (int sizeToTry = PhotoSizeFull; sizeToTry >= 0; sizeToTry--) {
            //			img = [[ImageCacheManager sharedInstance] getImageFromDiskCacheForUrl:[Photo urlWithBaseUrl:url forSize:sizeToTry]];
            //			if (img) {
            //				break;
            //			}
            //		}
            img = [[ImageCacheManager sharedInstance] getImageFromDiskCacheForUrl:url];
		}
		
		if (img) {
			[self performSelectorOnMainThread:@selector(imageLoadedSuccessfully:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:img,@"image", url,@"url", nil] waitUntilDone:YES];
		}
		else {
			[self performSelectorOnMainThread:@selector(imageFailedToLoadFromUrl:) withObject:url waitUntilDone:YES];
		}
        
	}
}

- (void) dealloc {
	
	[[ImageLoadingManager sharedInstance] cancelLoadingImageConnection:_connection];
	
}

@end
