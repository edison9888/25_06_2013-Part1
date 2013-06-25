//
//  RBAsyncImage.m
//  Red Beacon
//
//  Created by sudeep on 06/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "TDMAsyncImage.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>


#define ACTIVITYINDICATOR_TAG 999
#define ACTIVITY_FRAME CGRectMake(30, 35, 10, 10)
#define ACTIVITY_FRAME_NOT_HOME CGRectMake(33, 30, 10, 10)
#define VIDEO_THUMBNAIL_FRAME CGRectMake(12, 12, 20, 20)
#define VIDEO_THUMBNAIL_TAG 998
#define VIDEO_THUMBNAIL_IMAGE @"videoPlayerPlayButton.png"

@implementation TDMAsyncImage

@synthesize onReady;
@synthesize target;
@synthesize channelDetail;

-(void)showVideoIcon {
    
   UIImageView *imageThumbnail=[[UIImageView alloc]init];
   imageThumbnail.frame=VIDEO_THUMBNAIL_FRAME;
   imageThumbnail.tag = VIDEO_THUMBNAIL_TAG;
   //imageThumbnail.center=self.center;
   imageThumbnail.backgroundColor=[UIColor clearColor];
   imageThumbnail.image=[UIImage imageNamed:VIDEO_THUMBNAIL_IMAGE]; 
   [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
   [self addSubview:imageThumbnail];
   [imageThumbnail release];
   imageThumbnail=nil;
}


-(void)loadExistingImage:(UIImage *)image {
    
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImageView* imageView = [[[UIImageView alloc] init] autorelease];
    imageView.frame = CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4); 
    imageView.image = image; 
    imageView.layer.borderWidth=0.7f;
    imageView.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:imageView];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}

- (void)loadImageFromURL:(NSURL*)url isFromHome:(BOOL)isHome{
    
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 0.7f;
          
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=ACTIVITY_FRAME;
    activityIndicator.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //activityIndicator.color  =[UIColor blackColor];

    activityIndicator.tag = ACTIVITYINDICATOR_TAG;
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
    
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { data = nil; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:30.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImage *imageFromDate = [[UIImage alloc] initWithData:data]; 
    UIImage *image = [imageFromDate resizedImage:CGSizeMake(self.frame.size.width-2, self.frame.size.height-8)];
    channelDetail.channelIcon = image;

    if(data.length > 300){
        UIImageView* imageView = [[[UIImageView alloc] init] autorelease];
        imageView.frame = CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4); 
        imageView.image = [UIImage imageWithData:data];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:imageView];
        [imageView setNeedsLayout];
        [self setNeedsLayout];
        
           }
    else{
        UIImage *image = [UIImage imageNamed:@"imageNotAvailable"];
        [self loadExistingImage:image];
        channelDetail.channelIcon = image;
    }
    
    
    [imageFromDate release];
      // save the image to avoid multiple downloads
    
    [data release];
    data=nil;
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITYINDICATOR_TAG];
    [activity removeFromSuperview];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [connection release];
    connection=nil;
    NSLog(@"From AsyncImage, Error description : %@",[error description]);
    UIImage *image = [UIImage imageNamed:@"imageNotAvailable"];
    [self loadExistingImage:image];
 
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITYINDICATOR_TAG];
    [activity removeFromSuperview];
}
    
- (UIImage*)image
{
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
    
    //self.channelDetail=nil;
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

@end