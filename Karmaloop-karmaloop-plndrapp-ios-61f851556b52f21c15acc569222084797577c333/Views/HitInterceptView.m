//
//  HitInterceptView.m
//  Metro-iOS
//
//  Created by DX079 on 12-02-15.
//  Copyright (c) 2012 Michael Waterfall. All rights reserved.
//

#import "HitInterceptView.h"

@interface HitInterceptView ()

- (void) makeInvisible;

@end

@implementation HitInterceptView

@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
        [self makeInvisible];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self makeInvisible];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeInvisible];
    }
    return self;
}

- (void) makeInvisible {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    [self.delegate interceptOccurred];
    return [super hitTest:point withEvent:event];
}

@end
