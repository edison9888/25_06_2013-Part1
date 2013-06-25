//
//  TDMOverlayView.m
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMOverlayView.h"

@interface UILabel (Allignment)
-(void)alignWithText;
@end

@implementation UILabel (Allignment)

-(void)alignWithText    {
    
    //current label frame,
    //to ensure the label frame is not alter above this value.
	CGSize labelSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
	//to find size of label that need to include its text.
	CGSize thelabelSize = [self.text sizeWithFont:self.font constrainedToSize:labelSize lineBreakMode:self.lineBreakMode];
    //set the label with new frame.
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, thelabelSize.height);
}

@end

#pragma mark -

@implementation TDMOverlayView


#pragma mark Orientation Handles

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == _orientation)
    {
        return NO;
    }
    else
    {
        return orientation == UIDeviceOrientationLandscapeLeft
        || orientation == UIDeviceOrientationLandscapeRight
        || orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform
{
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(0, 0, height, width);
    } else {
        self.frame = CGRectMake(0, 0, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

#pragma mark UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([self shouldRotateToOrientation:orientation]) {
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

#pragma mark -

//default - with a "Loading" title and indicator, not prevent actions until dismiss.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor darkGrayColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, ((self.frame.size.height/2) +20), self.frame.size.width, 20)];
        
        label.numberOfLines=1;
        label.tag = 9696;
        label.lineBreakMode=UILineBreakModeWordWrap;
        label.textAlignment = UITextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [label setText:@""];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];	
        [label release];
        label=nil;
        
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setFrame:CGRectMake(((self.frame.size.width/2) -19), ((self.frame.size.height/2) -30), 37, 37)];
        activityIndicator.tag = 8686;
        [activityIndicator setHidesWhenStopped:NO];
        
        [self addSubview:activityIndicator];
        [self bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicator release];
        activityIndicator = nil;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor darkGrayColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, ((self.frame.size.height/2) +20), self.frame.size.width, ((self.frame.size.height/2) -20))];
        
        label.numberOfLines = 0;
        label.tag = 9696;
        label.lineBreakMode=UILineBreakModeWordWrap;
        label.textAlignment = UITextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [label setText:title];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        [self addSubview:label];	
        [label release];
        label=nil;
        
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setFrame:CGRectMake(((self.frame.size.width/2) -19), ((self.frame.size.height/2) -30), 37, 37)];
        activityIndicator.tag = 8686;
        [activityIndicator setHidesWhenStopped:NO];
        
        [self addSubview:activityIndicator];
        [self bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicator release];
        activityIndicator = nil;
        
    }
    return self;
}

//with a title, indicator and progress bar, not prevent actions until dismiss.
- (id)initWithFrame:(CGRect)frame  Title:(NSString *)title AndProgress:(UIProgressView *)progressView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor darkGrayColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, ((self.frame.size.height/2)), self.frame.size.width, 20)];
        
        label.numberOfLines=1;
        label.lineBreakMode=UILineBreakModeWordWrap;
        label.textAlignment = UITextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [label setText:title];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];	
        [label release];
        label=nil;
        
        title = nil;
        
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setFrame:CGRectMake(((self.frame.size.width/2) -19), ((self.frame.size.height/2) -40), 37, 37)];
        activityIndicator.tag = 8686;
        [activityIndicator setHidesWhenStopped:NO];
        
        [self addSubview:activityIndicator];
        [self bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicator release];
        activityIndicator = nil;
        
        progressView.frame = CGRectMake(10, (self.frame.size.height -20) ,(self.frame.size.width -20), 10);
        [self addSubview:progressView];
        
    }
    return self;
}

//with a "Loading" title and indicator, prevent actions until dismiss.
-(id)initWithSyncStyleAndTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        
        overLayView.layer.cornerRadius = 8.0;
        overLayView.tag = 5656;
        overLayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
        overLayView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        overLayView.center = self.center;
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, ((overLayView.frame.size.height/2) +20), (overLayView.frame.size.width - 10), 60)];
        
        label.numberOfLines = 0;
        label.tag = 9696;
        label.font = [UIFont fontWithName:@"Trebuchet MS" size:15];
        label.lineBreakMode=UILineBreakModeWordWrap;
        label.textAlignment = UITextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [label setText:title];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label alignWithText];
        
        [overLayView addSubview:label];	
        [label release];
        label=nil;
        
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setFrame:CGRectMake(((overLayView.frame.size.width/2) -19), ((overLayView.frame.size.height/2) -30), 37, 37)];
        activityIndicator.tag = 8686;
        [activityIndicator setHidesWhenStopped:NO];
        
        [overLayView addSubview:activityIndicator];
        [overLayView bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicator release];
        activityIndicator = nil;
        
        //a work around to remove un-wanted subview in top left corner.
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self addSubview:overLayView];
        [overLayView release];
        overLayView = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange:)
                                                     name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window addSubview:self];
        
        [window bringSubviewToFront:self];
        
        [self sizeToFitOrientation:YES];
    }
    return self;
}

#pragma mark - @Overrides

-(void)setTitle:(NSString *)title
{
    if ([NSThread isMainThread])
    {
        UILabel *titleLabel = (UILabel *)[self viewWithTag:9696];
        
        if (titleLabel)
        {
            UIView *overLayView = (UIView *)[self viewWithTag:5656];
            [titleLabel setText:title];
            [titleLabel setFrame:CGRectMake(5, (70), (overLayView.frame.size.width - 10), 60)];
            [titleLabel alignWithText];
            
            int height = titleLabel.frame.size.height;
            
            overLayView.frame = CGRectMake(0, 0, 200, (80 + height));
            if (UIInterfaceOrientationIsLandscape(_orientation)) {
                overLayView.center = CGPointMake(512, 374);
            }
            else
            {
                overLayView.center = CGPointMake(160, 230);
            }
            
            [self setNeedsLayout];
            [self setNeedsDisplay];
            
            //For fixing overlay text not changing issue.   
            //Reference:http://stackoverflow.com/questions/6835472/uilabel-text-not-being-updated
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];   
        }
	}
    else
    {
        [self performSelectorOnMainThread:@selector(setTitle:) withObject:title waitUntilDone:NO];
	}
}

-(void)startAnimating
{
    if ([NSThread isMainThread])
    {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:8686];
        if (indicator)
        {
            [indicator startAnimating];
            [self setNeedsDisplay];
        }
	}
    else
    {
        [self performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
	}
}

-(void)stopAnimating
{
    if ([NSThread isMainThread])
    {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:8686];
        if (indicator)
        {
            [indicator stopAnimating];
            [self setNeedsDisplay];
        }
	}
    else
    {
        [self performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
	}
}

#pragma mark -
- (void)dealloc
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [super dealloc];
}

@end