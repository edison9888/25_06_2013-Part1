//
//  UIScrollViewWithHitTest.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIScrollViewWithHitTest.h"

@implementation UIScrollViewWithHitTest

@synthesize scrollBoundInsets = _scrollBoundInsets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollBoundInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *returnView = nil;
    
    CGRect oldFrame = self.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x + self.scrollBoundInsets.left,
                                 oldFrame.origin.y + self.scrollBoundInsets.top,
                                 oldFrame.size.width - self.scrollBoundInsets.left - self.scrollBoundInsets.right,
                                 oldFrame.size.height - self.scrollBoundInsets.top - self.scrollBoundInsets.bottom);
    
    CGPoint newPoint = CGPointMake(point.x + (oldFrame.origin.x - newFrame.origin.x), point.y + (oldFrame.origin.y - newFrame.origin.y));
    
    self.frame = newFrame;
    if ([self pointInside:newPoint withEvent:event]) {
        returnView = self;
    }
    self.frame = oldFrame;
    
    return returnView;
}

@end
