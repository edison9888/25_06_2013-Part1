#import <Foundation/Foundation.h>
#import "JSONBase.h"
#import "Address.h"

@interface SavedAddressObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSNumber *_addressId;
        NSString *_name;
        NSNumber *_isPrimary;
        Address *_address;
        NSString *_typeOfPrimary;
}

    @property (nonatomic, strong, readwrite) NSNumber *addressId;
    @property (nonatomic, strong, readwrite) NSString *name;
    @property (nonatomic, strong, readwrite) NSNumber *isPrimary;
    @property (nonatomic, strong, readwrite) Address *address;
    @property (nonatomic, strong, readwrite) NSString *typeOfPrimary;


- (id)initWithaddressId:(NSNumber *)addressId
    name:(NSString *)name
    isPrimary:(NSNumber *)isPrimary
    address:(Address *)address
    typeOfPrimary:(NSString *)typeOfPrimary
;


@end