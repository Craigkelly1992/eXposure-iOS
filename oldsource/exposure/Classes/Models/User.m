#import "User.h"
#import "EXPAPIClient.h"
#import "CoreData+MagicalRecord.h"

@interface User ()

// Private interface goes here.

@end


@implementation User

// Custom logic goes here.
+ (NSURLSessionDataTask *)loginUserWithEmail:(NSString*)email password:(NSString*)password completion:(void (^)(User *user, NSError *error))completion {
    return [[EXPAPIClient sharedClient] GET:@"users/login" parameters:@{@"user_email":email, @"user_password": password} success:^(NSURLSessionDataTask *task, id responseObject){
         NSLog(@"%@", responseObject);
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            User *newUser = [User MR_createEntityInContext:localContext];
            newUser.firstName = responseObject[@"first_name"];
            newUser.lastName = responseObject[@"last_name"];
            newUser.email = responseObject[@"email"];
            newUser.profileImage = responseObject[@"profile_picture_url"];
            newUser.backdropImage = responseObject[@"background_picture_url"];
            newUser.token = responseObject[@"authentication_token"];
            newUser.userName = responseObject[@"username"];
            newUser.user_id = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
            newUser.followerCountValue = [NSString stringWithFormat:@"%@", responseObject[@"followers_count"]].integerValue;
            newUser.followingCountValue = [NSString stringWithFormat:@"%@", responseObject[@"follow_count"]].integerValue;
            NSArray *postsArray = responseObject[@"posts"];
            newUser.postCountValue = (int)postsArray.count;
            
        }completion:^(BOOL success, NSError *error){
            if(completion){
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
                User *user = [User currentUser];
                
                completion(user, nil);
            }
        }];

    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion) {
            completion(nil, error);
        }
        NSLog(@"%@",error);
    }];
}

+ (NSURLSessionDataTask *)signUpUserWithAttributes:(NSDictionary *)dict completion:(void (^)(User *user, NSError *error))block {
    return [[EXPAPIClient sharedClient]POST:@"users" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            User *newUser = [User MR_createEntityInContext:localContext];
            newUser.firstName = responseObject[@"first_name"];
            newUser.lastName = responseObject[@"last_name"];
            newUser.email = responseObject[@"email"];
            newUser.profileImage = responseObject[@"profile_picture_url"];
            newUser.backdropImage = responseObject[@"background_picture_url"];
            newUser.token = responseObject[@"authentication_token"];
            newUser.userName = responseObject[@"username"];
            newUser.user_id = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
            newUser.followerCountValue = (int)[NSString stringWithFormat:@"%@", responseObject[@"followers_count"]].integerValue;
            newUser.followingCountValue = (int)[NSString stringWithFormat:@"%@", responseObject[@"follow_count"]].integerValue;
            
        }completion:^(BOOL success, NSError *error){
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
            if(block){
                block([User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"token != NULL"]], nil);
            }
        }];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (block) {
            block(nil, error);
        }
        NSLog(@"%@",error);
    }];
    
}

- (NSURLSessionDataTask *)followersForUser:(User *)user completion:(void (^)(User *user, NSError *error))block {
   return [[EXPAPIClient sharedClient] POST:@"notifications" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

- (NSMutableSet*)followingForUser:(User *)user completion:(void (^)(User *user, NSError *error))block {
    [[EXPAPIClient sharedClient] POST:@"notifications" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
    return nil;
}

+ (NSURLSessionDataTask *)userWithID:(NSString *)userID completion:(void (^)(User *user, NSError *error))block {
    User *user = [User currentUser];
    
    
    NSString *string = [NSString stringWithFormat:@"users/%@",userID];
    return [[EXPAPIClient sharedClient]GET:string parameters: (user == nil) ?@{} : @{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
        if(block){
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
                User *newUser = [User MR_createEntityInContext:localContext];
                newUser.firstName = responseObject[@"first_name"];
                newUser.lastName = responseObject[@"last_name"];
                newUser.email = responseObject[@"email"];
                newUser.profileImage = responseObject[@"profile_picture_url"];
                newUser.backdropImage = responseObject[@"background_picture_url"];
                newUser.userName = responseObject[@"username"];
                newUser.user_id = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
                newUser.followerCountValue = [NSString stringWithFormat:@"%@", responseObject[@"followers_count"]].integerValue;
                newUser.followingCountValue = [NSString stringWithFormat:@"%@", responseObject[@"follow_count"]].integerValue;
                NSArray *postsArray = responseObject[@"posts"];
                newUser.postCountValue = (int)postsArray.count;
                NSLog(@"THIS IS THE USERS NAME %@", newUser.userName);
            }completion:^(BOOL success, NSError *error){
                if(block){
                    
                    User *newUser = [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",userID]];
                    block(newUser, nil);
                }
            }];
            
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
        if(block){
            block(nil, error);
        }
    }];
    

}

+(NSURLSessionDataTask *)currentUserProfile:(void (^)(NSError *error))block{
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient]GET:@"profile" parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
}

+ (void)editUserProfileWithAttributes:(NSDictionary *)dict completion:(void (^)(User *user, NSError *error))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:[NSString stringWithFormat:@"http://exposuretechnologies.com/api/users/%@",[User currentUser].user_id] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
        
    }];
    
    
}

