#import "StateObject.h"

@implementation StateObject

@synthesize name = _name;
@synthesize shortName = _shortName;

NSString *StatenameCodingKey = @"StatenameCodingKey";
NSString *StatevalueCodingKey = @"StatevalueCodingKey";

- (id)initWithname:(NSString *)name
    shortName:(NSString *)shortName
{
    self = [super init];
    if (self) {
        _name = name;
        _shortName = shortName;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"name" andValue:&_name andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_shortName andType:[NSString class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:StatenameCodingKey];
    [aCoder encodeObject:_shortName forKey:StatevalueCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:StatenameCodingKey];
    NSString *shortName = [aDecoder decodeObjectForKey:StatevalueCodingKey];
    self = [self initWithname:name shortName:shortName ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *name = [_name copy];
        NSString *shortName = [_shortName copy];
    StateObject *object = [[[self class] allocWithZone:zone] initWithname:name shortName:shortName ];
    return object;
}

@end