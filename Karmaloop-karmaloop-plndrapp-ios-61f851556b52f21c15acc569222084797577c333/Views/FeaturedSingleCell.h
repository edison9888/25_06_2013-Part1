//
//  FeaturedSingleCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeaturedThumbnail;

@interface FeaturedSingleCell : UITableViewCell

@property (nonatomic, strong) FeaturedThumbnail *thumbnail;

- (void) updateClock;

@end
