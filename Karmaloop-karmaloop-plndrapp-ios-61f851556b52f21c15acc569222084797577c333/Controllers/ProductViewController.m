//
//  ProductViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductViewController.h"
#import "Product.h"
#import "Constants.h"
#import "AsyncImageView.h"
#import "NSAttributedString+Attributes.h"
#import "Utility.h"
#import "CartItem.h"
#import "ModelContext.h"
#import "SizeCell.h"
#import "HitInterceptView.h"
#import "UIScrollViewWithHitTest.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "ProductSku.h"
#import "MiniBrowserViewController.h"
#import "MyCartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OneButtonNotificationPopupView.h"
#import "GANTracker.h"
#import "ImageCacheManager.h"
#import "FeaturedThumbnail.h"

@interface ProductViewController ()

- (void) setupRightBarButtons;
- (void) selectSizeClicked;
- (void) addToCartClicked;
- (void) initImageCarousel;
- (void) prepareAndShowCarousel;
- (void) prepareAndShowSizeButton;
- (void) reloadImageCarouselContentsForceReload:(BOOL)forceReload;
- (void) changePage:(id)sender;
- (void) setImagePagingEnabled:(BOOL)enabled;
- (void) createProductDetailsSubscription:(BOOL) forceFetch;
- (void) handleProductDetailsSubscriptionError;
- (void) setSizeTableVisible:(BOOL) isVisible;
- (void) hideSizeTable;
- (void) updateViewForCurrentSizeIndex;
- (void) notifyUserOfAddedItem;
- (void) updateProductDetailLabels;

+ (UIFont*) productDetailHeaderFont;
+ (UIFont*) productDetailFont;

- (void) animateSizeVisible:(BOOL)visible;
+ (CATransform3D) identityWithPerspective;
- (void) performSizeVisibleAnimation:(BOOL)visible;
- (void) resetHitDetectionResponse;

- (void) scheduleClockTimer;
- (void) updateTimer;
- (void) showLayoutForTimer;
- (void)expireCurrentView;
- (void)addCurrentlySelectedItemToCart;
- (void)shareProduct:(id)sender;

@end

@implementation ProductViewController

@synthesize product = _product, scrollContainer = _scrollContainer, productDetailsContainer = _productDetailsContainer, brandName = _brandName, productName = _productName, selectSizeButton = _selectSizeButton, originalPriceLabel = _originalPriceLabel, strikethroughView = _strikethroughView, salePriceLabel = _salePriceLabel, addToCartButton = _addToCartButton, productNameHeaderLabel = _productNameHeaderLabel, productNameInDescriptionLabel = _productNameInDescriptionLabel, productDescriptionHeaderLabel = _productDescriptionHeaderLabel, productDescription = _productDescription, productColorLabel = _productColorLabel, productStyleLabel = _productStyleLabel, fitInfoLink = _fitInfoButton, carouselIndex = _carouselIndex, carouselPageControl = _carouselPageControl;
@synthesize imageCarousel = _imageCarousel;
@synthesize productDetailsSubscription = _productDetailsSubscription;
@synthesize sizeTable = _sizeTable;
@synthesize sizeTableContainer = _sizeTableContainer;
@synthesize currentSizeIndex = _currentSizeIndex;
@synthesize screenshotView = _screenshotView;
@synthesize rotationView = _rotationView;
@synthesize screenshotBackgroundView = _screenshotBackgroundView;
@synthesize rotationBackgroundView = _rotationBackgroundView;
@synthesize sizeFakeClearBackgroundView = _sizeFakeClearBackgroundView;
@synthesize isRespondingToHitDetection = _isRespondingToHitDetection;
@synthesize soldOutBanner = _soldOutBanner;
@synthesize timerLabel = _timerLabel;
@synthesize timerBackground =_timerBackground;
@synthesize clockUpdateTimer = _clockUpdateTimer;
@synthesize addToCartPopup = _addToCartPopup;
@synthesize saleEndPopup = _saleEndPopup;
@synthesize isSelectedByAddToCartButton = _isSelectedByAddToCartButton;
@synthesize saleId = _saleId;
@synthesize soldOutLabel = _soldOutLabel;

- (id)initWithProduct:(Product*)product saleId:(NSNumber *)saleId {
    self = [super init];
    if (self) {
        self.product = product;
        self.title = [self.product.name uppercaseString];
        self.saleId = saleId;
    }
    return self;
}

