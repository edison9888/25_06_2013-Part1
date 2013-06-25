//
//  CheckoutSummaryHorizontalTableViewCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutSummaryHorizontalTableViewCell.h"
#import "AsyncImageView.h"
#import "Product.h"
#import "CartItem.h"
#import "Constants.h"

@interface CheckoutSummaryHorizontalTableViewCell ()

- (void) initSubviews;

@end

@implementation CheckoutSummaryHorizontalTableViewCell

@synthesize summaryItemImageView = _summaryItemImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return  self;
}

- (void)initSubviews {
    self.summaryItemImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((kSummaryHorizontalCellWidth - kMyCartTableCellImageWidth)/2, (kSummaryHorizontalCellHeight - kMyCartTableCellImageHeight)/2, kMyCartTableCellImageWidth, kMyCartTableCellImageHeight)];
    self.summaryItemImageView.placeholderImage = [UIImage imageNamed:@"Placeholder_58x89.png"];
    [self addSubview:self.summaryItemImageView];
}


- (void)updateCheckoutSummaryCellWithCartItem:(CartItem *)cartItem {
    [self.summaryItemImageView loadImageFromUrl:[[cartItem product] browseImageUrl] sizedForFrame:YES];
}
@end
