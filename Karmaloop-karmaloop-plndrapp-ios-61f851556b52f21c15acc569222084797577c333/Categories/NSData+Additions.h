#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface NSData(Additions)

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

- (BOOL) hasPrefix:(NSData *) prefix;
- (BOOL) hasPrefixBytes:(void *) prefix length:(unsigned int) length;

- (NSData *) encryptWithKey:(NSData *) aSymmetricKey;
- (NSData *) decryptWithKey:(NSData *) aSymmetricKey;

- (NSData *) doCipherWithKey:(NSData *) symmetricKey context:(CCOperation) encryptOrDecrypt;

@end
