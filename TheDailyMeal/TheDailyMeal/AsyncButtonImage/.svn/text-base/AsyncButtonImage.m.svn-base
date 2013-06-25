//
//  AsyncButtonImage.m
//  Imported class

#import "AsyncButtonImage.h"

@implementation AsyncButtonImage
@synthesize delegate;

#pragma mark - Memory Management

- (void)dealloc 
{
	[urlConnection cancel]; //In case the connection is still active
	[urlConnection release];
	[responseData release]; 
    [super dealloc];
}

#pragma mark - 
-(void)loadDefaultImage {
    
    if ([[self subviews] count]>0) 
    {
		[[[self subviews] objectAtIndex:0] removeFromSuperview];
	}
    
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"imageNotAvailable" ofType:@"png"]];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
    
    if (delegate && [delegate respondsToSelector:@selector(didLoadImage:forIndex:)]) 
    {
        [delegate didFailedLoadingImageForIndex:self.tag];
    }
}

- (void)loadImageFromURL:(NSURL*)url 
{	
	[self setBackgroundColor:[UIColor whiteColor]];
    
	if (urlConnection) 
    { 
        [urlConnection release]; 
    } 
	
    if (responseData) 
    { 
        [responseData release]; 
    }
	
    if(url){
    
        //Load Activity Indicator
        loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingActivityIndicator setFrame:CGRectMake((self.bounds.size.width/2.4), (self.bounds.size.height/2.4), 25, 25)];
        [self addSubview:loadingActivityIndicator];
        [loadingActivityIndicator startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else{
        
        [self loadDefaultImage];
    }
}

#pragma mark - NSURLConnection delegate methods

//the connection will call this method repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)receivedData 
{	
    if (!responseData) 
    { 
        responseData = [[NSMutableData alloc] initWithCapacity:2048]; 
    }
    
	[responseData appendData:receivedData];
}

//the connection will call this method when all the data has been received from the server.
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection 
{
	[urlConnection release];
	urlConnection=nil;
    
    //subviews count > 0 means there is already another image(previous image) present, In that case remove it.
	if ([[self subviews] count]>0) 
    {
		[[[self subviews] objectAtIndex:0] removeFromSuperview];
	}
    
    
    
    //Create the image from the data
	UIImage *backgroundImage = [UIImage imageWithData:responseData];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imageLoc = [NSString stringWithFormat:@"savedImage%d.png", self.tag];
//
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageLoc];
//    NSData *imageData = UIImagePNGRepresentation(backgroundImage);
//    [imageData writeToFile:savedImagePath atomically:NO];
    
    UIImage *stretchedImage = [backgroundImage stretchableImageWithLeftCapWidth:200 topCapHeight:196];
    
    
    //self.contentMode = UIViewContentModeScaleAspectFit;
    
	[self setImage:stretchedImage forState:UIControlStateNormal];
    [self setImage:stretchedImage forState:UIControlStateHighlighted];
    [self setImage:stretchedImage forState:UIControlStateSelected];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
    if (delegate && [delegate respondsToSelector:@selector(didLoadImage:forIndex:)]) 
    {
        [delegate didLoadImage:backgroundImage forIndex:self.tag];
    }
    
    [responseData release];
    responseData = nil;
	
	//Remove Activity Indicator
	[loadingActivityIndicator removeFromSuperview];
	[loadingActivityIndicator release];
	loadingActivityIndicator=nil;
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self loadDefaultImage];
    
    [responseData release];
    responseData = nil;
	
	//Remove Activity Indicator
	[loadingActivityIndicator removeFromSuperview];
	[loadingActivityIndicator release];
	loadingActivityIndicator=nil;
}


@end
