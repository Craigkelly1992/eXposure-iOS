//
//  ContestDetail.h
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "Contest.h"
#import "Brand.h"
#import "SubmissionList.h"
#import "User.h"

@interface ContestDetail : Jastor

///
@property (nonatomic, copy) NSString *status;
@property (nonatomic, retain) Contest *info;
@property (nonatomic, retain) Brand *brand;
@property (nonatomic, retain) SubmissionList *submissions;
@property (nonatomic, retain) NSArray *winners;

///

@end

// Example
/*
{
    contest: {
    status: "CLOSED"
        info: {
            id: 11
            brand_id: 5
            title: "Distributed demand-driven protocol"
            description: "Voluptas aut sed et quis ab. Aut molestiae ipsum. Facilis sunt consequuntur dicta possimus nostrum optio."
            rules: "Amet laudantium vitae. Et veritatis ex eos velit quis in. Nemo animi repellendus officia et ut blanditiis et. Quia consequatur dolorem eos modi tempore. Corrupti et eius omnis unde dolorum aperiam."
            prizes: "Qui qui enim consequatur harum exercitationem. Ut autem quidem rem. Animi sint nulla quo dolores nisi exercitationem quis. Rerum non voluptatum voluptatem voluptas libero cupiditate blanditiis."
            voting: false
            start_date: "2014-06-06T21:53:34.000Z"
            end_date: "2014-06-21T21:53:34.000Z"
            created_at: "2014-06-06T21:53:35.000Z"
            updated_at: "2014-06-06T21:53:35.000Z"
            location: null
            latitude: null
            longitude: null
            picture_file_name: "art_10.jpg"
            picture_content_type: "image/jpeg"
            picture_file_size: 29097
            picture_updated_at: "2014-06-06T21:53:34.000Z"
            cached_views: 1
            winner_id: null
        }
    }
    brand: {
        id: 5
        agency_id: 6
        name: "Simonis, Abernathy and Weimann"
        facebook: http://facebook.com/
        twitter: http://twitter.com/
        instagram: http://instagram.com/
        slogan: "Decentralized secondary encryption"
        website: http://mybrand.com
        description: "Nemo quis a quae facere. Nulla placeat est. In ipsa neque rerum est quisquam."
        created_at: "2014-06-06T21:46:16.000Z"
        updated_at: "2014-06-06T21:46:16.000Z"
        picture_file_name: "art_4.jpg"
        picture_content_type: "image/jpeg"
        picture_file_size: 22515
        picture_updated_at: "2014-06-06T21:46:06.000Z"
        cached_views: 1
    }
    submissions: {
        count: 3
        submissions: [
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
                           id: 38
                           uploader_id: 26
                           contest_id: 11
                           text: "this is a test"
                           created_at: "2014-06-06T22:31:58.000Z"
                           updated_at: "2014-06-06T22:31:58.000Z"
                           image_file_name: "photo"
                           image_content_type: "image/png"
                           image_file_size: 70683
                           image_updated_at: "2014-06-06T22:31:57.000Z"
                           cached_votes_total: 0
                           cached_votes_score: 0
                           cached_votes_up: 0
                           cached_votes_down: 0
                           cached_weighted_score: 0
                       }
       ]
    }
    winners: [
               {
                   id: 34
                   email: "paulo@parruda.net"
                   created_at: "2014-06-17T14:19:16.000Z"
                   updated_at: "2014-06-17T14:42:46.000Z"
                   profile_picture_file_name: null
                   profile_picture_content_type: null
                   profile_picture_file_size: null
                   profile_picture_updated_at: null
                   background_picture_file_name: null
                   background_picture_content_type: null
                   background_picture_file_size: null
                   background_picture_updated_at: null
                   first_name: "Paulo"
                   last_name: "arruda "
                   username: "parruda"
                   device_token: "348efb1ee8cf5fd5f8b42238ae6eef20f9fb6216b4c4ec7177a49f81a76f2b07"
                   phone: "6138180472"
                   authentication_token: "osNPmxGTeoXwcsT2VyxA"
                   cached_score: 0
                   description: null
                   enabled: true
               }
    ]
}
*/