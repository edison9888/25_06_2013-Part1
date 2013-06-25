//
//  MultiLinePreviewAndCheckboxMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiLinePreviewMetaData.h"

@interface MultiLinePreviewAndCheckboxMetaData : MultiLinePreviewMetaData

@property BOOL isChecked;
@property (nonatomic, copy) void(^clickedCheckbox)(void);

@end
