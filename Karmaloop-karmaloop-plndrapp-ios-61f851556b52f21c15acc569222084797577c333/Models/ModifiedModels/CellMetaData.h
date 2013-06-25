//
//  CellMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    InputAccessoryNone,
    InputAccessoryPreviousNextDismiss,
    InputAccessoryPreviousDismiss,
    InputAccessoryNextDismiss,
    InputAccessoryDismiss,
	InputAccessoryPreviousDismissGo
} InputAccessoryViewType;

@class BaseDataCell;

@interface CellMetaData : NSObject

@property BOOL isRowEnabled;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, copy) void(^didSelectBlock)(void);
@property (nonatomic, copy) void(^didBecomeFirstResponderBlock)(void);
@property (nonatomic, copy) void(^performPreviousAction)(void);
@property (nonatomic, copy) void(^performNextAction)(void);
@property InputAccessoryViewType inputAccessoryViewType;
@property BOOL isValid;
@end