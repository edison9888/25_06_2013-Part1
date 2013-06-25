#import "DiscountCodeObject.h"

@implementation DiscountCodeObject

@synthesize name = _name;
@synthesize type = _type;

NSString *DiscountCodenameCodingKey = @"DiscountCodenameCodingKey";
NSString *DiscountCodetypeCodingKey = @"DiscountCodetypeCodingKey";

- (id)initWithname:(NSString *)name
    type:(NSString *)type
{
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"type" andValue:&_type andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:DiscountCodenameCodingKey];
    [aCoder encodeObject:_type forKey:DiscountCodetypeCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:DiscountCodenameCodingKey];
    NSString *type = [aDecoder decodeObjectForKey:DiscountCodetypeCodingKey];
    self = [self initWithname:name type:type ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *name = [_name copy];
        NSString *type = [_type copy];
    DiscountCodeObject *object = [[[self class] allocWithZone:zone] initWithname:name type:type ];
    return object;
}

@end