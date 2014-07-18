//
//  EXPAPIClient.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.

#import "User.h"
#import "EXPAPIClient.h"
#import "CoreData+MagicalRecord.h"

@implementation EXPAPIClient

#pragma mark - Constants
// Server API
#define BASE_URL @"http://exposuretechnologies.com/api/"
#define USER_LOGIN @"users/login"
#define USER_SIGNUP @"users"

// API Parameters
#define PARAM_USERNAME @"user_email"
#define PARAM_PASSWORD @"user_password"

// API Response
#define RESPONSE_FIRSTNAME @"first_name"
#define RESPONSE_LASTNAME @"last_name"
#define RESPONSE_EMAIL @"email"
#define RESPONSE_PROFILE_PICTURE @"profile_picture_url"
#define RESPONSE_BACKGROUND_PICTURE @"background_picture_url"
#define RESPONSE_AUTHENTICATION_TOKEN @"authentication_token"
#define RESPONSE_USERNAME @"username"
#define RESPONSE_FOLLOWER_COUNT @"followers_count"
#define RESPONSE_FOLLOWING_COUNT @"follow_count"
#define RESPONSE_POST @"posts"
#define RESPONSE_USER_ID @"id"

#pragma mark - Instant
+ (instancetype)sharedClient {
    static EXPAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EXPAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

#pragma mark - LOGIN
// Signin User
+ (NSURLSessionDataTask *)loginUserWithEmail:(NSString*)email password:(NSString*)password completion:(void (^)(User *user, NSError *error))completion {
    
    return [[EXPAPIClient sharedClient] GET:USER_LOGIN parameters:@{PARAM_USERNAME:email, PARAM_PASSWORD: password} success:
            ^(NSURLSessionDataTask *task, id responseObject){
                NSLog(@"%@", responseObject);
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
                    User *newUser = [User MR_createEntityInContext:localContext];
                    newUser.firstName = responseObject[RESPONSE_FIRSTNAME];
                    newUser.lastName = responseObject[RESPONSE_LASTNAME];
                    newUser.email = responseObject[RESPONSE_EMAIL];
                    newUser.profileImage = responseObject[RESPONSE_PROFILE_PICTURE];
                    newUser.backdropImage = responseObject[RESPONSE_BACKGROUND_PICTURE];
                    newUser.token = responseObject[RESPONSE_AUTHENTICATION_TOKEN];
                    newUser.userName = responseObject[RESPONSE_USERNAME];
                    newUser.user_id = [NSString stringWithFormat:@"%@",responseObject[RESPONSE_USER_ID]];
                    newUser.followerCountValue = [NSString stringWithFormat:@"%@", responseObject[RESPONSE_FOLLOWER_COUNT]].integerValue;
                    newUser.followingCountValue = [NSString stringWithFormat:@"%@", responseObject[RESPONSE_FOLLOWING_COUNT]].integerValue;
                    NSArray *postsArray = responseObject[RESPONSE_POST];
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

// SignUp User
+ (NSURLSessionDataTask *)signUpUserWithAttributes:(NSDictionary *)dict completion:(void (^)(User *user, NSError *error))completion {
    
    return [[EXPAPIClient sharedClient]POST:USER_SIGNUP parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
            User *newUser = [User MR_createEntityInContext:localContext];
            newUser.firstName = responseObject[RESPONSE_FIRSTNAME];
            newUser.lastName = responseObject[RESPONSE_LASTNAME];
            newUser.email = responseObject[RESPONSE_EMAIL];
            newUser.profileImage = responseObject[RESPONSE_PROFILE_PICTURE];
            newUser.backdropImage = responseObject[RESPONSE_PROFILE_PICTURE];
            newUser.token = responseObject[RESPONSE_AUTHENTICATION_TOKEN];
            newUser.userName = responseObject[RESPONSE_USERNAME];
            newUser.user_id = [NSString stringWithFormat:@"%@",responseObject[RESPONSE_USER_ID]];
            newUser.followerCountValue = (int)[NSString stringWithFormat:@"%@", responseObject[RESPONSE_FOLLOWER_COUNT]].integerValue;
            newUser.followingCountValue = (int)[NSString stringWithFormat:@"%@", responseObject[RESPONSE_FOLLOWING_COUNT]].integerValue;
            
        }completion:^(BOOL success, NSError *error){
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
            if(completion){
                completion([User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"token != NULL"]], nil);
            }
        }];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (completion) {
            completion(nil, error);
        }
        NSLog(@"%@",error);
    }];
    
}



@end
