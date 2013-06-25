//
//  FeaturedListCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsyncImageView, OHAttributedLabel, Sale;

@interface FeaturedListCell : UITableViewCell

@property (nonatomic, strong) AsyncImageView *saleIcon;
@property (nonatomic, strong) UILabel *saleLabel;
@property (nonatomic, strong) OHAttributedLabel *timerLabel;
@property (nonatomic, strong) UIImageView *disclosureView;
@property (nonatomic, strong) NSDate *endDate;
// Borders
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;

+ (UIColor*)separatorColor;

- (void) updateClock;
- (void) updateWithSale:(Sale*)sale tag:(int)tag;

@end
