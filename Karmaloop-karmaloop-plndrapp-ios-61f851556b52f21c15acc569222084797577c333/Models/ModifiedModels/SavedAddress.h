//
//  SavedAddress.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-06-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SavedAddressObject.h"

typedef enum{
    SavedAddressBilling,
    SavedAddressShipping
}SavedAddressTypes;

@interface SavedAddress : SavedAddressObject

- (BOOL) isSavedAddressOfType:(SavedAddressTypes)savedAddressType;
+ (NSString*) getSavedAddressTypeString:(SavedAddressTypes) savedAddressType;
+ (int) getIndexOfDefaultSavedAddressOfType:(SavedAddressTypes) savedAddressType inArray:(NSArray*) array;

- (NSArray *)getNameSummary;
- (NSDictionary*) getAPIDictionary;

@end
