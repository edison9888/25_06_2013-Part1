//
//  RBNavigationController.m
//  TheDailyMeal
//
//  Created by Nithin George on 02/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMNavigationController.h"

#define RBNAVIGATIONITEM_TITLEVIEW_RECT CGRectMake(30, 5, 100, 38)
#define kTDMLogoImage @"logoImage"
#define kTDMImageType @"png"

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage 
                      imageWithContentsOfFile:[[NSBundle mainBundle] 
                                               pathForResource:@"navigationBar"
                                               ofType:@"png"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
    
}
@end

@implementation TDMNavigationController

- (void)customizeNavigationBarForBothiOS5andiOS4:(UINavigationController *)navContr{
    
    UINavigationBar *navBar = [navContr navigationBar];
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        UIImage *backgroundImage = [UIImage imageNamed:@"navigationBar.png"];
        [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (id) initWithRootViewController:(UIViewController *)rootViewController
{
    if((self = [super initWithRootViewController:rootViewController]))
    {
        [self customizeNavigationBarForBothiOS5andiOS4:self];
    }
    
    return self;
}

@end

@implementation UINavigationItem (TDM)

#pragma mark setter methods
- (void)setTDMIconImage
{
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:RBNAVIGATIONITEM_TITLEVIEW_RECT];
    CGRect iconRect = iconView.frame;
    iconRect.size.height = 38;
    iconView.frame = iconRect;
    NSString * iconPath = [[NSBundle mainBundle] pathForResource:kTDMLogoImage 
                                                          ofType:kTDMImageType];
    UIImage * icon = [[UIImage alloc] initWithContentsOfFile:iconPath];
    iconPath = nil;
    iconView.image = icon;
    [icon release];
    icon = nil;
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    [self setTitleView:iconView];
    [iconView release];
    iconView = nil;
}

- (void)setTDMTitle:(NSString *)title
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:RBNAVIGATIONITEM_TITLEVIEW_RECT];
    
    //set different properties
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:kGET_BOLD_FONT_WITH_SIZE(15)];
    
    [self setTitleView:titleLabel];
    [titleLabel release];
    titleLabel = nil;
}

- (void)setTDMTitle:(NSString *)title withSubTitle:(NSString*)subTitle
{
}

@end
