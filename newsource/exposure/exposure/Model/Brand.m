//
//  Brand.m
//  exposure
//
//  Created by Binh Nguyen on 7/16/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Brand.h"
#import "Submission.h"

@implementation Brand

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"brandId"];
    return [NSDictionary dictionaryWithDictionary:map];
}

+ (Class)submissions_mobile_class {
    return [Submission class];
}

+ (Class)winners_class {
    return [User class];
}

+ (Class)followers_list_class {
    return [User class];
}

@end
