//
//  CellMetaData.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

@implementation CellMetaData

@synthesize isRowEnabled = _isRowEnabled;
@synthesize cellClass = _cellClass; 
@synthesize didSelectBlock = _didSelectBlock;
@synthesize didBecomeFirstResponderBlock = _didBecomeFirstResponderBlock;
@synthesize performPreviousAction = _performPreviousAction;
@synthesize performNextAction = _performNextAction;
@synthesize inputAccessoryViewType = _inputAccessoryViewType;
@synthesize isValid = _isValid;

- (id)init {
    self = [super init];
    if (self) {
        _isRowEnabled = YES; // No is just a silly default.
        _isValid = YES;
    }
    return self;
}


@end
