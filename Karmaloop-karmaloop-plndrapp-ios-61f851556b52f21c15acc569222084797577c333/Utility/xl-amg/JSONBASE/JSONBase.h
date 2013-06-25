//
//  JSONBase.h
//  oda-ios
//
//  Created by DX065 on 11-06-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@interface JSONBase : NSObject <JSONModel> {
    NSArray *keyValuePairs_;
}

- (id)initFromJSON:(const NSString *)jsonString;
- (id)initFromDictionary:(NSDictionary *)dictionary;

- (void)updateFromDictionary:(NSDictionary *)dictionary;

- (id)proxyForJson;
- (NSArray*) getKeyValuePairs;

- (NSDate *)convertTimestamp:(NSNumber *)timestamp;
+ (NSString *)stringFromBool:(BOOL)value;
+ (BOOL)boolFromString:(NSString *)value;

// overrides to adjust default parsing behaviour
- (void) initDefaults;
- (void) postProcessData;

@end

typedef enum {
    kBaseType,
    kArrayType,
    kObjectType
} BASE_JSON_TYPE;

@interface KeyValuePair : NSObject {
    NSString *key_;

    Class type_;
    BASE_JSON_TYPE jsonBaseType_;
}

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong) NSObject *value;

- (BOOL)isArray;
- (BOOL)isObject;
- (Class)type;

- (id)initWithKey:(const NSString *)key andValue:(NSObject * __strong *)value andType:(Class)type;
+ (KeyValuePair *)pairWithKey:(const NSString *)key andValue:(NSObject * __strong *)value andType:(Class)type;
+ (KeyValuePair *)pairWithKey:(const NSString *)key andValue:(NSObject * __strong *)value andArrayType:(Class)type;

@end


