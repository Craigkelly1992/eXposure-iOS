//
//  APConnectionLayer.h
//  Activity Partner
//
//  Created by Adelphatech on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "User.h"

// base url
#define BASE_URL @"http://exposuretechnologies.com/api/"
#define USER_LOGIN @"users/login"
#define USER_SIGNUP @"users"
#define GET_FOLLOWER @"users/%@/followers"
#define GET_FOLLOWING @"users/%@/following"
#define CHECK_USER_FOLLOW @"users/%@/check_follow" // checks if the user is being followed by current_user
#define POST_USER_FOLLOW @"users/%@/follow"
#define POST_USER_UNFOLLOW @"users/%@/unfollow"
#define GET_USER_WITH_ID @"users/%@" // users/<userID>
#define GET_USER_PROFILE @"profile"
#define UPDATE_USER_PROFILE @"profile/update"
#define DELETE_USER_PROFILE @"users/%@"
#define GET_USER_SEARCH @"users/search"
#define GET_USER_GLOBAL_RANKING @"rankings/following"
#define POST_REGISTER_DEVICETOKEN @"rankings/following"
#define GET_ALL_BRAND @"brands"
#define GET_BRAND @"brands/%@" // brands/<brandID>
#define CHECK_BRAND_FOLLOW @"brands/%@/check_follow" // checks if the user is being followed by current_user
#define POST_BRAND_FOLLOW @"brands/%@/follow"
#define POST_BRAND_UNFOLLOW @"brands/%@/unfollow"
#define LOG_CLICK_BRAND @"brands/%@/click" // brands/<brandID>/click
#define GET_ALL_CONTEST @"contests"
#define GET_CONTEST_WITH_ID @"contests/%@" // contests/<contestID>
#define GET_CONTEST_WITH_BRANDID @"contests/by_brand"
#define CREATE_POST @"posts"
#define GET_ALL_POST @"posts"
#define GET_POST_BY_ID @"posts/%@" // posts/<postID>
#define GET_MY_POST @"posts/my_posts"
#define GET_POST_BY_USERID @"posts/by_user"
#define GET_POST_BY_CONTEST @"posts/by_contest"
#define GET_POST_BY_BRAND @"posts/by_brand"
#define GET_STREAM_POST @"posts/stream" // return posts from who you follow
#define LIKE_POST @"posts/%@/like" // postID
#define UNLIKE_POST @"posts/%@/unlike" // postID
#define GET_COMMENT_FROM_POST @"posts/%@/comments" // postID
#define CREATE_COMMENT @"comments" // postID
// ranking
#define GET_GLOBAL_RANKING @"rankings/global"
#define GET_FOLLOWING_RANKING @"rankings/following"
#define GET_FOLLOWER_RANKING @"rankings/followers"
// notification
#define GET_NOTIFICATION @"notifications"
#define REGISTER_DEVICE @"users/%@/save_token" // userID

// API Parameters
#define PARAM_USERNAME @"username"
#define PARAM_PASSWORD @"password"
#define PARAM_USER_PASSWORD @"user_password"
#define PARAM_EMAIL @"email"
#define PARAM_USER_EMAIL @"user_email"
#define PARAM_USER_TOKEN @"user_token"
#define PARAM_FIRSTNAME @"first_name"
#define PARAM_LASTNAME @"last_name"
#define PARAM_PHONE @"phone"
#define PARAM_DEVICE_TOKEN @"device_token"
#define PARAM_SIGNUP_FIRSTNAME @"user[first_name]"
#define PARAM_SIGNUP_LASTNAME @"user[last_name]"
#define PARAM_SIGNUP_EMAIL @"user[email]"
#define PARAM_SIGNUP_USERNAME @"user[username]"
#define PARAM_SIGNUP_PASSWORD @"user[password]"
#define PARAM_SIGNUP_PHONE @"user[phone]"
#define PARAM_SIGNUP_DEVICE_TOKEN @"user[device_token]"
#define PARAM_SIGNUP_PROFILE_PICTURE @"user[profile_picture]"
#define PARAM_SIGNUP_BACKGROUND_PICTURE @"user[background_picture]"
#define PARAM_POST_CONTEST_ID @"post[contest_id]"
#define PARAM_POST_UPLOADER_ID @"post[uploader_id]"
#define PARAM_POST_TEXT @"post[text]"
#define PARAM_POST_IMAGE_DATA @"post[image_data]"
#define PARAM_PAGE @"page"
#define PARAM_CONTEST_ID @"contest_id"
#define PARAM_TARGET @"target"
#define PARAM_BRAND_ID @"brand_id"
#define PARAM_USER_ID @"user_id"
#define PARAM_POST_ID @"post_id"
#define PARAM_COMMENT_TEXT @"comment[text]"

// API Response
#define RESPONSE_USER_ID @"id"
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

// Constants
#define TARGET_WEBSITE @"website"
#define TARGET_FACEBOOK @"facebook"
#define TARGET_TWITTER @"twitter"
#define TARGET_INSTAGRAM @"instagram"

///
@interface APConnectionLayer : AFHTTPRequestOperationManager

#pragma mark - Singleton
+ (APConnectionLayer *)sharedClient;


#pragma mark - User
// login
- (void)loginWithUserEmail:(NSString*)username
                 password:(NSString*)password
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// signup
- (void)signupWithUser:(User *)user
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// find user
- (void)getUserWithId:(NSString*)userId
                email:(NSString*)email
                token:(NSString*)token
              success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// user profile
