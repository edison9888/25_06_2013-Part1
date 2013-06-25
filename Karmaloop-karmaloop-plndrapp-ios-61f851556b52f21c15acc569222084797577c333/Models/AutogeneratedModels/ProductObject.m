#import "ProductObject.h"

@implementation ProductObject

@synthesize productId = _productId;
@synthesize style = _style;
@synthesize name = _name;
@synthesize url = _url;
@synthesize productDescription = _productDescription;
@synthesize vendorId = _vendorId;
@synthesize vendorName = _vendorName;
@synthesize availabilityEndDateRaw = _availabilityEndDateRaw;
@synthesize browseImageUrl = _browseImageUrl;
@synthesize checkoutPrice = _checkoutPrice;
@synthesize price = _price;
@synthesize categoryId = _categoryId;
@synthesize zooms = _zooms;
@synthesize stock = _stock;
@synthesize skus = _skus;

NSString *ProductidCodingKey = @"ProductidCodingKey";
NSString *ProductstyleNumberCodingKey = @"ProductstyleNumberCodingKey";
NSString *ProductnameCodingKey = @"ProductnameCodingKey";
NSString *ProducturlCodingKey = @"ProducturlCodingKey";
NSString *ProductmobileDescriptionCodingKey = @"ProductmobileDescriptionCodingKey";
NSString *ProductvendorIdCodingKey = @"ProductvendorIdCodingKey";
NSString *ProductvendorNameCodingKey = @"ProductvendorNameCodingKey";
NSString *ProductavailabilityEndDateCodingKey = @"ProductavailabilityEndDateCodingKey";
NSString *ProductbrowseImageUrlCodingKey = @"ProductbrowseImageUrlCodingKey";
NSString *ProductcheckoutPriceCodingKey = @"ProductcheckoutPriceCodingKey";
NSString *ProductpriceCodingKey = @"ProductpriceCodingKey";
NSString *ProductcategoryIdCodingKey = @"ProductcategoryIdCodingKey";
NSString *ProductzoomsCodingKey = @"ProductzoomsCodingKey";
NSString *ProductstockCodingKey = @"ProductstockCodingKey";
NSString *ProductskusCodingKey = @"ProductskusCodingKey";

