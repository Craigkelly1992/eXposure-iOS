//
//  APConnectionLayer.m
//  Activity Partner
//
//  Created by Adelphatech on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import "APConnectionLayer.h"

@implementation APConnectionLayer

+ (APConnectionLayer *)sharedClient {
    static APConnectionLayer *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APConnectionLayer alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return _sharedClient;
}

#pragma mark - User
// login - checked
- (void)loginWithUserEmail:(NSString*)userEmail
                  password:(NSString*)password
                   success:(void (^)(id responseObject))successHandler
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureHandler {
    
    NSString *path = [NSString stringWithFormat:USER_LOGIN];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        userEmail, PARAM_USER_EMAIL,
                                        password, PARAM_USER_PASSWORD,
                                        nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // if fail, will return something likes this
        /*
        {
        status: false
        message: "Invalid login or password"
        }
         */
        if (failureHandler) {
            failureHandler(operation, error);
        }
    }];
}

// signup - checked
- (void)signupWithUser:(User*)user
               success:(void (^)(id responseObject))successHandler
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureHandler {
    
    NSString *path = [NSString stringWithFormat:USER_SIGNUP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                user.first_name, PARAM_SIGNUP_FIRSTNAME,
                                user.last_name, PARAM_SIGNUP_LASTNAME,
                                user.email, PARAM_SIGNUP_EMAIL,
                                user.username, PARAM_SIGNUP_USERNAME,
                                user.password, PARAM_SIGNUP_PASSWORD,
                                user.phone, PARAM_SIGNUP_PHONE,
                                user.device_token, PARAM_SIGNUP_DEVICE_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successHandler) {
            successHandler(responseObject);
            // parse data
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // if fail, will return something likes this
        /*
         {
            email: [
                "has already been taken"
            ]
         }
         */
        if (failureHandler) {
            failureHandler(operation, error);
        }
    }];
}

// find user - checked
- (void)getUserWithId:(NSNumber*)userId
                email:(NSString*)userEmail
                token:(NSString*)token
              success:(void (^)(id responseObject))successHandler
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureHandler {
    
    NSString *path = [NSString stringWithFormat:GET_USER_WITH_ID, userId];
    [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return objects likes signup, except authentication_token
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureHandler) {
            failureHandler(operation, error);
        }
    }];
}

// user profile - checked
- (void)getUserProfileWithUserEmail:(NSString*)email
                              token:(NSString*)token
                            success:(void (^)(id responseObject))successHandler
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureHandler {
    
    NSString *path = [NSString stringWithFormat:GET_USER_PROFILE];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                email, PARAM_USER_EMAIL,
                                token, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return objects likes signup, except authentication_token
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureHandler) {
            failureHandler(operation, error);
        }
    }];
}

// edit user profile - not OK
- (void)editUserProfileWithUser:(User*)user
                 profilePicture:(NSData*)profilePicture
              backgroundPicture:(NSData*)backgroundPicture
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    // Neither a key nor a value can be nil; if you need to represent a null value in a dictionary, you should use NSNull
    // check device token
    NSString *deviceToken;
    if (!user.device_token) {
        deviceToken = (NSString*)[NSNull null];
    }
    if (!profilePicture) {
        profilePicture = (NSData*)[NSNull null];
    }
    if (!backgroundPicture) {
        backgroundPicture = (NSData*)[NSNull null];
    }
    NSString *path = [NSString stringWithFormat:UPDATE_USER_PROFILE];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                user.first_name, PARAM_SIGNUP_FIRSTNAME,
                                user.last_name, PARAM_SIGNUP_LASTNAME,
                                user.email, PARAM_SIGNUP_EMAIL,
                                user.phone, PARAM_SIGNUP_PHONE,
                                user.username, PARAM_SIGNUP_USERNAME,
                                deviceToken, PARAM_SIGNUP_DEVICE_TOKEN,
                                [profilePicture base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength], PARAM_SIGNUP_PROFILE_PICTURE,
                                [backgroundPicture base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength], PARAM_SIGNUP_BACKGROUND_PICTURE,
                                user.email, PARAM_USER_EMAIL,
                                user.authentication_token, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// update password
- (void)updatePasswordWithNewPassword:(NSString*)newPassword
                            userEmail:(NSString*)email
                                token:(NSString*)token
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:CHANGE_PASSWORD];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                newPassword, PARAM_SIGNUP_PASSWORD,
                                email, PARAM_USER_EMAIL,
                                token, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// delete user profile - checked
