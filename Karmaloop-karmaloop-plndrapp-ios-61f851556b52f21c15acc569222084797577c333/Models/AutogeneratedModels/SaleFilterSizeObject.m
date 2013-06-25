#import "SaleFilterSizeObject.h"

@implementation SaleFilterSizeObject

@synthesize displayName = _displayName;
@synthesize value = _value;

NSString *SaleFilterSizedisplayCodingKey = @"SaleFilterSizedisplayCodingKey";
NSString *SaleFilterSizevalueCodingKey = @"SaleFilterSizevalueCodingKey";

- (id)initWithdisplayName:(NSString *)displayName
    value:(NSString *)value
{
    self = [super init];
    if (self) {
        _displayName = displayName;
        _value = value;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"display" andValue:&_displayName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_value andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_displayName forKey:SaleFilterSizedisplayCodingKey];
    [aCoder encodeObject:_value forKey:SaleFilterSizevalueCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *displayName = [aDecoder decodeObjectForKey:SaleFilterSizedisplayCodingKey];
    NSString *value = [aDecoder decodeObjectForKey:SaleFilterSizevalueCodingKey];
    self = [self initWithdisplayName:displayName value:value ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *displayName = [_displayName copy];
        NSString *value = [_value copy];
    SaleFilterSizeObject *object = [[[self class] allocWithZone:zone] initWithdisplayName:displayName value:value ];
    return object;
}

@end