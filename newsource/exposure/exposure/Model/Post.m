//
//  Post.m
//  exposure
//
//  Created by Binh Nguyen on 7/16/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Post.h"

@implementation Post

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"postId"];
    return [NSDictionary dictionaryWithDictionary:map];
}

@end
