//
//  TextEntryMetaData.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextEntryMetaData.h"

@implementation TextEntryMetaData

@synthesize cellData = _cellData, cellPlaceholder = _cellPlaceholder, isSecure = _isSecure, isDataValidBlock = _isDataValidBlock, writeDataBlock = _writeDataBlock, cellKeyboardType = _cellKeyboardType;

- (id)init {
    self = [super init];
    if (self) {
        self.cellKeyboardType = UIKeyboardTypeDefault;  
    }
    return self;
}

@end
