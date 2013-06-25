//
//  JSONModel.h
//  oda-ios
//
//  Created by DX065 on 11-06-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JSONModel <NSObject>

- (id)initFromJSON:(const NSString *)jsonString;
- (id)initFromDictionary:(NSDictionary *)dictionary;

- (id)proxyForJson;

@end
