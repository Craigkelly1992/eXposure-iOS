#import "Contest.h"
#import "CoreData+MagicalRecord.h"
#import "User.h"
#import "EXPAPIClient.h"

@interface Contest ()

// Private interface goes here.

@end


@implementation Contest

// Custom logic goes here.
+ (NSURLSessionDataTask *)contestsWithcompletion:(void (^)(NSArray *contests, NSError *error))block {
    User *user = [User currentUser];
    NSString *string = [NSString stringWithFormat:@"contests"];
    return [[EXPAPIClient sharedClient]GET:string parameters:(user != nil) ? @{@"user_email":user.email ,@"user_token": user.token}:@{} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in responseObject) {
            Contest *contest = [Contest MR_createEntity];
            contest.title = dict[@"title"];
            contest.contest_description = dict[@"description"];
            contest.contest_id = [NSString stringWithFormat:@"%@", dict[@"id"]];
            contest.picture = dict[@"picture_file_name"];
            contest.brand_name = dict[@"brand_name"];
            contest.brand_id = [NSString stringWithFormat:@"%@",dict[@"brand_id"]];
            [array addObject:contest];
            
        }
        if(block){
            NSArray *arrayr =  [NSArray arrayWithArray:array];
            block(arrayr, nil);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
    
}

+ (NSURLSessionDataTask *)brandClickWithID:(NSString *)brandID completion:(void (^)(Contest *contest, NSError *error))block {
    User *user = [User currentUser];
    NSString *string = [NSString stringWithFormat:@"brands/%@/click",brandID];
    return [[EXPAPIClient sharedClient]GET:string parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
    
}

@end
