#import "AddressObject.h"

@implementation AddressObject

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize attention = _attention;
@synthesize email = _email;
@synthesize address1 = _address1;
@synthesize address2 = _address2;
@synthesize address3 = _address3;
@synthesize city = _city;
@synthesize state = _state;
@synthesize country = _country;
@synthesize postalCode = _postalCode;
@synthesize phone = _phone;

NSString *AddressfirstNameCodingKey = @"AddressfirstNameCodingKey";
NSString *AddresslastNameCodingKey = @"AddresslastNameCodingKey";
NSString *AddressattentionCodingKey = @"AddressattentionCodingKey";
NSString *AddressemailCodingKey = @"AddressemailCodingKey";
NSString *Addressaddress1CodingKey = @"Addressaddress1CodingKey";
NSString *Addressaddress2CodingKey = @"Addressaddress2CodingKey";
NSString *Addressaddress3CodingKey = @"Addressaddress3CodingKey";
NSString *AddresscityCodingKey = @"AddresscityCodingKey";
NSString *AddressstateCodingKey = @"AddressstateCodingKey";
NSString *AddresscountryCodingKey = @"AddresscountryCodingKey";
NSString *AddresspostalCodeCodingKey = @"AddresspostalCodeCodingKey";
NSString *AddressphoneCodingKey = @"AddressphoneCodingKey";

- (id)initWithfirstName:(NSString *)firstName
    lastName:(NSString *)lastName
    attention:(NSString *)attention
    email:(NSString *)email
    address1:(NSString *)address1
    address2:(NSString *)address2
    address3:(NSString *)address3
    city:(NSString *)city
    state:(NSString *)state
    country:(NSString *)country
    postalCode:(NSString *)postalCode
    phone:(NSString *)phone
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _attention = attention;
        _email = email;
        _address1 = address1;
        _address2 = address2;
        _address3 = address3;
        _city = city;
        _state = state;
        _country = country;
        _postalCode = postalCode;
        _phone = phone;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"firstName" andValue:&_firstName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"lastName" andValue:&_lastName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"attention" andValue:&_attention andType:[NSString class]],
            [KeyValuePair pairWithKey:@"email" andValue:&_email andType:[NSString class]],
            [KeyValuePair pairWithKey:@"address1" andValue:&_address1 andType:[NSString class]],
            [KeyValuePair pairWithKey:@"address2" andValue:&_address2 andType:[NSString class]],
            [KeyValuePair pairWithKey:@"address3" andValue:&_address3 andType:[NSString class]],
            [KeyValuePair pairWithKey:@"city" andValue:&_city andType:[NSString class]],
            [KeyValuePair pairWithKey:@"state" andValue:&_state andType:[NSString class]],
            [KeyValuePair pairWithKey:@"country" andValue:&_country andType:[NSString class]],
            [KeyValuePair pairWithKey:@"postalCode" andValue:&_postalCode andType:[NSString class]],
            [KeyValuePair pairWithKey:@"phone" andValue:&_phone andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_firstName forKey:AddressfirstNameCodingKey];
    [aCoder encodeObject:_lastName forKey:AddresslastNameCodingKey];
    [aCoder encodeObject:_attention forKey:AddressattentionCodingKey];
    [aCoder encodeObject:_email forKey:AddressemailCodingKey];
    [aCoder encodeObject:_address1 forKey:Addressaddress1CodingKey];
    [aCoder encodeObject:_address2 forKey:Addressaddress2CodingKey];
    [aCoder encodeObject:_address3 forKey:Addressaddress3CodingKey];
    [aCoder encodeObject:_city forKey:AddresscityCodingKey];
    [aCoder encodeObject:_state forKey:AddressstateCodingKey];
    [aCoder encodeObject:_country forKey:AddresscountryCodingKey];
    [aCoder encodeObject:_postalCode forKey:AddresspostalCodeCodingKey];
    [aCoder encodeObject:_phone forKey:AddressphoneCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *firstName = [aDecoder decodeObjectForKey:AddressfirstNameCodingKey];
    NSString *lastName = [aDecoder decodeObjectForKey:AddresslastNameCodingKey];
    NSString *attention = [aDecoder decodeObjectForKey:AddressattentionCodingKey];
    NSString *email = [aDecoder decodeObjectForKey:AddressemailCodingKey];
    NSString *address1 = [aDecoder decodeObjectForKey:Addressaddress1CodingKey];
    NSString *address2 = [aDecoder decodeObjectForKey:Addressaddress2CodingKey];
    NSString *address3 = [aDecoder decodeObjectForKey:Addressaddress3CodingKey];
    NSString *city = [aDecoder decodeObjectForKey:AddresscityCodingKey];
    NSString *state = [aDecoder decodeObjectForKey:AddressstateCodingKey];
    NSString *country = [aDecoder decodeObjectForKey:AddresscountryCodingKey];
    NSString *postalCode = [aDecoder decodeObjectForKey:AddresspostalCodeCodingKey];
    NSString *phone = [aDecoder decodeObjectForKey:AddressphoneCodingKey];
    self = [self initWithfirstName:firstName lastName:lastName attention:attention email:email address1:address1 address2:address2 address3:address3 city:city state:state country:country postalCode:postalCode phone:phone ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *firstName = [_firstName copy];
        NSString *lastName = [_lastName copy];
        NSString *attention = [_attention copy];
        NSString *email = [_email copy];
        NSString *address1 = [_address1 copy];
        NSString *address2 = [_address2 copy];
        NSString *address3 = [_address3 copy];
        NSString *city = [_city copy];
        NSString *state = [_state copy];
        NSString *country = [_country copy];
        NSString *postalCode = [_postalCode copy];
        NSString *phone = [_phone copy];
    AddressObject *object = [[[self class] allocWithZone:zone] initWithfirstName:firstName lastName:lastName attention:attention email:email address1:address1 address2:address2 address3:address3 city:city state:state country:country postalCode:postalCode phone:phone ];
    return object;
}

@end