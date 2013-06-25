//
//  HorizontalTableView.m
//  Metro-iOS
//
//  Created by DX079 on 12-02-10.
//  Copyright (c) 2012 Michael Waterfall. All rights reserved.
//

#import "HorizontalTableView.h"

@interface HorizontalTableView ()

- (void) rotateFrame;

@end

@implementation HorizontalTableView

- (id) init {
    self = [super init];
    if (self) {
        [self rotateFrame];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rotateFrame];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self rotateFrame];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self rotateFrame];
    }
    return self;
}

- (void) rotateFrame {
    CGRect frame = self.frame;
    self.transform = CGAffineTransformRotate(self.transform, (M_PI / -2.0));
    self.frame = frame;
    
    self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, self.frame.size.height - 8);
}

@end