- (void)deleteUserProfileWithUserId:(NSNumber*)userId
                              email:(NSString*)email
                              token:(NSString*)token
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:DELETE_USER_PROFILE, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                email, PARAM_USER_EMAIL,
                                token, PARAM_USER_TOKEN,
                                nil];
    [self DELETE:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // there's no way to success or fail, because server always return 204 - No content
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// search user - checked
- (void)searchUserProfile:(NSString*)searchText
                    email:(NSString*)email
                    token:(NSString*)token
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_USER_SEARCH];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                searchText, "q",
                                email, PARAM_USER_EMAIL,
                                token, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of user (except authentication_token)
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Brand
// get all brand - checked
- (void)getAllBrandUserEmail:(NSString*)userEmail
                   userToken:(NSString*)userToken
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_ALL_BRAND];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of brand objects
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get brand with id - checked
- (void)getBrandWithId:(NSNumber*)brandId
             userEmail:(NSString*)userEmail
             userToken:(NSString*)userToken
               success:(void (^)(id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_BRAND, brandId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return list of brand with more information [submissions, submissions_count]
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// checks if the brand is being followed by current_user - checked
- (void)checkFollowBrand:(NSNumber*)brandId
               userEmail:(NSString*)userEmail
                   token:(NSString*)userToken
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:CHECK_BRAND_FOLLOW, brandId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return list of brand with more information [submissions, submissions_count]
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// follow a brand - not OK
- (void)followBrand:(NSNumber*)brandId
          userEmail:(NSString*)userEmail
              token:(NSString*)userToken
            success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:POST_BRAND_FOLLOW, brandId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// unfollow a brand - not OK
- (void)unfollowBrand:(NSNumber*)brandId
            userEmail:(NSString*)userEmail
                token:(NSString*)userToken
              success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
 
    NSString *path = [NSString stringWithFormat:POST_BRAND_UNFOLLOW, brandId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// log click a brand - not OK
- (void)logClickBrandId:(NSString*)brandId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                    via:(NSString*)target
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:LOG_CLICK_BRAND, brandId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                target, PARAM_TARGET,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Contest
// get all contest - checked
- (void)getAllContestWithUserEmail:(NSString*)userEmail
                         userToken:(NSString*)userToken
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_ALL_CONTEST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return list of Contest object
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get contests by contest id - checked
- (void)getContestWithContestId:(NSNumber*)contestId
                      userEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_CONTEST_WITH_ID, contestId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return object of ContestDetail type
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get contest by brand id - checked
- (void)getContestByBrandId:(NSNumber*)brandId
                  userEmail:(NSString*)userEmail
                  userToken:(NSString*)userToken
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_CONTEST_WITH_BRANDID];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                brandId, PARAM_BRAND_ID,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return list of contest with Contest type
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get followed contest by user
- (void)getContestByFollowingUserId:(NSNumber*)userId
                          userEmail:(NSString*)userEmail
                          userToken:(NSString*)userToken
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_CONTEST_BY_FOLLOWING];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId, PARAM_USER_ID,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return list of contest with Contest type
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Post
// create post - checked
- (void)createPostWithContestId:(NSNumber*)contestId
                     uploaderId:(NSNumber*)uploaderId
                           text:(NSString*)text
                      imageData:(NSString*)imageData
                      userEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:CREATE_POST];
    // check
    NSString *contestIdString = @"";
    if (contestId) {
        contestIdString = [contestId stringValue];
    }
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                contestIdString, PARAM_POST_CONTEST_ID,
                                uploaderId, PARAM_POST_UPLOADER_ID,
                                text, PARAM_POST_TEXT,
                                imageData, PARAM_POST_IMAGE_DATA,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, will return something likes this
        /*
         {
             uploader_id: 43
             contest_id: 11
             text: "Demo "
             cached_votes_up: 0
             image_url: /photos/placeholder.png
             brand: 5
         }
         */
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get post by post id - checked
- (void)getPostByPostId:(NSNumber*)postId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_POST_BY_ID, postId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get all post - checked
- (void)getAllPostWithUserEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_ALL_POST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get all post - anonymous - checked
- (void)getAllPostWithSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_ALL_POST];
    [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get posts from current user - checked
- (void)getUserPostWithUserEmail:(NSString*)userEmail
                       userToken:(NSString*)userToken
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_MY_POST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of Post
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get posts by user id - checked
- (void)getPostByUserId:(NSNumber*)userId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_POST_BY_USERID];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userId, PARAM_USER_ID,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of Post
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get posts by contest id - checked
- (void)getPostByContestId:(NSNumber*)contestId
                 userEmail:(NSString*)userEmail
                 userToken:(NSString*)userToken
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_POST_BY_CONTEST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                contestId, PARAM_CONTEST_ID,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of Post
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get posts by brand id - not OK
- (void)getPostByBrandId:(NSNumber*)brandId
               userEmail:(NSString*)userEmail
               userToken:(NSString*)userToken
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_POST_BY_BRAND];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                brandId, PARAM_BRAND_ID,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// get stream post, posts from who you follow - checked
- (void)getPostStreamWithUserEmail:(NSString*)userEmail
                         userToken:(NSString*)userToken
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_STREAM_POST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// like a post - not OK
- (void)likePostWithPostId:(NSNumber*)postId
                 userEmail:(NSString*)userEmail
                 userToken:(NSString*)userToken
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:LIKE_POST, postId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// unlike a post - not OK
- (void)unlikePostWithPostId:(NSNumber*)postId
                   userEmail:(NSString*)userEmail
                   userToken:(NSString*)userToken
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:UNLIKE_POST, postId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Comment
// get comment for post id - not OK
- (void)getCommentFromPostId:(NSNumber*)postId
                  userEmail:(NSString*)userEmail
                  userToken:(NSString*)userToken
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_COMMENT_FROM_POST, postId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// create comment
- (void)createComment:(NSNumber*)postId
                 text:(NSString*)text
            userEmail:(NSString*)userEmail
            userToken:(NSString*)userToken
              success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:CREATE_COMMENT];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                postId, PARAM_POST_ID,
                                text, PARAM_COMMENT_TEXT,
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Ranking
// global ranking - Global shows only top 50. All results are sorted by cached_score DESC - checked
- (void)getGlobalRankingWithUserEmail:(NSString*)userEmail
                                token:(NSString*)userToken
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_GLOBAL_RANKING];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // return a list of user with following information
        /*
        {
            id: 3
            email: "audra@yahoo.com"
            first_name: "Gladyce"
            last_name: "Goyette"
            username: "joshuah"
            phone: "(999) 999-9999"
            cached_score: 9
            profile_picture_url: http://s3.amazonaws.com/exposure_app_production/users/profile_pictures/000/000/003/original/art_2.jpg?1402090922
            background_picture_url: http://s3.amazonaws.com/exposure_app_production/users/background_pictures/000/000/003/original/art_2.jpg?1402090923
            current_user_following: false
        }
         */
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// following ranking - Global shows only top 50. All results are sorted by cached_score DESC
- (void)getFollowingRankingWithUserEmail:(NSString*)userEmail
                                   token:(NSString*)userToken
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_FOLLOWING_RANKING];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if user didn't follow anyone
        /*
        {
            status: true
            message: "Current user is not following anyone."
        }
         */
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// follower ranking - Global shows only top 50. All results are sorted by cached_score DESC
- (void)getFollowerRankingWithUserEmail:(NSString*)userEmail
                                   token:(NSString*)userToken
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_FOLLOWER_RANKING];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if user has no follower
        /*
        {
            status: true
            message: "Current user has no followers."
        }
        */
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Follow
// following - checked
- (void)getFollowingWithUserId:(NSNumber*)userId
                     userEmail:(NSString*)userEmail
                         token:(NSString*)userToken
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_FOLLOWING, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


