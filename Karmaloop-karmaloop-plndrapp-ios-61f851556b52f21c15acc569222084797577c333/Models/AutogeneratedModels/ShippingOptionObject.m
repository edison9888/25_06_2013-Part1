#import "ShippingOptionObject.h"

@implementation ShippingOptionObject

@synthesize cost = _cost;
@synthesize name = _name;
@synthesize shippingOptionValue = _shippingOptionValue;

NSString *ShippingOptioncostCodingKey = @"ShippingOptioncostCodingKey";
NSString *ShippingOptionnameCodingKey = @"ShippingOptionnameCodingKey";
NSString *ShippingOptionvalueCodingKey = @"ShippingOptionvalueCodingKey";

- (id)initWithcost:(NSNumber *)cost
    name:(NSString *)name
    shippingOptionValue:(NSString *)shippingOptionValue
{
    self = [super init];
    if (self) {
        _cost = cost;
        _name = name;
        _shippingOptionValue = shippingOptionValue;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"cost" andValue:&_cost andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_shippingOptionValue andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cost forKey:ShippingOptioncostCodingKey];
    [aCoder encodeObject:_name forKey:ShippingOptionnameCodingKey];
    [aCoder encodeObject:_shippingOptionValue forKey:ShippingOptionvalueCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *cost = [aDecoder decodeObjectForKey:ShippingOptioncostCodingKey];
    NSString *name = [aDecoder decodeObjectForKey:ShippingOptionnameCodingKey];
    NSString *shippingOptionValue = [aDecoder decodeObjectForKey:ShippingOptionvalueCodingKey];
    self = [self initWithcost:cost name:name shippingOptionValue:shippingOptionValue ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *cost = [_cost copy];
        NSString *name = [_name copy];
        NSString *shippingOptionValue = [_shippingOptionValue copy];
    ShippingOptionObject *object = [[[self class] allocWithZone:zone] initWithcost:cost name:name shippingOptionValue:shippingOptionValue ];
    return object;
}

@end