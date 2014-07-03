#import "_Contest.h"

@interface Contest : _Contest {}
// Custom logic goes here.
+ (NSURLSessionDataTask *)contestsWithcompletion:(void (^)(NSArray *contests, NSError *error))block;
@end