- (void)getUserProfileWithUserEmail:(NSString*)email
                              token:(NSString*)token
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// edit user profile
- (void)editUserProfileWithUser:(User*)user
                 profilePicture:(NSData*)profilePicture
              backgroundPicture:(NSData*)backgroundPicture
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// delete user profile
- (void)deleteUserProfileWithUserId:(NSNumber*)userId
                              email:(NSString*)email
                              token:(NSString*)token
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// search user
- (void)searchUserProfile:(NSString*)searchText
                    email:(NSString*)email
                    token:(NSString*)token
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Brand
// get all brand
- (void)getAllBrandUserEmail:(NSString*)userEmail
                   userToken:(NSString*)userToken
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get brand with id
- (void)getBrandWithId:(NSNumber*)brandId
             userEmail:(NSString*)userEmail
             userToken:(NSString*)userToken
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// checks if the user is being followed by current_user
- (void)checkFollowBrand:(NSNumber*)brandId
              userEmail:(NSString*)userEmail
                  token:(NSString*)userToken
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// follow an user
- (void)followBrand:(NSNumber*)brandId
          userEmail:(NSString*)userEmail
              token:(NSString*)userToken
            success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// unfollow an user
- (void)unfollowBrand:(NSNumber*)brandId
            userEmail:(NSString*)userEmail
                token:(NSString*)userToken
              success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// log click a brand
- (void)logClickBrandId:(NSString*)brandId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                    via:(NSString*)target
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Contest
// get all contest
- (void)getAllContestWithUserEmail:(NSString*)userEmail
                         userToken:(NSString*)userToken
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get contests by contest id
- (void)getContestWithContestId:(NSNumber*)contestId
                      userEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get contest by brand id
- (void)getContestByBrandId:(NSNumber*)brandId
                  userEmail:(NSString*)userEmail
                  userToken:(NSString*)userToken
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Post
// create post
- (void)createPost:(NSString*)contestId
        uploaderId:(NSString*)uploaderId
              text:(NSString*)text
         imageData:(NSData*)imageData
         userEmail:(NSString*)userEmail
         userToken:(NSString*)userToken
           success:(void (^)(id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get post by post id
- (void)getPostByPostId:(NSNumber*)postId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get all post
- (void)getAllPostWithUserEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get all post- anonymous
- (void)getAllPostWithSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get posts from current user
- (void)getUserPostWithUserEmail:(NSString*)userEmail
                      userToken:(NSString*)userToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get posts by user id
- (void)getPostByUserId:(NSNumber*)userId
              userEmail:(NSString*)userEmail
              userToken:(NSString*)userToken
                success:(void (^)(id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get posts by contest id
- (void)getPostByContestId:(NSNumber*)contestId
                 userEmail:(NSString*)userEmail
                 userToken:(NSString*)userToken
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get posts by brand id
- (void)getPostByBrandId:(NSNumber*)brandId
               userEmail:(NSString*)userEmail
               userToken:(NSString*)userToken
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// get stream post, posts from who you follow
- (void)getPostStreamWithUserEmail:(NSString*)userEmail
                         userToken:(NSString*)userToken
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// like a post
- (void)likePostWithPostId:(NSNumber*)postId
                 userEmail:(NSString*)userEmail
                 userToken:(NSString*)userToken
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// unlike a post
- (void)unlikePostWithPostId:(NSNumber*)postId
                   userEmail:(NSString*)userEmail
                   userToken:(NSString*)userToken
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Comment
// get comment from post id
- (void)getCommentFromPostId:(NSNumber*)postId
                  userEmail:(NSString*)userEmail
                  userToken:(NSString*)userToken
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// create comment
- (void)createComment:(NSString*)postId
                 text:(NSString*)text
            userEmail:(NSString*)userEmail
            userToken:(NSString*)userToken
              success:(void (^)(id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Ranking
// Global shows only top 50. All results are sorted by cached_score DESC
// global ranking
- (void)getGlobalRankingWithUserEmail:(NSString*)email
                                token:(NSString*)token
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// following ranking
- (void)getFollowingRankingWithUserEmail:(NSString*)email
                                   token:(NSString*)token
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// follower ranking
- (void)getFollowerRankingWithUserEmail:(NSString*)email
                                   token:(NSString*)token
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Follow
// following
- (void)getFollowingWithUserId:(NSString*)userId
                     userEmail:(NSString*)userEmail
                         token:(NSString*)userToken
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


// follower
- (void)getFollowerWithUserId:(NSString*)userId
                    userEmail:(NSString*)userEmail
                        token:(NSString*)userToken
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// checks if the user is being followed by current_user
- (void)checkFollowUser:(NSString*)userId
                     userEmail:(NSString*)userEmail
                         token:(NSString*)userToken
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// follow an user
- (void)followUser:(NSString*)userId
          userEmail:(NSString*)userEmail
              token:(NSString*)userToken
            success:(void (^)(id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// unfollow an user
- (void)unfollowUser:(NSString*)userId
     userEmail:(NSString*)userEmail
         token:(NSString*)userToken
       success:(void (^)(id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Notification
// get notification for user
- (void)getNotificationWithUserEmail:(NSString*)userEmail
                           userToken:(NSString*)userToken
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - register device
- (void)registerDeviceWithUserId:(NSString*)userId
                           email:(NSString*)email
                       userToken:(NSString*)userToken
                     deviceToken:(NSString*)deviceToken
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
