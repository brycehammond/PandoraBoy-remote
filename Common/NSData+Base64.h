#import <Foundation/Foundation.h>

//NSData category to implement Base64 encoding/decoding
@interface NSData (Base64)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

@end


