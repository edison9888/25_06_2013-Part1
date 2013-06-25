//
//  DetailAndDisclosureDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"

@class DetailAndDisclosureDataCell;

@protocol DetailAndDisclosureDataCellDelegate

- (NSString*) getTitleStringForDetailAndDisclosureDataCell:(DetailAndDisclosureDataCell*)sender;
- (NSString*) getDetailStringForDetailAndDisclosureDataCell:(DetailAndDisclosureDataCell*)sender;

@end

@interface DetailAndDisclosureDataCell : BaseDataCell

@end
