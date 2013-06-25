//
//  ProductThumbnail.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductThumbnail.h"
#import "Constants.h"
#import "Product.h"
#import "AsyncImageView.h"
#import "Utility.h"
#import "ModelContext.h"

@interface ProductThumbnail ()
- (void)initSubviews;
- (void)highlightThumbnail;
- (void)unhighlightThumbnail;
@end

@implementation ProductThumbnail

@synthesize soldOutLabel =_soldOutLabel;
@synthesize productThumbnail = _productThumbnail;
@synthesize thumbnailOverlay = _thumbnailOverlay;
@synthesize productTitle = _productTitle;
@synthesize originalPriceLabel = _originalPriceLabel;
@synthesize originalPriceStrikethrough  = _originalPriceStrikethrough;
@synthesize salePriceLabel = _salePriceLabel;
@synthesize productThumbnailButton = _productThumbnailButton;
@synthesize thumbnailHighlightView = _thumbnailHighlightView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {    
    self.productThumbnail = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.productThumbnail.placeholderImage = [UIImage imageNamed:@"Placeholder_98x150.png"];
    [self addSubview:self.productThumbnail];
    
    self.thumbnailOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kSaleScreenThumbnailOverlayHeight, self.frame.size.width, kSaleScreenThumbnailOverlayHeight)];
    self.thumbnailOverlay.backgroundColor = kPlndrWhite;
    [self addSubview:self.thumbnailOverlay];
    
    UIFont *titleFont = kFontMedium11;
    CGSize titleSize = [@"TestString" sizeWithFont:titleFont constrainedToSize:CGSizeMake(300, kSaleScreenThumbnailOverlayHeight/2 - kSaleScreenThumbnailOverlayHorizontalMargin) lineBreakMode:UILineBreakModeTailTruncation];
    
    self.productTitle = [[UILabel alloc] initWithFrame:CGRectMake(kSaleScreenThumbnailOverlayHorizontalMargin, kSaleScreenThumbnailOverlayVerticalMargin, self.frame.size.width - 2*kSaleScreenThumbnailOverlayHorizontalMargin, titleSize.height)];
    self.productTitle.backgroundColor = [UIColor clearColor];
    self.productTitle.font = titleFont;
    self.productTitle.textColor = kPlndrMediumGreyTextColor;
    [self.thumbnailOverlay addSubview:self.productTitle];
    
    CGSize originalPriceSize = [@"TestString" sizeWithFont:kSaleScreenThumbnailOriginalPriceFont constrainedToSize:CGSizeMake(300, 15) lineBreakMode:UILineBreakModeTailTruncation];
    
    float originalPriceSizeRatio = 1.0/2.0;
    
    self.originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSaleScreenThumbnailOverlayHorizontalMargin, self.thumbnailOverlay.frame.size.height - kSaleScreenThumbnailOverlayVerticalMargin - originalPriceSize.height, ceilf(self.productTitle.frame.size.width*originalPriceSizeRatio) - kSaleScreenThumbnailOverlayHorizontalMargin, originalPriceSize.height)];
    self.originalPriceLabel.font = kFontMedium11;
    self.originalPriceLabel.backgroundColor = [UIColor clearColor];
    self.originalPriceLabel.textColor = kPlndrMediumGreyTextColor;
    [self.thumbnailOverlay addSubview:self.originalPriceLabel];
    
    UIFont *salePriceFont = kFontBold12;
    CGSize salePriceSize = [@"TestString" sizeWithFont:salePriceFont constrainedToSize:CGSizeMake(300, 15) lineBreakMode:UILineBreakModeTailTruncation];
    
    salePriceSize.width = ceilf(self.productTitle.frame.size.width*(1.0 - originalPriceSizeRatio)) - kSaleScreenThumbnailOverlayHorizontalMargin;
    self.salePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.thumbnailOverlay.frame.size.width - kSaleScreenThumbnailOverlayHorizontalMargin - salePriceSize.width, self.thumbnailOverlay.frame.size.height - kSaleScreenThumbnailOverlayVerticalMargin - salePriceSize.height, salePriceSize.width, salePriceSize.height)];
    self.salePriceLabel.backgroundColor = [UIColor clearColor];
    self.salePriceLabel.textAlignment = UITextAlignmentRight;
    self.salePriceLabel.font = salePriceFont;
    self.salePriceLabel.textColor = kPlndrBlack;
    [self.thumbnailOverlay addSubview:self.salePriceLabel];
    
    self.soldOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnailOverlay.frame.size.height - kSaleScreenThumbnailOverlayVerticalMargin - salePriceSize.height, self.thumbnailOverlay.frame.size.width, salePriceSize.height)];
    
    self.soldOutLabel.text = @"SOLD OUT";
    self.soldOutLabel.font = kFontBold12;
    self.soldOutLabel.textColor = kPlndrTextRed;
    self.soldOutLabel.textAlignment = UITextAlignmentCenter;
    self.soldOutLabel.backgroundColor = [UIColor clearColor];
    [self.thumbnailOverlay addSubview:self.soldOutLabel];
    self.soldOutLabel.hidden = YES;
    
    self.productThumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.productThumbnailButton.frame = self.productThumbnail.frame;
    [self.productThumbnailButton addTarget:self action:@selector(highlightThumbnail) forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.productThumbnailButton addTarget:self action:@selector(unhighlightThumbnail) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchDragOutside];
    self.productThumbnailButton.exclusiveTouch = YES;
    [self addSubview:self.productThumbnailButton];
    
    self.thumbnailHighlightView = [[UIView alloc] initWithFrame:self.productThumbnail.frame];
    self.thumbnailHighlightView.backgroundColor = kTileHighlightColor;
    self.thumbnailHighlightView.hidden = YES;
    [self addSubview:self.thumbnailHighlightView];
}

- (void) highlightThumbnail {
    self.thumbnailHighlightView.hidden = NO;
}

- (void ) unhighlightThumbnail {
    self.thumbnailHighlightView.hidden = YES;
}

- (void)updateOriginalPrice:(NSString *)originalPrice {
    if (!self.originalPriceStrikethrough) {
        self.originalPriceStrikethrough = [[UIView alloc] init];
        [self.thumbnailOverlay addSubview:self.originalPriceStrikethrough];
    }
    
    self.originalPriceLabel.text = originalPrice;
    [Utility strikethroughFromView:self.originalPriceStrikethrough forLabel:self.originalPriceLabel];
}

- (void)updateWithProduct:(Product*)product index:(int)index {
    self.hidden = NO;
    
    [self.productThumbnail loadImageFromUrl:product.browseImageUrl sizedForFrame:YES];
    self.productThumbnailButton.tag = index;
    self.productTitle.text = product.name;
    [self updateOriginalPrice:[Utility currencyStringForFloat:product.price.floatValue]];
    self.salePriceLabel.text = [Utility currencyStringForFloat:product.checkoutPrice.floatValue];
    
    if ([[ModelContext instance] isProductSoldOut:product]){
        self.originalPriceStrikethrough.hidden = YES;
        self.salePriceLabel.hidden = YES;
        self.originalPriceLabel.hidden = YES;
        self.soldOutLabel.hidden = NO;
    }
    else {
        self.originalPriceStrikethrough.hidden = NO;
        self.salePriceLabel.hidden = NO;
        self.originalPriceLabel.hidden = NO;
        self.soldOutLabel.hidden = YES;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
