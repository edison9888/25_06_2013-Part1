#import "SkuStockObject.h"

@implementation SkuStockObject

@synthesize skuId = _skuId;
@synthesize stock = _stock;

NSString *SkuStockskuIdCodingKey = @"SkuStockskuIdCodingKey";
NSString *SkuStockstockCodingKey = @"SkuStockstockCodingKey";

- (id)initWithskuId:(NSNumber *)skuId
    stock:(NSNumber *)stock
{
    self = [super init];
    if (self) {
        _skuId = skuId;
        _stock = stock;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"skuId" andValue:&_skuId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"stock" andValue:&_stock andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_skuId forKey:SkuStockskuIdCodingKey];
    [aCoder encodeObject:_stock forKey:SkuStockstockCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *skuId = [aDecoder decodeObjectForKey:SkuStockskuIdCodingKey];
    NSNumber *stock = [aDecoder decodeObjectForKey:SkuStockstockCodingKey];
    self = [self initWithskuId:skuId stock:stock ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *skuId = [_skuId copy];
        NSNumber *stock = [_stock copy];
    SkuStockObject *object = [[[self class] allocWithZone:zone] initWithskuId:skuId stock:stock ];
    return object;
}

@end