- (id)initWithproductId:(NSNumber *)productId
    style:(NSString *)style
    name:(NSString *)name
    url:(NSString *)url
    productDescription:(NSString *)productDescription
    vendorId:(NSNumber *)vendorId
    vendorName:(NSString *)vendorName
    availabilityEndDateRaw:(NSString *)availabilityEndDateRaw
    browseImageUrl:(NSString *)browseImageUrl
    checkoutPrice:(NSNumber *)checkoutPrice
    price:(NSNumber *)price
    categoryId:(NSNumber *)categoryId
    zooms:(NSArray *)zooms
    stock:(NSNumber *)stock
    skus:(NSArray *)skus
{
    self = [super init];
    if (self) {
        _productId = productId;
        _style = style;
        _name = name;
        _url = url;
        _productDescription = productDescription;
        _vendorId = vendorId;
        _vendorName = vendorName;
        _availabilityEndDateRaw = availabilityEndDateRaw;
        _browseImageUrl = browseImageUrl;
        _checkoutPrice = checkoutPrice;
        _price = price;
        _categoryId = categoryId;
        _zooms = zooms;
        _stock = stock;
        _skus = skus;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"id" andValue:&_productId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"styleNumber" andValue:&_style andType:[NSString class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"url" andValue:&_url andType:[NSString class]],
            [KeyValuePair pairWithKey:@"mobileDescription" andValue:&_productDescription andType:[NSString class]],
            [KeyValuePair pairWithKey:@"vendorId" andValue:&_vendorId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"vendorName" andValue:&_vendorName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"availabilityEndDate" andValue:&_availabilityEndDateRaw andType:[NSString class]],
            [KeyValuePair pairWithKey:@"browseImageUrl" andValue:&_browseImageUrl andType:[NSString class]],
            [KeyValuePair pairWithKey:@"checkoutPrice" andValue:&_checkoutPrice andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"price" andValue:&_price andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"categoryId" andValue:&_categoryId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"zooms" andValue:&_zooms andArrayType:[NSString class]],
            [KeyValuePair pairWithKey:@"stock" andValue:&_stock andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"skus" andValue:&_skus andArrayType:[ProductSku class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_productId forKey:ProductidCodingKey];
    [aCoder encodeObject:_style forKey:ProductstyleNumberCodingKey];
    [aCoder encodeObject:_name forKey:ProductnameCodingKey];
    [aCoder encodeObject:_url forKey:ProducturlCodingKey];
    [aCoder encodeObject:_productDescription forKey:ProductmobileDescriptionCodingKey];
    [aCoder encodeObject:_vendorId forKey:ProductvendorIdCodingKey];
    [aCoder encodeObject:_vendorName forKey:ProductvendorNameCodingKey];
    [aCoder encodeObject:_availabilityEndDateRaw forKey:ProductavailabilityEndDateCodingKey];
    [aCoder encodeObject:_browseImageUrl forKey:ProductbrowseImageUrlCodingKey];
    [aCoder encodeObject:_checkoutPrice forKey:ProductcheckoutPriceCodingKey];
    [aCoder encodeObject:_price forKey:ProductpriceCodingKey];
    [aCoder encodeObject:_categoryId forKey:ProductcategoryIdCodingKey];
    [aCoder encodeObject:_zooms forKey:ProductzoomsCodingKey];
    [aCoder encodeObject:_stock forKey:ProductstockCodingKey];
    [aCoder encodeObject:_skus forKey:ProductskusCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *productId = [aDecoder decodeObjectForKey:ProductidCodingKey];
    NSString *style = [aDecoder decodeObjectForKey:ProductstyleNumberCodingKey];
    NSString *name = [aDecoder decodeObjectForKey:ProductnameCodingKey];
    NSString *url = [aDecoder decodeObjectForKey:ProducturlCodingKey];
    NSString *productDescription = [aDecoder decodeObjectForKey:ProductmobileDescriptionCodingKey];
    NSNumber *vendorId = [aDecoder decodeObjectForKey:ProductvendorIdCodingKey];
    NSString *vendorName = [aDecoder decodeObjectForKey:ProductvendorNameCodingKey];
    NSString *availabilityEndDateRaw = [aDecoder decodeObjectForKey:ProductavailabilityEndDateCodingKey];
    NSString *browseImageUrl = [aDecoder decodeObjectForKey:ProductbrowseImageUrlCodingKey];
    NSNumber *checkoutPrice = [aDecoder decodeObjectForKey:ProductcheckoutPriceCodingKey];
    NSNumber *price = [aDecoder decodeObjectForKey:ProductpriceCodingKey];
    NSNumber *categoryId = [aDecoder decodeObjectForKey:ProductcategoryIdCodingKey];
    NSArray *zooms = [aDecoder decodeObjectForKey:ProductzoomsCodingKey];
    NSNumber *stock = [aDecoder decodeObjectForKey:ProductstockCodingKey];
    NSArray *skus = [aDecoder decodeObjectForKey:ProductskusCodingKey];
    self = [self initWithproductId:productId style:style name:name url:url productDescription:productDescription vendorId:vendorId vendorName:vendorName availabilityEndDateRaw:availabilityEndDateRaw browseImageUrl:browseImageUrl checkoutPrice:checkoutPrice price:price categoryId:categoryId zooms:zooms stock:stock skus:skus ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *productId = [_productId copy];
        NSString *style = [_style copy];
        NSString *name = [_name copy];
        NSString *url = [_url copy];
        NSString *productDescription = [_productDescription copy];
        NSNumber *vendorId = [_vendorId copy];
        NSString *vendorName = [_vendorName copy];
        NSString *availabilityEndDateRaw = [_availabilityEndDateRaw copy];
        NSString *browseImageUrl = [_browseImageUrl copy];
        NSNumber *checkoutPrice = [_checkoutPrice copy];
        NSNumber *price = [_price copy];
        NSNumber *categoryId = [_categoryId copy];
        NSArray *zooms = [[NSArray alloc] initWithArray:_zooms copyItems:YES];
        NSNumber *stock = [_stock copy];
        NSArray *skus = [[NSArray alloc] initWithArray:_skus copyItems:YES];
    ProductObject *object = [[[self class] allocWithZone:zone] initWithproductId:productId style:style name:name url:url productDescription:productDescription vendorId:vendorId vendorName:vendorName availabilityEndDateRaw:availabilityEndDateRaw browseImageUrl:browseImageUrl checkoutPrice:checkoutPrice price:price categoryId:categoryId zooms:zooms stock:stock skus:skus ];
    return object;
}

@end