// follower - checked
- (void)getFollowerWithUserId:(NSNumber*)userId
                    userEmail:(NSString*)userEmail
                        token:(NSString*)userToken
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_FOLLOWER, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// checks if the user is being followed by current_user - checked
- (void)checkFollowUser:(NSNumber*)userId
          userEmail:(NSString*)userEmail
              token:(NSString*)userToken
            success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:CHECK_USER_FOLLOW, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return
        /*
         {
             status: true
             following: false
         }
         */
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// follow an user - not OK
- (void)followUser:(NSNumber*)userId
     userEmail:(NSString*)userEmail
         token:(NSString*)userToken
       success:(void (^)(id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:POST_USER_FOLLOW, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

// unfollow an user - not OK
- (void)unfollowUser:(NSNumber*)userId
       userEmail:(NSString*)userEmail
           token:(NSString*)userToken
         success:(void (^)(id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:POST_USER_UNFOLLOW, userId];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - Notification
// get notification for user - checked
- (void)getNotificationWithUserEmail:(NSString*)userEmail
                           userToken:(NSString*)userToken
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:GET_NOTIFICATION];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                nil];
    [self GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // if success, return a list of notificaitons
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - register device
// register device token for notification - not OK
- (void)registerDeviceWithUserId:(NSString*)userId
                           email:(NSString*)userEmail
                       userToken:(NSString*)userToken
                     deviceToken:(NSString*)deviceToken
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *path = [NSString stringWithFormat:REGISTER_DEVICE, deviceToken];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, PARAM_USER_EMAIL,
                                userToken, PARAM_USER_TOKEN,
                                deviceToken, PARAM_DEVICE_TOKEN,
                                nil];
    [self POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

@end
