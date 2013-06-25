//
//  ProductListTripleCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductThumbnail.h"

@interface ProductListTripleCell : UITableViewCell

@property (nonatomic, strong) ProductThumbnail *leftThumbnail;
@property (nonatomic, strong) ProductThumbnail *middleThumbnail;
@property (nonatomic, strong) ProductThumbnail *rightThumbnail;

@end
