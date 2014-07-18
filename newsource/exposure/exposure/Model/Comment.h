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

@property (nonatomic, retain) NSString *commentPicture;
@property (nonatomic, retain) NSString *commentText;
@property (nonatomic, retain) NSString *comment_id;
@property (nonatomic, retain) NSString *commenter_id;
@property (nonatomic, retain) NSString *commenter_name;

@end
