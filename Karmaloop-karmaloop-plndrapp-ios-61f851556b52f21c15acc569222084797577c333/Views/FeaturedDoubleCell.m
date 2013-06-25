//
//  FeaturedDoubleCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeaturedDoubleCell.h"
#import "Constants.h"
#import "FeaturedThumbnail.h"

@interface FeaturedDoubleCell ()
- (void)initSubviews;
@end

@implementation FeaturedDoubleCell

@synthesize leftThumbnail = _leftThumbnail;
@synthesize rightThumbnail = _rightThumbnail;

- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int horizontalCellMargin = (kDeviceWidth - kHomeLongTileImageWidth)/2;
    
    self.leftThumbnail = [[FeaturedThumbnail alloc] initWithFrame:CGRectMake(horizontalCellMargin, (kHomeShortTileCellHeight - kHomeShortTileImageHeight)/2, kHomeShortTileImageWidth, kHomeShortTileImageHeight) thumbnailType:Short];
    [self.contentView addSubview:self.leftThumbnail];

    self.rightThumbnail = [[FeaturedThumbnail alloc] initWithFrame:CGRectMake(kDeviceWidth - horizontalCellMargin - self.leftThumbnail.frame.size.width, (kHomeShortTileCellHeight - kHomeShortTileImageHeight)/2, kHomeShortTileImageWidth, kHomeShortTileImageHeight) thumbnailType:Short];
    [self.contentView addSubview:self.rightThumbnail];
}

- (void)updateClock {
    [self.leftThumbnail updateTimer];
    [self.rightThumbnail updateTimer];
}

@end