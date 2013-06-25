//
//  DetailAndDisclosureDataCell.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailAndDisclosureDataCell.h"

@implementation DetailAndDisclosureDataCell

- (void)update {
    [super update];
    self.textLabel.text = [self.baseDataCellDelegate getTitleStringForDetailAndDisclosureDataCell:self];
    self.detailTextLabel.text = [self.baseDataCellDelegate getDetailStringForDetailAndDisclosureDataCell:self];
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron_hl.png"]];
    } else {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron.png"]];      
    }
}


@end