- (void)dealloc {
    self.sizeTable.dataSource = nil;
    self.sizeTable.delegate = nil;
    self.fitInfoLink.delegate = nil;
    self.imageCarousel.delegate = nil;
    [_productDetailsSubscription cancel];
    [self.clockUpdateTimer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    self.navigationItem.rightBarButtonItem = nil;
    self.scrollContainer = nil;
    self.productDetailsContainer = nil;
    self.brandName = nil;
    self.productName = nil;

    self.imageCarousel.delegate = nil;
    self.imageCarousel = nil;
    self.soldOutBanner = nil;
    self.carouselPageControl = nil;
    
    self.selectSizeButton = nil;
    self.addToCartButton = nil;
    self.soldOutLabel = nil;
    self.salePriceLabel = nil;
    self.originalPriceLabel = nil;
    self.strikethroughView = nil;
    self.productNameHeaderLabel = nil;
    self.productNameInDescriptionLabel = nil;
    self.productDescriptionHeaderLabel = nil;
    self.productDescription = nil;
    self.productColorLabel = nil;
    self.productStyleLabel = nil;
    self.fitInfoLink.delegate = nil;
    self.fitInfoLink = nil;
    
    self.sizeTableContainer = nil;
    self.sizeTable.delegate = nil;
    self.sizeTable.dataSource = nil;
    self.sizeTable = nil;

    self.sizeFakeClearBackgroundView = nil;
    self.screenshotView = nil;
    self.rotationView = nil;
    self.screenshotBackgroundView = nil;
    self.rotationBackgroundView = nil;
    
    self.timerBackground = nil;
    self.timerLabel = nil;

    [self.clockUpdateTimer invalidate];
    self.clockUpdateTimer = nil;
    
    
    [self.productDetailsSubscription cancel];
    self.productDetailsSubscription = nil;
}


#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    [self setupRightBarButtons];
    
    self.view.backgroundColor = kPlndrBgGrey;
    
    self.scrollContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollContainer setDelaysContentTouches:NO];
    [self.view addSubview:self.scrollContainer];
    
    self.productDetailsContainer = [[UIView alloc] initWithFrame:CGRectMake((self.scrollContainer.frame.size.width - kProductDetailsContainerWidth)/2, 0, kProductDetailsContainerWidth, kProductDetailsContainerHeight)];
    [self.scrollContainer addSubview:self.productDetailsContainer];
    
    int dropshadowWidth = 7;
    UIImageView *whiteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_panel.png"]];
    whiteView.frame = CGRectMake(-1*dropshadowWidth, 0, kProductDetailsContainerWidth + dropshadowWidth*2, kProductDetailsContainerHeight + dropshadowWidth);
    [self.productDetailsContainer addSubview:whiteView];
    
    // White Area
    int brandWidth = self.productDetailsContainer.frame.size.width - 2*kProductContainerInternalHorizontalMargin;
    UIFont *brandNameFont = kFontBold17;
    int brandNameHeight = [self.product.vendorName sizeWithFont:brandNameFont constrainedToSize:CGSizeMake(brandWidth, 35) lineBreakMode:UILineBreakModeTailTruncation].height;
    
    self.brandName = [[UILabel alloc] initWithFrame:CGRectMake(kProductContainerInternalHorizontalMargin, kProductContainerInternalHorizontalMargin, brandWidth, brandNameHeight)];
    self.brandName.backgroundColor = [UIColor clearColor];
    self.brandName.text = self.product.vendorName;
    self.brandName.font = brandNameFont;
    self.brandName.textColor = kPlndrBlack;
    [self.productDetailsContainer addSubview:self.brandName];
    
    UIFont *productNameFont = kFontMedium14;
    int productNameHeight = [self.product.name sizeWithFont:productNameFont constrainedToSize:CGSizeMake(brandWidth, 30) lineBreakMode:UILineBreakModeTailTruncation].height;
    
    self.productName = [[UILabel alloc] initWithFrame:CGRectMake(self.brandName.frame.origin.x, self.brandName.frame.origin.y + self.brandName.frame.size.height, self.brandName.frame.size.width, productNameHeight)];
    self.productName.backgroundColor = [UIColor clearColor];
    self.productName.numberOfLines = 1;
    self.productName.text = self.product.name;
    self.productName.font = productNameFont;
    self.productName.textColor = kPlndrMediumGreyTextColor;
    [self.productDetailsContainer addSubview:self.productName];
    
    [self initImageCarousel];
    
    self.selectSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sizeButtonBackground = [UIImage imageNamed:@"side_btn.png"];
    [self.selectSizeButton setBackgroundImage:sizeButtonBackground forState:UIControlStateNormal];
    self.selectSizeButton.frame = CGRectMake(self.productDetailsContainer.frame.size.width - sizeButtonBackground.size.width + 1, self.productName.frame.origin.y + self.productName.frame.size.height + kProductContainerInternalHorizontalMargin, sizeButtonBackground.size.width, sizeButtonBackground.size.height);
    [self.selectSizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.selectSizeButton addTarget:self action:@selector(selectSizeClicked) forControlEvents:UIControlEventTouchUpInside];
    self.selectSizeButton.titleLabel.font = kFontBoldCond15;
    self.selectSizeButton.backgroundColor = [UIColor clearColor];
    self.selectSizeButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.selectSizeButton.titleLabel.numberOfLines = 2;
    self.selectSizeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 2);
    self.selectSizeButton.titleLabel.textAlignment = UITextAlignmentCenter;
    [self.productDetailsContainer addSubview:self.selectSizeButton];
    
    self.addToCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addToCartImage = [UIImage imageNamed:@"yellow_sm_btn.png"];
    [self.addToCartButton setBackgroundImage:addToCartImage forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"yellow_sm_btn_hl.png"] forState:UIControlStateHighlighted];
    self.addToCartButton.frame = CGRectMake(self.productDetailsContainer.frame.size.width - kProductContainerInternalHorizontalMargin - addToCartImage.size.width, self.imageCarousel.frame.origin.y + self.imageCarousel.frame.size.height - addToCartImage.size.height, addToCartImage.size.width, addToCartImage.size.height);
    [self.addToCartButton setTitle:kProductAddToCart forState:UIControlStateNormal];
    [self.addToCartButton.titleLabel setFont:kFontBoldCond17];
    [self.addToCartButton setTitleColor:kPlndrBlack forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
    [self.addToCartButton addTarget:self action:@selector(addToCartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.productDetailsContainer addSubview:self.addToCartButton];
    
    UIFont *soldOutLabelFont = kFontBoldCond20;
    int soldOutLabelHeight = [kProductSoldOutLabel sizeWithFont:soldOutLabelFont constrainedToSize:CGSizeMake(320, 35) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.soldOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addToCartButton.frame.origin.x + kProductContainerInternalHorizontalMargin, self.addToCartButton.frame.origin.y, self.addToCartButton.frame.size.width - 2*kProductContainerInternalHorizontalMargin, soldOutLabelHeight)];

    [self.soldOutLabel setText:kProductSoldOutLabel];
    [self.soldOutLabel setFont:soldOutLabelFont];
    [self.soldOutLabel setTextColor:kPlndrTextRed];
    [self.soldOutLabel setTextAlignment:UITextAlignmentLeft];
    [self.soldOutLabel setBackgroundColor:[UIColor clearColor]];
    [self.productDetailsContainer addSubview:self.soldOutLabel];

    self.soldOutLabel.hidden = YES;
    
        
    NSString *salePriceText = [Utility currencyStringForFloat:self.product.checkoutPrice.floatValue];
    UIFont *salePriceFont = kFontBold22;
    int salePriceFontHeight = [salePriceText sizeWithFont:salePriceFont constrainedToSize:CGSizeMake(320, 35) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.salePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addToCartButton.frame.origin.x + kProductContainerInternalHorizontalMargin, self.addToCartButton.frame.origin.y - salePriceFontHeight - kProductContainerInternalHorizontalMargin, self.addToCartButton.frame.size.width - 2*kProductContainerInternalHorizontalMargin, salePriceFontHeight)];
    self.salePriceLabel.backgroundColor = [UIColor clearColor];
    self.salePriceLabel.text = salePriceText;
    self.salePriceLabel.textColor = kPlndrBlack;
    self.salePriceLabel.font = salePriceFont;
    [self.productDetailsContainer addSubview:self.salePriceLabel];
    
    NSString *originalPriceText = [Utility currencyStringForFloat:self.product.price.floatValue];
    UIFont *originalPriceFont = kFontMedium17;
    int originalPriceFontHeight = [originalPriceText sizeWithFont:originalPriceFont constrainedToSize:CGSizeMake(320, 35) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.salePriceLabel.frame.origin.x, self.salePriceLabel.frame.origin.y - originalPriceFontHeight -kProductContainerInternalHorizontalMargin, self.salePriceLabel.frame.size.width, originalPriceFontHeight)];
    self.originalPriceLabel.backgroundColor = [UIColor clearColor];
    self.originalPriceLabel.text = originalPriceText;
    self.originalPriceLabel.font = originalPriceFont;
    self.originalPriceLabel.textColor = kPlndrMediumGreyTextColor;
    [self.productDetailsContainer addSubview:self.originalPriceLabel];
    
    self.strikethroughView = [[UIView alloc] init];
    [self.productDetailsContainer addSubview:self.strikethroughView];
    [Utility strikethroughFromView:self.strikethroughView forLabel:self.originalPriceLabel];  
    
    
    // Description & Details area
    UIFont *headerFont = [ProductViewController productDetailHeaderFont];
    UIFont *detailFont = [ProductViewController productDetailFont];
    
    NSString *nameHeader = @"Name";
    int detailsWidth = kDeviceWidth - kProductSecondaryDetailsHorizontalMargin*2;
    int headerHeight = [nameHeader sizeWithFont:headerFont constrainedToSize:CGSizeMake(100, 25) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.productNameHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProductSecondaryDetailsHorizontalMargin, self.productDetailsContainer.frame.origin.y + self.productDetailsContainer.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, headerHeight)];
    self.productNameHeaderLabel.text = nameHeader;
    self.productNameHeaderLabel.textColor = kPlndrBlack;
    self.productNameHeaderLabel.font = headerFont;
    self.productNameHeaderLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:self.productNameHeaderLabel];
    
    NSString* name = self.product.name;
    int nameHeight = [name sizeWithFont:detailFont constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.productNameInDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.productNameHeaderLabel.frame.origin.x, self.productNameHeaderLabel.frame.origin.y + self.productNameHeaderLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, nameHeight)];
    self.productNameInDescriptionLabel.numberOfLines = 0;
    self.productNameInDescriptionLabel.text = name;
    self.productNameInDescriptionLabel.textColor = kPlndrMediumGreyTextColor;
    self.productNameInDescriptionLabel.font = detailFont;
    self.productNameInDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:self.productNameInDescriptionLabel];
    
    NSString *descriptionHeader = @"Description";
    self.productDescriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kProductSecondaryDetailsHorizontalMargin, self.productNameInDescriptionLabel.frame.origin.y + self.productNameInDescriptionLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, headerHeight)];
    self.productDescriptionHeaderLabel.text = descriptionHeader;
    self.productDescriptionHeaderLabel.textColor = kPlndrBlack;
    self.productDescriptionHeaderLabel.font = headerFont;
    self.productDescriptionHeaderLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:self.productDescriptionHeaderLabel];
    
    NSString* description = self.product.productDescription;
    int descriptionHeight = [description  sizeWithFont:detailFont constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.productDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.productDescriptionHeaderLabel.frame.origin.x, self.productDescriptionHeaderLabel.frame.origin.y + self.productDescriptionHeaderLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, descriptionHeight)];
    self.productDescription.numberOfLines = 0;
    self.productDescription.text = description;
    self.productDescription.textColor = kPlndrMediumGreyTextColor;
    self.productDescription.font = detailFont;
    self.productDescription.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:self.productDescription];
    
    self.productColorLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(self.productDescription.frame.origin.x, self.productDescription.frame.origin.y + self.productDescription.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, headerHeight)];
    self.productColorLabel.backgroundColor = [UIColor clearColor];
    [self.scrollContainer addSubview:self.productColorLabel];
    
    self.productStyleLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(self.productColorLabel.frame.origin.x, self.productColorLabel.frame.origin.y + self.productColorLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, headerHeight)];
    self.productStyleLabel.backgroundColor = [UIColor clearColor];
    self.productStyleLabel.automaticallyAddLinksForType = 0; // It thinks style is a phone number. turn it off
    [self.scrollContainer addSubview:self.productStyleLabel];
    
    [self updateProductDetailLabels];
    
    self.fitInfoLink = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(self.productStyleLabel.frame.origin.x, self.productStyleLabel.frame.origin.y + self.productStyleLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, detailsWidth, headerHeight)];
    self.fitInfoLink.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString: [NSString stringWithFormat: @"Sizing & Fit Info"]];
    [attrStr setFont:headerFont];
    self.fitInfoLink.attributedText = attrStr;
    [self.fitInfoLink addCustomLink:[NSURL URLWithString:kPlndrSizeAndFitUrl] inRange:[attrStr.string rangeOfString:attrStr.string]];
    self.fitInfoLink.linkColor = kPlndrTextGold;
    self.fitInfoLink.delegate = self;
    [self.scrollContainer addSubview:self.fitInfoLink];    
    
    int sizeTableContainerMargin = 5;
    int sizeTableContainerWidth = kProductDetailSizeTableWidth + 2*sizeTableContainerMargin;
    
    self.sizeTableContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTableContainerWidth, self.productDetailsContainer.frame.size.height)];
    self.sizeTableContainer.backgroundColor = kPlndrBgGrey;
    
    self.sizeTable = [[UITableView alloc] initWithFrame:CGRectMake(sizeTableContainerMargin, 0, kProductDetailSizeTableWidth, self.sizeTableContainer.frame.size.height)];
    self.sizeTable.delegate = self;
    self.sizeTable.dataSource = self;
    self.sizeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sizeTable.backgroundColor = kPlndrBgGrey;
    [self.sizeTableContainer addSubview:self.sizeTable];
    
    HitInterceptView *hitInterceptView = [[HitInterceptView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 600)];
    hitInterceptView.delegate = self;
    
    // Create the rotation views
    
    self.sizeFakeClearBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - sizeTableContainerWidth,
                                                                                0, 
                                                                                self.sizeTableContainer.frame.size.width,
                                                                                self.sizeTableContainer.frame.size.height + 10)];
    self.sizeFakeClearBackgroundView.backgroundColor = kPlndrBgGrey;
    
    [self.sizeFakeClearBackgroundView addSubview:self.sizeTableContainer];
    [self.scrollContainer addSubview:self.sizeFakeClearBackgroundView];

    self.screenshotView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sizeFakeClearBackgroundView.frame.size.width,
                                                                        0,
                                                                        self.sizeFakeClearBackgroundView.frame.size.width,
                                                                        self.sizeFakeClearBackgroundView.frame.size.height)];
    self.screenshotView.clipsToBounds = NO;
    self.screenshotView.backgroundColor = [UIColor greenColor];
    
    self.rotationView = [[UIView alloc] initWithFrame:CGRectMake(self.sizeFakeClearBackgroundView.frame.origin.x - self.sizeFakeClearBackgroundView.frame.size.width,
                                                                0,
                                                                self.sizeFakeClearBackgroundView.frame.size.width *2,
                                                                self.sizeFakeClearBackgroundView.frame.size.height)];
    
    self.rotationView.userInteractionEnabled = NO;
    self.rotationView.clipsToBounds = NO;
    self.rotationView.layer.doubleSided = NO;
    [self.rotationView addSubview:self.screenshotView];
    
    // The screenshotBackgroundView and rotationBackgroundView are for the gold backside of the timer flap.
    self.screenshotBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenshotView.frame.size.width, self.screenshotView.frame.size.height)];
    self.screenshotBackgroundView.backgroundColor = kFlipBackgroundColor;
    self.screenshotBackgroundView.clipsToBounds = NO;
    
    self.rotationBackgroundView = [[UIView alloc] initWithFrame:self.rotationView.frame];
    self.rotationBackgroundView.userInteractionEnabled = NO;
    self.rotationBackgroundView.clipsToBounds = NO;
    self.rotationBackgroundView.layer.doubleSided = NO;
    [self.rotationBackgroundView addSubview:self.screenshotBackgroundView];
    
    [self.scrollContainer addSubview:self.rotationBackgroundView];
    [self.scrollContainer addSubview:self.rotationView];
    
    
    UIImageView *timerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timer_icon.png"]];
    timerImage.frame = CGRectMake(0,0,timerImage.frame.size.width, timerImage.frame.size.height);
    NSString *timerText = @"00:00:00";
    UIFont *timerFont = kFontTimer;
    CGSize timerTextSize = [timerText sizeWithFont:timerFont constrainedToSize:CGSizeMake(320, 14) lineBreakMode:UILineBreakModeTailTruncation];
    self.timerBackground = [[UIView alloc] initWithFrame:CGRectMake(
                                                                    self.addToCartButton.frame.origin.x,
                                                                    self.addToCartButton.frame.origin.y + self.addToCartButton.frame.size.height,
                                                                    timerImage.frame.size.width + timerTextSize.width,
                                                                    timerTextSize.height)];
    
    [self.timerBackground addSubview:timerImage];
    
    self.timerLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(timerImage.frame.size.width,
                                                                          (self.timerBackground.frame.size.height - timerTextSize.height)/2 + 1, // Offset since image has a drop shadow
                                                                          self.timerBackground.frame.size.width - timerImage.frame.size.width,
                                                                          self.timerBackground.frame.size.height)]; 
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.centerVertically = YES;
    self.timerLabel.automaticallyAddLinksForType = 0;
    self.timerLabel.textAlignment = UITextAlignmentCenter;
    self.timerLabel.shadowColor = [UIColor whiteColor];
    self.timerLabel.shadowOffset = CGSizeMake(0.0, kTimerShadowHeight);
    
    [self.timerBackground addSubview:self.timerLabel];
    [self.productDetailsContainer addSubview:self.timerBackground];
    
    self.timerBackground.hidden = YES;
    self.timerLabel.hidden = YES;
    
    [self.scrollContainer insertSubview:hitInterceptView belowSubview:self.sizeFakeClearBackgroundView];
    
    self.scrollContainer.contentSize = CGSizeMake(320, self.fitInfoLink.frame.origin.y + self.fitInfoLink.frame.size.height + kProductSecondaryDetailsVerticalMargin);
    
    [self initPullDownViewOnParentView:self.scrollContainer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", self.product.name] withError:nil];
    [self pullPullDownView];
    [self setSizeTableVisible:NO];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // This might change due to interactions with the cart
    [self updateViewForCurrentSizeIndex];
    [self scheduleClockTimer];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.clockUpdateTimer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}


