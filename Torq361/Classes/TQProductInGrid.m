//
//  TQProductInGrid.m
//  Torq361
//
//  Created by Jayahari V on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TQProductInGrid.h"
#import "TQDirectoryPaths.h"
#import "Torq361AppDelegate.h"
#import "Home.h"

@interface TQProductInGrid (Private)
- (void)showBackgroundImage;
- (void)showActivityIndicator;
- (void)showImage;
- (void)showBanner;
- (void)showName;
- (void)showDescription;
@end

@implementation TQProductInGrid

@synthesize product;
@synthesize indicator;

NSString * kTQProductInGridBackgroundImage = @"PhotoFrame";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithProductDetail:(ProductDetails*)productDetail {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        
        self.product = productDetail;
        [self showBackgroundImage];
        [self showActivityIndicator];
        [self showImage];
        //[self showBanner];
        [self showName];
        [self showDescription];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;    
}
- (void)dealloc
{
    self.product = nil;
    self.indicator = nil;
    
    [super dealloc];
}

- (void)onTouchProduct:(id)sender {
    
    Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.home productDidSelectedWithProductID:[self.product.idProduct intValue]];
}

- (void)showBackgroundImage {
    //background image
    CGRect backgroundViewFrames = CGRectMake(0, 0, 212, 250);
    UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:backgroundViewFrames];
    [backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    NSString * pathForBackgroundImage = 
    [[NSBundle mainBundle] pathForResource:kTQProductInGridBackgroundImage 
                                    ofType:kImageType];
    UIImage * backgroundImage = [[UIImage alloc] initWithContentsOfFile:pathForBackgroundImage];
    [backgroundView setImage:backgroundImage];
    [backgroundImage release];
    [self addSubview:backgroundView];
    [backgroundView release];
}

- (void)showActivityIndicator {
    CGRect indicatorFrames = CGRectMake(94, 93, 25, 25);
    UIActivityIndicatorView * indicatorView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicatorView setFrame:indicatorFrames];
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    
    self.indicator = indicatorView;
    [indicatorView release];

}

- (void)showImage {
    
    //image to display for each product
    CGRect imageViewFrames = CGRectMake(5, 5, 200, 200);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageViewFrames];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];
    [imageView setBackgroundColor:[UIColor clearColor]];
    
        
    NSArray *objExtension = [self.product.ThumbNailImgPath componentsSeparatedByString:@"/"];
    NSString *thumpName=[objExtension lastObject];
    if([thumpName isEqualToString:@""]){
        [self.indicator stopAnimating];
        self.indicator.hidden=YES;
        NSString * pathForBackgroundImage = [[NSBundle mainBundle] pathForResource:kDefaultDisplayImage ofType:kImageType];
        UIImage * displayImage = [[UIImage alloc] initWithContentsOfFile:pathForBackgroundImage];
        imageView.image = displayImage;
        [displayImage release];
    }
    else {
        NSString *imagePath = [TQDirectoryPaths downloadedProductImagesDirectory];
        imagePath = [imagePath stringByAppendingFormat:@"/%@",[objExtension lastObject]];
        
        UIImage *thumpimage = [[UIImage alloc] initWithContentsOfFile:imagePath];
        if(thumpimage){
            imageView.image=thumpimage;
            [self.indicator stopAnimating];
            self.indicator.hidden=YES;
        }
        else{
            [self.indicator startAnimating];
            self.indicator.hidden=NO;
        }
        [thumpimage release];
    }
    
    [imageView release];
}

- (void)showBanner {
    //Banner to display for each product
    CGRect bannerFrames = CGRectMake(0, 0, 60, 60);
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:bannerFrames];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];
    [imageView setBackgroundColor:[UIColor clearColor]];

    NSString * pathToBannerImage;
    if ([self.product.newStatus isEqualToString:@"Y"]) {
        pathToBannerImage  = [[NSBundle mainBundle] pathForResource:kNewBanner ofType:kImageType];
    }
    else {
        pathToBannerImage  = [[NSBundle mainBundle] pathForResource:kTick ofType:kImageType];
    }
    
    UIImage * bannerImage = [[UIImage alloc] initWithContentsOfFile:pathToBannerImage];
    imageView.image = bannerImage;
    
    [imageView release];
    imageView = nil;
}

- (void)showName {
    //name
    CGRect nameFrames = CGRectMake(5, 205, 200, 20);
    UILabel* tempname = [[UILabel alloc] initWithFrame:nameFrames];
    [tempname setTextAlignment:UITextAlignmentCenter];
    [tempname setText:self.product.Name];
    //NSLog(@"Product Name : %@", tempname.text);
    [tempname setBackgroundColor:[UIColor clearColor]];
    [tempname setFont:[UIFont boldSystemFontOfSize:18.0]];
    [tempname setTextColor:[UIColor darkTextColor]];
    [tempname setNumberOfLines:1];
    [self addSubview:tempname];
    [tempname release];
}

- (void)showDescription {
    //Description
    CGRect descriptionFrames = CGRectMake(5, 225, 200, 14);
    UILabel* tempDescription = [[UILabel alloc] initWithFrame:descriptionFrames];
    [tempDescription setTextAlignment:UITextAlignmentCenter];
    [tempDescription setText:self.product.Description];
    [tempDescription setBackgroundColor:[UIColor clearColor]];
    [tempDescription setFont:[UIFont systemFontOfSize:12.0]];
    [tempDescription setNumberOfLines:1];
    [tempDescription setTextColor:[UIColor grayColor]];
    [self addSubview:tempDescription];
    [tempDescription release];
}

@end
