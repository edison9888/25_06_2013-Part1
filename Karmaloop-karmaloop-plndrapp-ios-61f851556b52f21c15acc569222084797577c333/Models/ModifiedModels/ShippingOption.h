//
//  ShippingOption.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShippingOptionObject.h"

@interface ShippingOption : ShippingOptionObject

@property (nonatomic, strong) NSNumber *isSelected;

+ (NSArray*) getAPIShippingOptionsForShippingOptions:(NSArray*)options;

@end
