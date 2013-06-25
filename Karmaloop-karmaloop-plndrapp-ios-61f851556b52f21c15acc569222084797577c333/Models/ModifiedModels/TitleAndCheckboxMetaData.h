//
//  TitleAndCheckboxMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

@interface TitleAndCheckboxMetaData : CellMetaData

@property (nonatomic, strong) NSString *cellTitle;
@property BOOL isChecked;

@end
