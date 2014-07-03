#import "_Post.h"

@interface Post : _Post {}
// Custom logic goes here.
+(void)postPostWithAttributes:(NSDictionary *)dict image:(UIImage *)image Completion:(void (^)(NSError *error))completion;
+(NSURLSessionDataTask *)userPostsWithCompletion:(void (^)(NSError *error))completion;
//+(NSURLSessionDataTask *)currentUserPosts:(void (^)(NSError *error))completion;
+(NSURLSessionDataTask *)postsByContestID:(NSString *)contestID completion:(void (^)(NSError *error))completion;
+(NSURLSessionDataTask *)userStreamPostsWithPage:(NSInteger)page Completion:(void (^)(NSError *error))completion;
-(NSURLSessionDataTask *)likePostWithCompletion:(void (^)(NSError *error)) completion;
+(NSURLSessionDataTask *)userPostsWithID:(NSString *)userID page:(NSInteger)page completion:(void (^)(NSError *error))completion;
+(NSURLSessionDataTask *)userAnonymousStreamPostsWithCompletion:(void (^)(NSError *error))completion;
-(NSURLSessionDataTask *)commentsWithCompletion:(void (^)(NSError *error))completion;
@end
