#import "_Brand.h"

@interface Brand : _Brand {}
// Custom logic goes here.
+ (NSURLSessionDataTask *)brandWithID:(NSString *)brandID completion:(void (^)(Brand *brand, NSError *error))block;
@end
