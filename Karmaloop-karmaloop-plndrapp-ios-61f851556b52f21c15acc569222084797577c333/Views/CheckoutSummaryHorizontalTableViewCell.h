//
//  CheckoutSummaryHorizontalTableViewCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@class AsyncImageView, CartItem;

@interface CheckoutSummaryHorizontalTableViewCell : HorizontalTableViewCell

@property (nonatomic, strong) AsyncImageView *summaryItemImageView;

- (void) updateCheckoutSummaryCellWithCartItem:(CartItem*) cartItem;

@end
