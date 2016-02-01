//
//  Comment.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Comment : Jastor

@property (nonatomic, retain) NSString *commentId;
@property (nonatomic, retain) NSString *post_id;
@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) NSString *updated_at;
@property (nonatomic, retain) NSString *user_avatar_url;

@end
