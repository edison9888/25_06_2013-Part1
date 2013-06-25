//
//  MultiLinePreviewMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

typedef enum {
	CustomAccessoryTypeNothing,
    CustomAccessoryTypePencil,
    CustomAccessoryTypePlus,
    CustomAccessoryTypeDisclosure
} CustomAccessoryType;

@interface MultiLinePreviewMetaData : CellMetaData

@property (nonatomic, strong) NSArray *cellTitle;
@property (nonatomic, strong) NSArray *cellDetail;
@property (nonatomic, strong) NSArray *cellPlaceholder;
@property (nonatomic, strong) NSNumber *cellHeight;
@property CustomAccessoryType customAccessoryType;
@end
