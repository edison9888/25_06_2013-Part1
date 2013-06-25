//
//  TQCategory.m
//  Torq361
//
//  Created by Jayahari V on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TQCategory.h"
#import "TQDirectoryPaths.h"
#import "Torq361AppDelegate.h"
#import "Home.h"

@interface TQCategory (Private)
- (void)showImage;
- (void)isSelected:(BOOL)selected;
@end

@implementation TQCategory

@synthesize imageView, title;
@synthesize indicator;
@synthesize category;

NSString * kTQCategoryBackgroundImage = @"SmallPhotoFrame";
NSString * kTQCategoryBackgroundSelectedImage = @"SmallPhotoFrameSelected";

int kBackgroundImageTag = 101;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCategoryDetails:(CategoryDetails*)categoryDetails {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        
        //self size -> width is 150: height is 145
        self.category = categoryDetails;
           
        //background image
        CGRect backgroundViewFrames = CGRectMake(0, 0, 150, 147);
        UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:backgroundViewFrames];
        [backgroundView setContentMode:UIViewContentModeScaleAspectFit];
        NSString * pathForBackgroundImage = [[NSBundle mainBundle] pathForResource:kTQCategoryBackgroundImage ofType:kImageType];
        UIImage * backgroundImage = [[UIImage alloc] initWithContentsOfFile:pathForBackgroundImage];
        [backgroundView setTag:kBackgroundImageTag];
        [backgroundView setImage:backgroundImage];
        [backgroundImage release];
        [self addSubview:backgroundView];
        [backgroundView release];

        //image to display for each category
        CGRect imageViewFrames = CGRectMake(20, 20, 110, 90);
        UIImageView* tempImageView = [[UIImageView alloc] initWithFrame:imageViewFrames];
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:tempImageView];
        [tempImageView setBackgroundColor:[UIColor clearColor]];
        self.imageView = tempImageView;
        [tempImageView release];
        
        CGRect indicatorFrames = CGRectMake(60, 50, 25, 25);
        UIActivityIndicatorView * indicatorView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [indicatorView setFrame:indicatorFrames];
        [self addSubview:indicatorView];
        [indicatorView startAnimating];
        
        self.indicator = indicatorView;
        [indicatorView release];
        
        [self showImage];
        
        //title
        CGRect titleFrames = CGRectMake(20, 112, 110, 16);
        UILabel* tempTitle = [[UILabel alloc] initWithFrame:titleFrames];
        [tempTitle setTextAlignment:UITextAlignmentCenter];
        [tempTitle setText:self.category.Name];
        [tempTitle setBackgroundColor:[UIColor clearColor]];
        [tempTitle setFont:[UIFont boldSystemFontOfSize:12.0]];
        [tempTitle setNumberOfLines:1];
        [self addSubview:tempTitle];
        self.title = tempTitle;
        [tempTitle release];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
    }    
    return self;
}

- (void)showImage {
    NSArray *objExtension = [self.category.ThumbNailImgPath componentsSeparatedByString:@"/"];
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
        NSString *imagePath = [TQDirectoryPaths downloadedCategoryImagesDirectory];
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self isSelected:YES];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self isSelected:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self isSelected:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self isSelected:YES];   
}

- (void)onTouchCategory:(UIGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        Torq361AppDelegate *appDelegate=(Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.home performSelector:@selector(hideMainCategorySelection:) 
                               withObject:self.category.idCategory 
                               afterDelay:0.1];
    }  

    
}

- (void)isSelected:(BOOL)selected {
    if (selected) {
        UIImageView * backgroundImageView = (UIImageView*)[self viewWithTag:kBackgroundImageTag];
        NSString * pathForBackgroundImage = [[NSBundle mainBundle] pathForResource:kTQCategoryBackgroundSelectedImage ofType:kImageType];
        UIImage * backgroundImage = [[UIImage alloc] initWithContentsOfFile:pathForBackgroundImage];
        backgroundImageView.image = backgroundImage;
        [backgroundImage release];

    }
    else {
        UIImageView * backgroundImageView = (UIImageView*)[self viewWithTag:kBackgroundImageTag];
        NSString * pathForBackgroundImage = [[NSBundle mainBundle] pathForResource:kTQCategoryBackgroundImage ofType:kImageType];
        UIImage * backgroundImage = [[UIImage alloc] initWithContentsOfFile:pathForBackgroundImage];
        backgroundImageView.image = backgroundImage;
        [backgroundImage release];
    }
}

- (void)dealloc
{
    NSLog(@"Deallocating TQCategory");
    self.imageView = nil;
    self.title = nil;
    self.indicator = nil;
    self.category = nil;
    [super dealloc];
}

@end
