//
//  Submission.h
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Submission : Jastor

///
@property (nonatomic, retain) NSNumber *submissionId;
@property (nonatomic, retain) NSNumber *uploader_id;
@property (nonatomic, retain) NSNumber *contest_id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *image_file_name;
@property (nonatomic, copy) NSString *image_content_type;
@property (nonatomic, retain) NSNumber *image_file_size;
@property (nonatomic, copy) NSString *image_updated_at;
@property (nonatomic, retain) NSNumber *cached_votes_total;
@property (nonatomic, retain) NSNumber *cached_votes_score;
@property (nonatomic, retain) NSNumber *cached_votes_up;
@property (nonatomic, retain) NSNumber *cached_votes_down;
@property (nonatomic, retain) NSNumber *cached_weighted_score;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *image_url_square;
@property (nonatomic, copy) NSString *image_url_preview;
@property (nonatomic, copy) NSString *image_url_thumb;

@end
