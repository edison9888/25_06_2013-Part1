//
//  ProgressView.m
//  PE
//
//  Created by Nithin George on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressView.h"


@implementation ProgressView
@synthesize pgrView;
@synthesize lblProgress;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
