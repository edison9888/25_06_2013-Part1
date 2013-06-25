//
//  ProductViewController.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlndrBaseViewController.h"
#import "ProductDetailSubscription.h"
#import "HitInterceptView.h"
#import "PopupViewController.h"
#import "PopupNotificationViewController.h"
#import "OHAttributedLabel.h"
#import "SocialManager.h"

@class AsyncImageView, Product, UIScrollViewWithHitTest;

@interface ProductViewController : PlndrBaseViewController <UIScrollViewDelegate, SubscriptionDelegate, UITableViewDelegate, UITableViewDataSource, HitInterceptDelegate,OHAttributedLabelDelegate, SocialManagerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSNumber*saleId;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) UIView *productDetailsContainer;
@property (nonatomic, strong) UILabel *brandName;
@property (nonatomic, strong) UILabel *productName;
@property (nonatomic, strong) UIButton *selectSizeButton;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UIView *strikethroughView;
@property (nonatomic, strong) UILabel *salePriceLabel;
@property (nonatomic, strong) UIButton *addToCartButton;
@property BOOL isSelectedByAddToCartButton;
@property (nonatomic, strong) UILabel *productNameHeaderLabel;
@property (nonatomic, strong) UILabel *productNameInDescriptionLabel;
@property (nonatomic, strong) UILabel *productDescriptionHeaderLabel;
@property (nonatomic, strong) UILabel *productDescription;
@property (nonatomic, strong) OHAttributedLabel *productColorLabel;
@property (nonatomic, strong) OHAttributedLabel *productStyleLabel;
@property (nonatomic, strong) OHAttributedLabel *fitInfoLink;

@property (nonatomic, strong) UITableView *sizeTable;
@property (nonatomic, strong) UIView *sizeTableContainer;
@property (nonatomic, strong) NSNumber *currentSizeIndex;

@property (nonatomic, strong) UIScrollViewWithHitTest *imageCarousel;
@property (nonatomic, strong) UIPageControl *carouselPageControl;
@property int carouselIndex;
@property (nonatomic, strong) UIImageView *soldOutBanner;
@property (nonatomic, strong) UILabel *soldOutLabel;

// Views for handling clock rotation
@property (nonatomic, strong) UIImageView *screenshotView;
@property (nonatomic, strong) UIView *rotationView;
@property (nonatomic, strong) UIView *screenshotBackgroundView;
@property (nonatomic, strong) UIView *rotationBackgroundView;
@property (nonatomic, strong) UIView *sizeFakeClearBackgroundView;

@property (nonatomic, strong) ProductDetailSubscription *productDetailsSubscription;
@property BOOL isRespondingToHitDetection;
// Timer Related
@property (nonatomic, strong) OHAttributedLabel *timerLabel;
@property (nonatomic, strong) UIView *timerBackground;
@property (nonatomic, strong) NSTimer *clockUpdateTimer;

// Popup
@property (nonatomic, strong) PopupViewController *saleEndPopup;
@property (nonatomic, strong) PopupViewController *addToCartPopup;


- (id)initWithProduct:(Product*)product saleId:(NSNumber *)saleId;

@end
