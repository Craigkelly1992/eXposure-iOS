//
//  Contest.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Contest.h"

@implementation Contest

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"contestId"];
    [map setObject:@"description" forKey:@"mDescription"];
    return [NSDictionary dictionaryWithDictionary:map];
}

@end
