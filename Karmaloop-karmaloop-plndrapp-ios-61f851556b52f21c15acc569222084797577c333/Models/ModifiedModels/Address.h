//
//  Address.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressObject.h"

@interface Address : AddressObject

@property (nonatomic, strong) NSNumber *countryIndex;
@property (nonatomic, strong) NSNumber *stateIndex;


- (BOOL) isComplete;
- (NSArray *)getSummaryStrings;
- (void)rectifyIndexAndStringStates;
- (NSDictionary*) getAPIDictionary;
- (NSArray*) getCountryIndexArray;
- (NSArray*) getCountryAndStateIndexArray;
- (NSArray*) getStateIndexArray;

@end
