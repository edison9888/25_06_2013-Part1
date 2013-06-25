//
//  FeaturedThumbnail.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	Short,
    Long
} ThumbnailType;

typedef enum {
    RemainingSaleTimeUnknown,
    RemainingSaleTimeLots,
    RemainingSaleTimeLittle,
    RemainingSaleTimeNone
} RemainingSaleTime;

@protocol FeaturedThumbnailDelegate <NSObject>

- (void) toggleTimer:(int)senderId;
- (BOOL) isTimerShowing:(int)senderId;
- (void) thumbnailClicked:(id)sender;

@end

@class AsyncImageView, OHAttributedLabel, Sale;

@interface FeaturedThumbnail : UIView

@property (nonatomic, strong) AsyncImageView *thumbnailImage;
@property (nonatomic, strong) UIButton *thumbnailButton;
@property (nonatomic, strong) UIView *thumbnailLabelTransparency;
@property (nonatomic, strong) OHAttributedLabel *timerLabel;
@property (nonatomic, strong) UILabel *brandNameLabel;
@property (nonatomic, strong) UIButton *timerButton;
@property (nonatomic, strong) UIButton *clockButton;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) NSDate *endDate;
@property ThumbnailType thumbnailType;
@property RemainingSaleTime remainingSaleTime;
@property (nonatomic, weak) id<FeaturedThumbnailDelegate> thumbnailDelegate;

// Views for handling clock rotation
@property (nonatomic, strong) UIImageView *screenshotView;
@property (nonatomic, strong) UIView *rotationView;
@property (nonatomic, strong) UIView *screenshotBackgroundView;
@property (nonatomic, strong) UIView *rotationBackgroundView;
@property (nonatomic, strong) UIView *timerFakeClearBackground;

- (id) initWithFrame:(CGRect)frame thumbnailType:(ThumbnailType)thumbnailType;

- (void) updateTimer;
- (void) displayOverlay;
- (void) removeOverlay;
- (void) toggleTimer;
- (void) updateWithSale:(Sale*)sale tag:(int)tag;
@end