#pragma mark - private

- (void)setupRightBarButtons {
    UIImage *shareButtonImage = [UIImage imageNamed:@"share_icn.png"];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height);
    [shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_icn_hl.png"] forState:UIControlStateHighlighted];
	[shareButton addTarget:self action:@selector(shareProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, shareButton.frame.size.width, shareButton.frame.size.height)];
    [rightButtonView addSubview:shareButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
}

- (void)selectSizeClicked {
    [self animateSizeVisible:YES];
}

- (void)addCurrentlySelectedItemToCart {
    [[GANTracker sharedTracker] trackEvent:kGANEventCheckout action:kGANActionAddToCart label:self.product.name value:-1 withError:nil];
    
    ProductSku *size = [self.product.skus objectAtIndex:self.currentSizeIndex.intValue];
    
    CartItem *newItem = [[CartItem alloc] initWithProduct:self.product size:size saleId:self.saleId];
    [[ModelContext instance] addCartItemToCart:newItem];
    
    [self updateViewForCurrentSizeIndex];
    
    [self notifyUserOfAddedItem];
}

- (void)addToCartClicked {

    BOOL isSizeSelected = self.currentSizeIndex != nil;
    if (isSizeSelected) {
        [self addCurrentlySelectedItemToCart];
    } else {
        self.isSelectedByAddToCartButton = YES;
        [self animateSizeVisible:YES];
    }
    
    
}

- (void)notifyUserOfAddedItem {
    if ([[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] isKindOfClass: [MyCartViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:kProductAddToCartTitle message:[NSString stringWithFormat: kProductAddToCartMessage,self.product.name, ((ProductSku*)[self.product.skus objectAtIndex:self.currentSizeIndex.intValue]).size] buttonOneTitle:kProductAddToCartButton1 buttonTwoTitle:kProductAddToCartButton2];
        self.addToCartPopup = popup;
        [PopupUtil presentPopup:popup withDelegate:self];
    }
}

- (void) initImageCarousel {
    int pageControlHeight = 26;
    
    // Create the carousel
    self.imageCarousel = [[UIScrollViewWithHitTest alloc] initWithFrame:CGRectMake(self.brandName.frame.origin.x, self.productName.frame.origin.y + self.productName.frame.size.height + kProductContainerInternalHorizontalMargin, kProductDetailImageWidth, kProductDetailImageHeight)];
    self.carouselPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.imageCarousel.frame.origin.x, self.imageCarousel.frame.origin.y + self.imageCarousel.frame.size.height - pageControlHeight, self.imageCarousel.frame.size.width, pageControlHeight)];
    
    self.imageCarousel.pagingEnabled = YES;
    self.imageCarousel.contentSize = CGSizeMake(self.imageCarousel.frame.size.width * 3, self.imageCarousel.frame.size.height);
    self.imageCarousel.showsHorizontalScrollIndicator = NO;
    self.imageCarousel.showsVerticalScrollIndicator = NO;
    self.imageCarousel.scrollsToTop = NO;
    self.imageCarousel.delegate = self;
    self.imageCarousel.scrollBoundInsets = UIEdgeInsetsMake(0, 0, 0, -60);
    [self.productDetailsContainer addSubview:self.imageCarousel];
    
    // Create the carousel contents
    UIView *contentViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.imageCarousel.frame.size.width * 3 , self.imageCarousel.frame.size.height)];
    for (int neighbourIndex = 0; neighbourIndex <= 2; neighbourIndex ++) {
        AsyncImageView *newImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(neighbourIndex*self.imageCarousel.frame.size.width, 0, self.imageCarousel.frame.size.width, self.imageCarousel.frame.size.height)];
        newImageView.placeholderImage = [UIImage imageNamed:@"Placeholder_180x275.png"];
        [contentViewContainer addSubview:newImageView];
    }
    [self.imageCarousel addSubview:contentViewContainer];
    
    [self.carouselPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.productDetailsContainer addSubview:self.carouselPageControl];
    
    // Create the sold out banner that goes on top of the carousel
    UIImage *bannerImage = [UIImage imageNamed:@"label_sold out.png"];
    self.soldOutBanner = [[UIImageView alloc] initWithImage:bannerImage];
    self.soldOutBanner.frame = CGRectMake(self.imageCarousel.frame.origin.x + self.imageCarousel.frame.size.width - bannerImage.size.width, self.imageCarousel.frame.origin.y, bannerImage.size.width, bannerImage.size.height);
    self.soldOutBanner.hidden = YES;
    
    [self.productDetailsContainer addSubview:self.soldOutBanner];
}

