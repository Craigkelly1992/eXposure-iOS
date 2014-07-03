#import "Post.h"
#import "User.h"
#import "EXPAPIClient.h"
#import "CoreData+MagicalRecord.h"
#import "MagicalRecord+Actions.h"
#import "Comment.h"


@interface Post ()

// Private interface goes here.

@end


@implementation Post

// Custom logic goes here.
+(void)postPostWithAttributes:(NSDictionary *)dict image:(UIImage *)image Completion:(void (^)(NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"http://exposuretechnologies.com/api/posts" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success!");
        if (completion) {
            NSLog(@"completion exists");
            completion(nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }

    }];
}

+(NSURLSessionDataTask *)userAnonymousStreamPostsWithCompletion:(void (^)(NSError *error))completion {
    return [[EXPAPIClient sharedClient] GET:@"posts" parameters:@{} success:^
            (NSURLSessionDataTask *task, id responseObject){
                NSLog(@"%@",responseObject);
                [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"stream == true"]];
                //  NSMutableArray *mArray = [[NSMutableArray alloc]init];
                for(NSDictionary *dict in responseObject){
                    
                    //[MagicalRecord ]
                    Post *post = [Post MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                    post.image_url = dict[@"image_url"];
                    // NSString *text = dict[@"text"];
                    if(![dict[@"text"] isKindOfClass:[NSNull class]]){
                        post.text = dict[@"text"];
                    }
                    post.post_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    post.user_id = [NSString stringWithFormat:@"%@",dict[@"uploader_id"]];
                    post.streamValue = true;
                    NSLog(@"THE IMAGE ID: %@", post.image_url);
                }
                NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
                [defaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
                    
                    completion(error);
                }];
                
                
                
            }failure:^(NSURLSessionDataTask *task, NSError *error){
                NSLog(@"%@", error);
            }];

}


+(NSURLSessionDataTask *)userStreamPostsWithPage:(NSInteger)page Completion:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
 
    return [[EXPAPIClient sharedClient] GET:@"posts/stream" parameters:@{@"user_email":user.email ,@"user_token": user.token, @"page":[NSString stringWithFormat:@"%ld", (long)page]} success:^
            (NSURLSessionDataTask *task, id responseObject){
                NSLog(@"%@",responseObject);
                if (page == 1) {
                    [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"stream == true"]];
                }
                //  NSMutableArray *mArray = [[NSMutableArray alloc]init];
                for(NSDictionary *dict in responseObject){
                    
                    //[MagicalRecord ]
                    Post *post = [Post MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                    post.image_url = dict[@"image_url"];
                    // NSString *text = dict[@"text"];
                    if(![dict[@"text"] isKindOfClass:[NSNull class]]){
                        post.text = dict[@"text"];
                    }
                    post.post_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    post.user_id = [NSString stringWithFormat:@"%@",dict[@"uploader_id"]];
                    post.streamValue = true;
                    ///NSLog(@"THE IMAGE ID: %@", post.image_url);
                }
                NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
                [defaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
                    
                    completion(error);
                }];
                
                
                
            }failure:^(NSURLSessionDataTask *task, NSError *error){
                NSLog(@"%@", error);
            }];
}

-(NSURLSessionDataTask *)commentsWithCompletion:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient]GET:[NSString stringWithFormat:@"posts/%@/comments",self.post_id] parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
      //500 error, can't see JSON.
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"COMMENT ERROR: %@",error);
        
    }];
}


+(NSURLSessionDataTask *)userPostsWithCompletion:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
   
    return [[EXPAPIClient sharedClient] GET:@"posts/my_posts" parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^
            (NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
                [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",[User currentUser].user_id]];
              //  NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for(NSDictionary *dict in responseObject){
            
                //[MagicalRecord ]
                Post *post = [Post MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                post.image_url = dict[@"image_url"];
                // NSString *text = dict[@"text"];
                if(![dict[@"text"] isKindOfClass:[NSNull class]]){
                    post.text = dict[@"text"];
                }
                post.post_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                post.user_id = [NSString stringWithFormat:@"%@",dict[@"uploader_id"]];
                post.like_countValue = [NSString stringWithFormat:@"%@", dict[@"cached_votes_up"]].integerValue;
            NSLog(@"THE IMAGE ID: %@", post.image_url);
        }
        NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
        [defaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
            
            completion(error);
        }];

           
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@", error);
    }];
}

