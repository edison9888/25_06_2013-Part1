#import "CheckoutErrorObject.h"

@implementation CheckoutErrorObject

@synthesize affectedArea = _affectedArea;
@synthesize generalMessage = _generalMessage;
@synthesize itemMessage = _itemMessage;
@synthesize skuId = _skuId;
@synthesize errorCode = _errorCode;

NSString *CheckoutErroraffectedAreaCodingKey = @"CheckoutErroraffectedAreaCodingKey";
NSString *CheckoutErrorgeneralMessageCodingKey = @"CheckoutErrorgeneralMessageCodingKey";
NSString *CheckoutErroritemMessageCodingKey = @"CheckoutErroritemMessageCodingKey";
NSString *CheckoutErrorskuIdCodingKey = @"CheckoutErrorskuIdCodingKey";
NSString *CheckoutErrorerrorCodeCodingKey = @"CheckoutErrorerrorCodeCodingKey";

- (id)initWithaffectedArea:(NSString *)affectedArea
    generalMessage:(NSString *)generalMessage
    itemMessage:(NSString *)itemMessage
    skuId:(NSNumber *)skuId
    errorCode:(NSString *)errorCode
{
    self = [super init];
    if (self) {
        _affectedArea = affectedArea;
        _generalMessage = generalMessage;
        _itemMessage = itemMessage;
        _skuId = skuId;
        _errorCode = errorCode;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"affectedArea" andValue:&_affectedArea andType:[NSString class]],
            [KeyValuePair pairWithKey:@"generalMessage" andValue:&_generalMessage andType:[NSString class]],
            [KeyValuePair pairWithKey:@"itemMessage" andValue:&_itemMessage andType:[NSString class]],
            [KeyValuePair pairWithKey:@"skuId" andValue:&_skuId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"errorCode" andValue:&_errorCode andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_affectedArea forKey:CheckoutErroraffectedAreaCodingKey];
    [aCoder encodeObject:_generalMessage forKey:CheckoutErrorgeneralMessageCodingKey];
    [aCoder encodeObject:_itemMessage forKey:CheckoutErroritemMessageCodingKey];
    [aCoder encodeObject:_skuId forKey:CheckoutErrorskuIdCodingKey];
    [aCoder encodeObject:_errorCode forKey:CheckoutErrorerrorCodeCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *affectedArea = [aDecoder decodeObjectForKey:CheckoutErroraffectedAreaCodingKey];
    NSString *generalMessage = [aDecoder decodeObjectForKey:CheckoutErrorgeneralMessageCodingKey];
    NSString *itemMessage = [aDecoder decodeObjectForKey:CheckoutErroritemMessageCodingKey];
    NSNumber *skuId = [aDecoder decodeObjectForKey:CheckoutErrorskuIdCodingKey];
    NSString *errorCode = [aDecoder decodeObjectForKey:CheckoutErrorerrorCodeCodingKey];
    self = [self initWithaffectedArea:affectedArea generalMessage:generalMessage itemMessage:itemMessage skuId:skuId errorCode:errorCode ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *affectedArea = [_affectedArea copy];
        NSString *generalMessage = [_generalMessage copy];
        NSString *itemMessage = [_itemMessage copy];
        NSNumber *skuId = [_skuId copy];
        NSString *errorCode = [_errorCode copy];
    CheckoutErrorObject *object = [[[self class] allocWithZone:zone] initWithaffectedArea:affectedArea generalMessage:generalMessage itemMessage:itemMessage skuId:skuId errorCode:errorCode ];
    return object;
}

@end