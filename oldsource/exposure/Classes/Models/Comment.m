#import "Comment.h"
#import "CoreData+MagicalRecord.h"
#import "EXPAPIClient.h"
#import "User.h"

@interface Comment ()

// Private interface goes here.

@end


@implementation Comment

// Custom logic goes here.
+(NSURLSessionDataTask *)postComment:(NSString *)comment ForPostID:(NSString *)postID completion:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
    
    return [[EXPAPIClient sharedClient]POST:@"comments/" parameters:@{@"post[post_id]": postID, @"user_email":user.email ,@"user_token": user.token, @"comment[text]":comment} success:^(NSURLSessionDataTask *task, id responseObject){
        if (completion) {
            completion(nil);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion) {
            NSLog(@"%@", error);
            completion(error);
        }
    }];
    
}
@end
