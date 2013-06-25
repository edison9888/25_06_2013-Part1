//
//  TreeMapAnimationCell.m
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeMapAnimationCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TreeMapAnimationCell
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button addTarget:self 
//                   action:@selector(btnTouched)
//         forControlEvents:UIControlEventTouchDown];
//        button.backgroundColor = [UIColor clearColor];
//        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        button.titleLabel.text = @"Click";
//            // button.center = center;
//        button.frame =self.frame;// cellView.frame;
                                 // [self addSubview:button];  
    }
    return self;
}
-(void)initWithView:(UIView *)cellView :(CGRect)viewFrame{

    self.frame = cellView.frame;
    UIGraphicsBeginImageContext(cellView.bounds.size);
    [cellView.layer  renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *image = [[UIImageView alloc] initWithImage:viewImage];
    image.frame = CGRectMake(cellView.frame.origin.x, cellView.frame.origin.y, cellView.frame.size.width, cellView.frame.size.height);
    [self addSubview:image];


}
- (void)btnTouched {
    
    [self removeFromSuperview];
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(removeAnimatedCell)])
        [self.delegate removeAnimatedCell];
    
    
}

@end
