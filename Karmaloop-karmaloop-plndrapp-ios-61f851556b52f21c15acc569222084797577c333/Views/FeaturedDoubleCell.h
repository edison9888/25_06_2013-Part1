//
//  FeaturedDoubleCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedSingleCell.h"

@interface FeaturedDoubleCell : FeaturedSingleCell

@property (nonatomic, strong) FeaturedThumbnail *leftThumbnail;
@property (nonatomic, strong) FeaturedThumbnail *rightThumbnail;

@end
