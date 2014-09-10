//
//  Brand.h
//  exposure
//
//  Created by Binh Nguyen on 7/16/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Brand : Jastor

///
@property (nonatomic, retain) NSNumber *brandId;
@property (nonatomic, copy) NSString *agency_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *facebook;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *instagram;
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *picture_file_name;
@property (nonatomic, copy) NSString *picture_content_type;
@property (nonatomic, retain) NSNumber *picture_file_size;
@property (nonatomic, copy) NSString *picture_updated_at;
@property (nonatomic, retain) NSNumber *cached_views;
@property (nonatomic, copy) NSString *picture_url;

/// just returned when getting brand by id
@property (nonatomic, retain) NSArray *submissions_mobile;
@property (nonatomic, retain) NSNumber *submissions_count;
@property (nonatomic, retain) NSNumber *winners_count;
@property (nonatomic, retain) NSNumber *followers_count;

///
@property (nonatomic, retain) NSArray *winners;
@property (nonatomic, retain) NSArray *followers_list;

// An example
/*
 [
     {
         id: 21
         agency_id: 2
         name: "Hand-Hayes"
         facebook: http://facebook.com/
         twitter: http://twitter.com/
         instagram: http://instagram.com/
         slogan: "Grass-roots system-worthy model"
         website: http://mybrand.com
         description: "Optio ut ex omnis itaque saepe consectetur et. Et quia ut voluptatem omnis corrupti occaecati nemo. Sed ipsum illo fuga iure veritatis. Qui qui iste similique tempore delectus ut est. Ipsa laborum fuga nesciunt consequuntur est."
         created_at: "2014-06-06T21:52:20.000Z"
         updated_at: "2014-06-06T21:52:20.000Z"
         picture_file_name: "art_20.jpg"
         picture_content_type: "image/jpeg"
         picture_file_size: 71698
         picture_updated_at: "2014-06-06T21:52:19.000Z"
         cached_views: 0
         picture_url: http://s3.amazonaws.com/exposure_app_production/brands/pictures/000/000/021/original/art_20.jpg?1402091539
     }
 ]
 */

@end
