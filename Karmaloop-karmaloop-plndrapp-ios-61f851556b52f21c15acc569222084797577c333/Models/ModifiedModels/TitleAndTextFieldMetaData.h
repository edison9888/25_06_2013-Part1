//
//  TitleAndTextFieldMetaData.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellMetaData.h"

@interface TitleAndTextFieldMetaData : CellMetaData

@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, strong) NSString *cellDetail;
@property (nonatomic, strong) NSString *cellDetailGhost;
@property (nonatomic, copy) BOOL(^isDetailValidBlock)(NSString* detail);
@property (nonatomic, copy) void(^writeDetailBlock)(NSString*);
@property UIKeyboardType keyboardType;
@property BOOL isSecure;

@end