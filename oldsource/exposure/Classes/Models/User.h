#import "_User.h"

@interface User : _User {}
// Custom logic goes here.

+ (NSURLSessionDataTask *)loginUserWithEmail:(NSString*)email password:(NSString*)password completion:(void (^)(User *user, NSError *error))completion;
+ (NSURLSessionDataTask *)signUpUserWithAttributes:(NSDictionary *)dict completion:(void (^)(User *user, NSError *error))block;
+(NSURLSessionDataTask *)currentUserProfile:(void (^)(NSError *error))block;
+(User*)currentUser;
+ (void)editUserProfileWithAttributes:(NSDictionary *)dict completion:(void (^)(User *user, NSError *error))block;
+ (NSURLSessionDataTask *)userWithID:(NSString *)userID completion:(void (^)(User *user, NSError *error))block;
-(NSURLSessionDataTask *)registerDeviceWithToken:(NSString *)token completion:(void (^)(NSError *error))block;
+(NSURLSessionDataTask *)userGlobalRankingsWithCompletion:(void (^)(NSMutableArray *array, NSError *error))completion;
+(NSURLSessionDataTask *)userFollowingRankingsWithCompletion:(void (^)(NSMutableArray *array, NSError *error))completion;
@end
