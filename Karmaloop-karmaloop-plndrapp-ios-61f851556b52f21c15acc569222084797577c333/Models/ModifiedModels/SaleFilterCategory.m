//
//  SaleFilterCategory.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaleFilterCategory.h"

@implementation SaleFilterCategory

- (void)setSizes:(NSArray *)sizes {
    _sizes = sizes;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: name=%@", [self class], self.displayName];
}

@end
