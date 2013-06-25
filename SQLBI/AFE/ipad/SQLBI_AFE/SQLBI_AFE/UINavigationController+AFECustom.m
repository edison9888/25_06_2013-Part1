//
//  AFENavigationController.m
//  Super Saver
//
//  Created by Anoop on 02/06/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.

#import "UINavigationController+AFECustom.h"


#define AFE_NAVIGATIONITEM_TITLEVIEW_RECT CGRectMake(0, 5, 800, 38)


@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage 
                      imageWithContentsOfFile:[[NSBundle mainBundle] 
                                               pathForResource:@"topBar"
                                               ofType:@"png"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
}
@end


@implementation UINavigationController (AFECustom)

- (void)customizeNavigationBarForAFE{
    
    UINavigationBar *navBar = [self navigationBar];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5)
    {
        if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            UIImage *backgroundImage = [UIImage imageNamed:@"topBar"];
            [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
            navBar.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    
}

@end

@implementation UINavigationItem (AFE)

#pragma mark setter methods

- (void)setTitle:(NSString *)title
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:AFE_NAVIGATIONITEM_TITLEVIEW_RECT];
    
    //set different properties
    [titleLabel setText:title];
    [titleLabel setTextColor:COLOR_NAVIGATIONBAR_TITLE];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:FONT_NAVIGATIONBAR_TITLE];
    [self setTitleView:titleLabel];
    titleLabel = nil;
}

@end
