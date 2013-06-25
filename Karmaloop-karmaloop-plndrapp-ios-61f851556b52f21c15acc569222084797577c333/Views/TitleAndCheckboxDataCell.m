//
//  TitleAndCheckboxDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleAndCheckboxDataCell.h"

@implementation TitleAndCheckboxDataCell

- (void)update {
    [super update];
    self.textLabel.text = [self.baseDataCellDelegate getTitleStringForTitleAndCheckboxDataCell:self];
    
    if ([self.baseDataCellDelegate isTitleAndCheckboxDataCellChecked:self]) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_box_on.png"]];
    } else {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_box.png"]];
    }
}

@end