- (void) prepareAndShowCarousel {
    // Initialize the content offset and index
    self.imageCarousel.contentOffset = CGPointMake(self.imageCarousel.frame.size.width, 0);
    self.carouselIndex = 0;
    
    self.carouselPageControl.currentPage = self.carouselIndex;
    self.carouselPageControl.numberOfPages = MAX(self.product.zooms.count, 1);
	
	if (self.product.zooms.count <= 1) {
		[self.imageCarousel setScrollEnabled:NO];
	} else {
		[self.imageCarousel setScrollEnabled:YES];
	}
		
    
    // Load the images
    [self reloadImageCarouselContentsForceReload:YES];

}

- (void) prepareAndShowSizeButton {
    [self.selectSizeButton setTitle:kProductPickASize forState:UIControlStateNormal];
    self.selectSizeButton.hidden = NO;
}

- (void) updateProductDetailLabels {
    UIFont *headerFont = [ProductViewController productDetailHeaderFont];
    UIFont *detailFont = [ProductViewController productDetailFont];
    
    NSString* description = self.product.productDescription;
    float descriptionHeight = [description  sizeWithFont:self.productDescription.font constrainedToSize:CGSizeMake(self.productDescription.frame.size.width, 10000) lineBreakMode:UILineBreakModeTailTruncation].height;
    self.productDescription.frame = CGRectMake(self.productDescription.frame.origin.x, self.productDescription.frame.origin.y, self.productDescription.frame.size.width, descriptionHeight);
    self.productDescription.text = description;
    self.productDescription.numberOfLines = 0;
    
    self.productColorLabel.frame = CGRectMake(self.productColorLabel.frame.origin.x, self.productDescription.frame.origin.y + self.productDescription.frame.size.height + kProductSecondaryDetailsVerticalMargin, self.productColorLabel.frame.size.width, self.productColorLabel.frame.size.height);
    NSString *productColor = self.product.skus.count > 0 ? ((ProductSku *) [self.product.skus objectAtIndex:0]).color : @"-";
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString: [NSString stringWithFormat: @"Color: %@", productColor]];
    [attrStr setFont:detailFont];
    [attrStr setFont:headerFont range:[attrStr.string rangeOfString:@"Color:"]];
    [attrStr setTextColor:kPlndrMediumGreyTextColor];
    [attrStr setTextColor:kPlndrBlack range:[attrStr.string rangeOfString:@"Color:"]];
    self.productColorLabel.attributedText = attrStr;
    
    self.productStyleLabel.frame = CGRectMake(self.productStyleLabel.frame.origin.x, self.productColorLabel.frame.origin.y + self.productColorLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, self.productStyleLabel.frame.size.width, self.productStyleLabel.frame.size.height);
    NSString *productStyle = self.product.style ? self.product.style : @"-";
    attrStr = [NSMutableAttributedString attributedStringWithString: [NSString stringWithFormat: @"Style # %@", productStyle]];
    [attrStr setFont:detailFont];
    [attrStr setFont:headerFont range:[attrStr.string rangeOfString:@"Style #"]];
    [attrStr setTextColor:kPlndrMediumGreyTextColor];
    [attrStr setTextColor:kPlndrBlack range:[attrStr.string rangeOfString:@"Style #"]];
    self.productStyleLabel.attributedText = attrStr;
    
    self.fitInfoLink.frame = CGRectMake(self.fitInfoLink.frame.origin.x, self.productStyleLabel.frame.origin.y + self.productStyleLabel.frame.size.height + kProductSecondaryDetailsVerticalMargin, self.fitInfoLink.frame.size.width, self.fitInfoLink.frame.size.height);
    
    self.scrollContainer.contentSize = CGSizeMake(320, self.fitInfoLink.frame.origin.y + self.fitInfoLink.frame.size.height + kProductSecondaryDetailsVerticalMargin*2);
}

