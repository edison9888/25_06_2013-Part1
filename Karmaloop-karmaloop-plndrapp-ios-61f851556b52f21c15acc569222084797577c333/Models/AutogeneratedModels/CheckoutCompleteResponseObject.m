#import "CheckoutCompleteResponseObject.h"

@implementation CheckoutCompleteResponseObject

@synthesize orderNumber = _orderNumber;

NSString *CheckoutCompleteResponseorderNumberCodingKey = @"CheckoutCompleteResponseorderNumberCodingKey";

- (id)initWithorderNumber:(NSNumber *)orderNumber
{
    self = [super init];
    if (self) {
        _orderNumber = orderNumber;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"orderNumber" andValue:&_orderNumber andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_orderNumber forKey:CheckoutCompleteResponseorderNumberCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *orderNumber = [aDecoder decodeObjectForKey:CheckoutCompleteResponseorderNumberCodingKey];
    self = [self initWithorderNumber:orderNumber ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *orderNumber = [_orderNumber copy];
    CheckoutCompleteResponseObject *object = [[[self class] allocWithZone:zone] initWithorderNumber:orderNumber ];
    return object;
}

@end