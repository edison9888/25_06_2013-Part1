#import "ProductSkuObject.h"

@implementation ProductSkuObject

@synthesize skuId = _skuId;
@synthesize stock = _stock;
@synthesize size = _size;
@synthesize color = _color;

NSString *ProductSkuidCodingKey = @"ProductSkuidCodingKey";
NSString *ProductSkustockCodingKey = @"ProductSkustockCodingKey";
NSString *ProductSkusizeCodeCodingKey = @"ProductSkusizeCodeCodingKey";
NSString *ProductSkucolorCodingKey = @"ProductSkucolorCodingKey";

- (id)initWithskuId:(NSNumber *)skuId
    stock:(NSNumber *)stock
    size:(NSString *)size
    color:(NSString *)color
{
    self = [super init];
    if (self) {
        _skuId = skuId;
        _stock = stock;
        _size = size;
        _color = color;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"id" andValue:&_skuId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"stock" andValue:&_stock andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"sizeCode" andValue:&_size andType:[NSString class]],
            [KeyValuePair pairWithKey:@"color" andValue:&_color andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_skuId forKey:ProductSkuidCodingKey];
    [aCoder encodeObject:_stock forKey:ProductSkustockCodingKey];
    [aCoder encodeObject:_size forKey:ProductSkusizeCodeCodingKey];
    [aCoder encodeObject:_color forKey:ProductSkucolorCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *skuId = [aDecoder decodeObjectForKey:ProductSkuidCodingKey];
    NSNumber *stock = [aDecoder decodeObjectForKey:ProductSkustockCodingKey];
    NSString *size = [aDecoder decodeObjectForKey:ProductSkusizeCodeCodingKey];
    NSString *color = [aDecoder decodeObjectForKey:ProductSkucolorCodingKey];
    self = [self initWithskuId:skuId stock:stock size:size color:color ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *skuId = [_skuId copy];
        NSNumber *stock = [_stock copy];
        NSString *size = [_size copy];
        NSString *color = [_color copy];
    ProductSkuObject *object = [[[self class] allocWithZone:zone] initWithskuId:skuId stock:stock size:size color:color ];
    return object;
}

@end