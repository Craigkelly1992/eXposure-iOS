//
//  User.h
//  exposure
//
//  Created by Binh Nguyen on 7/16/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface User : Jastor

/// returned objects
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *first_name;
@property (nonatomic, copy) NSString *last_name;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *authentication_token;
@property (nonatomic, copy) NSString *profile_picture_url;
@property (nonatomic, copy) NSString *profile_picture_url_thumb;
@property (nonatomic, copy) NSString *profile_picture_url_preview;
@property (nonatomic, copy) NSString *profile_picture_url_square;
@property (nonatomic, copy) NSString *background_picture_url;
@property (nonatomic, copy) NSString *background_picture_url_preview;
@property (nonatomic, retain) NSArray *posts; // Post type
@property (nonatomic, retain) NSNumber *followers_count;
@property (nonatomic, retain) NSNumber *follow_count;

/// returned in contest's winner
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *profile_picture_file_name;
@property (nonatomic, copy) NSString *profile_picture_content_type;
@property (nonatomic, retain) NSNumber *profile_picture_file_size;
@property (nonatomic, copy) NSString *profile_picture_updated_at;
@property (nonatomic, copy) NSString *background_picture_file_name;
@property (nonatomic, copy) NSString *background_picture_content_type;
@property (nonatomic, retain) NSNumber *background_picture_file_size;
@property (nonatomic, copy) NSString *background_picture_updated_at;
@property (nonatomic, copy) NSString *device_token;
@property (nonatomic, retain) NSNumber *cached_score;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, retain) NSNumber *enabled;

/// for signup || edit
@property (nonatomic, copy) NSString *password;

/// for ranking
@property (nonatomic, retain) NSNumber *current_user_following;

@end

// An example
/*
{
    id: 34
    email: "paulo@parruda.net"
    first_name: "Paulo"
    last_name: "arruda "
    username: "parruda"
    phone: "6138180472"
    profile_picture_url: /photos/placeholder.png
    background_picture_url: /photos/placeholder.png
    posts: [
             {
                 id: 41
                 uploader_id: 34
                 contest_id: 6
                 text: "lol"
                 created_at: "2014-06-17T14:20:53.000Z"
                 updated_at: "2014-06-17T14:20:53.000Z"
                 image_file_name: "photo"
                 image_content_type: "image/jpeg"
                 image_file_size: 2560130
                 image_updated_at: "2014-06-17T14:20:48.000Z"
                 cached_votes_total: 0
                 cached_votes_score: 0
                 cached_votes_up: 0
                 cached_votes_down: 0
                 cached_weighted_score: 0
             }
             {
                 id: 42
                 uploader_id: 34
                 contest_id: 6
                 text: "lol"
                 created_at: "2014-06-17T14:29:43.000Z"
                 updated_at: "2014-06-17T14:29:43.000Z"
                 image_file_name: "photo"
                 image_content_type: "image/jpeg"
                 image_file_size: 1029854
                 image_updated_at: "2014-06-17T14:29:05.000Z"
                 cached_votes_total: 0
                 cached_votes_score: 0
                 cached_votes_up: 0
                 cached_votes_down: 0
                 cached_weighted_score: 0
             }
             {
                 id: 43
                 uploader_id: 34
                 contest_id: 11
                 text: "test"
                 created_at: "2014-06-17T14:30:51.000Z"
                 updated_at: "2014-06-17T14:30:51.000Z"
                 image_file_name: "photo"
                 image_content_type: "image/jpeg"
                 image_file_size: 1034160
                 image_updated_at: "2014-06-17T14:30:48.000Z"
                 cached_votes_total: 0
                 cached_votes_score: 0
                 cached_votes_up: 0
                 cached_votes_down: 0
                 cached_weighted_score: 0
             }
             {
                 id: 44
                 uploader_id: 34
                 contest_id: 11
                 text: "test"
                 created_at: "2014-06-17T14:31:05.000Z"
                 updated_at: "2014-06-17T14:31:05.000Z"
                 image_file_name: "photo"
                 image_content_type: "image/jpeg"
                 image_file_size: 1034160
                 image_updated_at: "2014-06-17T14:31:01.000Z"
                 cached_votes_total: 0
                 cached_votes_score: 0
                 cached_votes_up: 0
                 cached_votes_down: 0
                 cached_weighted_score: 0
             }
    ]
    follow_count: 0
    followers_count: 0
}
*/