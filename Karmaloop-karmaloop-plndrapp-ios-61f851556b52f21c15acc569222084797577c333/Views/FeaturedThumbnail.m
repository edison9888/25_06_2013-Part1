//
//  FeaturedThumbnail.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeaturedThumbnail.h"
#import "Utility.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "Constants.h"
#import "Sale.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface FeaturedThumbnail ()
- (void) initSubviews;
- (void) setTimerVisible:(BOOL)visible;
- (void) animateTimerVisible:(BOOL)visible;
+ (CATransform3D) identityWithPerspective;
- (void) performTimerVisibleAnimation:(BOOL)visible;
@end

@implementation FeaturedThumbnail

@synthesize thumbnailImage = _thumbnailImage;
@synthesize thumbnailButton = _thumbnailButton;
@synthesize thumbnailLabelTransparency = _thumbnailOverlay;
@synthesize timerLabel = _timerView;
@synthesize brandNameLabel = _brandNameLabel;
@synthesize timerButton = _timerButton;
@synthesize clockButton = _clockButton;
@synthesize highlightView = _highlightView;
@synthesize endDate = _endDate;
@synthesize thumbnailType = _thumbnailType;
@synthesize remainingSaleTime = _remainingSaleTime;
@synthesize thumbnailDelegate = _thumbnailDelegate;
@synthesize screenshotView = _screenshotView;
@synthesize rotationView = _rotationView;
@synthesize timerFakeClearBackground = _timerFakeClearBackground;
@synthesize screenshotBackgroundView = _screenshotBackgroundView;
@synthesize rotationBackgroundView = _rotationBackgroundView;

