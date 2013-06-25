//
//  MultiLineItemizedMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

@interface MultiLineItemizedMetaData : CellMetaData

@property (nonatomic, strong) NSArray *attributedStringLineItems;
@property (nonatomic, strong) NSNumber *cellHeight;

@end
