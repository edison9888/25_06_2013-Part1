
#import "JSONBase.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

#pragma mark - KeyValuePair

@interface KeyValuePair() {
@private
    NSObject * __strong *valuePtr_;
}
@end

@implementation KeyValuePair

@synthesize key = key_;

- (id)initWithKey:(NSString *)key andValue:(NSObject * __strong *)value andType:(Class)type {
    self = [super init];
    if (self) {
        key_ = key;
        
        valuePtr_ = value;
        type_ = type;
        if ((type == [NSString class]) || (type == [NSNumber class]) || (type == [NSDictionary class])) {
             jsonBaseType_ = kBaseType;
        } else {
            jsonBaseType_ = kObjectType;
        }
    }
    return self;
}

- (id)initWithKey:(NSString *)key andValue:(NSObject * __strong *)value andArrayType:(Class)type {
    self = [super init];
    if (self) {
        key_ = key;
        
        valuePtr_ = value;
        type_ = type;
        jsonBaseType_ = kArrayType;
    }
    return self;
}

+ (KeyValuePair *)pairWithKey:(NSString *)key andValue:(NSObject * __strong *)value andType:(Class)type {
    return [[KeyValuePair alloc] initWithKey:key andValue:value andType:(Class)type];
}

+ (KeyValuePair *)pairWithKey:(NSString *)key andValue:(NSObject * __strong *)value andArrayType:(Class)type {
    return [[KeyValuePair alloc] initWithKey:key andValue:value andArrayType:(Class)type];
}

- (NSObject *)value {
    if (valuePtr_ == nil) {
        return nil;
    }
    return *valuePtr_;
}

- (void)setValue:(__strong NSObject *)value {
    if ((valuePtr_ != nil) && ([self isArray] || [value isKindOfClass:type_] || (value == nil))) {
        *valuePtr_ = value;
    }
}

- (BOOL)isArray {
    return (jsonBaseType_ == kArrayType);
}

- (BOOL)isObject {
    return (jsonBaseType_ == kObjectType);
}

- (Class)type {
    return type_;
}


@end

#pragma mark - JSONBase

@implementation JSONBase

- (id)init
{
    self = [super init];
    if (self)
    {
        keyValuePairs_ = [self getKeyValuePairs];
    }
    return self;
}

- (id)initFromJSON:(const NSString *)jsonString
{
    NSDictionary *jsonData = [jsonString JSONValue];
    return [self initFromDictionary:jsonData];
}

- (id)initFromDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        [self initDefaults];
        [self updateFromDictionary:dictionary];
    }
    return self;
}

- (void)updateFromDictionary:(NSDictionary *)dictionary
{
    for (KeyValuePair *pair in keyValuePairs_)
    {
        if ([pair isArray]) {
            if ((pair.type == [NSString class]) || (pair.type == [NSNumber class]) || (pair.type == [NSDictionary class])) {            
                pair.value = [dictionary objectForKey:pair.key];
            } else {
                // need to further parse the JSONBase objects in the array
                NSArray *raw = [dictionary objectForKey:pair.key];
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[raw count]];
                for (NSDictionary *element in raw) {
                    NSObject *parsed = [[[pair type] alloc] initFromDictionary:element];
                    [array addObject:parsed];
                }
                pair.value = array;
            }
        } else if ([pair isObject]) {
            NSDictionary *raw = [dictionary objectForKey:pair.key];
            if (raw != nil) {
                NSObject *parsed = [[[pair type] alloc] initFromDictionary:raw];
                pair.value = parsed;
            }
        } else {
            pair.value = [dictionary objectForKey:pair.key];
        }
    }
    [self postProcessData];
}

- (id)proxyForJson
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (KeyValuePair *pair in keyValuePairs_)
    {
        if (pair.value != nil) {
            [dictionary setObject:pair.value forKey:pair.key];
        }
    }
    return dictionary;
}

- (NSArray*) getKeyValuePairs {
    return nil;
}

- (void) initDefaults {
    // normally no special defaults
}

- (void) postProcessData {
    // normally nothing special needs to be done here
}

- (NSDate *)convertTimestamp:(NSNumber *)timestamp
{
    unsigned long long reallyPreciseTime = [timestamp unsignedLongLongValue];
    return [NSDate dateWithTimeIntervalSince1970:(double)(reallyPreciseTime / 1000.0)];    
}

+ (NSString *)stringFromBool:(BOOL)value
{
    if(value == YES)
    {
        return @"Y";
    } else {
        return @"N";
    }
}

+ (BOOL)boolFromString:(NSString *)value
{
    return [value isEqualToString:@"Y"];
}

#pragma mark - Comparison

- (BOOL)isEqualToJSONBase:(JSONBase *)other {

    if (self == other) {
        return YES;
    }
    
    NSArray *otherKeyValuePairs = [other getKeyValuePairs];
    if ([keyValuePairs_ count] != [otherKeyValuePairs count]) {
        return NO;
    }
    
    // compare the values from the keyValuePairs array
    for (int i = 0; i < [keyValuePairs_ count]; ++i) {
        id selfValue = [(KeyValuePair *)[keyValuePairs_ objectAtIndex:i] value];
        id otherValue = [(KeyValuePair *)[otherKeyValuePairs objectAtIndex:i] value];
        
        if (selfValue == otherValue) {
            // we're cool, proceed
        } else {
            if (((selfValue == nil) && (otherValue != nil)) || 
                ((otherValue == nil) && (selfValue != nil)) ||
                ![selfValue isEqual:otherValue]) {
                return NO;
            }
        }
    }    
    
    return YES;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToJSONBase:other];
}

@end
