//
//  HomeNavBarView.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeNavBarView.h"
#import "Constants.h"
#import "iCarousel.h"
#import "ModelContext.h"

@interface HomeNavBarView () 

- (void) toggleList;

@end

@implementation HomeNavBarView

@synthesize scrollWheel = _scrollWheel;
@synthesize listToggle = _listToggle;
@synthesize categories = _categories;
@synthesize currentCarouselView = _currentCarouselView;
@synthesize previousCarouselView = _previousCarouselView;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = kHomeNavBarFrame;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"home_nav_bar_bg.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundView.frame = CGRectMake(0, 0, kDeviceWidth, backgroundImage.size.height);
        [self addSubview:backgroundView];

        // Insert the logo
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        logoView.frame = CGRectMake(kHomeScreenNavBarMargin,(self.frame.size.height - logoView.frame.size.height)/2, logoView.frame.size.width, logoView.frame.size.height);        
        
        UIImageView *scrollWheelBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll_box.png"]];
        
        self.scrollWheel = [[iCarousel alloc] initWithFrame:CGRectMake(80, (self.frame.size.height - kHomeScrollWheelHeight)/2, kHomeScrollWheelWidth, kHomeScrollWheelHeight)];
        scrollWheelBackground.frame = self.scrollWheel.frame;
        self.scrollWheel.backgroundColor = [UIColor clearColor];
        self.scrollWheel.dataSource = self;
        self.scrollWheel.delegate = self;
        self.scrollWheel.bounds = self.scrollWheel.frame;
        self.scrollWheel.clipsToBounds = YES;
        self.scrollWheel.decelerationRate = 0.05;
        self.scrollWheel.scrollSpeed = 0.3;
        
        UIImageView *scrollWheelTransparency = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll_top_gradient.png"]];
        scrollWheelTransparency.frame = scrollWheelBackground.frame;
        
        self.listToggle = [UIButton buttonWithType:UIButtonTypeCustom];
        self.listToggle.frame = CGRectMake(kDeviceWidth - kHomeScreenNavBarMargin - kMagicButtonHeight, (self.frame.size.height - kMagicButtonHeight)/2, kMagicButtonHeight, kMagicButtonHeight);
        [self.listToggle setImage:[UIImage imageNamed:@"list_icn.png"] forState:UIControlStateNormal];
        [self.listToggle setImage:[UIImage imageNamed:@"list_icn_hl.png"] forState:UIControlStateHighlighted];
        [self.listToggle addTarget:self action:@selector(toggleList) forControlEvents:UIControlEventTouchUpInside];
        
        self.categories = [[NSArray alloc] initWithObjects:@"ALL",@"WOMEN",@"MEN",@"ALL",@"WOMEN",@"MEN", nil];
        
        [self addSubview:logoView];    
        [self addSubview:scrollWheelBackground];
        [self addSubview:self.scrollWheel];
        [self addSubview:scrollWheelTransparency];
        [self addSubview:self.listToggle];
        
        GenderCategory initialGenderCategory = [[ModelContext instance] genderCategory];
        NSInteger initialIndex;
        
        // These asserts are safe. If they fail, it's because of developer error: update the indexes in the asserts and switch below to ensure the datasource and translation remain synced
        NSAssert([[self.categories objectAtIndex:0] isEqualToString:@"ALL"], @"HomeNavBarView expected ALL to be at index 0");
        NSAssert([[self.categories objectAtIndex:1] isEqualToString:@"WOMEN"], @"HomeNavBarView expected WOMEN to be at index 1");
        NSAssert([[self.categories objectAtIndex:2] isEqualToString:@"MEN"], @"HomeNavBarView expected MEN to be at index 2");
        
        switch (initialGenderCategory) {
            case GenderCategoryMen:
                initialIndex = 2;
                break;
            case GenderCategoryWomen:
                initialIndex = 1;
                break;
            case GenderCategoryAll:
            default:
                initialIndex = 0;
                break;
        }
        [self.scrollWheel scrollToItemAtIndex:initialIndex animated:NO];
        [self carouselCurrentItemIndexUpdated:self.scrollWheel];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.scrollWheel.delegate = nil;
}

