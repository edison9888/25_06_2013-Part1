#import "SaleObject.h"

@implementation SaleObject

@synthesize saleId = _saleId;
@synthesize url = _url;
@synthesize vendorId = _vendorId;
@synthesize name = _name;
@synthesize tileImagePathLarge = _tileImagePathLarge;
@synthesize tileImagePathMedium = _tileImagePathMedium;
@synthesize startDateRaw = _startDateRaw;
@synthesize endDateRaw = _endDateRaw;
@synthesize priority = _priority;

NSString *SalesaleIdCodingKey = @"SalesaleIdCodingKey";
NSString *SaleurlCodingKey = @"SaleurlCodingKey";
NSString *SalevendorIdCodingKey = @"SalevendorIdCodingKey";
NSString *SalenameCodingKey = @"SalenameCodingKey";
NSString *SaletileImagePathLargeCodingKey = @"SaletileImagePathLargeCodingKey";
NSString *SaletileImagePathMediumCodingKey = @"SaletileImagePathMediumCodingKey";
NSString *SalestartDateCodingKey = @"SalestartDateCodingKey";
NSString *SaleendDateCodingKey = @"SaleendDateCodingKey";
NSString *SalepriorityCodingKey = @"SalepriorityCodingKey";

- (id)initWithsaleId:(NSNumber *)saleId
    url:(NSString *)url
    vendorId:(NSNumber *)vendorId
    name:(NSString *)name
    tileImagePathLarge:(NSString *)tileImagePathLarge
    tileImagePathMedium:(NSString *)tileImagePathMedium
    startDateRaw:(NSString *)startDateRaw
    endDateRaw:(NSString *)endDateRaw
    priority:(NSNumber *)priority
{
    self = [super init];
    if (self) {
        _saleId = saleId;
        _url = url;
        _vendorId = vendorId;
        _name = name;
        _tileImagePathLarge = tileImagePathLarge;
        _tileImagePathMedium = tileImagePathMedium;
        _startDateRaw = startDateRaw;
        _endDateRaw = endDateRaw;
        _priority = priority;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"saleId" andValue:&_saleId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"url" andValue:&_url andType:[NSString class]],
            [KeyValuePair pairWithKey:@"vendorId" andValue:&_vendorId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"tileImagePathLarge" andValue:&_tileImagePathLarge andType:[NSString class]],
            [KeyValuePair pairWithKey:@"tileImagePathMedium" andValue:&_tileImagePathMedium andType:[NSString class]],
            [KeyValuePair pairWithKey:@"startDate" andValue:&_startDateRaw andType:[NSString class]],
            [KeyValuePair pairWithKey:@"endDate" andValue:&_endDateRaw andType:[NSString class]],
            [KeyValuePair pairWithKey:@"priority" andValue:&_priority andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_saleId forKey:SalesaleIdCodingKey];
    [aCoder encodeObject:_url forKey:SaleurlCodingKey];
    [aCoder encodeObject:_vendorId forKey:SalevendorIdCodingKey];
    [aCoder encodeObject:_name forKey:SalenameCodingKey];
    [aCoder encodeObject:_tileImagePathLarge forKey:SaletileImagePathLargeCodingKey];
    [aCoder encodeObject:_tileImagePathMedium forKey:SaletileImagePathMediumCodingKey];
    [aCoder encodeObject:_startDateRaw forKey:SalestartDateCodingKey];
    [aCoder encodeObject:_endDateRaw forKey:SaleendDateCodingKey];
    [aCoder encodeObject:_priority forKey:SalepriorityCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *saleId = [aDecoder decodeObjectForKey:SalesaleIdCodingKey];
    NSString *url = [aDecoder decodeObjectForKey:SaleurlCodingKey];
    NSNumber *vendorId = [aDecoder decodeObjectForKey:SalevendorIdCodingKey];
    NSString *name = [aDecoder decodeObjectForKey:SalenameCodingKey];
    NSString *tileImagePathLarge = [aDecoder decodeObjectForKey:SaletileImagePathLargeCodingKey];
    NSString *tileImagePathMedium = [aDecoder decodeObjectForKey:SaletileImagePathMediumCodingKey];
    NSString *startDateRaw = [aDecoder decodeObjectForKey:SalestartDateCodingKey];
    NSString *endDateRaw = [aDecoder decodeObjectForKey:SaleendDateCodingKey];
    NSNumber *priority = [aDecoder decodeObjectForKey:SalepriorityCodingKey];
    self = [self initWithsaleId:saleId url:url vendorId:vendorId name:name tileImagePathLarge:tileImagePathLarge tileImagePathMedium:tileImagePathMedium startDateRaw:startDateRaw endDateRaw:endDateRaw priority:priority ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *saleId = [_saleId copy];
        NSString *url = [_url copy];
        NSNumber *vendorId = [_vendorId copy];
        NSString *name = [_name copy];
        NSString *tileImagePathLarge = [_tileImagePathLarge copy];
        NSString *tileImagePathMedium = [_tileImagePathMedium copy];
        NSString *startDateRaw = [_startDateRaw copy];
        NSString *endDateRaw = [_endDateRaw copy];
        NSNumber *priority = [_priority copy];
    SaleObject *object = [[[self class] allocWithZone:zone] initWithsaleId:saleId url:url vendorId:vendorId name:name tileImagePathLarge:tileImagePathLarge tileImagePathMedium:tileImagePathMedium startDateRaw:startDateRaw endDateRaw:endDateRaw priority:priority ];
    return object;
}

@end