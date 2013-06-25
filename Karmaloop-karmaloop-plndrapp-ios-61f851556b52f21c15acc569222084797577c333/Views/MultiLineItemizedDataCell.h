//
//  MultiLineItemizedDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"

@class MultiLineItemizedDataCell, MultiLineItemizedMetaData;

@protocol MultiLineItemizedDataCellDelegate

- (NSArray*) getAttributedStringLineItemsMultiLineItemizedDataCell:(MultiLineItemizedDataCell*)sender;

@end

@interface MultiLineItemizedDataCell : BaseDataCell

@property (nonatomic, strong) NSMutableArray *labels;

+ (NSNumber*) getHeightWithMetadata:(MultiLineItemizedMetaData*)metaData;
- (NSNumber*) getHeight;

@end
