#import "ShippingMethodObject.h"

@implementation ShippingMethodObject

@synthesize cost = _cost;
@synthesize isAvailable = _isAvailable;
@synthesize name = _name;
@synthesize shippingMethodValue = _shippingMethodValue;
@synthesize shippingOptions = _shippingOptions;

NSString *ShippingMethodcostCodingKey = @"ShippingMethodcostCodingKey";
NSString *ShippingMethodisAvailableCodingKey = @"ShippingMethodisAvailableCodingKey";
NSString *ShippingMethodnameCodingKey = @"ShippingMethodnameCodingKey";
NSString *ShippingMethodvalueCodingKey = @"ShippingMethodvalueCodingKey";
NSString *ShippingMethodoptionsCodingKey = @"ShippingMethodoptionsCodingKey";

- (id)initWithcost:(NSNumber *)cost
    isAvailable:(NSNumber *)isAvailable
    name:(NSString *)name
    shippingMethodValue:(NSString *)shippingMethodValue
    shippingOptions:(NSArray *)shippingOptions
{
    self = [super init];
    if (self) {
        _cost = cost;
        _isAvailable = isAvailable;
        _name = name;
        _shippingMethodValue = shippingMethodValue;
        _shippingOptions = shippingOptions;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"cost" andValue:&_cost andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"isAvailable" andValue:&_isAvailable andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_shippingMethodValue andType:[NSString class]],
            [KeyValuePair pairWithKey:@"options" andValue:&_shippingOptions andArrayType:[ShippingOption class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_cost forKey:ShippingMethodcostCodingKey];
    [aCoder encodeObject:_isAvailable forKey:ShippingMethodisAvailableCodingKey];
    [aCoder encodeObject:_name forKey:ShippingMethodnameCodingKey];
    [aCoder encodeObject:_shippingMethodValue forKey:ShippingMethodvalueCodingKey];
    [aCoder encodeObject:_shippingOptions forKey:ShippingMethodoptionsCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *cost = [aDecoder decodeObjectForKey:ShippingMethodcostCodingKey];
    NSNumber *isAvailable = [aDecoder decodeObjectForKey:ShippingMethodisAvailableCodingKey];
    NSString *name = [aDecoder decodeObjectForKey:ShippingMethodnameCodingKey];
    NSString *shippingMethodValue = [aDecoder decodeObjectForKey:ShippingMethodvalueCodingKey];
    NSArray *shippingOptions = [aDecoder decodeObjectForKey:ShippingMethodoptionsCodingKey];
    self = [self initWithcost:cost isAvailable:isAvailable name:name shippingMethodValue:shippingMethodValue shippingOptions:shippingOptions ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *cost = [_cost copy];
        NSNumber *isAvailable = [_isAvailable copy];
        NSString *name = [_name copy];
        NSString *shippingMethodValue = [_shippingMethodValue copy];
        NSArray *shippingOptions = [[NSArray alloc] initWithArray:_shippingOptions copyItems:YES];
    ShippingMethodObject *object = [[[self class] allocWithZone:zone] initWithcost:cost isAvailable:isAvailable name:name shippingMethodValue:shippingMethodValue shippingOptions:shippingOptions ];
    return object;
}

@end