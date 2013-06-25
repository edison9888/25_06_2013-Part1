#import "SavedAddressObject.h"

@implementation SavedAddressObject

@synthesize addressId = _addressId;
@synthesize name = _name;
@synthesize isPrimary = _isPrimary;
@synthesize address = _address;
@synthesize typeOfPrimary = _typeOfPrimary;

NSString *SavedAddressidCodingKey = @"SavedAddressidCodingKey";
NSString *SavedAddressnameCodingKey = @"SavedAddressnameCodingKey";
NSString *SavedAddressisPrimaryCodingKey = @"SavedAddressisPrimaryCodingKey";
NSString *SavedAddressaddressCodingKey = @"SavedAddressaddressCodingKey";
NSString *SavedAddresstypeCodingKey = @"SavedAddresstypeCodingKey";

- (id)initWithaddressId:(NSNumber *)addressId
    name:(NSString *)name
    isPrimary:(NSNumber *)isPrimary
    address:(Address *)address
    typeOfPrimary:(NSString *)typeOfPrimary
{
    self = [super init];
    if (self) {
        _addressId = addressId;
        _name = name;
        _isPrimary = isPrimary;
        _address = address;
        _typeOfPrimary = typeOfPrimary;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"id" andValue:&_addressId andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"isPrimary" andValue:&_isPrimary andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"address" andValue:&_address andType:[Address class]],
            [KeyValuePair pairWithKey:@"type" andValue:&_typeOfPrimary andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_addressId forKey:SavedAddressidCodingKey];
    [aCoder encodeObject:_name forKey:SavedAddressnameCodingKey];
    [aCoder encodeObject:_isPrimary forKey:SavedAddressisPrimaryCodingKey];
    [aCoder encodeObject:_address forKey:SavedAddressaddressCodingKey];
    [aCoder encodeObject:_typeOfPrimary forKey:SavedAddresstypeCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSNumber *addressId = [aDecoder decodeObjectForKey:SavedAddressidCodingKey];
    NSString *name = [aDecoder decodeObjectForKey:SavedAddressnameCodingKey];
    NSNumber *isPrimary = [aDecoder decodeObjectForKey:SavedAddressisPrimaryCodingKey];
    Address *address = [aDecoder decodeObjectForKey:SavedAddressaddressCodingKey];
    NSString *typeOfPrimary = [aDecoder decodeObjectForKey:SavedAddresstypeCodingKey];
    self = [self initWithaddressId:addressId name:name isPrimary:isPrimary address:address typeOfPrimary:typeOfPrimary ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSNumber *addressId = [_addressId copy];
        NSString *name = [_name copy];
        NSNumber *isPrimary = [_isPrimary copy];
        Address *address = [_address copy];
        NSString *typeOfPrimary = [_typeOfPrimary copy];
    SavedAddressObject *object = [[[self class] allocWithZone:zone] initWithaddressId:addressId name:name isPrimary:isPrimary address:address typeOfPrimary:typeOfPrimary ];
    return object;
}

@end