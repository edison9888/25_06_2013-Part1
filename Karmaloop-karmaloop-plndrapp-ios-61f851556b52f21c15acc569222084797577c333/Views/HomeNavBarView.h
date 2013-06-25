//
//  HomeNavBarView.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Sale.h"
#import "GenderCategory.h"

@protocol HomeNavBarDelegate <NSObject>

- (void) toggleList;
- (BOOL) isListView;
- (void) scrollWheelIndexDidUpdate;

@end

@interface HomeNavBarView : UIView <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) iCarousel *scrollWheel;
@property (nonatomic, strong) UIButton *listToggle;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) UILabel *currentCarouselView;
@property (nonatomic, strong) UILabel *previousCarouselView;
@property (nonatomic, weak) id<HomeNavBarDelegate> delegate;


+ (GenderCategory) defaultGenderCategory;

@end
