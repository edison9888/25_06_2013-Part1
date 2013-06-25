//
//  MyCartTableCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCartTableCellDelegate <NSObject>

- (void) addQuantity:(id)sender;
- (void) subtractQuantity:(id)sender;
- (BOOL) minusButtonEnabled:(id)sender;
- (BOOL) plusButtonEnabled:(id)sender;
@end

@class CartItem, AsyncImageView;

@interface MyCartTableCell : UITableViewCell

@property (nonatomic, strong) AsyncImageView *productImage;
@property (nonatomic, strong) UILabel *brandNameLabel;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *sizeAndColorLabel;
@property (nonatomic, strong) UILabel *checkoutPriceLabel;
@property (nonatomic, strong) UILabel *quantityLabel;
@property (nonatomic, strong) UIButton *quantityMinusButton;
@property (nonatomic, strong) UIButton *quantityPlusButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, weak) id<MyCartTableCellDelegate> myCartDelegate;
@property (nonatomic, strong) UIView *bottomBorder;

- (void)updateWithCartItem:(CartItem*)cartItem;

@end
