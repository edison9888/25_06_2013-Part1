#import "CheckoutSummaryObject.h"

@implementation CheckoutSummaryObject

@synthesize adjustedItems = _adjustedItems;
@synthesize appliedDiscounts = _appliedDiscounts;
@synthesize cartSubtotal = _cartSubtotal;
@synthesize handling = _handling;
@synthesize shippingSubtotal = _shippingSubtotal;
@synthesize subtotal = _subtotal;
@synthesize tax = _tax;
@synthesize total = _total;
@synthesize totalDiscount = _totalDiscount;

NSString *CheckoutSummaryadjustedItemsCodingKey = @"CheckoutSummaryadjustedItemsCodingKey";
NSString *CheckoutSummaryappliedDiscountsCodingKey = @"CheckoutSummaryappliedDiscountsCodingKey";
NSString *CheckoutSummarycartSubtotalCodingKey = @"CheckoutSummarycartSubtotalCodingKey";
NSString *CheckoutSummaryhandlingCodingKey = @"CheckoutSummaryhandlingCodingKey";
NSString *CheckoutSummaryshippingSubtotalCodingKey = @"CheckoutSummaryshippingSubtotalCodingKey";
NSString *CheckoutSummarysubtotalCodingKey = @"CheckoutSummarysubtotalCodingKey";
NSString *CheckoutSummarytaxCodingKey = @"CheckoutSummarytaxCodingKey";
NSString *CheckoutSummarytotalCodingKey = @"CheckoutSummarytotalCodingKey";
NSString *CheckoutSummarytotalDiscountCodingKey = @"CheckoutSummarytotalDiscountCodingKey";

- (id)initWithadjustedItems:(NSArray *)adjustedItems
    appliedDiscounts:(NSArray *)appliedDiscounts
    cartSubtotal:(NSNumber *)cartSubtotal
    handling:(NSNumber *)handling
    shippingSubtotal:(NSNumber *)shippingSubtotal
    subtotal:(NSNumber *)subtotal
    tax:(NSNumber *)tax
    total:(NSNumber *)total
    totalDiscount:(NSNumber *)totalDiscount
{
    self = [super init];
    if (self) {
        _adjustedItems = adjustedItems;
        _appliedDiscounts = appliedDiscounts;
        _cartSubtotal = cartSubtotal;
        _handling = handling;
        _shippingSubtotal = shippingSubtotal;
        _subtotal = subtotal;
        _tax = tax;
        _total = total;
        _totalDiscount = totalDiscount;
    }
    return self;
}

- (NSArray *) getKeyValuePairs
{
    return [NSArray arrayWithObjects:
            [KeyValuePair pairWithKey:@"adjustedItems" andValue:&_adjustedItems andArrayType:[AdjustedCartItem class]],
            [KeyValuePair pairWithKey:@"appliedDiscounts" andValue:&_appliedDiscounts andArrayType:[AppliedDiscountCode class]],
            [KeyValuePair pairWithKey:@"cartSubtotal" andValue:&_cartSubtotal andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"handling" andValue:&_handling andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"shippingSubtotal" andValue:&_shippingSubtotal andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"subtotal" andValue:&_subtotal andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"tax" andValue:&_tax andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"total" andValue:&_total andType:[NSNumber class]],
            [KeyValuePair pairWithKey:@"totalDiscount" andValue:&_totalDiscount andType:[NSNumber class]],
            nil];
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_adjustedItems forKey:CheckoutSummaryadjustedItemsCodingKey];
    [aCoder encodeObject:_appliedDiscounts forKey:CheckoutSummaryappliedDiscountsCodingKey];
    [aCoder encodeObject:_cartSubtotal forKey:CheckoutSummarycartSubtotalCodingKey];
    [aCoder encodeObject:_handling forKey:CheckoutSummaryhandlingCodingKey];
    [aCoder encodeObject:_shippingSubtotal forKey:CheckoutSummaryshippingSubtotalCodingKey];
    [aCoder encodeObject:_subtotal forKey:CheckoutSummarysubtotalCodingKey];
    [aCoder encodeObject:_tax forKey:CheckoutSummarytaxCodingKey];
    [aCoder encodeObject:_total forKey:CheckoutSummarytotalCodingKey];
    [aCoder encodeObject:_totalDiscount forKey:CheckoutSummarytotalDiscountCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSArray *adjustedItems = [aDecoder decodeObjectForKey:CheckoutSummaryadjustedItemsCodingKey];
    NSArray *appliedDiscounts = [aDecoder decodeObjectForKey:CheckoutSummaryappliedDiscountsCodingKey];
    NSNumber *cartSubtotal = [aDecoder decodeObjectForKey:CheckoutSummarycartSubtotalCodingKey];
    NSNumber *handling = [aDecoder decodeObjectForKey:CheckoutSummaryhandlingCodingKey];
    NSNumber *shippingSubtotal = [aDecoder decodeObjectForKey:CheckoutSummaryshippingSubtotalCodingKey];
    NSNumber *subtotal = [aDecoder decodeObjectForKey:CheckoutSummarysubtotalCodingKey];
    NSNumber *tax = [aDecoder decodeObjectForKey:CheckoutSummarytaxCodingKey];
    NSNumber *total = [aDecoder decodeObjectForKey:CheckoutSummarytotalCodingKey];
    NSNumber *totalDiscount = [aDecoder decodeObjectForKey:CheckoutSummarytotalDiscountCodingKey];
    self = [self initWithadjustedItems:adjustedItems appliedDiscounts:appliedDiscounts cartSubtotal:cartSubtotal handling:handling shippingSubtotal:shippingSubtotal subtotal:subtotal tax:tax total:total totalDiscount:totalDiscount ];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
        NSArray *adjustedItems = [[NSArray alloc] initWithArray:_adjustedItems copyItems:YES];
        NSArray *appliedDiscounts = [[NSArray alloc] initWithArray:_appliedDiscounts copyItems:YES];
        NSNumber *cartSubtotal = [_cartSubtotal copy];
        NSNumber *handling = [_handling copy];
        NSNumber *shippingSubtotal = [_shippingSubtotal copy];
        NSNumber *subtotal = [_subtotal copy];
        NSNumber *tax = [_tax copy];
        NSNumber *total = [_total copy];
        NSNumber *totalDiscount = [_totalDiscount copy];
    CheckoutSummaryObject *object = [[[self class] allocWithZone:zone] initWithadjustedItems:adjustedItems appliedDiscounts:appliedDiscounts cartSubtotal:cartSubtotal handling:handling shippingSubtotal:shippingSubtotal subtotal:subtotal tax:tax total:total totalDiscount:totalDiscount ];
    return object;
}

@end