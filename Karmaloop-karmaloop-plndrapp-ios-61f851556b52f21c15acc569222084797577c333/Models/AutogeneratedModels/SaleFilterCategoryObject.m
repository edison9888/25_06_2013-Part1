#import "SaleFilterCategoryObject.h"

@implementation SaleFilterCategoryObject

@synthesize displayName = _displayName;
@synthesize categoryId = _categoryId;
@synthesize sizes = _sizes;

NSString *SaleFilterCategorydisplayCodingKey = @"SaleFilterCategorydisplayCodingKey";
NSString *SaleFilterCategoryvalueCodingKey = @"SaleFilterCategoryvalueCodingKey";
NSString *SaleFilterCategorynoKeyCodingKey = @"SaleFilterCategorynoKeyCodingKey";

- (id)initWithdisplayName:(NSString *)displayName
    categoryId:(NSString *)categoryId
    sizes:(NSArray *)sizes
{
    self = [super init];
    if (self) {
        _displayName = displayName;
        _categoryId = categoryId;
        _sizes = sizes;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"display" andValue:&_displayName andType:[NSString class]],
            [KeyValuePair pairWithKey:@"value" andValue:&_categoryId andType:[NSString class]],
            [KeyValuePair pairWithKey:@"noKey" andValue:&_sizes andArrayType:[SaleFilterSize class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_displayName forKey:SaleFilterCategorydisplayCodingKey];
    [aCoder encodeObject:_categoryId forKey:SaleFilterCategoryvalueCodingKey];
    [aCoder encodeObject:_sizes forKey:SaleFilterCategorynoKeyCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *displayName = [aDecoder decodeObjectForKey:SaleFilterCategorydisplayCodingKey];
    NSString *categoryId = [aDecoder decodeObjectForKey:SaleFilterCategoryvalueCodingKey];
    NSArray *sizes = [aDecoder decodeObjectForKey:SaleFilterCategorynoKeyCodingKey];
    self = [self initWithdisplayName:displayName categoryId:categoryId sizes:sizes ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSString *displayName = [_displayName copy];
        NSString *categoryId = [_categoryId copy];
        NSArray *sizes = [[NSArray alloc] initWithArray:_sizes copyItems:YES];
    SaleFilterCategoryObject *object = [[[self class] allocWithZone:zone] initWithdisplayName:displayName categoryId:categoryId sizes:sizes ];
    return object;
}

@end