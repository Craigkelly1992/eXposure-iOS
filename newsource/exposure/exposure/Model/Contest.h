//
//  Contest.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Contest : Jastor

///
@property (nonatomic, retain) NSNumber *contestId;
@property (nonatomic, retain) NSNumber *brand_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *rules;
@property (nonatomic, copy) NSString *prizes;
@property (nonatomic, retain) NSNumber *voting; // false || true
@property (nonatomic, copy) NSString *start_date;
@property (nonatomic, copy) NSString *end_date;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *picture_file_name;
@property (nonatomic, copy) NSString *picture_content_type;
@property (nonatomic, retain) NSNumber *picture_file_size;
@property (nonatomic, copy) NSString *picture_updated_at;
@property (nonatomic, retain) NSNumber *cached_views;
@property (nonatomic, retain) NSNumber *winner_id;
@property (nonatomic, copy) NSString *brand_name;

///

@end