- (void) reloadImageCarouselContentsForceReload:(BOOL)forceReload {
    NSArray *images = self.product.zooms;
    BOOL isSizedForFrame  = YES;
    if (images.count == 0) {
        // There are no zooms. Try to find a smaller image to use here instead
        NSString *url = [AsyncImageView urlFromUrl:self.product.browseImageUrl withWidth:kSaleScreenThumbnailWidth];
        UIImage *thumbnail = [[ImageCacheManager sharedInstance] getImageFromCacheForUrl:url];
        if (!thumbnail) {
            url = [AsyncImageView urlFromUrl:self.product.browseImageUrl withWidth:kMyCartTableCellImageWidth];
            thumbnail = [[ImageCacheManager sharedInstance] getImageFromCacheForUrl:url];
        }
        
        if (thumbnail) {
            images = [NSArray arrayWithObject:url];
        } else {
            images = [NSArray arrayWithObject:@"http://"]; // force load of the placeholder
        }
        isSizedForFrame = NO;
    }
    
    if (images > 0) {
        // Reset content offset, if necessary, to stay in bounds.
        CGPoint contentOffset = self.imageCarousel.contentOffset;
        int direction = 0;
        if (contentOffset.x < 0.2*self.imageCarousel.frame.size.width) {
            contentOffset.x += self.imageCarousel.frame.size.width;
            direction = -1;
        } else if (contentOffset.x >= 1.8*self.imageCarousel.frame.size.width) {
            contentOffset.x -= self.imageCarousel.frame.size.width;            
            direction = 1;
        }     
        self.imageCarousel.contentOffset = contentOffset;
        
        // If content offset changed (or if the carousel needs a hard reset) update contents
        if (direction != 0 || forceReload) {
            self.carouselIndex = (self.carouselIndex + direction + images.count) % images.count;
            self.carouselPageControl.currentPage = self.carouselIndex;
            // Get the view containing the recycled views, so we can iterate through them
            UIView *contentViewContainer = [self.imageCarousel.subviews objectAtIndex:0];
            
            // Iterate through the (three) views
            for (int carouselContainerIndex = 0; carouselContainerIndex < contentViewContainer.subviews.count; carouselContainerIndex++) {
                AsyncImageView *currImageView = [contentViewContainer.subviews objectAtIndex:carouselContainerIndex];
                int newIndex = (self.carouselIndex -1 + carouselContainerIndex + images.count) % images.count;
                [currImageView loadImageFromUrl:[images objectAtIndex:newIndex] sizedForFrame:isSizedForFrame];
            }
        }  
    } 
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setImagePagingEnabled:YES];
}

