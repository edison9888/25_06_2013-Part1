#import "AccountDetailsObject.h"

@implementation AccountDetailsObject

@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize phone = _phone;
@synthesize birthdayRaw = _birthdayRaw;
@synthesize gender = _gender;
@synthesize customerId = _customerId;

NSString *AccountDetailsemailCodingKey = @"AccountDetailsemailCodingKey";
NSString *AccountDetailsfirstNameCodingKey = @"AccountDetailsfirstNameCodingKey";
NSString *AccountDetailslastNameCodingKey = @"AccountDetailslastNameCodingKey";
NSString *AccountDetailsphoneCodingKey = @"AccountDetailsphoneCodingKey";
NSString *AccountDetailsbirthdayCodingKey = @"AccountDetailsbirthdayCodingKey";
NSString *AccountDetailsgenderCodingKey = @"AccountDetailsgenderCodingKey";
NSString *AccountDetailscustomerIdCodingKey = @"AccountDetailscustomerIdCodingKey";

- (id)initWithemail:(NSString *)email
    firstName:(NSString *)firstName
    lastName:(NSString *)lastName
    phone:(NSString *)phone
    birthdayRaw:(NSString *)birthdayRaw
    gender:(NSString *)gender
    customerId:(NSNumber *)customerId
{
    self = [super init];
    if (self) {
        _email = email;
        _firstName = firstName;
        _lastName = lastName;
        _phone = phone;
        _birthdayRaw = birthdayRaw;
        _gender = gender;
        _customerId = customerId;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"email" andValue:&_email andType:[NSString class]],
            [KeyValuePair pairWithKey:@"firstName" andValue:&_firstName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"lastName" andValue:&_lastName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"phone" andValue:&_phone andType:[NSString class]],
            [KeyValuePair pairWithKey:@"birthday" andValue:&_birthdayRaw andType:[NSString class]],
            [KeyValuePair pairWithKey:@"gender" andValue:&_gender andType:[NSString class]],
            [KeyValuePair pairWithKey:@"customerId" andValue:&_customerId andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_email forKey:AccountDetailsemailCodingKey];
    [aCoder encodeObject:_firstName forKey:AccountDetailsfirstNameCodingKey];
    [aCoder encodeObject:_lastName forKey:AccountDetailslastNameCodingKey];
    [aCoder encodeObject:_phone forKey:AccountDetailsphoneCodingKey];
    [aCoder encodeObject:_birthdayRaw forKey:AccountDetailsbirthdayCodingKey];
    [aCoder encodeObject:_gender forKey:AccountDetailsgenderCodingKey];
    [aCoder encodeObject:_customerId forKey:AccountDetailscustomerIdCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *email = [aDecoder decodeObjectForKey:AccountDetailsemailCodingKey];
    NSString *firstName = [aDecoder decodeObjectForKey:AccountDetailsfirstNameCodingKey];
    NSString *lastName = [aDecoder decodeObjectForKey:AccountDetailslastNameCodingKey];
    NSString *phone = [aDecoder decodeObjectForKey:AccountDetailsphoneCodingKey];
    NSString *birthdayRaw = [aDecoder decodeObjectForKey:AccountDetailsbirthdayCodingKey];
    NSString *gender = [aDecoder decodeObjectForKey:AccountDetailsgenderCodingKey];
    NSNumber *customerId = [aDecoder decodeObjectForKey:AccountDetailscustomerIdCodingKey];
    self = [self initWithemail:email firstName:firstName lastName:lastName phone:phone birthdayRaw:birthdayRaw gender:gender customerId:customerId ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *email = [_email copy];
        NSString *firstName = [_firstName copy];
        NSString *lastName = [_lastName copy];
        NSString *phone = [_phone copy];
        NSString *birthdayRaw = [_birthdayRaw copy];
        NSString *gender = [_gender copy];
        NSNumber *customerId = [_customerId copy];
    AccountDetailsObject *object = [[[self class] allocWithZone:zone] initWithemail:email firstName:firstName lastName:lastName phone:phone birthdayRaw:birthdayRaw gender:gender customerId:customerId ];
    return object;
}

@end