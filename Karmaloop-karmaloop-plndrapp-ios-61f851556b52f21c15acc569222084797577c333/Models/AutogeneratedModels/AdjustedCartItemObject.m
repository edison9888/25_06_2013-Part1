#import "AdjustedCartItemObject.h"

@implementation AdjustedCartItemObject

@synthesize adjustedPricePerUnit = _adjustedPricePerUnit;
@synthesize productName = _productName;
@synthesize adjustedShippingPerUnit = _adjustedShippingPerUnit;
@synthesize excludedForm = _excludedForm;
@synthesize originalPricePerUnit = _originalPricePerUnit;
@synthesize originalShippingPerUnit = _originalShippingPerUnit;
@synthesize quantity = _quantity;
@synthesize skuId = _skuId;
@synthesize taxPerUnit = _taxPerUnit;

NSString *AdjustedCartItemadjustedPricePerUnitCodingKey = @"AdjustedCartItemadjustedPricePerUnitCodingKey";
NSString *AdjustedCartItemnameCodingKey = @"AdjustedCartItemnameCodingKey";
NSString *AdjustedCartItemadjustedShippingPerUnitCodingKey = @"AdjustedCartItemadjustedShippingPerUnitCodingKey";
NSString *AdjustedCartItemexcludedFormCodingKey = @"AdjustedCartItemexcludedFormCodingKey";
NSString *AdjustedCartItemoriginalPricePerUnitCodingKey = @"AdjustedCartItemoriginalPricePerUnitCodingKey";
NSString *AdjustedCartItemoriginalShippingPerUnitCodingKey = @"AdjustedCartItemoriginalShippingPerUnitCodingKey";
NSString *AdjustedCartItemquantityCodingKey = @"AdjustedCartItemquantityCodingKey";
NSString *AdjustedCartItemskuIdCodingKey = @"AdjustedCartItemskuIdCodingKey";
NSString *AdjustedCartItemtaxPerUnitCodingKey = @"AdjustedCartItemtaxPerUnitCodingKey";

- (id)initWithadjustedPricePerUnit:(NSNumber *)adjustedPricePerUnit
    productName:(NSString *)productName
    adjustedShippingPerUnit:(NSNumber *)adjustedShippingPerUnit
    excludedForm:(NSArray *)excludedForm
    originalPricePerUnit:(NSNumber *)originalPricePerUnit
    originalShippingPerUnit:(NSNumber *)originalShippingPerUnit
    quantity:(NSNumber *)quantity
    skuId:(NSNumber *)skuId
    taxPerUnit:(NSNumber *)taxPerUnit
{
    self = [super init];
    if (self) {
        _adjustedPricePerUnit = adjustedPricePerUnit;
        _productName = productName;
        _adjustedShippingPerUnit = adjustedShippingPerUnit;
        _excludedForm = excludedForm;
        _originalPricePerUnit = originalPricePerUnit;
        _originalShippingPerUnit = originalShippingPerUnit;
        _quantity = quantity;
        _skuId = skuId;
        _taxPerUnit = taxPerUnit;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"adjustedPricePerUnit" andValue:&_adjustedPricePerUnit andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_productName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"adjustedShippingPerUnit" andValue:&_adjustedShippingPerUnit andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"excludedForm" andValue:&_excludedForm andArrayType:[NSString class]],
            [KeyValuePair pairWithKey:@"originalPricePerUnit" andValue:&_originalPricePerUnit andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"originalShippingPerUnit" andValue:&_originalShippingPerUnit andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"quantity" andValue:&_quantity andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"skuId" andValue:&_skuId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"taxPerUnit" andValue:&_taxPerUnit andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_adjustedPricePerUnit forKey:AdjustedCartItemadjustedPricePerUnitCodingKey];
    [aCoder encodeObject:_productName forKey:AdjustedCartItemnameCodingKey];
    [aCoder encodeObject:_adjustedShippingPerUnit forKey:AdjustedCartItemadjustedShippingPerUnitCodingKey];
    [aCoder encodeObject:_excludedForm forKey:AdjustedCartItemexcludedFormCodingKey];
    [aCoder encodeObject:_originalPricePerUnit forKey:AdjustedCartItemoriginalPricePerUnitCodingKey];
    [aCoder encodeObject:_originalShippingPerUnit forKey:AdjustedCartItemoriginalShippingPerUnitCodingKey];
    [aCoder encodeObject:_quantity forKey:AdjustedCartItemquantityCodingKey];
    [aCoder encodeObject:_skuId forKey:AdjustedCartItemskuIdCodingKey];
    [aCoder encodeObject:_taxPerUnit forKey:AdjustedCartItemtaxPerUnitCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *adjustedPricePerUnit = [aDecoder decodeObjectForKey:AdjustedCartItemadjustedPricePerUnitCodingKey];
    NSString *productName = [aDecoder decodeObjectForKey:AdjustedCartItemnameCodingKey];
    NSNumber *adjustedShippingPerUnit = [aDecoder decodeObjectForKey:AdjustedCartItemadjustedShippingPerUnitCodingKey];
    NSArray *excludedForm = [aDecoder decodeObjectForKey:AdjustedCartItemexcludedFormCodingKey];
    NSNumber *originalPricePerUnit = [aDecoder decodeObjectForKey:AdjustedCartItemoriginalPricePerUnitCodingKey];
    NSNumber *originalShippingPerUnit = [aDecoder decodeObjectForKey:AdjustedCartItemoriginalShippingPerUnitCodingKey];
    NSNumber *quantity = [aDecoder decodeObjectForKey:AdjustedCartItemquantityCodingKey];
    NSNumber *skuId = [aDecoder decodeObjectForKey:AdjustedCartItemskuIdCodingKey];
    NSNumber *taxPerUnit = [aDecoder decodeObjectForKey:AdjustedCartItemtaxPerUnitCodingKey];
    self = [self initWithadjustedPricePerUnit:adjustedPricePerUnit productName:productName adjustedShippingPerUnit:adjustedShippingPerUnit excludedForm:excludedForm originalPricePerUnit:originalPricePerUnit originalShippingPerUnit:originalShippingPerUnit quantity:quantity skuId:skuId taxPerUnit:taxPerUnit ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *adjustedPricePerUnit = [_adjustedPricePerUnit copy];
        NSString *productName = [_productName copy];
        NSNumber *adjustedShippingPerUnit = [_adjustedShippingPerUnit copy];
        NSArray *excludedForm = [[NSArray alloc] initWithArray:_excludedForm copyItems:YES];
        NSNumber *originalPricePerUnit = [_originalPricePerUnit copy];
        NSNumber *originalShippingPerUnit = [_originalShippingPerUnit copy];
        NSNumber *quantity = [_quantity copy];
        NSNumber *skuId = [_skuId copy];
        NSNumber *taxPerUnit = [_taxPerUnit copy];
    AdjustedCartItemObject *object = [[[self class] allocWithZone:zone] initWithadjustedPricePerUnit:adjustedPricePerUnit productName:productName adjustedShippingPerUnit:adjustedShippingPerUnit excludedForm:excludedForm originalPricePerUnit:originalPricePerUnit originalShippingPerUnit:originalShippingPerUnit quantity:quantity skuId:skuId taxPerUnit:taxPerUnit ];
    return object;
}

@end