#import "ShippingDetailsObject.h"

@implementation ShippingDetailsObject

@synthesize address = _address;
@synthesize method = _method;
@synthesize options = _options;

NSString *ShippingDetailsaddressCodingKey = @"ShippingDetailsaddressCodingKey";
NSString *ShippingDetailsmethodCodingKey = @"ShippingDetailsmethodCodingKey";
NSString *ShippingDetailsoptionsCodingKey = @"ShippingDetailsoptionsCodingKey";

- (id)initWithaddress:(Address *)address
    method:(NSString *)method
    options:(NSArray *)options
{
    self = [super init];
    if (self) {
        _address = address;
        _method = method;
        _options = options;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"address" andValue:&_address andType:[Address class]],
            [KeyValuePair pairWithKey:@"method" andValue:&_method andType:[NSString class]],
            [KeyValuePair pairWithKey:@"options" andValue:&_options andArrayType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_address forKey:ShippingDetailsaddressCodingKey];
    [aCoder encodeObject:_method forKey:ShippingDetailsmethodCodingKey];
    [aCoder encodeObject:_options forKey:ShippingDetailsoptionsCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    Address *address = [aDecoder decodeObjectForKey:ShippingDetailsaddressCodingKey];
    NSString *method = [aDecoder decodeObjectForKey:ShippingDetailsmethodCodingKey];
    NSArray *options = [aDecoder decodeObjectForKey:ShippingDetailsoptionsCodingKey];
    self = [self initWithaddress:address method:method options:options ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        Address *address = [_address copy];
        NSString *method = [_method copy];
        NSArray *options = [[NSArray alloc] initWithArray:_options copyItems:YES];
    ShippingDetailsObject *object = [[[self class] allocWithZone:zone] initWithaddress:address method:method options:options ];
    return object;
}

@end