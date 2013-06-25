#import <Foundation/Foundation.h>
#import "JSONBase.h"

@interface AddressObject : JSONBase <NSCoding, NSCopying> {
@protected
        NSString *_firstName;
        NSString *_lastName;
        NSString *_attention;
        NSString *_email;
        NSString *_address1;
        NSString *_address2;
        NSString *_address3;
        NSString *_city;
        NSString *_state;
        NSString *_country;
        NSString *_postalCode;
        NSString *_phone;
}

    @property (nonatomic, strong, readwrite) NSString *firstName;
    @property (nonatomic, strong, readwrite) NSString *lastName;
    @property (nonatomic, strong, readwrite) NSString *attention;
    @property (nonatomic, strong, readwrite) NSString *email;
    @property (nonatomic, strong, readwrite) NSString *address1;
    @property (nonatomic, strong, readwrite) NSString *address2;
    @property (nonatomic, strong, readwrite) NSString *address3;
    @property (nonatomic, strong, readwrite) NSString *city;
    @property (nonatomic, strong, readwrite) NSString *state;
    @property (nonatomic, strong, readwrite) NSString *country;
    @property (nonatomic, strong, readwrite) NSString *postalCode;
    @property (nonatomic, strong, readwrite) NSString *phone;


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
;


@end