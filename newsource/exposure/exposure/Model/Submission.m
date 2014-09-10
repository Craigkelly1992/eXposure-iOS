//
//  Submission.m
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Submission.h"

@implementation Submission

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"submissionId"];
    return [NSDictionary dictionaryWithDictionary:map];
}

@end
