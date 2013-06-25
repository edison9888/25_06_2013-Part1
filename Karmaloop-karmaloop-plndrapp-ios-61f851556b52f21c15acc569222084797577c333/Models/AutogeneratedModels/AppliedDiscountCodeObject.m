#import "AppliedDiscountCodeObject.h"

@implementation AppliedDiscountCodeObject

@synthesize name = _name;
@synthesize discountDescription = _discountDescription;
@synthesize shipping = _shipping;
@synthesize subtotal = _subtotal;
@synthesize totalDiscount = _totalDiscount;
@synthesize type = _type;

NSString *AppliedDiscountCodenameCodingKey = @"AppliedDiscountCodenameCodingKey";
NSString *AppliedDiscountCodedescriptionCodingKey = @"AppliedDiscountCodedescriptionCodingKey";
NSString *AppliedDiscountCodeshippingCodingKey = @"AppliedDiscountCodeshippingCodingKey";
NSString *AppliedDiscountCodesubtotalCodingKey = @"AppliedDiscountCodesubtotalCodingKey";
NSString *AppliedDiscountCodetotalDiscountCodingKey = @"AppliedDiscountCodetotalDiscountCodingKey";
NSString *AppliedDiscountCodetypeCodingKey = @"AppliedDiscountCodetypeCodingKey";

- (id)initWithname:(NSString *)name
    discountDescription:(NSString *)discountDescription
    shipping:(NSNumber *)shipping
    subtotal:(NSNumber *)subtotal
    totalDiscount:(NSNumber *)totalDiscount
    type:(NSString *)type
{
    self = [super init];
    if (self) {
        _name = name;
        _discountDescription = discountDescription;
        _shipping = shipping;
        _subtotal = subtotal;
        _totalDiscount = totalDiscount;
        _type = type;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"description" andValue:&_discountDescription andType:[NSString class]],
            [KeyValuePair pairWithKey:@"shipping" andValue:&_shipping andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"subtotal" andValue:&_subtotal andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"totalDiscount" andValue:&_totalDiscount andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"type" andValue:&_type andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:AppliedDiscountCodenameCodingKey];
    [aCoder encodeObject:_discountDescription forKey:AppliedDiscountCodedescriptionCodingKey];
    [aCoder encodeObject:_shipping forKey:AppliedDiscountCodeshippingCodingKey];
    [aCoder encodeObject:_subtotal forKey:AppliedDiscountCodesubtotalCodingKey];
    [aCoder encodeObject:_totalDiscount forKey:AppliedDiscountCodetotalDiscountCodingKey];
    [aCoder encodeObject:_type forKey:AppliedDiscountCodetypeCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:AppliedDiscountCodenameCodingKey];
    NSString *discountDescription = [aDecoder decodeObjectForKey:AppliedDiscountCodedescriptionCodingKey];
    NSNumber *shipping = [aDecoder decodeObjectForKey:AppliedDiscountCodeshippingCodingKey];
    NSNumber *subtotal = [aDecoder decodeObjectForKey:AppliedDiscountCodesubtotalCodingKey];
    NSNumber *totalDiscount = [aDecoder decodeObjectForKey:AppliedDiscountCodetotalDiscountCodingKey];
    NSString *type = [aDecoder decodeObjectForKey:AppliedDiscountCodetypeCodingKey];
    self = [self initWithname:name discountDescription:discountDescription shipping:shipping subtotal:subtotal totalDiscount:totalDiscount type:type ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *name = [_name copy];
        NSString *discountDescription = [_discountDescription copy];
        NSNumber *shipping = [_shipping copy];
        NSNumber *subtotal = [_subtotal copy];
        NSNumber *totalDiscount = [_totalDiscount copy];
        NSString *type = [_type copy];
    AppliedDiscountCodeObject *object = [[[self class] allocWithZone:zone] initWithname:name discountDescription:discountDescription shipping:shipping subtotal:subtotal totalDiscount:totalDiscount type:type ];
    return object;
}

@end