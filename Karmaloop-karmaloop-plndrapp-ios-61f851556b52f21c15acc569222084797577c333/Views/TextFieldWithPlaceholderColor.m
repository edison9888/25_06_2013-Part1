//
//  TextFieldWithPlaceholderColor.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextFieldWithPlaceholderColor.h"

@interface TextFieldWithPlaceholderColor () 

- (UIColor*) defaultPlaceholderColor;

@end

@implementation TextFieldWithPlaceholderColor

@synthesize placeholderColor = _placeholderColor;

- (id)init {
    self = [super init];
    if (self) {
        self.placeholderColor = [self defaultPlaceholderColor];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholderColor = [self defaultPlaceholderColor];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

#pragma mark - private

- (UIColor *)defaultPlaceholderColor {
    return [UIColor colorWithWhite:0.0f alpha:0.7f];
}

#pragma mark - override

- (void) drawPlaceholderInRect:(CGRect)rect {
    [self.placeholderColor setFill];
    [[self placeholder] drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
}

@end
