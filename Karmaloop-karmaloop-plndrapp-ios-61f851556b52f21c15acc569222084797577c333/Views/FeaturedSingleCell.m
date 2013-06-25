//
//  FeaturedSingleCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeaturedSingleCell.h"
#import "Constants.h"
#import "FeaturedThumbnail.h"

@interface FeaturedSingleCell ()
- (void)initSubviews;
@end

@implementation FeaturedSingleCell

@synthesize thumbnail = _thumbnail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.thumbnail = [[FeaturedThumbnail alloc] initWithFrame:CGRectMake((kDeviceWidth - kHomeLongTileImageWidth)/2, (kHomeLongTileCellHeight - kHomeLongTileImageHeight)/2, kHomeLongTileImageWidth, kHomeLongTileImageHeight) thumbnailType:Long];
    
    [self.contentView addSubview:self.thumbnail];
}

- (void) updateClock {
    [self.thumbnail updateTimer];
}

@end