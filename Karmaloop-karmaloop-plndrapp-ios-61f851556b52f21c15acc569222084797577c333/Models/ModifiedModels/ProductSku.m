//
//  ProductSku.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductSku.h"

@implementation ProductSku

- (void)randomizeStock {
    int randomInt = arc4random() % 5;
    _stock = [NSNumber numberWithInt:randomInt];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: skuId=%@ size=%@", [self class], self.skuId, self.size];
}

@end