- (void) changePage:(id)sender {
    [self setImagePagingEnabled:NO];
    
    int direction = self.carouselPageControl.currentPage - self.carouselIndex;
    
    CGRect frame = self.imageCarousel.frame;
    if (direction > 0) {
        frame.origin.x = frame.size.width * 2;
    } else {
        frame.origin.x = 0;
    }
    frame.origin.y = 0;
    [self.imageCarousel scrollRectToVisible:frame animated:YES];
}

- (void)setImagePagingEnabled:(BOOL)enabled {
    self.carouselPageControl.userInteractionEnabled = enabled;
    self.imageCarousel.userInteractionEnabled = enabled;
}

- (void) createProductDetailsSubscription:(BOOL)forceFetch{
    [_productDetailsSubscription cancel]; //Cancel any previously set up subscription
    
    // If the model context doesn't know about this product (due to cache eviction), make it aware:
    [[ModelContext instance] addProductToCache:self.product];
    
    _productDetailsSubscription = [[ProductDetailSubscription alloc] initWithProductId:self.product.productId context:[ModelContext instance] forceFetch:forceFetch];
    _productDetailsSubscription.delegate = self;
    [self subscriptionUpdatedState:_productDetailsSubscription];
}

- (void)handleProductDetailsSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.productDetailsSubscription];
    [self displayAPIErrorWithTitle:kProductErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (void)setSizeTableVisible:(BOOL)isVisible {
    if(isVisible) {
        self.sizeFakeClearBackgroundView.hidden = NO;
        self.screenshotView.hidden = NO;
        self.screenshotBackgroundView.hidden = NO;

        CATransform3D transform = CATransform3DRotate([ProductViewController identityWithPerspective], -1* kTimerRotationInRadians, 0.0, 1.0f, 0.0f);
        self.rotationView.layer.transform = transform;
        
        CATransform3D upsideDownTransform = CATransform3DRotate(transform, 2*k90DegreesInRadians, 0.0f, 1.0f, 0.0f );
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
        
    } else {
        self.sizeFakeClearBackgroundView.hidden = YES;
        self.screenshotView.hidden = YES;
        self.screenshotBackgroundView.hidden = YES;
        
        CATransform3D transform = [ProductViewController identityWithPerspective];
        self.rotationView.layer.transform = transform;
        
        CATransform3D upsideDownTransform = CATransform3DRotate(transform, 2*k90DegreesInRadians, 0.0f, 1.0f, 0.0f);
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
        
        [self hideSizeTable];
    }
}

- (void) hideSizeTable {
    self.sizeFakeClearBackgroundView.hidden = YES;
    [self updateViewForCurrentSizeIndex];
}

- (void)updateViewForCurrentSizeIndex {
    NSString *sizeString;
    if (self.currentSizeIndex.intValue >= self.product.skus.count) {
        self.currentSizeIndex = nil;
    }
    if (self.currentSizeIndex) {
        sizeString = ((ProductSku*)[self.product.skus objectAtIndex:self.currentSizeIndex.intValue]).size;
        sizeString = [NSString stringWithFormat:kProductSizeXXX, sizeString];
    } else {
        sizeString = kProductPickASize;
    }
    
    [self.selectSizeButton setTitle:sizeString forState:UIControlStateNormal];
    [self.selectSizeButton setTitleColor:kPlndrTextGold forState:UIControlStateNormal];
    NSNumber *index = self.currentSizeIndex;
    BOOL isSizeSelected = index != nil;
    BOOL isSizeAvailable = (!isSizeSelected) || (isSizeSelected && [[ModelContext instance] additionalStockAvailableForProduct:self.product sku:((ProductSku*)[self.product.skus objectAtIndex:self.currentSizeIndex.intValue])] > 0);    

    self.addToCartButton.enabled = isSizeAvailable;
    if (isSizeSelected) {
        self.soldOutBanner.hidden = isSizeAvailable;
        self.addToCartButton.hidden = !isSizeAvailable;
        self.soldOutLabel.hidden = isSizeAvailable;
    } else {
        BOOL isProductInStock =![[ModelContext instance] isProductSoldOut:self.product];
        self.soldOutBanner.hidden = isProductInStock;
        self.addToCartButton.hidden = !isProductInStock;
        self.soldOutLabel.hidden = isProductInStock;
    }
}

+ (UIFont*) productDetailHeaderFont {
    return kFontBold14;
}

+ (UIFont*) productDetailFont {
    return kFontMedium14;
}


- (void)animateSizeVisible:(BOOL)visible {
    if (visible) {
        // snap the whole frame
        CGPoint oldOffset = self.scrollContainer.contentOffset;
        self.scrollContainer.contentOffset = CGPointMake(0,0);
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *preCropImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.scrollContainer.contentOffset = oldOffset;
        
        // crop the part we want
        CGImageRef imageRef = CGImageCreateWithImageInRect([preCropImage CGImage], self.sizeFakeClearBackgroundView.frame);
        self.screenshotView.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);

        
    }
    
    [self performSizeVisibleAnimation:visible];
}

