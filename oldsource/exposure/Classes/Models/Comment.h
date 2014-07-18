#import "_Comment.h"

@interface Comment : _Comment {}
// Custom logic goes here.
+(NSURLSessionDataTask *)postComment:(NSString *)comment ForPostID:(NSString *)postID completion:(void (^)(NSError *error))completion;
@end
