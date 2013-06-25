//
//  TitleAndPickerViewMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"
#import "TitleAndTextFieldMetaData.h"

@interface TitleAndPickerViewMetaData : TitleAndTextFieldMetaData

@property (nonatomic, strong) NSArray *pickerDataSources;
@property (nonatomic, strong) NSArray *pickerValues;
@property (nonatomic, strong) NSArray *pickerColumnWidths;
@property (nonatomic, copy) void(^writePickerValuesBlock)(NSArray*);
@property BOOL hasBeenSelected;

@end
