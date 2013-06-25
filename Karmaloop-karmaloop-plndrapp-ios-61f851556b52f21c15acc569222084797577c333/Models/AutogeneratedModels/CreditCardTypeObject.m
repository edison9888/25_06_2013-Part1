#import "CreditCardTypeObject.h"

@implementation CreditCardTypeObject

@synthesize name = _name;
@synthesize value = _value;

NSString *CreditCardTypenameCodingKey = @"CreditCardTypenameCodingKey";
NSString *CreditCardTypevalueCodingKey = @"CreditCardTypevalueCodingKey";

- (id)initWithname:(NSString *)name
    value:(NSString *)value
{
    self = [super init];
    if (self) {
        _name = name;
        _value = value;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_value andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:CreditCardTypenameCodingKey];
    [aCoder encodeObject:_value forKey:CreditCardTypevalueCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:CreditCardTypenameCodingKey];
    NSString *value = [aDecoder decodeObjectForKey:CreditCardTypevalueCodingKey];
    self = [self initWithname:name value:value ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *name = [_name copy];
        NSString *value = [_value copy];
    CreditCardTypeObject *object = [[[self class] allocWithZone:zone] initWithname:name value:value ];
    return object;
}

@end