+(NSURLSessionDataTask *)userPostsWithID:(NSString *)userID page:(NSInteger)page completion:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
    
    return [[EXPAPIClient sharedClient] GET:@"posts/by_user" parameters:(user == nil) ?@{@"page":[NSString stringWithFormat:@"%d",page]} :@{@"user_email":user.email ,@"user_token": user.token, @"user_id": userID, @"page":[NSString stringWithFormat:@"%d",page]} success:^
            (NSURLSessionDataTask *task, id responseObject){
                NSLog(@"%@",responseObject);
                if (page == 1) {
                    [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userID]];
                }
                
                for(NSDictionary *dict in responseObject){
                    
                    //[MagicalRecord ]
                    Post *post = [Post MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                    post.image_url = dict[@"image_url"];
                    // NSString *text = dict[@"text"];
                    if(![dict[@"text"] isKindOfClass:[NSNull class]]){
                        post.text = dict[@"text"];
                    }
                    post.post_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    post.user_id = [NSString stringWithFormat:@"%@",dict[@"uploader_id"]];
                    post.like_countValue = [NSString stringWithFormat:@"%@", dict[@"cached_votes_up"]].integerValue;
                    NSLog(@"THE IMAGE ID: %@", post.image_url);
                }
                NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
                [defaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
                    
                    completion(error);
                }];
                
                
                
            }failure:^(NSURLSessionDataTask *task, NSError *error){
                NSLog(@"%@", error);
            }];

}

+(NSURLSessionDataTask *)allPosts:(void (^)(NSError *error))completion {
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient] GET:@"posts" parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

+(NSURLSessionDataTask *)postsByContestID:(NSString *)contestID completion:(void (^)(NSError *error))completion{
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient] GET:@"posts/by_contest" parameters:@{@"user_email":user.email ,@"user_token": user.token, @"contest_id": contestID} success:^(NSURLSessionDataTask *task, id responseObject){
       
            NSLog(@"%@",responseObject);
            [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"contest_id == %@",contestID]];
            //  NSMutableArray *mArray = [[NSMutableArray alloc]init];
            for(NSDictionary *dict in responseObject){
                
                //[MagicalRecord ]
                Post *post = [Post MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                post.image_url = dict[@"image_url"];
                // NSString *text = dict[@"text"];
                if(![dict[@"text"] isKindOfClass:[NSNull class]]){
                    post.text = dict[@"text"];
                }
                post.post_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                post.user_id = [NSString stringWithFormat:@"%@",dict[@"uploader_id"]];
                post.contest_id = [NSString stringWithFormat:@"%@", dict[@"contest_id"]];
                post.like_countValue = [NSString stringWithFormat:@"%@", dict[@"cached_votes_up"]].integerValue;

                NSLog(@"THE Contest ID: %@", dict[@"contest_id"]);
            }
            NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
            [defaultContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
                
                completion(error);
            }];
            
            
            
        }failure:^(NSURLSessionDataTask *task, NSError *error){
            NSLog(@"%@", error);
        }];
}

-(NSURLSessionDataTask *)likePostWithCompletion:(void (^)(NSError *error)) completion{
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient] POST:[NSString stringWithFormat:@"posts/%@/like",self.post_id] parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        if(completion){
            completion(nil);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if(completion){
            NSLog(@"%@", error);
            completion(error);
        }
    }];

}

//+(NSURLSessionDataTask *)currentUserPosts:(void (^)(NSError *error))completion {
//    User *user = [User currentUser];
//    return [[EXPAPIClient sharedClient] GET:@"posts/my_posts " parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
//        NSLog(@"%@", responseObject);
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
//            
//        }];
//    }failure:^(NSURLSessionDataTask *task, NSError *error){
//        NSLog(@"%@", error);
//    }];
//} /api/posts/by_contest


@end