+ (CATransform3D)identityWithPerspective {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    return transform;
}

- (void)performSizeVisibleAnimation:(BOOL)visible { 
    
    self.sizeFakeClearBackgroundView.hidden = NO;
    self.screenshotView.hidden = NO;
    self.screenshotBackgroundView.hidden = NO;

    
    double radians = kTimerRotationInRadians;
    radians = visible ? radians * -1 : radians;
    
    CATransform3D transform = CATransform3DRotate(self.rotationView.layer.transform, radians, 0.0f, 1.0f, 0.0f);
    CATransform3D upsideDownTransform = CATransform3DRotate(self.rotationBackgroundView.layer.transform, radians, 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.4f animations:^ (void) {
        self.rotationView.layer.transform = transform;
        self.rotationBackgroundView.layer.transform = upsideDownTransform;
    } completion:^ (BOOL isComplete) {
        [self setSizeTableVisible:visible];
    }];
    
}

- (void) updateTimer {
    NSString *redTxt = @"";
    NSDate *endDate = self.product.availabilityEndDate;
    RemainingSaleTime unusedRST = RemainingSaleTimeLots;
    NSString *txt = [Utility stringForSaleEndDate:endDate textToMakeRed:&redTxt remainingSaleTime:&unusedRST];
    
    
    int totalSecondsUntilEnd = [endDate timeIntervalSinceNow];
    int daysUntilEnd = totalSecondsUntilEnd / kSecondsInDay;
    
    if (daysUntilEnd == 0) {
        if (self.timerBackground.hidden) {
            [self showLayoutForTimer];
        }
        
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
        [attrStr setFont:kFontTimer];
        [attrStr setTextColor:kPlndrTextRed range:[txt rangeOfString:redTxt]];
        
        self.timerLabel.attributedText = attrStr;
        if (![Utility isTimeInFuture:endDate]) {
            [self.clockUpdateTimer invalidate]; // Invalidate the Timer as it has hit 0.
            [self expireCurrentView];
        }
    }
    
    // Else Do nothing as timer is more than 1 day
    
}

- (void) scheduleClockTimer {
    BOOL isTimeInFuture = [Utility isTimeInFuture:self.product.availabilityEndDate];
    // This needs to be checked before calling updatedTimer
    
    [self updateTimer];
    [self.clockUpdateTimer invalidate];
    
    if (isTimeInFuture) {
        self.clockUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES]; 
    }
}

- (void)showLayoutForTimer {
    self.timerBackground.hidden = NO;
    self.timerLabel.hidden = NO;
    
    self.timerBackground.frame = CGRectMake(self.addToCartButton.frame.origin.x + kProductContainerInternalHorizontalMargin, 
                                            self.addToCartButton.frame.origin.y - self.timerBackground.frame.size.height - kProductContainerInternalHorizontalMargin,
                                            self.timerBackground.frame.size.width,
                                            self.timerBackground.frame.size.height);
    self.salePriceLabel.frame = CGRectMake(self.addToCartButton.frame.origin.x + kProductContainerInternalHorizontalMargin, 
                                           self.timerBackground.frame.origin.y - self.salePriceLabel.frame.size.height, 
                                           self.salePriceLabel.frame.size.width,
                                           self.salePriceLabel.frame.size.height);
    self.originalPriceLabel.frame = CGRectMake(self.addToCartButton.frame.origin.x + kProductContainerInternalHorizontalMargin,
                                               self.salePriceLabel.frame.origin.y - self.originalPriceLabel.frame.size.height, 
                                               self.originalPriceLabel.frame.size.width,
                                               self.originalPriceLabel.frame.size.height);
    self.originalPriceLabel.textColor = kPlndrMediumGreyTextColor;
    
    [Utility strikethroughFromView:self.strikethroughView forLabel:self.originalPriceLabel];
}

- (void)expireCurrentView {
    if ([[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] isKindOfClass: [MyCartViewController class]]) { return; }
    
    PopupNotificationViewController *popup = [[PopupNotificationViewController alloc] initWithTitle:kSaleEndTitle message:[NSString stringWithFormat:kSaleEndErrorMessage,self.product.name] buttonOneTitle:kSaleEndButtonTitle ];
    self.saleEndPopup = popup;
    [PopupUtil presentPopup:popup withDelegate:self];
}

