//
//  ShareView.m
//  ElDiario
//
//  Created by NaveenShan on 10/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareView.h"

static CGFloat kFacebookBlue[4] = {0.42578125, 0.515625, 0.703125, 1.0};
static CGFloat kTwitterBlue[4] = {0.333333, 0.6, 0.733333, 1.0};
static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kBorderBlue[4] = {0.23, 0.35, 0.6, 1.0};

static CGFloat kTransitionDuration = 0.3;

static CGFloat kTitleMarginX = 8;
static CGFloat kTitleMarginY = 10;
static CGFloat kBorderWidth = 0;

static CGFloat kPadding = 0;

@implementation ShareView


- (id)initWithFrame:(CGRect)frame ShareType:(ShareType)itype andSubView:(UIView *)view {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		m_ShareType = itype;
		_subView = view;
		[_subView retain];
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange:)
                                                     name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
	CGRect grayRect = CGRectOffset(rect, -0.5, -0.5);
	[self drawRect:grayRect fill:kBorderGray radius:10];
	
	CGRect headerRect = CGRectMake(
								   ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth),
								   rect.size.width - kBorderWidth*2, _titleLabel.frame.size.height);
	if (m_ShareType == faceBook) {
		[self drawRect:headerRect fill:kFacebookBlue radius:0];
	}
	else {
		[self drawRect:headerRect fill:kTwitterBlue radius:0];
	}

	[self strokeLines:headerRect stroke:kBorderBlue];
	
	CGRect viewRect = CGRectMake(
								ceil(rect.origin.x + kBorderWidth), headerRect.origin.y + headerRect.size.height,
								rect.size.width - kBorderWidth*2, _subView.frame.size.height+1);
	[self strokeLines:viewRect stroke:kBorderBlack];	
	 
}

#pragma mark -

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if (fillColors) {
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		if (radius) {
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextFillPath(context);
		} else {
			CGContextFillRect(context, rect);
		}
		CGContextRestoreGState(context);
	}
	
	CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
    
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y-0.5,
			rect.origin.x+rect.size.width, rect.origin.y-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5,
			rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+rect.size.width-0.5, rect.origin.y,
			rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y,
			rect.origin.x+0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
}

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	if (radius == 0) {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	} else {
		rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
		CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
		CGContextScaleCTM(context, radius, radius);
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

#pragma mark orientation handles

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIDeviceOrientationLandscapeLeft
        || orientation == UIDeviceOrientationLandscapeRight
        || orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

- (CGAffineTransform)transformForOrientation {
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

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat width = frame.size.width - kPadding * 2;
    CGFloat height = frame.size.height - kPadding * 2;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, (width), (height));
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
    UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([self shouldRotateToOrientation:orientation]) { //!_showingKeyboard && 
       // [self updateWebOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}


#pragma mark bounce handles

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

#pragma mark -

-(void)load	{
	
	CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;  
	
	self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
	
    
    UIImage* iconImage;
    UIImage* closeImage = [UIImage imageNamed:@"close.png"];
	
	if (m_ShareType == faceBook) {
		iconImage = [UIImage imageNamed:@"FBConnect.bundle/images/fbicon.png"];
	}
	else {
		iconImage = [UIImage imageNamed:@"twittericon.png"];
	}
    
    _iconView = [[UIImageView alloc] initWithImage:iconImage];
    [self addSubview:_iconView];
    
  // UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
    UIColor *color = [UIColor redColor];
    _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    //_closeButton.backgroundColor   = [UIColor redColor];
    [_closeButton setImage:closeImage forState:UIControlStateNormal];
    [_closeButton setTitleColor:color forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(cancel)
		   forControlEvents:UIControlEventTouchUpInside];
	if ([_closeButton respondsToSelector:@selector(titleLabel)]) {
		_closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	} 
	_closeButton.showsTouchWhenHighlighted = YES;
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
	| UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_closeButton];	
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	if (m_ShareType == faceBook) {
		_titleLabel.text = @"Facebook";
	}
	else {
		_titleLabel.text = @"Twitter";
	}
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_titleLabel];
	
	
	_subView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_subView];
	
	
	_titleLabel.frame = CGRectMake(
								   kBorderWidth + kTitleMarginX + _iconView.frame.size.width + kTitleMarginX,
								   kBorderWidth,
								   innerWidth - (_titleLabel.frame.size.height + _iconView.frame.size.width + kTitleMarginX*2),
								   _titleLabel.frame.size.height + kTitleMarginY*2);
	
	_iconView.frame = CGRectMake(
								 kBorderWidth + kTitleMarginX,
								 kBorderWidth + floor(_titleLabel.frame.size.height/2 - _iconView.frame.size.height/2),
								 _iconView.frame.size.width,
								 _iconView.frame.size.height);
   
	
	_closeButton.frame = CGRectMake(
									self.frame.size.width - (_titleLabel.frame.size.height + (2*kBorderWidth)+15),
									kBorderWidth,
									(_titleLabel.frame.size.height + kBorderWidth+15),
									_titleLabel.frame.size.height);
	
	_subView.frame = CGRectMake(
								kBorderWidth+1,
								kBorderWidth + _titleLabel.frame.size.height,
								innerWidth,
								self.frame.size.height - (_titleLabel.frame.size.height + 1 + kBorderWidth*2));
	
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	[window addSubview:self];
    
    [self sizeToFitOrientation:YES];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)cancel {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self removeFromSuperview];
}

#pragma mark - Memory Handles

- (void)dealloc {

	[_subView release];
	[_titleLabel release];
	[_iconView release];
	[_closeButton release];

	[super dealloc];
}


@end
