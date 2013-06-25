//
//  TextEntryMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

@interface TextEntryMetaData : CellMetaData

@property (nonatomic, strong) NSString *cellData;
@property (nonatomic, strong) NSString *cellPlaceholder;
@property UIKeyboardType cellKeyboardType;
@property BOOL isSecure;
@property (nonatomic, copy) BOOL(^isDataValidBlock)(NSString* detail);
@property (nonatomic, copy) void(^writeDataBlock)(NSString*);


@end
