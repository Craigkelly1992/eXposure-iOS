//
//  Notification.h
//  exposure
//
//  Created by Binh Nguyen on 7/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"


@interface Notification : Jastor

@property (nonatomic, retain) NSNumber * notificationId;
@property (nonatomic, retain) NSNumber * receiver_id;
@property (nonatomic, retain) NSNumber * sender_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * sender_picture;
@property (nonatomic, copy) NSString * sender_picture_thumb;
@property (nonatomic, copy) NSString * sender_name;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * image_file_name;
@property (nonatomic, copy) NSString * image_content_type;
@property (nonatomic, retain) NSNumber * image_file_size;
@property (nonatomic, copy) NSString * image_updated_at;
@property (nonatomic, copy) NSString * sender_type;
@property (nonatomic, copy) NSNumber * contest_id;
@property (nonatomic, copy) NSString * notification_image_url;
@property (nonatomic) BOOL readed_flag;
@property (nonatomic) BOOL is_claimed;

@end

// An example
/*
{
    id: 3
    receiver_id: 34
    sender_id: 6
    type: "winner"
    post_id: 43
    text: "congratz!"
    sender_picture: http://s3.amazonaws.com/exposure_app_production/brands/pictures/000/000/005/original/art_4.jpg?1402091166
    sender_name: "Simonis, Abernathy and Weimann"
    created_at: "2014-06-17T14:54:07.000Z"
    updated_at: "2014-06-17T14:54:07.000Z"
    image_file_name: "__20.JPG"
    image_content_type: "image/jpeg"
    image_file_size: 30224
    image_updated_at: "2014-06-17T14:54:06.000Z"
    sender_type: "agency"
}
*/