- (void)shareProduct:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Email",@"Facebook",@"Twitter",@"SMS", nil];
	[actionSheet showInView:self.tabBarController.view];
}

- (void) updatedView {
    [self prepareAndShowCarousel];
    [self prepareAndShowSizeButton];
    [self updateProductDetailLabels];
    [self updateViewForCurrentSizeIndex];
    [self.sizeTable reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case ShareActionSheetFacebook:
			[[SocialManager instance] setSocialManagerDelegate:self];
			[[SocialManager instance] loginFacebookAndPopDialog];
			break;
		case ShareActionSheetEmail:
		case ShareActionSheetSMS:
		case ShareActionSheetTwitter:
		default: {
			[[SocialManager instance] shareProductViaShareActionType:(ShareActionSheetType)buttonIndex itemName:self.product.name discountPercentage:self.product.discountPercentage url:self.product.url viewController:self];
		}
			break;
	}	
}

#pragma mark - SocialManagerDelegate Methods

- (void) onFacebookLoginSuccess {
	[[SocialManager instance] setSocialManagerDelegate:nil];
    [[SocialManager instance] facebookShareProductWithitemName:self.product.name discountPercentage:self.product.discountPercentage url:self.product.url];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.imageCarousel) {
        [self reloadImageCarouselContentsForceReload:NO];
    } else {
        [super scrollViewDidScroll:scrollView];
    }
    
}

#pragma mark - PullDownViewDelegate

- (void)pullDownToRefreshContent {
    [self createProductDetailsSubscription:YES];
}

- (BOOL)pullDownIsLoading{
    return (self.productDetailsSubscription.state == SubscriptionStatePending);
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        [self resetPullDownView];
        [self updatedView];
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription == self.productDetailsSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [self resetPullDownView];
            [_productDetailsSubscription cancel];
            Product *newProduct = [[ModelContext instance] getProduct:self.product.productId];
            if (newProduct) {
                self.product = newProduct;
            }
            [self updatedView];
            [self hideLoadingView];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            [self updatedView];
            [self handleProductDetailsSubscriptionError];
        } else { //Pending
            // Using Pull to refresh instead
        } 
    } 
}

#pragma mark - PlndrBaseViewController loading overrides

- (CGRect)loadingViewFrame {
    return CGRectMake(0, 150, kDeviceWidth, 30);
}

- (UIColor*) loadingViewBackgroundColor {
    return [UIColor clearColor];
}


#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    if (sender == self.saleEndPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) moveToHomePage];
        self.saleEndPopup = nil;
    }else if (sender == self.defaultErrorPopup) {
        // Bring them back to Sale if Subscription Error
        [self.navigationController popViewControllerAnimated:YES];
        self.defaultErrorPopup = nil;
    } else {
        self.addToCartPopup = nil;
    }
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [PopupUtil dismissPopup];
    if ([popupViewController numberOfButtons] == 1) {
        if (popupViewController == self.saleEndPopup) {            
            [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) moveToHomePage];
            self.saleEndPopup = nil;
        } else if (popupViewController == self.defaultErrorPopup) {
            [self.navigationController popViewControllerAnimated:YES];
            self.defaultErrorPopup = nil;
        }
    } else {
        // Go to cart

        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.addToCartPopup = nil;
    }
}

- (void) popupButtonTwoClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    // Continue shopping
    [PopupUtil dismissPopup];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate/DataSource 

// Customize the number of sections in the table view.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProductDetailSizeTableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.product.skus count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kProductDetailSizeTableWidth, [self tableView:tableView heightForHeaderInSection:section])];
    headerView.backgroundColor = kPlndrBgGrey;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kProductDetailSizeTableWidth, headerView.frame.size.height)];
    headerLabel.text = kProductPickASize;
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [SizeCell cellFont];
    
    UIView *separator = [SizeCell borderSeparator];
    separator.frame = CGRectMake(0, headerView.frame.size.height - separator.frame.size.height, separator.frame.size.width, separator.frame.size.height);
    
    [headerView addSubview:headerLabel];
    [headerView addSubview:separator];
    
    if ([self tableView:tableView numberOfRowsInSection:0]  ==  0 && ![self pullDownIsLoading]) {
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, kProductDetailSizeTableWidth, kProductDetailsContainerHeight - headerView.frame.size.height)];
        emptyLabel.backgroundColor = [UIColor clearColor];
        emptyLabel.text = kProductNoSizesAvailable;
        emptyLabel.textColor = kPlndrMediumGreyTextColor;
        emptyLabel.font = kErrorFontForReplaceingTables;
        emptyLabel.textAlignment = UITextAlignmentCenter;
        emptyLabel.numberOfLines = 0;
        [headerView addSubview:emptyLabel];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [SizeCell borderSeparator].frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [SizeCell borderSeparator];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sizeTableCell";
    
    SizeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BOOL isSelected = self.currentSizeIndex && indexPath.row == self.currentSizeIndex.intValue;
    [cell updateWithSku:(ProductSku*)[self.product.skus objectAtIndex:indexPath.row] isSelected:isSelected];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sizeTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSizeIndex.intValue inSection:0] animated:NO];
    
    self.currentSizeIndex = [NSNumber numberWithInt:indexPath.row];
    
    [self.sizeTable reloadData];
    
    [self animateSizeVisible:NO];
    if (self.isSelectedByAddToCartButton) {
        self.isSelectedByAddToCartButton = NO;
        [self addCurrentlySelectedItemToCart];
    }
}

#pragma mark - HitInterceptDelegate

- (void)interceptOccurred {
    if (!self.isRespondingToHitDetection) {
        self.isRespondingToHitDetection = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(resetHitDetectionResponse) userInfo:nil repeats:NO];
        
        if (!self.sizeFakeClearBackgroundView.hidden) {
            [self animateSizeVisible:NO];
        }
    }
}

- (void) resetHitDetectionResponse {
    self.isRespondingToHitDetection = NO;
}

#pragma mark - OHAttributedLabelDelegate

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo {
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:linkInfo.URL];
    MiniBrowserViewController *browserVC = [[MiniBrowserViewController alloc] initWithUrl:urlRequest];
    browserVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browserVC animated:YES];
    
    return NO;
}

@end
