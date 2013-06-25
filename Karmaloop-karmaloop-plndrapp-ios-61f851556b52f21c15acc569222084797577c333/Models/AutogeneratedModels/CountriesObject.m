#import "CountriesObject.h"

@implementation CountriesObject

@synthesize name = _name;
@synthesize shortName = _shortName;
@synthesize states = _states;

NSString *CountriesnameCodingKey = @"CountriesnameCodingKey";
NSString *CountriesvalueCodingKey = @"CountriesvalueCodingKey";
NSString *CountriesstatesCodingKey = @"CountriesstatesCodingKey";

- (id)initWithname:(NSString *)name
    shortName:(NSString *)shortName
    states:(NSArray *)states
{
    self = [super init];
    if (self) {
        _name = name;
        _shortName = shortName;
        _states = states;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_shortName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"states" andValue:&_states andArrayType:[State class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:CountriesnameCodingKey];
    [aCoder encodeObject:_shortName forKey:CountriesvalueCodingKey];
    [aCoder encodeObject:_states forKey:CountriesstatesCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:CountriesnameCodingKey];
    NSString *shortName = [aDecoder decodeObjectForKey:CountriesvalueCodingKey];
    NSArray *states = [aDecoder decodeObjectForKey:CountriesstatesCodingKey];
    self = [self initWithname:name shortName:shortName states:states ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *name = [_name copy];
        NSString *shortName = [_shortName copy];
        NSArray *states = [[NSArray alloc] initWithArray:_states copyItems:YES];
    CountriesObject *object = [[[self class] allocWithZone:zone] initWithname:name shortName:shortName states:states ];
    return object;
}

@end