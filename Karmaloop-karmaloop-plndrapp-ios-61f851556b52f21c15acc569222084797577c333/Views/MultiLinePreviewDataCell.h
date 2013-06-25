//
//  MultiLinePreviewDataCell.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseDataCell.h"
#import "MultiLinePreviewMetaData.h"

@class MultiLinePreviewDataCell, MultiLinePreviewMetaData;

@protocol MultiLinePreviewDataCellDelegate

- (NSArray*) getTitleForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender;
- (NSArray*) getDetailForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender;
- (NSArray*) getPlaceholderForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender;
- (CustomAccessoryType) getCustomAccessoryTypeForMultiLinePreviewDataCell:(MultiLinePreviewDataCell*)sender;

@end

@interface MultiLinePreviewDataCell : BaseDataCell

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UIView *iconView;

+ (NSNumber*) getHeightWithMetadata:(MultiLinePreviewMetaData*)metaData;
- (NSNumber*) getHeight;

- (int) getLabelHorizontalMargin;

@end