+ (NSURLSessionDataTask *)usersSearchedFor:(NSString *)searchTerm completion:(void (^)(User *user, NSError *error))block {
  return [[EXPAPIClient sharedClient] GET:@"searched" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

+(NSURLSessionDataTask *)userGlobalRankingsWithCompletion:(void (^)(NSMutableArray *array, NSError *error))completion{
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient]GET:@"rankings/following" parameters:(user == nil) ?@{} :@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
       
            if(completion){
                NSMutableArray *array = [[NSMutableArray alloc]init];
                NSLog(@"%@", responseObject);
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
                     for (NSDictionary *dict in responseObject) {
                       //  NSLog(@"%@", dict[@"username"]);
                         User *newUser = [User MR_createEntity];
                         newUser.firstName = dict[@"first_name"];
                         newUser.lastName = dict[@"last_name"];
                         newUser.email = dict[@"email"];
                         newUser.profileImage = dict[@"profile_picture_url"];
                         newUser.backdropImage = dict[@"background_picture_url"];
                         newUser.userName = dict[@"username"];
                         newUser.user_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                         newUser.followerCountValue = [NSString stringWithFormat:@"%@", dict[@"followers_count"]].integerValue;
                         newUser.followingCountValue = [NSString stringWithFormat:@"%@", dict[@"follow_count"]].integerValue;
                         NSArray *postsArray = dict[@"posts"];
                         newUser.postCountValue = (int)postsArray.count;
                         [array addObject:newUser];
                         newUser.rankingValue = [NSString stringWithFormat:@"%@", dict[@"cached_score"]].integerValue;
                         NSLog(newUser.userName);
                    }
                }completion:^(BOOL success, NSError *error){
                    completion(array, nil);
                    }];
                
            

        }
        //NSLog(@"RESPONSE OBJECT FOR GLOBAL RANKINGS %@", responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"RESPONSE OBJECT ERROR %@", error);
    }];
}

+(NSURLSessionDataTask *)userFollowingRankingsWithCompletion:(void (^)(NSMutableArray *array, NSError *error))completion{
    User *user = [User currentUser];
    return [[EXPAPIClient sharedClient]GET:@"rankings/following" parameters:@{@"user_email":user.email ,@"user_token": user.token} success:^(NSURLSessionDataTask *task, id responseObject){
        if(completion){
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSLog(@"%@", responseObject);
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
                for (NSDictionary *dict in responseObject) {
                    //  NSLog(@"%@", dict[@"username"]);
                    User *newUser = [User MR_createEntity];
                    newUser.firstName = dict[@"first_name"];
                    newUser.lastName = dict[@"last_name"];
                    newUser.email = dict[@"email"];
                    newUser.profileImage = dict[@"profile_picture_url"];
                    newUser.backdropImage = dict[@"background_picture_url"];
                    newUser.userName = dict[@"username"];
                    newUser.user_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
                    newUser.followerCountValue = [NSString stringWithFormat:@"%@", dict[@"followers_count"]].integerValue;
                    newUser.followingCountValue = [NSString stringWithFormat:@"%@", dict[@"follow_count"]].integerValue;
                    NSArray *postsArray = dict[@"posts"];
                    newUser.postCountValue = (int)postsArray.count;
                    [array addObject:newUser];
                    newUser.rankingValue = [NSString stringWithFormat:@"%@", dict[@"cached_score"]].integerValue;
                    NSLog(newUser.userName);
                }
            }completion:^(BOOL success, NSError *error){
                completion(array, nil);
            }];
            
            
            
        }
        //NSLog(@"RESPONSE OBJECT FOR GLOBAL RANKINGS %@", responseObject);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"RESPONSE OBJECT ERROR %@", error);
    }];
}



-(NSURLSessionDataTask *)registerDeviceWithToken:(NSString *)token completion:(void (^)(NSError *error))block{
    [[EXPAPIClient sharedClient] POST:[NSString stringWithFormat:@"users/%@/save_token",self.user_id] parameters:@{@"user_email":self.email ,@"user_token": self.token, @"device_token": token} success:^(NSURLSessionDataTask *task, id responseObject){
        
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
    return nil;

}
///api/users/:id/save_token     params: device_token

+(User*)currentUser{
    return [User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"token != NULL"]];
}


@end