- (id)initWithFrame:(CGRect)frame thumbnailType:(ThumbnailType)thumbnailType {
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbnailType = thumbnailType;
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    self.clipsToBounds = NO;
    
    self.thumbnailImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if (self.thumbnailType == Long) {
        self.thumbnailImage.placeholderImage = [UIImage imageNamed:@"Placeholder_310x160.png"];
    } else {
        self.thumbnailImage.placeholderImage = [UIImage imageNamed:@"Placeholder_154x92.png"];
    }
    [self addSubview:self.thumbnailImage];
    
    self.thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];   
    self.thumbnailButton.frame = self.thumbnailImage.frame;
    [self.thumbnailButton addTarget:self action:@selector(displayOverlay) forControlEvents: UIControlEventTouchDragEnter | UIControlEventTouchDown];
    [self.thumbnailButton addTarget:self action:@selector(removeOverlay) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchUpInside];
    [self.thumbnailButton addTarget:self.thumbnailDelegate action:@selector(thumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.thumbnailButton.exclusiveTouch = YES;
    [self addSubview:self.thumbnailButton];
    
    self.thumbnailLabelTransparency = [[UIView alloc] initWithFrame:CGRectMake(0, self.thumbnailImage.frame.origin.y + self.thumbnailImage.frame.size.height - kHomeScreenThumbnailOverlayHeight, self.thumbnailImage.frame.size.width, kHomeScreenThumbnailOverlayHeight)];
    self.thumbnailLabelTransparency.backgroundColor = kHomeTileThumbnailOverlayColor;

    [self addSubview:self.thumbnailLabelTransparency];
    
    self.clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clockButton.frame = CGRectMake(self.thumbnailLabelTransparency.frame.size.width - kMagicButtonHeight, self.thumbnailLabelTransparency.frame.origin.y + self.thumbnailLabelTransparency.frame.size.height - kMagicButtonHeight, kMagicButtonHeight, kMagicButtonHeight);
    [self.clockButton addTarget:self action:@selector(toggleTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.clockButton setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
    self.clockButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -18, -12);

    [self addSubview:self.clockButton];
    
    self.brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHomeScreenThumbnailOverlayInnerMargin, 0, self.thumbnailLabelTransparency.frame.size.width - self.clockButton.frame.size.width, kHomeScreenThumbnailOverlayHeight)];
    self.brandNameLabel.textColor = kPlndrWhite;
    self.brandNameLabel.font = kFontMedium14;
    self.brandNameLabel.backgroundColor = [UIColor clearColor];
    [self.thumbnailLabelTransparency addSubview:self.brandNameLabel];
    
    // Create the rotation views
    self.timerFakeClearBackground = [[UIView alloc] initWithFrame:self.thumbnailLabelTransparency.frame];
    self.timerFakeClearBackground.backgroundColor = kPlndrBgGrey;
    
    self.timerLabel = [[OHAttributedLabel alloc] initWithFrame: CGRectMake(0, 0, self.thumbnailLabelTransparency.frame.size.width - kHomeScreenThumbnailOverlayInnerMargin, self.thumbnailLabelTransparency.frame.size.height)];
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.centerVertically = YES;
    self.timerLabel.automaticallyAddLinksForType = 0;

    self.timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timerButton.frame = CGRectMake(0, self.thumbnailLabelTransparency.frame.origin.y - (kMagicButtonHeight - kHomeScreenThumbnailOverlayHeight), self.thumbnailLabelTransparency.frame.size.width, kMagicButtonHeight);
    [self.timerButton addTarget:self action:@selector(toggleTimer) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.timerFakeClearBackground addSubview:self.timerLabel];
    [self addSubview:self.timerFakeClearBackground];
    [self addSubview:self.timerButton];
    
    self.screenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.thumbnailLabelTransparency.frame.size.height, self.thumbnailLabelTransparency.frame.size.width, self.thumbnailLabelTransparency.frame.size.height)];
    self.screenshotView.clipsToBounds = NO;
    self.rotationView = [[UIView alloc] initWithFrame:CGRectMake(self.thumbnailLabelTransparency.frame.origin.x, 
                                                                self.thumbnailLabelTransparency.frame.origin.y - self.thumbnailLabelTransparency.frame.size.height,
                                                                self.thumbnailLabelTransparency.frame.size.width,
                                                                 self.thumbnailLabelTransparency.frame.size.height * 2)];
    self.rotationView.userInteractionEnabled = NO;
    self.rotationView.clipsToBounds = NO;
    self.rotationView.layer.doubleSided = NO;
    [self.rotationView addSubview:self.screenshotView];
    
    
    // The screenshotBackgroundView and rotationBackgroundView are for the gold backside of the timer flap.
    self.screenshotBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenshotView.frame.size.width, self.screenshotView.frame.size.height)];
    self.screenshotBackgroundView.backgroundColor = kFlipBackgroundColor;
    self.screenshotBackgroundView.clipsToBounds = NO;
    
    self.rotationBackgroundView = [[UIView alloc] initWithFrame:self.rotationView.frame];
    self.rotationBackgroundView.userInteractionEnabled = NO;
    self.rotationBackgroundView.clipsToBounds = NO;
    self.rotationBackgroundView.layer.doubleSided = NO;
    [self.rotationBackgroundView addSubview:self.screenshotBackgroundView];
    
    [self addSubview:self.rotationBackgroundView];
    [self addSubview:self.rotationView];
    
    self.highlightView = [[UIView alloc] init];
    self.highlightView.frame = self.thumbnailImage.frame;
    self.highlightView.backgroundColor = kTileHighlightColor;
    self.highlightView.hidden = YES;
    [self addSubview:self.highlightView];
}

- (void)updateWithSale:(Sale *)sale tag:(int)tag {
    self.hidden = NO; // incase we were hidden previously in a double cell
    
    self.thumbnailButton.tag = tag;
    self.endDate = sale.endDate;
    self.brandNameLabel.text = sale.name;
    if (self.thumbnailType == Long) {
        [self.thumbnailImage loadImageFromUrl:sale.tileImagePathLarge sizedForFrame:YES];
    } else {
        [self.thumbnailImage loadImageFromUrl:sale.tileImagePathMedium sizedForFrame:YES];
    }
    [self setTimerVisible:[self.thumbnailDelegate isTimerShowing:self.thumbnailButton.tag]];
}

