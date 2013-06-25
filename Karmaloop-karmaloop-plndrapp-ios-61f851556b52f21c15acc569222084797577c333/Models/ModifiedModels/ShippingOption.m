//
//  ShippingOption.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShippingOption.h"

@implementation ShippingOption

@synthesize isSelected = _isSelected;

NSString* kShippingOptionIsSelectedKey = @"kShippingOptionIsSelectedKey";

- (void)postProcessData {
    _isSelected = [NSNumber numberWithBool:NO];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: name=%@ value=%@ cost=%@", [self class], self.name, self.shippingOptionValue, self.cost];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_isSelected forKey:kShippingOptionIsSelectedKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    _isSelected = [aDecoder decodeObjectForKey:kShippingOptionIsSelectedKey];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ShippingOption *option = [super copyWithZone:zone];
    option.isSelected = self.isSelected;
    return option;
}

+ (NSArray *)getAPIShippingOptionsForShippingOptions:(NSArray *)options {
    NSMutableArray *apiOptions = [NSMutableArray array];
    for (ShippingOption *option in options) {
        [apiOptions addObject:option.shippingOptionValue];
    }
    return apiOptions;
}

@end