#pragma private

- (void) toggleList {
    [self.delegate toggleList];
    if ([self.delegate isListView]) {
        [self.listToggle setImage:[UIImage imageNamed:@"tile_icn.png"] forState:UIControlStateNormal];
        [self.listToggle setImage:[UIImage imageNamed:@"tile_icn_hl.png"] forState:UIControlStateHighlighted];
    } else {
        [self.listToggle setImage:[UIImage imageNamed:@"list_icn.png"] forState:UIControlStateNormal];
        [self.listToggle setImage:[UIImage imageNamed:@"list_icn_hl.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - iCarouselDataSource/Delegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.categories count];
}

-(BOOL)carouselShouldWrap:(iCarousel *)carousel {
    return YES;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UILabel *carouselCell = (UILabel*)view;
    if (carouselCell == nil)  {
        carouselCell = [[UILabel alloc] init];
        carouselCell.frame = CGRectMake(0, 0, kHomeScrollWheelWidth/2.5, kHomeScrollWheelHeight);
        carouselCell.textAlignment = UITextAlignmentCenter;
        carouselCell.backgroundColor = [UIColor clearColor];
//        carouselCell.font = [UIFont boldSystemFontOfSize:12];
        carouselCell.font = kFontBoldCond17;
        carouselCell.textColor = kPlndrLightGreyTextColor;
        carouselCell.clipsToBounds = YES;
        
        UIImage *scrollLine = [UIImage imageNamed:@"scroll_line.png"];
        UIImageView *leftScrollLine = [[UIImageView alloc] initWithImage:scrollLine];
        leftScrollLine.frame = CGRectMake(-1*scrollLine.size.width/2.0f, (kHomeScrollWheelHeight - scrollLine.size.height)/2, scrollLine.size.width, scrollLine.size.height);
        [carouselCell addSubview:leftScrollLine];
        
        UIImageView *rightScrollLine = [[UIImageView alloc] initWithImage:scrollLine];
        rightScrollLine.frame = CGRectMake(carouselCell.frame.size.width + -1*scrollLine.size.width/2.0f, (kHomeScrollWheelHeight - scrollLine.size.height)/2, scrollLine.size.width, scrollLine.size.height);
        [carouselCell addSubview:rightScrollLine];
        
        // Init with the right color
        if (index == carousel.currentItemIndex) {
            carouselCell.textColor = kPlndrBlack;
            self.previousCarouselView = self.currentCarouselView;
            self.currentCarouselView = carouselCell;
        }
    }
    carouselCell.text = [self.categories objectAtIndex:index];
    
    return carouselCell;
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel {
    if (self.currentCarouselView == carousel.currentItemView) {
        return;
    }
    
    self.previousCarouselView = self.currentCarouselView;
    self.currentCarouselView = (UILabel*)carousel.currentItemView;
    
    self.previousCarouselView.textColor = kPlndrLightGreyTextColor;
    self.currentCarouselView.textColor = kPlndrBlack;
    
    GenderCategory genderCategory;
    NSString* categoryName = [self.categories objectAtIndex:[carousel currentItemIndex]];
    if ([categoryName isEqualToString:@"MEN"]) {
        genderCategory = GenderCategoryMen;
    } else if ([categoryName isEqualToString:@"WOMEN"]) {
        genderCategory = GenderCategoryWomen;
    } else {
        genderCategory = GenderCategoryAll;
    }
    
    [ModelContext instance].genderCategory = genderCategory;
    [self.delegate scrollWheelIndexDidUpdate];
}

+ (GenderCategory)defaultGenderCategory {
    return GenderCategoryAll;
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
