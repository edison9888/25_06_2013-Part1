//
//  ProductThumbnail.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView, Product;

@interface ProductThumbnail : UIView

@property (nonatomic, strong) AsyncImageView *productThumbnail;
@property (nonatomic, strong) UIView *thumbnailOverlay;
@property (nonatomic, strong) UILabel *productTitle;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UIView *originalPriceStrikethrough;
@property (nonatomic, strong) UILabel *salePriceLabel;
@property (nonatomic, strong) UIButton *productThumbnailButton;
@property (nonatomic, strong) UIView *thumbnailHighlightView;
@property (nonatomic, strong) UILabel *soldOutLabel;

- (void) updateOriginalPrice:(NSString*)originalPrice;
- (void) updateWithProduct:(Product*)product index:(int)index;

@end
