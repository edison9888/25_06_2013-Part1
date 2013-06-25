//
//  HorizontalTableViewCell.m
//  Metro-iOS
//
//  Created by Michelle Den Hollander on 12-02-12.
//  Copyright (c) 2012 Michael Waterfall. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformRotate(self.transform, (M_PI / 2.0));
        self.frame = frame;
    }
    return self;
}

@end
