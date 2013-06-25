//
//  TDMImageZoomHelper.m
//  TheDailyMeal
//
//  Created by Mrudula Krishanan on 25/04/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMImageZoomHelper.h"


@implementation TDMImageZoomHelper
@synthesize imagePath;
@synthesize zoomedImage;
@synthesize navigationBardelegate;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"TDMImageZoomHelper" owner:self options:nil]; 
        UIView * myView = [xib objectAtIndex:0];
        [self addSubview:myView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(self.overlayView)
        [self.overlayView removeFromSuperview];
}


- (IBAction)onCloseButtonClicked:(id)sender {
    
    [self removeFromSuperview];

    if (self.navigationBardelegate && [self.navigationBardelegate  respondsToSelector:@selector(showNavigationBar)]) 
    {
        [self.navigationBardelegate showNavigationBar];
    }
    
}

- (void)showImage
{
    zoomedImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    
}
- (void)dealloc {
    [zoomedImage release];
    [super dealloc];
}
- (void)removeOverlayView {

    if (overlayView) {
        [overlayView removeFromSuperview];
        // [overlayView release];
        overlayView = nil;
    }
}
@end
