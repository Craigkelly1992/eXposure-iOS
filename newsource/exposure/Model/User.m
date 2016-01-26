//
//  User.m
//  exposure
//
//  Created by Binh Nguyen on 7/16/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "User.h"
#import "Post.h"

@implementation User

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"userId"];
    [map setObject:@"description" forKey:@"mDescription"];
    return [NSDictionary dictionaryWithDictionary:map];
}

+ (Class)posts_class {
    return [Post class];
}

@end
