#import "Notification.h"
#import "EXPAPIClient.h"
#import "User.h"
#import "CoreData+MagicalRecord.h"

@interface Notification ()

// Private interface goes here.

@end


@implementation Notification

// Custom logic goes here.
+ (NSURLSessionDataTask *)notificationsForUser:(User *)user completion:(void (^)(User *user, NSError *error))block {
  return [[EXPAPIClient sharedClient] POST:@"notifications" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}


@end
