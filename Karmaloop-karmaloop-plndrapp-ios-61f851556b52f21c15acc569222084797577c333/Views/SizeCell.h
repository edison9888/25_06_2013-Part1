//
//  SizeCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductSku;

@interface SizeCell : UITableViewCell

@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *bottomBorder;
@property BOOL isSelected;
@property BOOL isDisabled;

- (void)updateWithSku:(ProductSku*)sku isSelected:(BOOL)isSelected;
+ (UIColor*) separatorColor;
+ (UIFont*) cellFont;
+ (UIView*) borderSeparator;
@end