- (void) updateTimer {
    NSString *redTxt = @"";
    RemainingSaleTime remainingSaleTime = RemainingSaleTimeLots;
    
    NSString *txt = [Utility stringForSaleEndDate:self.endDate textToMakeRed:&redTxt remainingSaleTime:&remainingSaleTime];
    
    // Update the clock image, if necessary
    if (remainingSaleTime == RemainingSaleTimeLots && self.remainingSaleTime != RemainingSaleTimeLots) {
        [self.clockButton setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal]; 
    } else if (remainingSaleTime == RemainingSaleTimeLittle && self.remainingSaleTime != RemainingSaleTimeLittle) {
        [self.clockButton setImage:[UIImage imageNamed:@"time_hl.png"] forState:UIControlStateNormal];
    } else if (remainingSaleTime == RemainingSaleTimeNone && self.remainingSaleTime != RemainingSaleTimeNone) {
        [self.clockButton setImage:[UIImage imageNamed:@"icon_expired.png"] forState:UIControlStateNormal];
    }
    self.remainingSaleTime = remainingSaleTime;
    
    if (!self.timerLabel.hidden) {
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
        [attrStr setFont:kFontHomeViewTimer];
        [attrStr setTextColor:kPlndrMediumGreyTextColor];

        // possibly make the timer red
        [attrStr setTextColor:kPlndrTextRed range:[txt rangeOfString:redTxt]];

        self.timerLabel.attributedText = attrStr;
        self.timerLabel.textAlignment = UITextAlignmentRight;
        self.timerLabel.shadowColor = [UIColor whiteColor];
        self.timerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
}

- (void) displayOverlay {
    self.highlightView.hidden = NO;
}

- (void) removeOverlay {
    self.highlightView.hidden = YES;
}

- (void) toggleTimer {
    [self.thumbnailDelegate toggleTimer:self.thumbnailButton.tag];
    
    [self animateTimerVisible:[self.thumbnailDelegate isTimerShowing:self.thumbnailButton.tag]];
}

- (void)setTimerVisible:(BOOL)visible {
    
    if (visible) {
        self.timerFakeClearBackground.hidden = NO;
        self.timerButton.hidden = NO;
        self.screenshotView.hidden = NO;
        self.screenshotBackgroundView.hidden = NO;
        
        self.brandNameLabel.hidden = YES;
        self.clockButton.hidden = YES;

        CATransform3D transform = CATransform3DRotate([FeaturedThumbnail identityWithPerspective], kTimerRotationInRadians, 1.0, 0.0f, 0.0f);
        self.rotationView.layer.transform = transform;
        
        CATransform3D upsideDownTransform = CATransform3DRotate(transform, 2*k90DegreesInRadians, 1.0f, 0.0f, 0.0f );
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
        
    } else {
        self.timerFakeClearBackground.hidden = YES;
        self.timerButton.hidden =YES;
        self.screenshotView.hidden = YES;
        self.screenshotBackgroundView.hidden = YES;
        
        self.brandNameLabel.hidden = NO;
        self.clockButton.hidden = NO;
 
        CATransform3D transform = [FeaturedThumbnail identityWithPerspective];
        self.rotationView.layer.transform = transform;
        
        CATransform3D upsideDownTransform = CATransform3DRotate(transform, 2*k90DegreesInRadians, 1.0f, 0.0f, 0.0f);
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
    }

    [self updateTimer];
}

- (void)animateTimerVisible:(BOOL)visible {
    if (visible) {
        // snap the whole frame
        UIGraphicsBeginImageContext(self.frame.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *preCropImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // crop the part we want
        CGImageRef imageRef = CGImageCreateWithImageInRect([preCropImage CGImage], self.thumbnailLabelTransparency.frame);
        self.screenshotView.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);

    }
    
    [self performTimerVisibleAnimation:visible];
}

+ (CATransform3D)identityWithPerspective {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    return transform;
}

- (void)performTimerVisibleAnimation:(BOOL)visible { 
    self.screenshotView.hidden = NO;
    self.screenshotBackgroundView.hidden = NO;
    self.timerFakeClearBackground.hidden = NO;
    self.timerButton.hidden = NO;
    
    double radians = kTimerRotationInRadians;
    radians = visible ? radians : radians * -1;

    CATransform3D transform = CATransform3DRotate(self.rotationView.layer.transform, radians, 1.0f, 0.0f, 0.0f);
    CATransform3D upsideDownTransform = CATransform3DRotate(self.rotationBackgroundView.layer.transform, radians, 1.0f, 0.0f, 0.0f);
    
    [UIView animateWithDuration:kTimerAnimationDuration animations:^ (void) {
        self.rotationView.layer.transform = transform;
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
    } completion:^ (BOOL isComplete) {
        [self setTimerVisible:visible];
    }];
    
}

@end
