//
//  ProductListTripleCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductListTripleCell.h"
#import "ProductThumbnail.h"
#import "Constants.h"

@interface ProductListTripleCell ()
- (void)initSubviews;
@end

@implementation ProductListTripleCell

@synthesize leftThumbnail = _leftThumbnail;
@synthesize middleThumbnail = _middleThumbnail;
@synthesize rightThumbnail = _rightThumbnail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    int rowWidth = kSaleScreenThumbnailWidth*kSaleScreenThumbnailsPerRow + kSaleScreenThumbnailMargin*(kSaleScreenThumbnailsPerRow-1);
    int edgeMargin = (kSaleScreenTableWidth - rowWidth)/2;
    
    self.leftThumbnail = [[ProductThumbnail alloc] initWithFrame:CGRectMake(edgeMargin, kSaleScreenThumbnailMargin/2, kSaleScreenThumbnailWidth , kSaleScreenThumbnailHeight)];
    [self addSubview:self.leftThumbnail];
    
    self.middleThumbnail = [[ProductThumbnail alloc] initWithFrame:CGRectMake(self.leftThumbnail.frame.origin.x + self.leftThumbnail.frame.size.width + kSaleScreenThumbnailMargin, self.leftThumbnail.frame.origin.y, kSaleScreenThumbnailWidth, kSaleScreenThumbnailHeight)];
    [self addSubview:self.middleThumbnail];
    
    self.rightThumbnail = [[ProductThumbnail alloc] initWithFrame:CGRectMake(self.middleThumbnail.frame.origin.x + self.middleThumbnail.frame.size.width + kSaleScreenThumbnailMargin, self.leftThumbnail.frame.origin.y, kSaleScreenThumbnailWidth, kSaleScreenThumbnailHeight)];
    [self addSubview:self.rightThumbnail];
}

@end
